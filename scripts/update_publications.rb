# Appends works from OpenAlex that are missing from the bibliography.
#
#   docker compose run --rm site bundle exec ruby scripts/update_publications.rb
#
# Existing entries are never changed. A work counts as already present when its
# DOI, title, or arXiv id matches an entry, including entries marked
# `hidden = {true}`; hide unwanted entries rather than deleting them, or they
# will be added back on the next run.
#
# Settings come from `publications` in _config.yml (bibliography, openalex_author).
# Set OPENALEX_API_KEY to use an OpenAlex API key.
require 'jekyll'
require 'json'
require 'net/http'
require 'set'
require 'yaml'
require_relative '../_plugins/publications'

ROOT = File.expand_path('..', __dir__)
SKIP_TYPES = %w[paratext erratum editorial letter peer-review dataset retraction supplementary-materials].freeze
VENUES = {
  /\AProceedings of the \.\.\. American Control Conference/ => 'American Control Conference (ACC)',
  /\ALecture notes in computer science\z/i => 'Lecture Notes in Computer Science'
}.freeze

config = YAML.safe_load_file(File.join(ROOT, '_config.yml'))['publications'] || {}
author = config['openalex_author'] or abort 'Set publications.openalex_author in _config.yml'
bib_path = File.join(ROOT, config['bibliography'] || '_bibliography/publications.bib')
bib = File.exist?(bib_path) ? File.read(bib_path, encoding: 'bom|utf-8') : ''

def normalize_doi(doi)
  doi.to_s.downcase.sub(%r{\Ahttps?://(dx\.)?doi\.org/}, '').strip
end

def arxiv_from_doi(doi)
  doi[%r{10\.48550/arxiv\.(.+)}, 1]
end

def fetch_works(author)
  works = []
  cursor = '*'
  while cursor
    params = { filter: "author.id:#{author}", 'per-page' => 200, cursor: cursor }
    params[:api_key] = ENV['OPENALEX_API_KEY'] if ENV['OPENALEX_API_KEY'].to_s != ''
    uri = URI('https://api.openalex.org/works')
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri)
    abort "OpenAlex request failed: #{response.code} #{response.body[0, 200]}" unless response.is_a?(Net::HTTPSuccess)

    page = JSON.parse(response.body)
    works.concat(page['results'])
    cursor = page['results'].empty? ? nil : page.dig('meta', 'next_cursor')
  end
  works
end

def clean(text)
  text.to_s.gsub(/<[^>]+>/, '').delete('{}').gsub(/\s+/, ' ').strip
end

def venue_name(name)
  VENUES.each { |pattern, replacement| return replacement if name.to_s.match?(pattern) }
  clean(name)
end

def cite_key(work, taken)
  first = work['authorships'].first&.dig('author', 'display_name').to_s
  word = clean(work['title']).split.find { |w| w.length > 3 }.to_s
  base = "#{CasaPublications.name_key(first.split.last.to_s)}#{work['publication_year']}#{CasaPublications.name_key(word)}"
  key = base
  key += 'b' while taken.include?(key)
  taken << key
  key
end

def to_bibtex(work, key)
  source = work.dig('primary_location', 'source') || {}
  venue = venue_name(source['display_name'])
  doi = normalize_doi(work['doi'])
  arxiv = arxiv_from_doi(doi)
  authors = work['authorships'].map do |a|
    parts = clean(a.dig('author', 'display_name')).split
    "#{parts.pop}, #{parts.join(' ')}".sub(/, \z/, '')
  end
  fields = [['title', clean(work['title'])], ['author', authors.join(' and ')]]
  kind =
    if work['type'] == 'preprint' || arxiv
      fields << ['journal', arxiv ? "arXiv preprint arXiv:#{arxiv}" : "#{venue} preprint"]
      'article'
    elsif work['type'] == 'dissertation'
      fields << ['school', venue]
      'phdthesis'
    elsif work['type'] == 'book-chapter'
      fields << ['booktitle', venue]
      'incollection'
    elsif work['type'] == 'conference-paper' || source['type'] == 'conference'
      fields << ['booktitle', venue]
      'inproceedings'
    else
      fields << ['journal', venue]
      'article'
    end
  fields << ['year', work['publication_year'].to_s]
  fields << ['doi', doi] unless doi.empty? || arxiv
  fields.reject! { |_, value| value.to_s.empty? }
  "@#{kind}{#{key},\n" + fields.map { |name, value| "  #{name}={#{value}}" }.join(",\n") + "\n}"
end

entries = CasaPublications::BibTeX.parse(bib)
known_dois = Set.new(entries.map { |e| normalize_doi(e['doi']) }.reject(&:empty?))
known_titles = Set.new(entries.map { |e| CasaPublications.title_key(CasaPublications.latex_to_text(e['title'])) })
known_arxiv = Set.new(entries.filter_map { |e| CasaPublications.arxiv_id(e) })
taken_keys = Set.new(entries.map { |e| e['key'] })

added = []
fetch_works(author).sort_by { |w| [-w['publication_year'].to_i, w['title'].to_s] }.each do |work|
  next if work['title'].to_s.strip.empty? || work['is_retracted'] || SKIP_TYPES.include?(work['type'])

  doi = normalize_doi(work['doi'])
  title = CasaPublications.title_key(clean(work['title']))
  arxiv = arxiv_from_doi(doi)
  next if (!doi.empty? && known_dois.include?(doi)) || known_titles.include?(title) || (arxiv && known_arxiv.include?(arxiv))

  known_dois << doi unless doi.empty?
  known_titles << title
  known_arxiv << arxiv if arxiv
  added << [work, to_bibtex(work, cite_key(work, taken_keys))]
end

if added.empty?
  puts 'No new publications found on OpenAlex.'
else
  header = "% Added from OpenAlex on #{Time.now.utc.strftime('%Y-%m-%d')}; review authors, venue, and type."
  File.write(bib_path, "#{bib.rstrip}\n\n#{header}\n\n#{added.map(&:last).join("\n\n")}\n")
  puts "Added #{added.size} publication(s) to #{File.basename(bib_path)}:"
  added.each { |work, _| puts "- #{work['publication_year']}: #{clean(work['title'])}" }
end

if (out = ENV['GITHUB_OUTPUT'])
  File.open(out, 'a') { |f| f.puts "added=#{added.size}" }
end

# Reads the BibTeX file named in _config.yml (publications.bibliography) and
# exposes it to Liquid as site.data.publications, newest first.
#
# Each entry is classified as journal, conference, preprint, or other. Google
# Scholar exports proceedings such as IFAC-PapersOnLine as @article, so venue
# names are checked too. Add `pubtype = {journal}` (or conference, preprint,
# other) to an entry to override the guess, or `hidden = {true}` to skip it.
require 'set'

module CasaPublications
  ACCENTS = {
    "'" => "́", '`' => "̀", '^' => "̂", '~' => "̃",
    '"' => "̈", '=' => "̄", '.' => "̇", 'u' => "̆",
    'v' => "̌", 'H' => "̋", 'c' => "̧", 'k' => "̨"
  }.freeze
  SYMBOLS = {
    'ss' => 'ß', 'o' => 'ø', 'O' => 'Ø', 'aa' => 'å', 'AA' => 'Å',
    'ae' => 'æ', 'AE' => 'Æ', 'oe' => 'œ', 'l' => 'ł', 'L' => 'Ł', 'i' => 'ı'
  }.freeze
  PREPRINT = /arxiv|corr\b|preprint|techrxiv|ssrn|biorxiv|medrxiv/i
  PROCEEDINGS = /ifac-papersonline|lecture notes|proceedings|conference|workshop|symposium|congress|congresso/i
  CONFERENCE_TYPES = %w[inproceedings conference proceedings].freeze
  THESIS_TYPES = %w[phdthesis mastersthesis].freeze
  TYPE_LABELS = {
    'journal' => 'Journal', 'conference' => 'Conference',
    'preprint' => 'Preprint', 'other' => 'Other'
  }.freeze

  # Minimal BibTeX reader: entries of the form @type{key, field = {value}, ...}.
  # Values may be {braced}, "quoted", or bare numbers/macros.
  module BibTeX
    module_function

    def parse(text)
      entries = []
      pos = 0
      while (at = text.index('@', pos))
        open = text.index(/[{(]/, at) or break
        type = text[(at + 1)...open].strip.downcase
        close = matching(text, open)
        body = text[(open + 1)...close]
        pos = close + 1
        next if %w[comment string preamble].include?(type)

        key, fields = body.split(',', 2)
        entries << { 'type' => type, 'key' => key.strip }.merge(fields(fields.to_s))
      end
      entries
    end

    def fields(text)
      result = {}
      scanner = 0
      while (m = /\s*([A-Za-z][\w-]*)\s*=\s*/.match(text, scanner))
        start = m.end(0)
        case text[start]
        when '{'
          finish = matching(text, start)
          value = text[(start + 1)...finish]
        when '"'
          finish = text.index('"', start + 1) || text.length
          value = text[(start + 1)...finish]
        else
          finish = (text.index(/[,}]/, start) || text.length) - 1
          value = text[start..finish].strip
        end
        result[m[1].downcase] = value
        scanner = finish + 1
        scanner += 1 while scanner < text.length && text[scanner] =~ /[\s,]/
      end
      result
    end

    def matching(text, open)
      closer = text[open] == '(' ? ')' : '}'
      depth = 0
      (open...text.length).each do |i|
        c = text[i]
        next if i.positive? && text[i - 1] == '\\'

        depth += 1 if c == text[open]
        depth -= 1 if c == closer
        return i if depth.zero?
      end
      text.length
    end
  end

  module_function

  def latex_to_text(value)
    text = value.to_s.dup
    text.gsub!(/\\([uvHck])(?:\s*\{\\?([A-Za-z])\}|\s+([A-Za-z]))/) { "#{$2 || $3}#{ACCENTS[$1]}" }
    text.gsub!(/\\(['`^~"=.])\s*(?:\{\s*\\?([A-Za-z])\s*\}|\\?([A-Za-z]))/) { "#{$2 || $3}#{ACCENTS[$1]}" }
    text.gsub!(/\\(ss|aa|AA|ae|AE|oe|o|O|l|L|i)(?![A-Za-z])\s*/) { SYMBOLS[$1] }
    text.gsub!(/\\([&%$#_])/, '\1')
    text.gsub!('---', '—')
    text.gsub!('--', '–')
    text.delete!('{}')
    text.gsub(/\s+/, ' ').strip.unicode_normalize(:nfc)
  end

  # "Meira-Góes, Rômulo" or "Rômulo Meira-Góes" -> ["Rômulo", "Meira-Góes"]
  def split_name(name)
    return name.split(',', 2).map(&:strip).reverse if name.include?(',')

    parts = name.split
    last = parts.pop.to_s
    [parts.join(' '), last]
  end

  # "Meira-Góes, Rômulo" -> "R. Meira-Góes"
  def short_name(name)
    first, last = split_name(name)
    initials = first.split.map do |part|
      part.split('-').map { |p| p.end_with?('.') && p.length <= 3 ? p : "#{p[0]}." }.join('-')
    end
    [initials.join(' '), last].reject(&:empty?).join(' ')
  end

  def name_key(name)
    name.to_s.unicode_normalize(:nfkd).gsub(/[^A-Za-z]/, '').downcase
  end

  # First initial plus last name, ignoring accents: "R. Meira-Góes" and
  # "Rômulo Meira-Góes" both become "r|meiragoes".
  def person_key(name)
    first, last = split_name(latex_to_text(name))
    "#{name_key(first)[0]}|#{name_key(last)}"
  end

  # From an `arxiv` or `eprint` field, or from Scholar's
  # "arXiv preprint arXiv:2311.07462" journal text or an arxiv.org URL.
  def arxiv_id(entry)
    pattern = /(\d{4}\.\d{4,5}|[a-z-]+(?:\.[A-Z]{2})?\/\d{7})(?:v\d+)?/
    explicit = entry['arxiv'] || (entry['eprint'] if entry['archiveprefix'].to_s.match?(/arxiv/i) || entry['eprint'].to_s.match?(/\A\d{4}\.\d{4,5}/))
    candidates = [explicit, entry['journal'].to_s[/arxiv[:\s].*/i], entry['url'].to_s[/arxiv\.org.*/i], entry['doi'].to_s[/arxiv\.\S*/i]]
    candidates.compact.each { |c| return c[pattern, 1] if c.match?(pattern) }
    nil
  end

  def title_key(title)
    title.to_s.unicode_normalize(:nfkd).downcase.gsub(/[^a-z0-9]/, '')
  end

  # Drops preprints that also appear as a published paper (same title or same
  # arXiv id) and gives the published entry the preprint's arXiv link.
  def merge_preprints(pubs)
    published = pubs.reject { |p| p['type'] == 'preprint' }
    by_title = published.group_by { |p| title_key(p['title']) }
    by_arxiv = published.select { |p| p['arxiv'] }.group_by { |p| p['arxiv'] }
    pubs.reject do |pub|
      next false unless pub['type'] == 'preprint'

      match = (by_arxiv[pub['arxiv']] || by_title[title_key(pub['title'])])&.first
      next false unless match

      match['arxiv'] ||= pub['arxiv']
      match['arxiv_url'] ||= pub['arxiv_url']
      true
    end
  end

  def classify(entry)
    explicit = entry['pubtype'].to_s.strip.downcase
    return explicit if TYPE_LABELS.key?(explicit)

    venue = [entry['journal'], entry['booktitle'], entry['howpublished'], entry['note']].join(' ')
    return 'preprint' if venue.match?(PREPRINT) || entry['archiveprefix'].to_s.match?(PREPRINT)
    return 'conference' if CONFERENCE_TYPES.include?(entry['type'])
    return 'other' unless entry['type'] == 'article'

    venue.match?(PROCEEDINGS) ? 'conference' : 'journal'
  end

  def build(entry, highlight)
    return nil if entry['hidden'].to_s.strip.downcase == 'true'

    authors = latex_to_text(entry['author']).split(/\s+and\s+/i).map do |name|
      next { 'name' => 'et al.', 'highlight' => false } if name.casecmp?('others')

      { 'name' => short_name(name), 'highlight' => highlight.include?(person_key(name)) }
    end
    type = classify(entry)
    label = THESIS_TYPES.include?(entry['type']) ? 'Thesis' : TYPE_LABELS[type]
    venue = entry['journal'] || entry['booktitle'] || entry['school'] || entry['publisher'] || entry['howpublished']
    doi = entry['doi'].to_s.sub(%r{\Ahttps?://(dx\.)?doi\.org/}i, '')
    url = doi.empty? ? entry['url'] : "https://doi.org/#{doi}"
    arxiv = arxiv_id(entry)
    url = nil if type == 'preprint' && arxiv # the arXiv link already covers it

    {
      'key' => entry['key'],
      'title' => latex_to_text(entry['title']),
      'authors' => authors,
      'venue' => latex_to_text(venue),
      'year' => entry['year'].to_s[/\d{4}/].to_s,
      'month' => entry['month'].to_s,
      'type' => type,
      'label' => label,
      'url' => url.to_s.empty? ? nil : url,
      'arxiv' => arxiv,
      'arxiv_url' => arxiv && "https://arxiv.org/abs/#{arxiv}",
      'pdf' => entry['pdf'],
      'note' => entry['note'] && latex_to_text(entry['note'])
    }
  end

  class Generator < Jekyll::Generator
    safe true
    priority :high

    MONTHS = %w[jan feb mar apr may jun jul aug sep oct nov dec].freeze

    def generate(site)
      config = site.config['publications'] || {}
      path = site.in_source_dir(config['bibliography'] || '_bibliography/publications.bib')
      unless File.exist?(path)
        Jekyll.logger.warn 'Publications:', "no bibliography found at #{path}"
        return
      end

      # Everyone on the Team page (current and alumni) plus any extra names.
      team = site.collections['team']&.docs.to_a.map { |doc| doc.data['title'] }
      names = (team + Array(config['highlight'])).compact.reject(&:empty?)
      highlight = Set.new(names.map { |n| CasaPublications.person_key(n) })
      pubs = BibTeX.parse(File.read(path, encoding: 'bom|utf-8'))
                   .filter_map { |entry| CasaPublications.build(entry, highlight) }
      pubs = CasaPublications.merge_preprints(pubs)
      site.data['publications'] = pubs.sort_by do |p|
        [-p['year'].to_i, -month_number(p['month']), p['title'].downcase]
      end
      Jekyll.logger.info 'Publications:', "#{pubs.size} entries from #{config['bibliography']}"
    end

    private

    def month_number(month)
      m = month.to_s.strip.downcase
      m.match?(/\A\d+\z/) ? m.to_i : (MONTHS.index(m[0, 3]) || -1) + 1
    end
  end
end

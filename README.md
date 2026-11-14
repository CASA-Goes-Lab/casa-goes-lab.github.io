# Casa Góes Lab

Jekyll site built with HTML, Liquid, and one stylesheet.

## Run locally with Docker (recommended)

With Docker Desktop running, from the repository folder:

```sh
docker compose up --build
```

Open http://localhost:4000. The site rebuilds and the browser reloads whenever you save a file. Stop it with `Ctrl+C` (or `docker compose down`). The image uses the same Ruby version as the GitHub Actions build. Run `--build` again after changing the `Gemfile`.

If the folder is synced by OneDrive, mark it "Always keep on this device"; cloud-only placeholder files cannot be read inside the container (`Errno::EDEADLK`).

## Run locally with Ruby

Install Ruby 4.0 and Bundler, then run:

```sh
bundle config set --local path vendor/bundle
bundle install
bundle exec jekyll serve
```

Open http://localhost:4000. To build the website a single time and stay on that version:
```sh
bundle exec jekyll build
```
If you want to build the website and have it rebuild every time you save changes, run:
```sh
bundle exec jekyll serve
```

## Updating publications

The Publications page is generated from `_bibliography/publications.bib` by `_plugins/publications.rb`.

New papers are added from [OpenAlex](https://openalex.org/A5069939622) by `scripts/update_publications.rb`. The script asks OpenAlex for every work by the author ID in `_config.yml` (`publications.openalex_author`) and appends the ones that are not already in the `.bib` file (matched by DOI, title, or arXiv id). Existing entries are never changed, so your manual edits are kept.

There are two ways to run it. Either way, review the new entries before publishing: OpenAlex sometimes swaps first and last names, uses a repository name as the venue, or picks the wrong type.

### Option 1: GitHub Actions (automatic)

The workflow `.github/workflows/update-publications.yml` runs the script on every push to `master`, every Monday at 12:00 UTC, and whenever you start it by hand. If it finds new papers, it opens a pull request named "Add new publications from OpenAlex". Nothing changes on the live site until you merge it.

One-time setup:

1. On GitHub, go to **Settings → Actions → General**.
2. Under "Workflow permissions", tick **Allow GitHub Actions to create and approve pull requests**, then **Save**. If the box is greyed out, enable the same option in the organization's settings (CASA-Goes-Lab → Settings → Actions → General) first.
3. Make sure the workflow file is on `master` (scheduled runs and the Run workflow button only work from the default branch).

Each time a pull request appears:

1. Open the pull request. Its description lists the papers that were added.
2. Check the **Files changed** tab and fix anything wrong directly in `_bibliography/publications.bib` (edit the file on the PR branch, or pull the branch and edit locally).
3. Merge the pull request. The deploy workflow then publishes the updated page.

To check for new papers right away: **Actions → Update publications from OpenAlex → Run workflow**.

### Option 2: Docker (manual, on your computer)

1. Start Docker Desktop and open a terminal in the repository folder.
2. Run the script:
   ```sh
   docker compose run --rm site bundle exec ruby scripts/update_publications.rb
   ```
   It prints the papers it added, or "No new publications found on OpenAlex."
3. Review the new entries at the end of `_bibliography/publications.bib` (they follow a `% Added from OpenAlex on <date>` line).
4. Preview the page with `docker compose up` and open http://localhost:4000/publications/.
5. Commit and push `_bibliography/publications.bib`.

### Notes

- **Removing a paper:** add `hidden = {true}` to its entry instead of deleting it; a deleted entry is added back on the next run.
- **Papers OpenAlex misses:** add them by hand, for example by copying the entry from Google Scholar (select the paper, then **Export → BibTeX**).
- **OpenAlex API key (optional):** the script works without one. To use a key, add it as the repository secret `OPENALEX_API_KEY` (Settings → Secrets and variables → Actions), or pass `-e OPENALEX_API_KEY=...` to `docker compose run`.

Entries are grouped as journal, conference, preprint, or other. `@inproceedings` entries are conferences, and `@article` entries whose venue looks like proceedings (IFAC-PapersOnLine, Lecture Notes, "Conference", "Workshop", ...) are also treated as conferences. An arXiv preprint with the same title as a published paper is hidden, and its arXiv link is added to the published paper. Optional fields you can add to an entry:

- `pubtype = {journal}`: force the group (`journal`, `conference`, `preprint`, or `other`).
- `arxiv = {2311.07462}`: link an arXiv version whose title differs from the published one; that preprint entry is then hidden.
- `hidden = {true}`: leave the entry off the page.
- `doi = {...}` or `url = {...}`: link the title. `pdf = {/files/paper.pdf}`: add a PDF button.

Authors who match someone in `_team` (current or alumni, by first initial and last name) are shown in bold, as are any extra names listed under `publications.highlight` in `_config.yml`. Restart the Docker container after editing `_config.yml` or the plugin.

## Folder Explanations
- `_includes`: This is where elements that you want on every page will go. The header and footer are here.
- `_layouts`: Reusable page layouts that are referenced by files in `pages`
- `_news`, `_team`: Folders of content files that are automatically added to the 'Lab News' section and 'Team' page, respectively.
- `pages`: Where main page files go, such as `team.md`.
- `images`: Where all images for site go.
- `styles`: The CSS and any fonts or other styling files
- `_config.yml`, `Gemfile`, `Gemfile.lock`, `.gitignore`, `.github/workflows`: Configuration files

### Other
- `_archive`: The previous design of the site. Everything here is excluded from builds. This folder should be deleted at some point.
- `_site`, `.bundle`, `vendor`, `.jekyll-cacge`: Temporary site files generated by your local machine so you can privew the site. These are ignored by Git. You should not see these on the GitHub repository.

## Notes
Team members use `startdate` for current-student ordering and `date_left` for alumni ordering (most recent departure first). Write `date_left` as a quoted ISO date, such as `"2026-05"` or `"2026-05-15"`. Current members retain their previous date values as temporary placeholders; when moving someone to `category: alumni`, update `date_left` to their actual departure date and `enddate` to the displayed end month/year.

1. For simplicity, all of the CSS is stored in a single `main.css` file. If this is too cumbersome, it would be viable in the future to split it into multiple SCSS files for different sections that become merged when the site is built.

2. Delete the archive file at some point in the future.

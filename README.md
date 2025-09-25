# Stabat Mater static site

This repository contains the static export of the Stabat Mater website. We are in
the process of migrating the project to a maintainable Jekyll structure so that
shared layout and navigation elements can be managed centrally instead of being
embedded in each HTML page.

## Local development

1. Install Ruby (3.1 or newer is recommended).
2. Install the dependencies and start the development server:

   ```bash
   bundle install
   bundle exec jekyll serve
   ```

   The site will be available at <http://localhost:4000>. The generated files are
   written to the `_site` folder, which is ignored by Git.

## Migration status

- ✅ Jekyll toolchain bootstrapped (`_config.yml`, `Gemfile`, shared layout
  placeholders).
- ⏳ Extract the shared `<head>`, header, sidebar, footer, and scripts from the
  exported pages into `_includes/` (partials wired for pages converted so far).
- ⏳ Convert content pages into Markdown/HTML documents with YAML front matter so
  they render through `_layouts/default.html`.
  - ✅ Initial batch of 10 pages converted: `stabat-mater-composer/`, `stabat-mater-
    collection-support/`, `stabat-mater-colourbar/`, `stabat-mater-foundation/`,
    `stabat-mater-dolorosa-about-the-poem/`, `stabat-mater-dolorosa-have-you-read-it-yet/`,
    `stabat-mater-translations-and-languages/`, `stabat-mater-english-translation/`,
    `stabat-mater-latin-text/`, `stabat-mater-french-translation/`.
- ⏳ Model shared data (composer lists, translations, etc.) in `_data/` files and
  render them with Liquid templates.

These notes will evolve as the migration progresses.

### Migration helper script

Use `script/migrate_page.rb` to bootstrap the conversion of additional legacy
pages. The script extracts the SEO metadata, body class, and main content from a
static export and writes a Jekyll-friendly file with YAML front matter:

```bash
bundle exec ruby script/migrate_page.rb path/to/legacy/index.html
```

Pass a second argument to write the converted output to a different file. Run
`bundle exec ruby script/migrate_page.rb --help` to see the available options.

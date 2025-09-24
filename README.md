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
  exported pages into `_includes/`.
- ⏳ Convert content pages into Markdown/HTML documents with YAML front matter so
  they render through `_layouts/default.html`.
- ⏳ Model shared data (composer lists, translations, etc.) in `_data/` files and
  render them with Liquid templates.

These notes will evolve as the migration progresses.

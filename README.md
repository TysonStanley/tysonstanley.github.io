# tysonbarrett.com — Quarto site

Replaces the old Jekyll (Lanyon) site, which lives on in git history at
the tag `jekyll-final` — `git show jekyll-final` or
`git checkout jekyll-final` to recover any of it.

Source is the repo root. `quarto render` writes `_site/`, which is
gitignored: GitHub Actions renders it on every push and deploys it, so the
output is never committed.

## Layout

```
  _quarto.yml         project + website config (navbar, theme, listing)
  styles.scss         light theme  (single accent color, serif headings)
  dark.scss           dark theme overrides
  index.qmd           landing page (about: trestles)
  blog.qmd            post listing
  research.qmd  software.qmd  teaching.qmd  consulting.qmd
  teaching/*.qmd      course pages (foundations, regression, applied, ...)
  posts/<slug>/index.qmd
  assets/             CVs, slides, syllabi, data, post figures
  notes/              data.table working notes — not part of the site
```

Quarto copies `assets/` to `_site/assets/` as a project resource on every
render, so served paths are unchanged from Jekyll: a link to
`/assets/CV/CV.pdf` still resolves to `/assets/CV/CV.pdf`.

Two things in `_quarto.yml` keep that safe, and both matter:

- `- "!assets/**"` under `render:` — `assets/` contains about 40 `.qmd`
  and `.Rmd` files (the CV, conference talks, the original post sources).
  Without this exclusion Quarto would try to render and execute every one
  of them as a page.
- `- "!assets/PyData/mini/**"` under `resources:` — that directory is a
  committed Python virtualenv and must not ship to the site.

## Local development

```bash
quarto preview        # live reload at localhost:4200
quarto render         # writes _site/
```

## Writing a post

```bash
mkdir -p posts/my-new-post
$EDITOR posts/my-new-post/index.qmd
```

```yaml
---
title: "Post title"
description: "One or two sentences — this shows on the blog listing."
date: 2026-09-18
author: Tyson S. Barrett
categories: [data.table, regression]
---
```

Then write. **R chunks execute at render time** — no more knitting an
`.Rmd` in `assets/RMD/` and copying the markdown into `_posts/`:

````markdown
```{r}
library(data.table)
dt <- as.data.table(mtcars)
dt[, .(mpg = mean(mpg)), by = cyl]
```
````

`execute: freeze: auto` in `_quarto.yml` means a post is re-executed only
when its source changes. Commit `_freeze/` so CI never needs R installed.

Posts migrated from Jekyll use ```` ```r ````/```` ```output ```` fences —
pre-rendered text, not live code. Convert one to a live `{r}` chunk
whenever you next touch it.

## Deploying

`.github/workflows/publish.yml` renders on push to `main`/`master` and
deploys `_site/` to GitHub Pages.

Required once, in repo settings → Pages:

1. Source: **GitHub Actions** (not "Deploy from a branch").
2. Custom domain: `tysonbarrett.com`.

Pages' branch-deploy mode can only serve `/` or `/docs`, which is why this
uses Actions instead — it deploys any directory. The Actions path never
runs Jekyll, so no `CNAME` or `.nojekyll` file is needed in the output.

## Recovering anything from the old site

Everything Jekyll-era is at the tag `jekyll-final`:

```bash
git show jekyll-final:_posts/2019-12-03-workflow_dtplyr_tidyfast.md
git checkout jekyll-final -- _layouts/    # restore a path if ever needed
```

Post URLs changed from `/YYYY/MM/DD/slug/` to `/posts/slug/`. To make an
old inbound link resolve, add to that post's front matter:

```yaml
aliases:
  - /2019/12/03/workflow_dtplyr_tidyfast/
```

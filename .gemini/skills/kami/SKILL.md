---
name: "kami"
description: "Typeset documents to PDF — resumes, one-pagers, white papers, slide decks. Markdown input, professional PDF output. Use when creating polished documents from agent-generated content."
---

# Kami — Document Typesetting

Markdown to professional PDF. Resumes, one-pagers, white papers, slide decks.

---

## When to Use

- "Create a resume from my experience"
- "Typeset this white paper"
- "Make a one-pager for the project"
- "Generate a slide deck from this outline"

## Steps

**1. Identify document type**

| Type | Template | Output |
|------|----------|--------|
| Resume | `resume` | 1-page PDF, clean layout |
| One-pager | `one-pager` | Single-sided, key points |
| White paper | `white-paper` | Multi-page, academic style |
| Slide deck | `slides` | PDF slides, 16:9 |

**2. Create the markdown source**

Write the content in markdown. Use standard markdown with YAML frontmatter:

```markdown
---
type: resume
title: "Senior Engineer"
author: "Name"
date: "2026-06-02"
---

## Experience

...
```

**3. Render to PDF**

```bash
# Using pandoc (if available)
pandoc input.md -o output.pdf --template=<template> --pdf-engine=xelatex

# Using typst (if available)
typst compile input.typ output.pdf

# Fallback: markdown → HTML → PDF
pandoc input.md -o output.html
wkhtmltopdf output.html output.pdf
```

**4. Verify the output**

```bash
file output.pdf
pdfinfo output.pdf 2>/dev/null | head -5
```

## Templates

Templates are stored in `~/dotfiles/scripts/__kami_templates/` (if available).

If no templates exist, use sensible defaults:
- **Resume**: 10pt, single column, section headers bold
- **One-pager**: 11pt, two-column for dense content
- **White paper**: 12pt, 1.5 line spacing, numbered sections
- **Slides**: 20pt minimum, landscape orientation

## Guardrails

- Always verify the PDF renders correctly before delivering
- Keep resumes to 1 page unless explicitly asked for more
- Slide decks: one idea per slide, minimal text
- White papers: include abstract, numbered sections, references
- If pandoc/typst not available, fall back to HTML output

## Related

- `humanizer` — strip AI-isms from the text before typesetting
- `showboat` — for executable demo documents
- `handoff` — for session summaries

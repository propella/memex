---
name: new
description: Start writing a new article in this digital garden (memex). Use when the user wants to create a new post, article, or note.
argument-hint: "[category] [title]"
allowed-tools: Read, Write, Bash, Glob
---

Create a new article in the memex digital garden.

## Directory structure

```
content/
├── dev/        # Technical articles
├── art/        # Kinetic art / electronics
├── note/       # Essays and misc
├── portfolio/  # Work samples
└── en/         # English articles
```

File path pattern: `content/<category>/YYYY/MM-<slug>.md`

## Steps

1. If $ARGUMENTS is provided, parse category and title from it. Otherwise ask the user for:
   - Category: dev / art / note / portfolio / en
   - Title (Japanese or English)
   - Language: Japanese or English (default: Japanese)

2. Determine today's date using the `currentDate` value from context (or run `date +%Y-%m-%d` if unavailable).

3. Generate a slug from the title:
   - English: lowercase, spaces → hyphens, remove special characters
   - Japanese title: transliterate or use a short English keyword that captures the topic

4. Create the directory `content/<category>/YYYY/` if it does not exist.

5. Create the file `content/<category>/YYYY/MM-<slug>.md` with this frontmatter:

```yaml
---
title: "<title>"
date: YYYY-MM-DD
slug: <slug>
tags: [<category>]
draft: true
---
```

6. Write a skeleton article body appropriate to the topic and language. Include:
   - A brief opening paragraph stating the purpose of the article
   - 2–4 section headings (H2) with placeholder content relevant to the topic
   - A closing paragraph or "今後の予定" / "What's next" section

7. Report the created file path to the user.

---
name: localization
description: Implementing and maintaining next-intl based localization
---

## Purpose

Ensure all visible text in the app is localized with **next-intl**, with clean message organization for **English** and **German** and minimal risk of hard-coded strings.

## When to use this skill

- You add or change any user-facing text (labels, tooltips, placeholders, error messages, headings, buttons, etc.).
- You create new pages, components, or features.
- You refactor existing components that currently use hard-coded strings.

## Core principles

- **No visible text without translations**:
  - Every user-facing string must come from `next-intl`.
  - Never leave English literals in JSX/TSX except in tests or debug logs.
- **Two main locales**:
  - Always provide translations for **English** and **German**.
  - English messages live in `src/messages/en/**.json`, German in `src/messages/de/**.json`.
- **Namespaces by feature**:
  - Use feature-based message files, e.g. `src/messages/en/dashboard.json`, `src/messages/de/dashboard.json`.
  - Reuse existing keys where possible before adding new ones.

## How to add or change text

1. **Choose the namespace**
   - Find the closest existing feature namespace (e.g. `auth`, `dashboard`, `settings`).
   - If none fits, create a new feature JSON file in both `en` and `de` folders.

2. **Add translation keys**
   - Use **descriptive, stable keys**, e.g.:
     - `pageTitle`, `ctaPrimary`, `form.email.label`, `form.email.errorRequired`.
   - Fill in both `en` and `de` values.
   - Prefer **nested objects** for structure over long flat keys.

3. **Use translations in components**
   - For **Server Components**, use `getTranslations(namespace)` or equivalent project helper.
   - For **Client Components**, use `useTranslations(namespace)`.
   - Replace hard-coded strings:
     - Before: `<h1>Dashboard</h1>`
     - After: `const t = useTranslations('dashboard'); <h1>{t('pageTitle')}</h1>`

4. **Formatting & ICU messages**
   - Use ICU formatting for:
     - Plurals: `"items": "{count, plural, one {# item} other {# items}}"`
     - Interpolations: `"welcome": "Welcome, {name}!"`
   - Let `next-intl` handle date, time, and number formatting instead of manual concatenation.

## Quality checks

- Scan modified files for any new hard-coded text; convert them to `t('...')` calls.
- Ensure **key parity** between `en` and `de` JSON for the namespaces you touched.
- Keep translations **short, clear, and consistent** with existing terminology.

## What not to do

- Do not invent new message structures that conflict with existing namespaces.
- Do not duplicate identical messages under many different keys; reuse canonical ones when they fit.
- Do not bypass localization for “temporary” copy; everything shipped to users should be localized.

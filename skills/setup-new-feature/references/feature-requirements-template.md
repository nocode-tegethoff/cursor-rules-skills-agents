# Feature Requirements Template

Use this template when creating `/docs/requirements/<feature-name>.md`.

## Context

- **Feature name**: …
- **Problem / opportunity**: What user or business problem does this solve?
- **Current behavior**: How does the system work today?
- **Related features / modules**: Links to existing docs or routes.

## Goals & Non-goals

### Goals

- …

### Non-goals

- …

## User Stories

- As a **…**, I want **…**, so that **…**.
- As a **…**, I want **…**, so that **…**.

## Acceptance Criteria

- [ ] Given **context A**, when **user action X**, then **observable result Y**.
- [ ] …

## Domain & UX Notes

- Key domain concepts, terms, and constraints.
- Expected UX flow at a high level (screens / states).

## Technical Approach

- **Frontend**
  - New routes / pages: `app/(segment)/...`
  - New components / hooks: `src/app/(feature)/...`
  - State management (Zustand, search params with Nuqs, etc.).
- **Backend**
  - New API routes: `app/api/...`
  - New Server Actions or services.
  - Changes to existing modules.
- **Database**
  - New tables / columns / relations.
  - RLS implications and policies to update.

## Open Questions

- …

## Risks & Trade-offs

- …


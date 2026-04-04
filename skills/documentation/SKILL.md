---
name: documentation
description: Writing and updating project documentation for humans and AI agents
---

## Purpose

Help keep documentation in `/docs` and related rule files accurate, concise, and useful for:
- Engineers extending or refactoring the app.
- AI agents implementing new features or fixes.

Always treat documentation as **docs-as-code**: versioned, reviewed, and updated together with implementation changes.

## When to use this skill

Use this skill whenever:
- The user asks you to create or update docs in `/docs`, `.cursor/rules`, `.cursor/skills` or other markdown guides.
- Your code changes modify behavior, data models, APIs, or architecture.
- Existing docs clearly contradict the current code.
- **Product behavior changed:** consider updating the relevant REQ-* lines in [`docs/prds/prd.md`](../../docs/prds/prd.md) (see `.cursor/rules/project-context.mdc` — **PRD and implementation**); use the PRD-docs skill for structure and EARS style.

## Sources of truth

- `/docs/` (technical, product, and architecture docs; built via MkDocs).
- `.cursor/rules/**` and `.cursor/skills/**` (project rules and skills for APIs, frontend, backend, database, etc.).

Never invent architecture or behavior that is not supported by the codebase.

## How to update documentation

1. **Review impact**
   - Identify all files you edited and summarize what changed.
   - Open the relevant doc(s) and see what they currently claim.
   - Decide what must change so the docs describe the **current full state**, not just your diff.

2. **Plan the doc changes**
   - List the key topics affected (e.g. API route behavior, data model fields, key workflows).
   - Decide which doc sections map to which topics (or whether a new section is needed).

3. **Write concise, structured content**
   - Prefer short paragraphs and bullet lists.
   - Focus on the **what, why, when, where, and how**:
     - What this module/route/component does.
     - Why it exists and key design trade-offs.
     - When it is called or used.
     - Where it lives in the codebase.
     - How data flows through it and how it interacts with other parts.
   - Highlight exposed **functions, hooks, types, interfaces, API routes, and data models**.

4. **Use diagrams where helpful**
   - Use Mermaid for:
     - Flowcharts (control or request flow).
     - Sequence diagrams (API/client interactions).
     - Data diagrams (entities and relationships).
   - Keep diagrams small and focused on a single concern.

5. **Link code and docs**
   - Mention key files, modules, or directories by relative path.
   - Describe how code interfaces with the rest of the application (dependencies, upstream/downstream callers).
   - Prefer **canonical examples** (short code snippets, ≤3 lines) instead of large copies of code.

## Style guidelines

- Be **concise**; avoid repetition and filler language.
- Use clear headings and lists; keep sections short and focused.
- Use present tense and neutral tone; avoid status judgments like “production ready”.
- Do **not** paste long code blocks; only include short examples when necessary.
- Keep terminology consistent with existing docs and code (naming, domain language).

## What not to do

- Do not describe only “what changed”; rewrite sections so they describe the **current behavior end-to-end**.
- Do not contradict `.cursor/rules/**`, `.cursor/skills` or the actual implementation.
- Do not weaken or ignore security/privacy aspects documented elsewhere.

## Final checklist before saving

- [ ] All described behavior matches the current code.
- [ ] New/changed APIs, data models, and flows are documented.
- [ ] Links, paths, and references are correct.
- [ ] No unnecessary long code blocks; examples are minimal and canonical.
- [ ] Language is concise and clear enough for another AI agent to follow.


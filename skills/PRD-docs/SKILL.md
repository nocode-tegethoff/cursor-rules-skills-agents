---
name: prd-docs
description: Writing Product Requirement Documents (PRDs) and requirements themselves
---

## Purpose

Help keep [`docs/prds/prd.md`](../../docs/prds/prd.md) (single canonical PRD) and related technical docs accurate, concise, and useful for requirement-driven development. Always treat documentation as **docs-as-code**: versioned, and updated together with implementation changes.

## When to use this skill

- Writing or restructuring PRDs and requirements.
- **After implementing, updating, or fixing a feature:** check whether the affected REQ-* section in `docs/prds/prd.md` still matches behavior; update requirements or add a concise gap/TBD where incomplete.
- **Plan mode (large implementations):** the first plan todo should be PRD alignment (see `.cursor/rules/project-context.mdc` — **PRDs and implementation**).

## Keeping PRDs in sync with code

PRDs are **not** expected to be perfect before coding. The goal is **continuous alignment**: when code changes, the PRD should reflect the current intended product behavior (or explicitly mark what is still TBD). That keeps tests, agents, and future readers aligned on intent.

## How to write PRDs

1. Every requirement and sub-requirement needs to be EARS compliant.
2. Requirements shall have a hierarchical structure to them: a feature should get one or more high-level requirements with individual aspects of the feature being implemented in sub-requirements.
3. No fluff in the requirements. I'm the only dev together with you as the AI agent. Beyond the actual requirement description, only give a checkbox for the implementation status + date of creation/completion  - no effort, people, etc.
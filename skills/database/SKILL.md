---
name: database
description: When working on database components or interactions
---

**Also review the "database.mdc" rule when working with database interactions in the backend.**

## Schema design & types

- Model data for **clarity and longevity**:
  - Use **normalized schemas** by default; denormalize only when justified by profiling.
  - Prefer **UUID v4** primary keys and consistent naming (`table_name`, `column_name`).
- Use **snake_case** for all table and column names.
- Use **foreign keys** wherever appropriate; choose cascading behavior on edit/delete intentionally per relationship.
- Choose **correct data types**:
  - `uuid` for ids, `timestamptz` for timestamps, `text` for emails and identifiers, `jsonb` only for flexible/unstructured data.
- Always:
  - Add NOT NULL where appropriate.
  - Use check constraints for invariants that must never be broken.

## Indexing & performance

- Index:
  - All **foreign key columns**.
  - Columns frequently used in **WHERE, JOIN, ORDER BY**.
- Favor **composite indexes** for common multi-column filters (e.g. `(business_id, created_at DESC)`).
- Avoid index bloat:
  - Do not create overlapping/duplicate indexes.
  - Use **partial indexes** for hot subsets (e.g. `WHERE archived = false`).
- Regularly verify critical queries with `EXPLAIN ANALYZE` and adjust indexes accordingly.

## RLS & security

- Enable **RLS on all business tables**; default deny.
- Scope access by:
  - `auth.uid()` (user ownership).
  - `business_id` (multi-tenant boundary).
- Keep policies:
  - **Simple, explicit, and testable**.
  - Backed by appropriate indexes on any columns used in policy predicates.
- Prefer **shared security-definer functions** for complex, reused rules instead of repeating logic across many policies.
- Define **conservative RLS policies** and never weaken or bypass them as a workaround to fix bugs.
- Never compromise security for fixing bugs or adding features.

## Migrations & SQL files

- Treat `/src/lib/supabase/*.sql` as the **single source of truth** for the schema and security.
- Every structural change MUST:
  - Be reflected in the appropriate SQL file (tables, indexes, policies, functions).
  - Be **idempotent** or clearly versioned so it can run safely in CI/deploys.
- Never patch the database manually in production without also updating the SQL migration files.
- Always keep the SQL files in `/src/lib/supabase/` up to date:
  - `tables.sql` for all table definitions.
  - `security.sql` for all RLS policies.
  - `functions.sql` for all functions and triggers.

## Query design & access patterns

- Keep queries **simple, predictable, and explainable**:
  - Avoid N+1; use joins and relations where possible.
  - Always paginate large result sets with stable ordering.
- Select only needed columns; avoid `SELECT *` in production code.
- Prefer a **centralized data access layer** in the app that:
  - Encapsulates Supabase/Postgres details.
  - Applies business and tenant filtering consistently.

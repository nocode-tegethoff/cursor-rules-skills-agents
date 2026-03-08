---
name: backend
description: Creating backend code (Next.js)
---
When implementing backend logic (server components, Server Actions, and route handlers):

- Prefer **server components and a data access layer (DAL)** for reads.
- Use **Server Actions** for UI-driven mutations, and **route handlers** for public/external APIs.
- Always **validate input with Zod** before any database or external calls.
- Keep all **auth, authorization, and business context** checks on the server.

## Architecture & layering

- Organize backend code into clear layers:
  - **Route handler / Server Action**: I/O, parsing, validation, HTTP concerns only.
  - **Service layer**: business rules, orchestration.
  - **Repository / DAL**: database access, Supabase queries, and caching.
- Keep each function **small and focused**, returning plain data objects (no JSX).
- Never access the database directly from client components.

## Server Actions vs. route handlers (high level)

- Use **Server Actions** when:
  - The only consumer is the **Next.js UI**.
  - You need **mutations + revalidation** (`revalidatePath`, `revalidateTag`).
  - You want built-in CSRF protection and form integration.
- Use **route handlers** (`app/api/.../route.ts`) when:
  - The API must be consumed by **other services or clients**.
  - You need **pure HTTP semantics** (RESTful endpoints, status codes, headers).

## Input validation & types

- Define Zod schemas for:
  - Request body
  - Query/search params
  - URL params (ids, cursors, etc.)
- Always:
  - Parse and validate before calling services/DAL.
  - Return `400` on validation failure with a safe, minimal error payload.
- Infer and export **TypeScript types** from schemas for end-to-end type safety.

## Data access & performance

- Centralize Supabase/DB access in the **DAL/repository** layer.
- Follow query rules:
  - Avoid N+1: use relations and well-designed queries.
  - Always paginate lists with stable ordering.
  - Select only the columns you actually need.
- Use **caching** where appropriate (React `cache`, Next data cache, tags) to reduce repeated queries.

## Security & robustness

- Derive `userId` / `businessId` from the **authenticated Supabase session**, never from client input.
- Enforce **authorization** at the service/DAL layer for every resource access.
- Handle errors explicitly:
  - Map expected errors to appropriate HTTP statuses.
  - Log unexpected errors server-side; never leak stack traces to clients.
- Be careful with secrets:
  - Keep secrets only in **server-side code** and environment variables.
  - Never expose service role keys to the client.

## Logging, observability & maintainability

- Log:
  - Key lifecycle events (created/updated/deleted entities).
  - Integration failures (Supabase, third-party APIs).
  - Security-relevant events (auth failures, permission denials).
- Keep logs structured and redact sensitive fields.
- Prefer **pure, testable functions** in services/DAL with explicit dependencies.
- Delete dead code and keep backend modules small, cohesive, and well-named.


---
name: apis
description: Editing API routes
---

When working on APIs:

- Always build **resource-oriented, RESTful** APIs
- Never trust user input
- Use **Zod** for all validation
- Define **input and output** types with Zod schemas
- Export **inferred types** generated from schemas

## Design & HTTP semantics

- Prefer **clear, resource-based routes**:
  - `GET /api/projects` – list
  - `POST /api/projects` – create
  - `GET /api/projects/:id` – detail
  - `PATCH /api/projects/:id` – partial update
- Use **appropriate status codes**:
  - `200/201` success, `400` validation errors, `401` unauthenticated, `403` forbidden, `404` not found, `409` conflict, `500` unexpected.
- Keep responses **stable and versioned**:
  - Avoid breaking changes; if needed, version: `/api/v1/...`.

## Validation & Types (Zod-first)

- All external input (body, query, params, headers) MUST:
  - Be parsed and validated with **Zod**.
  - Return `400` with a safe error payload on validation failure.
- Always define a **schema + inferred TypeScript type**:

```ts
import { z } from "zod";

export const createProjectSchema = z.object({
  name: z.string().min(1),
  description: z.string().optional(),
});

export type CreateProjectInput = z.infer<typeof createProjectSchema>;
```

## Canonical Next.js route pattern (simplified)

```ts
// app/api/projects/route.ts
import { NextResponse } from "next/server";
import { z } from "zod";

const querySchema = z.object({
  page: z.coerce.number().int().min(1).default(1),
  pageSize: z.coerce.number().int().min(1).max(100).default(20),
});

export async function GET(req: Request) {
  const url = new URL(req.url);
  const parseResult = querySchema.safeParse(
    Object.fromEntries(url.searchParams),
  );
  if (!parseResult.success) {
    return NextResponse.json({ error: "Invalid query" }, { status: 400 });
  }

  const { page, pageSize } = parseResult.data;
  // Fetch data, always with LIMIT and stable ordering
  return NextResponse.json({ data: [], page, pageSize });
}
```

## Security must-dos

- **Auth & authz**:
  - Require authentication for any non-public data.
  - Authorize at the **resource level** (e.g. filter by `user_id` / `business_id` on every query).
- **Input safety**:
  - Never pass unvalidated input into DB queries or third-party APIs.
- **Error handling**:
  - Do not leak stack traces or internal error details; log them server-side only.
- **Rate limiting**:
  - Apply rate limits on sensitive routes (login, write-heavy operations).

## Performance & pagination

- Always paginate list endpoints:
  - Use **cursor or page/pageSize** and **stable ordering** (e.g. by `created_at` or `id`).
- Prefer **single, well-scoped queries** over N+1 patterns.
- Return only required fields; avoid over-fetching.

Canonical pagination shape:

```ts
{
  data: T[];
  nextCursor?: string;
}
```

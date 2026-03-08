# Backend Layering Examples (Next.js + Supabase + Zod)

This file shows **golden-path** examples for how to structure backend code into:

- Route handler / Server Action (I/O + validation)
- Service layer (business logic)
- Repository / DAL (Supabase/Postgres access)

All examples assume:

- Next.js App Router (`app/`),
- TypeScript,
- Zod for validation,
- Supabase with RLS and business scoping.

---

## Example 1: Route handler → service → repository

### 1. Route handler (HTTP + validation only)

`app/api/projects/route.ts`

```ts
import { NextResponse } from "next/server";
import { z } from "zod";
import { listProjects } from "@/server/services/projects-service";
import { createClient } from "@/core/supabase/server";
import { cookies } from "next/headers";

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

  const cookieStore = await cookies();
  const supabase = createClient(cookieStore);
  const {
    data: { user },
    error: authError,
  } = await supabase.auth.getUser();

  if (authError || !user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const { page, pageSize } = parseResult.data;

  try {
    const result = await listProjects({
      supabase,
      userId: user.id,
      page,
      pageSize,
    });

    return NextResponse.json(result, { status: 200 });
  } catch (error) {
    // Map expected errors to 4xx; treat everything else as 500.
    return NextResponse.json({ error: "Internal server error" }, { status: 500 });
  }
}
```

### 2. Service layer (business rules)

`src/server/services/projects-service.ts`

```ts
import type { SupabaseClient } from "@supabase/supabase-js";
import { listProjectsByUser } from "@/server/repositories/projects-repository";

interface ListProjectsParams {
  supabase: SupabaseClient;
  userId: string;
  page: number;
  pageSize: number;
}

export async function listProjects(params: ListProjectsParams) {
  const { supabase, userId, page, pageSize } = params;

  const limit = pageSize;
  const offset = (page - 1) * pageSize;

  return listProjectsByUser({ supabase, userId, limit, offset });
}
```

### 3. Repository / DAL (Supabase queries)

`src/server/repositories/projects-repository.ts`

```ts
import type { SupabaseClient } from "@supabase/supabase-js";

interface ListProjectsByUserParams {
  supabase: SupabaseClient;
  userId: string;
  limit: number;
  offset: number;
}

export async function listProjectsByUser(params: ListProjectsByUserParams) {
  const { supabase, userId, limit, offset } = params;

  const query = supabase
    .from("projects")
    .select("*")
    .eq("created_by", userId)
    .order("created_at", { ascending: false })
    .range(offset, offset + limit - 1);

  const { data, error } = await query;

  if (error) {
    throw error;
  }

  return {
    data: data ?? [],
    pagination: {
      limit,
      offset,
    },
  };
}
```

---

## Example 2: Server Action → service → repository

Use a Server Action when the only consumer is your own UI and you want automatic form handling + revalidation.

### 1. Server Action (UI entrypoint)

`app/(dashboard)/projects/actions.ts`

```ts
"use server";

import { z } from "zod";
import { revalidatePath } from "next/cache";
import { cookies } from "next/headers";
import { createClient } from "@/core/supabase/server";
import { createProject } from "@/server/services/projects-service";

const createProjectSchema = z.object({
  name: z.string().min(1),
  description: z.string().max(2000).optional(),
});

export async function createProjectAction(formData: FormData) {
  const raw = {
    name: formData.get("name"),
    description: formData.get("description"),
  };

  const parseResult = createProjectSchema.safeParse(raw);

  if (!parseResult.success) {
    return {
      ok: false,
      fieldErrors: parseResult.error.flatten().fieldErrors,
    };
  }

  const cookieStore = await cookies();
  const supabase = createClient(cookieStore);
  const {
    data: { user },
    error: authError,
  } = await supabase.auth.getUser();

  if (authError || !user) {
    return { ok: false, error: "Unauthorized" };
  }

  try {
    await createProject({
      supabase,
      userId: user.id,
      input: parseResult.data,
    });

    revalidatePath("/projects");
    return { ok: true };
  } catch {
    return { ok: false, error: "Could not create project" };
  }
}
```

### 2. Service & repository

Service and repository can follow the same pattern as in Example 1; the Server Action replaces the HTTP layer but keeps the rest identical.


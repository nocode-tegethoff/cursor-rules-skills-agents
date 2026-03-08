# Server Actions vs API Routes (Guidance)

Use this reference to decide whether to implement backend behavior as a **Server Action** or an **API route**.

Both should follow the same core principles:

- Input validation with Zod.
- Business logic in services.
- Data access in repositories/DAL.
- Auth and authorization on the server, never in the client.

---

## When to use a Server Action

Choose a **Server Action** when:

- The only consumer is your **Next.js UI**.
- You are handling **form submissions or UI-triggered mutations** (create/update/delete).
- You want automatic:
  - CSRF protection.
  - Access to `cookies()` / `headers()` in a server-only context.
  - Integration with `revalidatePath` / `revalidateTag`.

Typical examples:

- Creating/updating a project from a dashboard page.
- Toggling feature flags for the current user or business.
- Submitting configuration changes for the logged-in tenant.

### Example shape (pseudocode)

```ts
"use server";

import { z } from "zod";
import { cookies } from "next/headers";
import { revalidatePath } from "next/cache";
import { createClient } from "@/core/supabase/server";
import { someService } from "@/server/services/some-service";

const inputSchema = z.object({
  id: z.string().uuid().optional(),
  name: z.string().min(1),
});

export async function saveSomethingAction(formData: FormData) {
  const raw = {
    id: formData.get("id"),
    name: formData.get("name"),
  };

  const parsed = inputSchema.safeParse(raw);
  if (!parsed.success) {
    return { ok: false, fieldErrors: parsed.error.flatten().fieldErrors };
  }

  const cookieStore = await cookies();
  const supabase = createClient(cookieStore);
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return { ok: false, error: "Unauthorized" };
  }

  await someService({ supabase, userId: user.id, input: parsed.data });
  revalidatePath("/some-path");
  return { ok: true };
}
```

---

## When to use an API route

Choose an **API route** (`app/api/.../route.ts`) when:

- The behavior must be callable from **outside** your own UI:
  - Other internal services.
  - 3rd-party integrations or webhooks.
  - CLI tools or automation.
- You care about **pure HTTP semantics**:
  - RESTful resources.
  - Status codes, headers, content negotiation.
- You expect this contract to be **versioned and documented** as an API.

Typical examples:

- Public or partner-facing APIs.
- Webhooks from external systems (e.g. billing, IoT events).
- Internal APIs consumed by other services.

### Example shape (pseudocode)

```ts
import { NextResponse } from "next/server";
import { z } from "zod";
import { cookies } from "next/headers";
import { createClient } from "@/core/supabase/server";
import { someService } from "@/server/services/some-service";

const bodySchema = z.object({
  name: z.string().min(1),
});

export async function POST(req: Request) {
  const json = await req.json().catch(() => null);
  const parsed = bodySchema.safeParse(json);

  if (!parsed.success) {
    return NextResponse.json(
      { error: "Invalid body" },
      { status: 400 },
    );
  }

  const cookieStore = await cookies();
  const supabase = createClient(cookieStore);
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const result = await someService({
      supabase,
      userId: user.id,
      input: parsed.data,
    });

    return NextResponse.json(result, { status: 201 });
  } catch (error) {
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 },
    );
  }
}
```

---

## Decision checklist

Before implementing new backend behavior, ask:

- **Who are the consumers?**
  - Only this app’s UI → prefer **Server Action**.
  - Multiple clients / external systems → prefer **API route**.
- **Do I need HTTP-level concerns?**
  - If yes (status codes, headers, CORS, API versioning) → **API route**.
- **Am I doing UI-centric mutations with revalidation?**
  - If yes → **Server Action** often gives a cleaner flow.

Regardless of choice:

- Keep business logic in **services**.
- Keep data access in **repositories/DAL**.
- Always validate inputs with **Zod** and derive `userId`/`businessId` from the Supabase session.


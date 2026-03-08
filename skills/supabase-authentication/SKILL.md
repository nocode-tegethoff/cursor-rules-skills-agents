---
name: supabase-authentication
description: Use when implementing or updating authentication flows with Supabase.
---

## Purpose

Ensure all authentication flows using Supabase Auth are **secure**, **consistent**, and align with Supabase’s recommended patterns for sign-up, sign-in, session handling, and provider-based login.

## When to use this skill

- You create or update any **login, signup, logout, password reset, or session** behavior.
- You integrate or modify **OAuth/social login** (e.g. Google, GitHub) via Supabase.
- You touch **Supabase client initialization** that affects auth (server or browser).

## Core principles

- **Single source of truth for auth state**:
  - Use the shared Supabase client helpers already defined in the project (e.g. `createClient`, `createServiceRoleClient`) instead of ad-hoc clients.
  - Do not manually cache or duplicate auth state; rely on Supabase sessions and helpers.
- **Never trust client-provided identity**:
  - Never accept `userId` or `businessId` from request bodies, search params, or headers.
  - Always derive identity from `supabase.auth.getUser()` on the server and/or the authenticated client instance in the browser.
- **Follow official Supabase auth flows**:
  - For email/password:
    - Sign up with `supabase.auth.signUp({ email, password })` and handle email confirmation according to the project’s dashboard settings.
    - Sign in with `supabase.auth.signInWithPassword({ email, password })`.
  - For OAuth / social login:
    - Use `supabase.auth.signInWithOAuth({ provider, options })` and configure redirect URLs in the Supabase dashboard.
  - For magic links / OTP:
    - Use the documented `signInWithOtp` / magic link flows only when explicitly required.
- **Respect Supabase dashboard configuration**:
  - Confirm whether **email confirmation** and **allow new signups** are enabled and design flows (UI messages, redirects) accordingly.
  - Do not hardcode behavior that conflicts with dashboard settings (e.g. assuming instant sign-in when confirmation is required).
- **Session & security hygiene**:
  - Never log or expose access tokens or refresh tokens to logs, analytics, or client-visible error messages.
  - Ensure logout always calls `supabase.auth.signOut()` and clears any derived app state.
  - Keep sensitive auth logic on the server whenever possible; avoid leaking implementation details to the client.

## Golden reference (simplified patterns)

### 1. Using the shared Supabase clients in this project

**Browser components (public, user-facing auth UI)**

```ts
import { createClient } from "@/core/supabase/client";

const supabase = createClient();

// Example: sign in with email + password
const { data, error } = await supabase.auth.signInWithPassword({
  email,
  password,
});
```

**Server code (Route Handlers, Server Components, Server Actions)**

```ts
// app/api/example/route.ts
import { NextResponse } from "next/server";
import { cookies } from "next/headers";
import { createClient } from "@/core/supabase/server";

export async function GET() {
  const cookieStore = await cookies();
  const supabase = createClient(cookieStore);

  const {
    data: { user },
    error,
  } = await supabase.auth.getUser();

  if (error || !user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  // Business logic here must not accept userId from the client;
  // always use user.id and business context derived from Supabase.

  return NextResponse.json({ userId: user.id });
}
```

**Service-role usage (backend-only, never exposed to the browser)**

```ts
import { createServiceRoleClient } from "@/core/supabase/server";

export async function doAdminWork() {
  const supabase = await createServiceRoleClient();
  // Use this only for privileged, backend-only operations.
}
```

### 2. Core auth flows

**Email + password sign-up with confirmation-aware UI**

```ts
// Browser-side (simplified)
const { data, error } = await supabase.auth.signUp({
  email,
  password,
  options: {
    emailRedirectTo: `${window.location.origin}/auth/callback`,
  },
});

if (error) {
  // Show a safe, generic error message
}

// If email confirmation is required, inform the user:
// "Check your email to confirm your account before logging in."
```

**Email + password sign-in**

```ts
const { data, error } = await supabase.auth.signInWithPassword({
  email,
  password,
});

if (error) {
  // Map errors to non-leaky messages (e.g. "Invalid email or password")
}
// On success, rely on Supabase session handling and project-level routing guards.
```

**OAuth / social login (e.g. Google)**  
See `https://supabase.com/docs/guides/auth/social-login` for provider-specific options.

```ts
await supabase.auth.signInWithOAuth({
  provider: "google",
  options: {
    redirectTo: `${window.location.origin}/auth/callback`,
  },
});
```

When in doubt, consult the official Supabase docs:
- General Auth overview: `https://supabase.com/docs/guides/auth`
- Password-based auth: `https://supabase.com/docs/guides/auth/passwords`
- Social/OAuth login: `https://supabase.com/docs/guides/auth/social-login`

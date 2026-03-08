---
name: deploy-app
description: Deploy the Next.js app to Vercel safely and consistently.
---

# Deploy App (Vercel)

Deploy the application to Vercel (staging or production) with a repeatable, scriptable workflow.

This skill assumes:

- The project is a Next.js app hosted on Vercel.
- The Vercel project is already linked to this repository or to your local checkout.
- The Vercel CLI is installed and authenticated (`npm i -g vercel` or `npx vercel login`).

Whenever you need details about specific Vercel options or flags, **query the Vercel docs via the `context7` MCP** (e.g. “Vercel CLI deployment options”, “Next.js on Vercel build configuration”) instead of guessing.

## When to use this skill

- Deploying the app to a **preview/staging** environment for testing.
- Deploying the app to **production**.
- Verifying that a change is safely deployable (build passes, environment is configured).

## Environments

- **Preview / Staging**
  - Use for testing branches and features.
  - Typically corresponds to non-production Vercel environments or preview deployments.
- **Production**
  - Use only when changes are reviewed and tested.
  - Maps to the Vercel “Production” environment and main branch.

Use `context7` MCP to look up how Vercel maps Git branches and environments for your configuration if needed.

## Pre-deployment checklist

Before running a deployment:

- Code:
  - All tests pass (`run-tests-fix-failures` skill and its scripts).
  - TypeScript build passes (no type errors).
  - Linting passes (or at least no new critical issues).
- Configuration:
  - Required **environment variables** are configured in the correct Vercel environment (staging vs production).
  - Supabase keys and URLs are set only in **server-side** environments as appropriate.
  - Any new database migrations are applied and committed.
- Security:
  - No hardcoded secrets, tokens, or credentials.
  - RLS and access controls are not weakened as part of this release.

See `references/vercel-deployment-checklist.md` for a more detailed step-by-step guide.

## How to deploy (CLI)

Prefer the `scripts/deploy-vercel.ps1` script from this skill to encapsulate the deploy command and avoid mistakes.

### Staging / preview

- Run from the repository root (PowerShell):
  - `.\.cursor\skills\deploy-app\scripts\deploy-vercel.ps1 -Environment preview`
- Or, if already in the skill directory:
  - `.\scripts\deploy-vercel.ps1 -Environment preview`

This will invoke the Vercel CLI with the appropriate flags for a non-production deployment.

### Production

- Run from the repository root (PowerShell):
  - `.\.cursor\skills\deploy-app\scripts\deploy-vercel.ps1 -Environment production`

The script will:

- Ensure it runs from the repo root.
- Use your package manager’s build script (if needed) before deploying.
- Call the Vercel CLI with `--prod` for production when requested.

For detailed CLI behaviors (e.g. `--prebuilt`, `--prod`, environment selection), query the Vercel CLI docs via `context7` MCP.

## Using context7 MCP for Vercel docs

When you need more detail than this skill provides:

- Ask `context7` MCP things like:
  - “Vercel CLI deployment reference”
  - “How to configure environment variables for Next.js on Vercel”
  - “Next.js image optimization configuration on Vercel”
- Use those docs to refine:
  - Build and deployment flags for your scripts.
  - Best practices for caching, edge functions, and ISR on Vercel.

Do **not** guess advanced Vercel settings; always consult the official docs through `context7`.

## Post-deployment verification

After deployment:

- Confirm:
  - The deployment URL is healthy (no 5xx errors, no obvious regressions).
  - Critical paths load correctly (auth, dashboards, main workflows).
  - Localization works for the supported locales.
  - Supabase-backed features work and respect RLS/business scoping.
- For production:
  - Check logging/monitoring for errors introduced by the release.
  - Roll back or redeploy if critical issues are detected.

Use the `documentation` skill to update any deployment or runbook docs if this release introduces significant operational changes.


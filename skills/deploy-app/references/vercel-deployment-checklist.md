# Vercel Deployment Checklist

Use this checklist for each deployment (preview or production). Adapt as needed based on current Vercel best practices from the official docs (query via `context7` MCP).

## 1. Pre-flight checks

- [ ] **Branch / environment**
  - [ ] You are on the correct Git branch for this deployment.
  - [ ] The corresponding Vercel project and environment are configured (preview vs production).
- [ ] **Dependencies & build**
  - [ ] Dependencies are installed (`pnpm install` / `yarn install` / `npm install`).
  - [ ] Local build succeeds (`pnpm build` / `yarn build` / `npm run build`).
- [ ] **Tests & quality**
  - [ ] All tests pass (see `run-tests-fix-failures` skill and `scripts/run-tests.ps1`).
  - [ ] Linting passes and there are no new critical warnings.
  - [ ] TypeScript has no errors.

## 2. Environment configuration (Vercel)

Verify in the Vercel dashboard (or via CLI, using docs from `context7` MCP):

- [ ] **Environment variables**
  - [ ] Required variables are set for the target environment (preview or production).
  - [ ] Supabase URLs and keys are present only where needed and never exposed to the client unintentionally.
  - [ ] No secrets are hardcoded in the repository.
- [ ] **Next.js / Vercel settings**
  - [ ] Image domains and optimization settings are correct.
  - [ ] Any edge / function region configuration matches your data locality requirements.
  - [ ] Preview vs production settings are appropriate (e.g. logging, instrumentation).

## 3. Database & migrations

- [ ] All required database migrations are applied in the appropriate environment.
- [ ] RLS policies remain strict and correct; no temporary relaxations are left in place.
- [ ] Any data backfills or one-off scripts have been run and verified.

## 4. Deployment execution

- [ ] For **preview/staging**:
  - [ ] Run `deploy-vercel.ps1 -Environment preview` (or equivalent CLI command).
  - [ ] Confirm the preview URL is generated and accessible.
- [ ] For **production**:
  - [ ] Changes have been reviewed and approved.
  - [ ] Run `deploy-vercel.ps1 -Environment production` (or equivalent CLI command).
  - [ ] The deployment completed without errors.

## 5. Post-deployment verification

- [ ] **Smoke tests**
  - [ ] Home / landing page loads without errors.
  - [ ] Authentication flows (login/logout) work.
  - [ ] Primary dashboards or workflows load and use live data.
- [ ] **Localization**
  - [ ] Supported locales render correctly.
  - [ ] No untranslated strings appear in critical paths.
- [ ] **Data & security**
  - [ ] Supabase-backed features behave as expected and respect tenant boundaries.
  - [ ] No obvious security regressions (e.g. data exposed across tenants).
- [ ] **Monitoring**
  - [ ] Check logs and error tracking for new issues after the deployment.
  - [ ] Roll back or redeploy if critical issues are found.

## 6. Documentation & follow-up

- [ ] Update any relevant runbooks or deployment docs if processes changed.
- [ ] Note any new operational risks or follow-up tasks discovered during deployment.


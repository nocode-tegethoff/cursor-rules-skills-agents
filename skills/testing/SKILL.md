---
name: testing
description: Write and maintain tests with Vitest (Vite-native), React Testing Library for React/Next, and optional browser/E2E. Use when adding tests, fixing failures, or improving quality.
---

# Testing (Vitest + React Testing Library + Next.js)

Use this skill when writing or updating tests. Tests live in `__tests__/` and mirror `src/` structure. Canonical strategy and **CI/CD** (workflows, secrets, local scripts): [`docs/technical/testing-strategy.md`](../../../docs/technical/testing-strategy.md) (includes former `ci-cd.md` content). **Intent:** Prefer [`docs/prds/prd.md`](../../../docs/prds/prd.md); triangulate with technical docs and rules (see `.cursor/rules/project-context.mdc` — **PRD and implementation**).

## Related: test-implementation subagent

- **Staged tests from intended behavior** (PRD/docs-first, Vitest + optional `npm run ci`, strict escalation): Cursor subagent [`.cursor/agents/test-implementation.md`](../agents/test-implementation.md) — invoke with **`/test-implementation`** or explicit request.

## When to Use

- Adding or changing unit tests for components, services, or API behavior.
- A test fails: **do not** change the test to make it pass. Fix the implementation or report to the user. Tests are the contract; never force a test to pass with a workaround or by weakening assertions.
- Aiming for ~90% coverage with **meaningful** tests that catch real bugs and block bad deploys—not many small tests that only assert trivial variations of the same behavior.

## Golden Rules

1. **Test behavior, not implementation.** Assert observable outcomes (what the user or caller sees), not internal state, private functions, or how something is implemented. Refactors should not break tests if behavior is unchanged.
2. **One behavior, one (or few) tests.** Prefer a small number of tests that cover the full behavior of a feature over dozens of tests that each check a tiny variant. Avoid testing every prop combination; test the general, important flows.
3. **Never force a test to pass.** If a test fails, fix the code under test or escalate to the user. Do **not**:
   - Relax or remove assertions so the test passes.
   - Add `// @ts-expect-error` or skip the test to “fix” it.
   - Implement workarounds in the test (e.g. mocking away the thing being tested) just to get green.
4. **Non-trivial tests.** Tests should exercise real logic and interactions. Trivial getter/setter or “it renders” tests with no behavior add noise; prefer tests that would catch regressions in prod.

## API route tests

- Assert **HTTP status** and **JSON body** the client would receive (success and validation errors). Use **`vi.clearAllMocks()`** in `beforeEach` when asserting spies were **not** called, so parallel or ordered tests do not leak call counts.
- Prefer **unambiguous invalid inputs** (e.g. schema-breaking values) if Zod coercion makes edge cases unclear.

## Vitest (this repo and upstream)

- Use `describe` for the unit (e.g. component or module), `test`/`it` for a single behavior.
- **Descriptions = user-facing behavior.** Good: `test('shows error when email is invalid')`. Bad: `test('calls validateEmail')`.
- **Default runner:** `vitest` with `environment: 'node'` is correct for pure logic, services with mocked repos, and API-style tests without a DOM.
- **DOM / React:** set `test.environment` to `happy-dom` or `jsdom` (install the package), add `@vitejs/plugin-react` (or SWC) for JSX in tests, and keep `@/*` resolution aligned with `tsconfig` (e.g. `vite-tsconfig-paths` or `resolve.alias`).
- **Split configs:** use **`test.projects`** (`vitest.config.ts`) when you need both **Node** and **DOM** (or Vitest **Browser Mode**) suites—different `include`, `environment`, and `setupFiles` without one config fighting another.
- **Isolation:** prefer `clearMocks` / `restoreMocks` where helpful; use **`vi.stubEnv`** / **`vi.stubGlobal`** for `process.env`, `import.meta.env`, and browser globals; call **`vi.unstubAllEnvs()`** / **`vi.unstubAllGlobals()`** in `afterEach` when stubbing.
- **Mocking:** use `vi.mock()` for modules; **MSW** for HTTP when many routes are involved. Do not mock the code under test to make a test pass.
- **Assertions:** use `expect()`; use `toHaveBeenCalled` / `toHaveBeenCalledWith` only to verify **integration points** (e.g. “persisted via API”), not internal call order trivia.

## Next.js

- **Client components** (`"use client"` in `src/features/`, `src/components/`): primary targets for RTL + jsdom/happy-dom.
- **Async Server Components** and full **page** integration: **Vitest alone is insufficient** for async RSC; use **E2E** (e.g. Playwright) or test extracted **pure** helpers in Node. See [Next.js testing](https://nextjs.org/docs/app/guides/testing).
- **Route handlers** (`src/app/api/`): invoke handlers with `NextRequest`/`Request`; mock auth and services/repos as needed.
- **`next/*` mocks:** use `vi.mock('next/navigation')` (etc.) only when required; keep mocks small and stable.

## React Testing Library

- **Query like a user:** prefer `getByRole`, `getByLabelText`, then `getByText`. Avoid `getByTestId` unless no semantic query fits.
- Use **`@testing-library/user-event`** for interactions (click, type, tab) instead of raw `fireEvent` when possible—assert **visible outcomes** after the interaction (text, state), not that a specific handler fired unless that is the contract.
- Render, act, then assert on **visible** outcomes (text, roles, ARIA). Do not assert on React state or internal props.
- Use **`findBy*`** or **`waitFor`** for async updates; avoid arbitrary `setTimeout` sleeps.

## Optional: Vitest Browser Mode

- For real browser behavior (CSS, layout, focus, native events), use **Vitest Browser Mode** with a provider (e.g. Playwright) and `vitest-browser-react`. Heavier than jsdom—use selectively. See [Vitest Browser](https://vitest.dev/guide/browser/).

## Structure

- **Arrange–Act–Assert:** set up, perform the behavior, assert the outcome.
- Keep each test short and readable; split by **behavior**, not by line count or one-assert dogma.

## Coverage

- Target ~90% coverage on critical paths (session actions, validation, payouts, economy). Do not chase 100% with low-value tests.

## References

- [Vitest](https://vitest.dev)
- [Vitest Browser Mode](https://vitest.dev/guide/browser/)
- [Vite config](https://vite.dev/config/)
- [Next.js: Testing](https://nextjs.org/docs/app/guides/testing)
- [Next.js: Vitest](https://nextjs.org/docs/app/building-your-application/testing/vitest)
- [React Testing Library](https://testing-library.com/docs/react-testing-library/intro/)

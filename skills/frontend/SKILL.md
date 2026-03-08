---
name: frontend
description: Working on frontend components
---
When working in components directory:

- Always use **Tailwind** for styling (utility-first, design-token driven)
- Use **Framer Motion** for meaningful, subtle animations (never for decoration only)
- Follow **component naming conventions** and feature-based structure
- Apply **modern UI/UX best practices** for clean, intuitive, accessible interfaces

## React component guidelines

- Prefer **small, focused components** with a single responsibility.
- Use **server components by default**, client components only when needed (state, effects, browser APIs).
- Keep props **typed and explicit**; avoid `any`.
- Lift state only as high as necessary; use **Zustand** for shared app state when appropriate.
- Derive state instead of duplicating it; avoid unnecessary re-renders (memoize heavy children/selectors).

## Tailwind & design system

- Use **Tailwind utilities** as the primary styling mechanism.
- Centralize colors, spacing, and typography through the existing **design tokens** (e.g. `bg-background`, `text-foreground`, `primary`, `muted`).
- Prefer **composed classes** in `className` over ad-hoc inline styles.
- Keep class lists readable:
  - Group related utilities (layout → spacing → typography → color → effects).
  - Extract **reusable UI patterns** into components instead of copy-pasting long class strings.
- Respect dark mode using the app’s theme tokens; never hardcode light-only colors.

Canonical Tailwind usage:

```tsx
export function Card({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <section className="rounded-xl border bg-card p-4 shadow-sm">
      <h2 className="mb-2 text-lg font-semibold text-card-foreground">{title}</h2>
      <div className="text-sm text-muted-foreground">{children}</div>
    </section>
  );
}
```

## Framer Motion principles

- Use **Framer Motion** for:
  - Page transitions, modals/drawers, toasts.
  - Emphasizing hierarchy and feedback (hover/press/selection states beyond basic CSS).
- Prefer **variants** for complex components and consistent motion across states.
- Animate **opacity and transforms** (`x/y/scale/rotate`) instead of layout properties.
- Honor `prefers-reduced-motion` and offer non-animated fallbacks for essential interactions.

Canonical motion usage:

```tsx
import { motion } from "framer-motion";

const cardVariants = {
  hidden: { opacity: 0, y: 8 },
  visible: { opacity: 1, y: 0 },
};

export function AnimatedCard(props: React.ComponentProps<"div">) {
  return (
    <motion.div
      variants={cardVariants}
      initial="hidden"
      animate="visible"
      transition={{ duration: 0.22, ease: "easeOut" }}
      {...props}
    />
  );
}
```

## UX, accessibility & performance

- Always:
  - Use **semantic HTML** (`button`, `nav`, `header`, `main`, `section`, `form`, `label`, etc.).
  - Ensure proper keyboard support (tab order, `Enter`/`Space` activation, focus styles).
  - Provide accessible names (`aria-label`, `aria-labelledby`) where needed.
- Keep layouts **responsive-first**:
  - Design for mobile, then enhance with responsive Tailwind breakpoints.
- Optimize perceived performance:
  - Use **skeletons/spinners** where loading is noticeable.
  - Avoid blocking the main thread with heavy computations in client components.
  - Prefer streaming/server data fetching where possible.

## Consistency & maintainability

- Reuse **shadcn-ui** and existing components before creating new ones.
- Keep files small and colocate logic by feature.
- Use **clear naming** for components and props (`PrimaryButton`, `isOpen`, `onClose`).
- Delete dead code and avoid half-implemented components; keep the UI surface polished.

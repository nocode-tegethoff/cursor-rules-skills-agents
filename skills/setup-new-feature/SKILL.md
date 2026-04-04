---
name: setup-new-feature
description: Setup New Feature
disable-model-invocation: true
---

# Setup New Feature

## Overview
Systematically set up a new feature from initial planning through to implementation structure.

## Steps
1. **Define requirements**
   - Clarify feature scope and goals within context of existing features
   - Identify user stories and acceptance criteria
   - Plan technical approach within context of existing architecture
   - Add or extend functional requirements in [`docs/prds/prd.md`](../../docs/prds/prd.md) (and `docs/technical/` for design); avoid new standalone PRD files unless the product owner explicitly splits them.

2. **Create feature branch**
   - Branch from main/develop
   - Set up local development environment if needed
   - Configure any new dependencies

3. **Plan architecture**
   - Design data models, logic, and APIs within context of existing codebase
   - Plan UI components and flow
   - Consider testing strategy

## Feature Setup Checklist
- [ ] Requirements documented
- [ ] User stories written
- [ ] Technical approach planned
- [ ] Feature branch created
- [ ] Development environment ready

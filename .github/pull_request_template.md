## Description

<!-- Describe what changed and why. Link issues: Closes #123 -->

## Type of Change

- [ ] `feat` — New feature
- [ ] `fix` — Bug fix
- [ ] `refactor` — Code refactor (no functional change)
- [ ] `perf` — Performance improvement
- [ ] `test` — New or updated tests
- [ ] `docs` — Documentation
- [ ] `chore` — Maintenance

## Affected Area

- [ ] Schema (tables, columns)
- [ ] RLS policies
- [ ] Triggers / Functions
- [ ] Edge Functions
- [ ] Migrations
- [ ] Seed data
- [ ] Config / CI

## Database Changes

<!-- List migrations if schema changed -->

| Migration | Description |
|-----------|-------------|
| `YYYYMMDD_name.sql` | ... |

## Checklist

- [ ] Tests pass (`npm run test`)
- [ ] New tables have RLS enabled with policies
- [ ] New tables have index on `user_id`
- [ ] CHECK constraints for enums and ranges
- [ ] Migrations use `IF NOT EXISTS` / `IF EXISTS`
- [ ] SECURITY DEFINER functions have `SET search_path`
- [ ] Commits follow Conventional Commits
- [ ] Documentation updated if needed

## Test Plan

<!-- How was this tested? -->

## Notes for Reviewer

<!-- Risks, design decisions, anything the reviewer should know -->

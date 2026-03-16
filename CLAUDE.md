# dobby-backend — Project Documentation

## Description

Supabase backend for **Personal Finance Tutor** (dobby-frontend). The frontend is a React SPA that syncs all its state with Supabase via `supabase-js`. There is no custom REST API — the frontend queries tables directly, protected by Row Level Security (RLS).

**Frontend repository:** `dobby-frontend` (separate repo)

## Stack

- **PostgreSQL 17** — Main database
- **Supabase Auth** — Authentication (email/password + Google OAuth)
- **Row Level Security (RLS)** — Row-level security on ALL tables
- **Edge Functions** — Deno 2.x for serverless logic
- **Supabase Realtime** — Real-time sync (enabled)
- **pgTAP** — PostgreSQL testing framework
- **Deno** — Runtime for Edge Functions and their tests

## Commands

### Local development
```bash
npm run dev              # Start local Supabase (requires Docker)
npm run stop             # Stop local Supabase
npm run status           # Show URLs, keys, and status
```

### Migrations
```bash
npm run migrate:new <name>     # Create new migration
npm run migrate:up             # Apply pending migrations (local)
npm run migrate:list           # List migration status
npm run migrate:repair         # Repair migration state
npm run db:reset               # Full reset (migrations + seed)
npm run db:push                # Push migrations to production
npm run db:diff                # Generate diff of current schema
npm run db:lint                # Lint SQL schema
```

### Testing
```bash
npm run test             # pgTAP database tests
npm run test:functions   # Edge Functions tests (Deno)
npm run test:all         # All tests
```

### Edge Functions
```bash
npm run functions:serve    # Serve Edge Functions locally
npm run functions:deploy   # Deploy Edge Functions to production
```

### Types and deploy
```bash
npm run types            # Generate TypeScript types from schema
npm run deploy           # Full deploy (migrations + functions)
```

## Testing

### pgTAP (database tests)
- Location: `tests/database/`
- Framework: pgTAP (PostgreSQL extension)
- Run: `npm run test` or `supabase test db`
- Minimum coverage: 80% on RLS policies and functions

### Existing tests
| File | What it verifies |
|------|-----------------|
| `00_schema.test.sql` | Tables and columns exist |
| `01_rls.test.sql` | RLS enabled, correct policies |
| `02_indexes.test.sql` | Indexes exist |
| `03_triggers.test.sql` | Triggers and functions exist |
| `04_constraints.test.sql` | CHECK constraints and FKs |

### Edge Functions (Deno test)
- Location: `tests/functions/`
- Run: `npm run test:functions`

## Gitflow

### Branches
- `main` — Production (Supabase hosted). **NO direct push.**
- `dev` — Development/integration
- `feat/<name>`, `fix/<name>`, `refactor/<name>` — from `dev`
- `hotfix/<name>` — from `main`, merge to `main` AND `dev`

### Flow
```
feat/new-table    ──PR──▶  dev  ──PR──▶  main (production)
fix/rls-policy    ──PR──▶  dev  ──PR──▶  main
hotfix/urgent     ──PR──▶  main + dev
```

## Conventional Commits

```
<type>(<scope>): <description in English>
```

### Types
`feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `chore`, `ci`

### Scopes
`schema`, `rls`, `migration`, `function`, `trigger`, `seed`, `auth`, `deps`, `ci`

### Examples
```
feat(schema): add custom categories table
fix(rls): fix delete policy on transactions
test(function): add tests for delete_user_account
chore(deps): update Supabase CLI to v1.210
ci: set up GitHub Actions for tests
```

## Database Architecture

### Tables

#### `profiles` (extends auth.users)
- PK: `id uuid` → `auth.users(id)` ON DELETE CASCADE
- Columns: name, country, currency, locale, onboarding_completed, dark_mode, debt_strategy, goal_mode, current_fund, timestamps
- Note: `biweekly_checked_items` was removed — biweekly state is now derived from `transactions.biweekly_key`
- CHECK: debt_strategy IN ('avalanche', 'snowball'), goal_mode IN ('sequential', 'parallel')

#### `incomes`
- PK: `id text`
- FK: `user_id uuid` → `profiles(id)` ON DELETE CASCADE
- Columns: name, amount, frequency, pay_days (jsonb), is_net, timestamps
- CHECK: frequency IN ('monthly', 'biweekly', 'weekly')

#### `expenses`
- PK: `id text`
- FK: `user_id uuid` → `profiles(id)` ON DELETE CASCADE
- Columns: name, amount, category, is_fixed, is_essential, due_day, payment_method, notes, timestamps
- CHECK: payment_method IN ('cash', 'debit', 'credit_card')

#### `debts`
- PK: `id text`
- FK: `user_id uuid` → `profiles(id)` ON DELETE CASCADE
- Columns: name, type, current_balance, original_amount, monthly_payment, interest_rate, annual_rate, remaining/total/completed_payments, due_day, credit_limit, minimum_payment, product_name, product_value, timestamps

#### `goals`
- PK: `id text`
- FK: `user_id uuid` → `profiles(id)` ON DELETE CASCADE
- Columns: name, icon, target_amount, current_saved, priority, category, deadline, is_flexible, notes, timestamps

#### `transactions`
- PK: `id text`
- FK: `user_id uuid` → `profiles(id)` ON DELETE CASCADE
- Columns: date, amount, type, category, description, payment_method, is_recurring, biweekly_key, created_at
- CHECK: type IN ('income', 'expense', 'debt_payment', 'savings', 'transfer'), payment_method IN ('cash', 'debit', 'credit_card')

### RLS Policies
All tables have RLS enabled. Each user can only CRUD their own records:
- `profiles`: SELECT, INSERT, UPDATE (filter: `auth.uid() = id`)
- `incomes`, `expenses`, `debts`, `goals`: SELECT, INSERT, UPDATE, DELETE (filter: `auth.uid() = user_id`)
- `transactions`: SELECT, INSERT, UPDATE, DELETE (filter: `auth.uid() = user_id`)

### Triggers
- `on_auth_user_created` → `handle_new_user()` — Auto-creates profile on signup (SECURITY DEFINER)
- `*_updated_at` → `update_updated_at()` — Auto-updates updated_at on profiles, incomes, expenses, debts, goals

### RPC Functions
- `delete_user_account()` — SECURITY DEFINER. Deletes all user data + auth.users entry. Only `authenticated` can execute it.

### Indexes
- `idx_*_user` on user_id of all tables
- `idx_transactions_date` composite (user_id, date DESC)
- `idx_transactions_biweekly_key` partial (user_id, biweekly_key) WHERE biweekly_key IS NOT NULL

## DB ↔ Frontend Mapping

The DB uses **snake_case**, the frontend uses **camelCase**. The frontend's `syncService` handles the conversion automatically.

Example: `current_balance` (DB) ↔ `currentBalance` (frontend)

## Business Rules

1. **RLS is mandatory** — NEVER create a table without RLS policies
2. **Migrations are immutable** — Once pushed, NEVER modify. Create a new one.
3. **Tests before merge** — Every schema or function change must have tests
4. **SECURITY DEFINER with care** — Only in functions that need it, always with `SET search_path`
5. **snake_case always** — Tables, columns, functions, triggers
6. **Validations in DB** — CHECK constraints for enums and ranges, don't rely only on the frontend
7. **English only** — All code, commits, comments, documentation, branch names, and PR descriptions must be in English. No Spanish.

## Slash Commands

| Command | Description |
|---------|-------------|
| `/project:dev` | Start local Supabase, show URLs and keys |
| `/project:test` | Run pgTAP and Edge Functions tests |
| `/project:migrate` | Create/apply migrations |
| `/project:security` | RLS, permissions, and grants audit |
| `/project:debug` | Debug queries, policies, functions |
| `/project:seed` | Generate/apply seed data |
| `/project:deploy` | Pre-deploy checklist and deploy to production |
| `/project:typecheck` | Generate TypeScript types from schema |
| `/project:architecture` | Schema, indexes, and performance review |

## Git Hooks

Configured in `.githooks/` (activate with `git config core.hooksPath .githooks`):

- **commit-msg** — Validates Conventional Commits with backend scopes
- **pre-commit** — SQL lint, verify migration names, Edge Functions tests
- **pre-push** — Blocks direct push to main

## Supabase Gotchas

1. **RLS and service_role** — The `service_role` key bypasses RLS. Only use in server-side Edge Functions, NEVER expose to the frontend.
2. **auth.uid()** — Only available when there's a valid JWT. In SECURITY DEFINER functions, make sure to validate `auth.uid() IS NOT NULL`.
3. **Production migrations** — `supabase db push` applies pending migrations. It's destructive if there are DROPs. Always review with `db:diff` first.
4. **Seed data** — Only applied with `supabase db reset`, NOT with `db push`. It's for local development only.
5. **Edge Functions cold start** — First invocation is slow (~500ms). Consider warm-up if critical.
6. **Timestamps** — Use `timestamptz` (with timezone), not `timestamp`. The DB stores in UTC.
7. **Frontend IDs** — The frontend generates IDs as `text` (nanoid), not UUID. Data tables use `id text PK`.
8. **CASCADE** — All FKs have `ON DELETE CASCADE`. Deleting a profile deletes ALL their data.

## Test Users (seed)

| Email | Password | Name |
|-------|----------|------|
| carlos@test.com | password123 | Carlos Rodríguez |
| maria@test.com | password123 | María López |

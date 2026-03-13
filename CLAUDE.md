# dobby-backend — Documentación del Proyecto

## Descripción

Backend en Supabase para **Tutor Financiero Personal** (dobby-frontend). El frontend es una SPA React que sincroniza todo su estado con Supabase vía `supabase-js`. No hay REST API custom — el frontend hace queries directos a las tablas, protegido por Row Level Security (RLS).

**Repositorio frontend:** `dobby-frontend` (repo separado)

## Stack

- **PostgreSQL 17** — Base de datos principal
- **Supabase Auth** — Autenticación (email/password + Google OAuth)
- **Row Level Security (RLS)** — Seguridad a nivel de fila en TODAS las tablas
- **Edge Functions** — Deno 2.x para lógica serverless
- **Supabase Realtime** — Sync en tiempo real (habilitado)
- **pgTAP** — Framework de testing para PostgreSQL
- **Deno** — Runtime para Edge Functions y sus tests

## Comandos

### Desarrollo local
```bash
npm run dev              # Levanta Supabase local (requiere Docker)
npm run stop             # Detiene Supabase local
npm run status           # Muestra URLs, keys y estado
```

### Migraciones
```bash
npm run migrate:new <nombre>   # Crea nueva migración
npm run migrate:up             # Aplica migraciones pendientes (local)
npm run migrate:list           # Lista estado de migraciones
npm run migrate:repair         # Repara estado de migraciones
npm run db:reset               # Reset completo (migraciones + seed)
npm run db:push                # Push migraciones a producción
npm run db:diff                # Genera diff del schema actual
npm run db:lint                # Lint del schema SQL
```

### Testing
```bash
npm run test             # Tests pgTAP de base de datos
npm run test:functions   # Tests de Edge Functions (Deno)
npm run test:all         # Todos los tests
```

### Edge Functions
```bash
npm run functions:serve    # Sirve Edge Functions localmente
npm run functions:deploy   # Deploy Edge Functions a producción
```

### Tipos y deploy
```bash
npm run types            # Genera tipos TypeScript desde schema
npm run deploy           # Deploy completo (migraciones + functions)
```

## Testing

### pgTAP (tests de base de datos)
- Ubicación: `tests/database/`
- Framework: pgTAP (extensión PostgreSQL)
- Ejecutar: `npm run test` o `supabase test db`
- Cobertura mínima: 80% en RLS policies y functions

### Tests existentes
| Archivo | Qué verifica |
|---------|-------------|
| `00_schema.test.sql` | Tablas y columnas existen |
| `01_rls.test.sql` | RLS habilitado, policies correctas |
| `02_indexes.test.sql` | Indexes existen |
| `03_triggers.test.sql` | Triggers y functions existen |
| `04_constraints.test.sql` | CHECK constraints y FKs |

### Edge Functions (Deno test)
- Ubicación: `tests/functions/`
- Ejecutar: `npm run test:functions`

## Gitflow

### Ramas
- `main` — Producción (Supabase hosted). **NO push directo.**
- `dev` — Desarrollo/integración
- `feat/<nombre>`, `fix/<nombre>`, `refactor/<nombre>` — desde `dev`
- `hotfix/<nombre>` — desde `main`, merge a `main` Y `dev`

### Flujo
```
feat/nueva-tabla  ──PR──▶  dev  ──PR──▶  main (producción)
fix/rls-policy    ──PR──▶  dev  ──PR──▶  main
hotfix/urgente    ──PR──▶  main + dev
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

## Arquitectura de Base de Datos

### Tablas

#### `profiles` (extiende auth.users)
- PK: `id uuid` → `auth.users(id)` ON DELETE CASCADE
- Columnas: name, country, currency, locale, onboarding_completed, dark_mode, debt_strategy, goal_mode, current_fund, timestamps
- CHECK: debt_strategy IN ('avalanche', 'snowball'), goal_mode IN ('sequential', 'parallel')

#### `incomes`
- PK: `id text`
- FK: `user_id uuid` → `profiles(id)` ON DELETE CASCADE
- Columnas: name, amount, frequency, pay_days (jsonb), is_net, timestamps
- CHECK: frequency IN ('monthly', 'biweekly', 'weekly')

#### `expenses`
- PK: `id text`
- FK: `user_id uuid` → `profiles(id)` ON DELETE CASCADE
- Columnas: name, amount, category, is_fixed, is_essential, due_day, payment_method, notes, timestamps
- CHECK: payment_method IN ('cash', 'debit', 'credit_card')

#### `debts`
- PK: `id text`
- FK: `user_id uuid` → `profiles(id)` ON DELETE CASCADE
- Columnas: name, type, current_balance, original_amount, monthly_payment, interest_rate, annual_rate, remaining/total/completed_payments, due_day, credit_limit, minimum_payment, product_name, product_value, timestamps

#### `goals`
- PK: `id text`
- FK: `user_id uuid` → `profiles(id)` ON DELETE CASCADE
- Columnas: name, icon, target_amount, current_saved, priority, category, deadline, is_flexible, notes, timestamps

#### `transactions`
- PK: `id text`
- FK: `user_id uuid` → `profiles(id)` ON DELETE CASCADE
- Columnas: date, amount, type, category, description, payment_method, is_recurring, created_at
- CHECK: type IN ('income', 'expense', 'debt_payment', 'savings', 'transfer'), payment_method IN ('cash', 'debit', 'credit_card')

### RLS Policies
Todas las tablas tienen RLS habilitado. Cada usuario solo puede CRUD sus propios registros:
- `profiles`: SELECT, INSERT, UPDATE (filtro: `auth.uid() = id`)
- `incomes`, `expenses`, `debts`, `goals`: SELECT, INSERT, UPDATE, DELETE (filtro: `auth.uid() = user_id`)
- `transactions`: SELECT, INSERT, DELETE (filtro: `auth.uid() = user_id`)

### Triggers
- `on_auth_user_created` → `handle_new_user()` — Auto-crea profile al signup (SECURITY DEFINER)
- `*_updated_at` → `update_updated_at()` — Auto-actualiza updated_at en profiles, incomes, expenses, debts, goals

### RPC Functions
- `delete_user_account()` — SECURITY DEFINER. Elimina todos los datos del usuario + auth.users entry. Solo `authenticated` puede ejecutarla.

### Indexes
- `idx_*_user` en user_id de todas las tablas
- `idx_transactions_date` compuesto (user_id, date DESC)

## Mapeo DB ↔ Frontend

La DB usa **snake_case**, el frontend usa **camelCase**. El `syncService` del frontend hace la conversión automática.

Ejemplo: `current_balance` (DB) ↔ `currentBalance` (frontend)

## Reglas de Negocio

1. **RLS es obligatorio** — NUNCA crear una tabla sin RLS policies
2. **Migraciones son inmutables** — Una vez pusheada, NUNCA modificar. Crear una nueva.
3. **Tests antes de merge** — Todo cambio de schema o function debe tener test
4. **SECURITY DEFINER con cuidado** — Solo en functions que lo necesiten, siempre con `SET search_path`
5. **snake_case siempre** — Tablas, columnas, functions, triggers
6. **Validaciones en DB** — CHECK constraints para enums y rangos, no depender solo del frontend
7. **English only** — All code, commits, comments, documentation, branch names, and PR descriptions must be in English. No Spanish.

## Slash Commands

| Comando | Descripción |
|---------|-------------|
| `/project:dev` | Levantar Supabase local, mostrar URLs y keys |
| `/project:test` | Ejecutar tests pgTAP y Edge Functions |
| `/project:migrate` | Crear/aplicar migraciones |
| `/project:security` | Auditoría de RLS, permisos, grants |
| `/project:debug` | Debug de queries, policies, functions |
| `/project:seed` | Generar/aplicar seed data |
| `/project:deploy` | Pre-deploy checklist y deploy a producción |
| `/project:typecheck` | Generar tipos TypeScript desde schema |
| `/project:architecture` | Revisión de schema, indexes, performance |

## Git Hooks

Configurados en `.githooks/` (activar con `git config core.hooksPath .githooks`):

- **commit-msg** — Valida Conventional Commits con scopes de backend
- **pre-commit** — Lint SQL, verificar nombres de migraciones, tests de Edge Functions
- **pre-push** — Bloquea push directo a main

## Gotchas de Supabase

1. **RLS y service_role** — El `service_role` key bypasea RLS. Solo usar en Edge Functions serverside, NUNCA exponer al frontend.
2. **auth.uid()** — Solo disponible cuando hay JWT válido. En funciones SECURITY DEFINER, asegurarse de validar `auth.uid() IS NOT NULL`.
3. **Migraciones en producción** — `supabase db push` aplica migraciones pendientes. Es destructivo si hay DROP. Siempre revisar con `db:diff` primero.
4. **Seed data** — Solo se aplica con `supabase db reset`, NO con `db push`. Es solo para desarrollo local.
5. **Edge Functions cold start** — Primera invocación es lenta (~500ms). Considerar warm-up si es crítico.
6. **Timestamps** — Usar `timestamptz` (con timezone), no `timestamp`. La DB almacena en UTC.
7. **IDs del frontend** — El frontend genera IDs como `text` (nanoid), no UUID. Las tablas de datos usan `id text PK`.
8. **CASCADE** — Todas las FKs tienen `ON DELETE CASCADE`. Borrar un profile borra TODOS sus datos.

## Usuarios de prueba (seed)

| Email | Password | Nombre |
|-------|----------|--------|
| carlos@test.com | password123 | Carlos Rodríguez |
| maria@test.com | password123 | María López |

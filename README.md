# dobby-backend

<p align="center">
  <strong>Backend en Supabase para Tutor Financiero Personal</strong>
</p>

<p align="center">
  <a href="#arquitectura">Arquitectura</a> &middot;
  <a href="#setup-rápido">Setup</a> &middot;
  <a href="#scripts">Scripts</a> &middot;
  <a href="#testing">Testing</a> &middot;
  <a href="#contribuir">Contribuir</a>
</p>

---

## Sobre el proyecto

**dobby-backend** es el backend de [dobby-frontend](https://github.com/smola/dobby-frontend), una aplicación de finanzas personales que ayuda a los usuarios a gestionar ingresos, gastos, deudas y metas de ahorro.

El frontend es una SPA React que sincroniza todo su estado con Supabase vía `supabase-js`. No hay REST API custom — el frontend hace queries directos a las tablas, protegido por **Row Level Security (RLS)**.

### Stack

| Tecnología | Uso |
|------------|-----|
| **PostgreSQL 17** | Base de datos principal |
| **Supabase Auth** | Autenticación (email/password + Google OAuth) |
| **Row Level Security** | Seguridad a nivel de fila en todas las tablas |
| **Edge Functions** | Deno 2.x para lógica serverless |
| **Supabase Realtime** | Sincronización en tiempo real |
| **pgTAP** | Testing de base de datos |

## Arquitectura

```
┌─────────────────┐     supabase-js      ┌──────────────────────────┐
│  dobby-frontend │ ◄──────────────────►  │     Supabase Platform    │
│   (React SPA)   │    JWT + Realtime     │                          │
└─────────────────┘                       │  ┌────────────────────┐  │
                                          │  │   Auth (GoTrue)    │  │
                                          │  └────────────────────┘  │
                                          │  ┌────────────────────┐  │
                                          │  │   PostgreSQL 17    │  │
                                          │  │   + RLS Policies   │  │
                                          │  │   + Triggers       │  │
                                          │  │   + RPC Functions  │  │
                                          │  └────────────────────┘  │
                                          │  ┌────────────────────┐  │
                                          │  │  Edge Functions    │  │
                                          │  │  (Deno 2.x)       │  │
                                          │  └────────────────────┘  │
                                          └──────────────────────────┘
```

### Modelo de datos

```
auth.users
    │
    ▼ (1:1, ON DELETE CASCADE)
profiles ─────┬──► incomes
              ├──► expenses
              ├──► debts
              ├──► goals
              └──► transactions
```

Todas las tablas tienen **RLS habilitado**. Cada usuario solo puede leer y modificar sus propios datos (`auth.uid() = user_id`).

| Tabla | Descripción | PK |
|-------|-------------|-----|
| `profiles` | Perfil del usuario (config, preferencias) | `uuid` (FK → auth.users) |
| `incomes` | Fuentes de ingreso | `text` (nanoid) |
| `expenses` | Gastos fijos y variables | `text` (nanoid) |
| `debts` | Deudas y créditos | `text` (nanoid) |
| `goals` | Metas de ahorro | `text` (nanoid) |
| `transactions` | Historial de movimientos | `text` (nanoid) |

## Requisitos

- [Node.js](https://nodejs.org/) >= 20
- [Supabase CLI](https://supabase.com/docs/guides/cli) >= 1.200
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (para Supabase local)
- [Deno](https://deno.land/) >= 2.0 (para Edge Functions)

## Setup rápido

```bash
# 1. Clonar el repositorio
git clone https://github.com/smola/dobby-backend.git
cd dobby-backend

# 2. Configurar git hooks
git config core.hooksPath .githooks

# 3. Levantar Supabase local (requiere Docker corriendo)
npm run dev

# 4. Ver URLs y keys locales
npm run status

# 5. Correr tests
npm run test

# 6. (Opcional) Reset con seed data de prueba
npm run db:reset
```

### Usuarios de prueba (seed)

| Email | Password | Nombre |
|-------|----------|--------|
| carlos@test.com | password123 | Carlos Rodríguez |
| maria@test.com | password123 | María López |

## Scripts

### Desarrollo
| Script | Descripción |
|--------|-------------|
| `npm run dev` | Levanta Supabase local |
| `npm run stop` | Detiene Supabase local |
| `npm run status` | Muestra URLs, keys y estado |

### Migraciones
| Script | Descripción |
|--------|-------------|
| `npm run migrate:new <nombre>` | Crea nueva migración |
| `npm run migrate:up` | Aplica migraciones pendientes |
| `npm run migrate:list` | Lista estado de migraciones |
| `npm run db:reset` | Reset completo (migraciones + seed) |
| `npm run db:push` | Push migraciones a producción |
| `npm run db:diff` | Genera diff del schema actual |
| `npm run db:lint` | Lint del schema SQL |

### Testing
| Script | Descripción |
|--------|-------------|
| `npm run test` | Tests pgTAP de base de datos |
| `npm run test:functions` | Tests de Edge Functions (Deno) |
| `npm run test:all` | Todos los tests |

### Edge Functions y tipos
| Script | Descripción |
|--------|-------------|
| `npm run functions:serve` | Sirve Edge Functions localmente |
| `npm run functions:deploy` | Deploy Edge Functions a producción |
| `npm run types` | Genera tipos TypeScript desde schema |
| `npm run deploy` | Deploy completo (migraciones + functions) |

## Testing

Usamos **pgTAP** para tests de base de datos y **Deno test** para Edge Functions.

```bash
# Tests de base de datos (requiere Supabase local corriendo)
npm run test

# Tests de Edge Functions
npm run test:functions

# Todos los tests
npm run test:all
```

### Suites de tests

| Suite | Archivo | Tests |
|-------|---------|-------|
| Schema | `tests/database/00_schema.test.sql` | Tablas y columnas existen |
| RLS | `tests/database/01_rls.test.sql` | Policies correctas por tabla |
| Indexes | `tests/database/02_indexes.test.sql` | Indexes existen |
| Triggers | `tests/database/03_triggers.test.sql` | Triggers y functions |
| Constraints | `tests/database/04_constraints.test.sql` | CHECK constraints y FKs |

## Gitflow

```
feat/nueva-tabla  ──PR──▶  dev  ──PR──▶  main (producción)
fix/rls-policy    ──PR──▶  dev  ──PR──▶  main
hotfix/urgente    ──PR──▶  main + dev
```

| Rama | Propósito |
|------|-----------|
| `main` | Producción (Supabase hosted). **NO push directo.** |
| `dev` | Desarrollo e integración |
| `feat/<nombre>` | Nuevas funcionalidades (desde `dev`) |
| `fix/<nombre>` | Correcciones (desde `dev`) |
| `refactor/<nombre>` | Refactorización (desde `dev`) |
| `hotfix/<nombre>` | Fixes urgentes (desde `main`, merge a `main` Y `dev`) |

### Conventional Commits

```
<type>(<scope>): <descripción en español>
```

**Types:** `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `chore`, `ci`

**Scopes:** `schema`, `rls`, `migration`, `function`, `trigger`, `seed`, `auth`, `deps`, `ci`

## Estructura del proyecto

```
dobby-backend/
├── .claude/commands/       # Slash commands de Claude Code
├── .github/                # Templates de issues y PRs
├── .githooks/              # Git hooks (commit-msg, pre-commit, pre-push)
├── supabase/
│   ├── migrations/         # Migraciones SQL (inmutables una vez pusheadas)
│   ├── functions/          # Edge Functions (Deno/TypeScript)
│   ├── seed.sql            # Seed data para desarrollo local
│   └── config.toml         # Configuración de Supabase local
├── tests/
│   ├── database/           # Tests pgTAP (schema, RLS, triggers, constraints)
│   └── functions/          # Tests de Edge Functions (Deno test)
├── CLAUDE.md               # Documentación técnica completa
├── CONTRIBUTING.md         # Guía de contribución
├── package.json            # Scripts npm
└── deno.json               # Config Deno para Edge Functions
```

## Contribuir

Las contribuciones son bienvenidas. Lee [CONTRIBUTING.md](CONTRIBUTING.md) para conocer el proceso.

En resumen:
1. Fork del repositorio
2. Crea tu rama desde `dev` (`feat/mi-feature`)
3. Haz tus cambios con tests
4. Abre un Pull Request hacia `dev`

## Licencia

MIT

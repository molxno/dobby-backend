# dobby-backend

Backend en Supabase para **Tutor Financiero Personal** (dobby-frontend).

## Requisitos

- [Node.js](https://nodejs.org/) >= 20
- [Supabase CLI](https://supabase.com/docs/guides/cli) >= 1.200
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (para Supabase local)
- [Deno](https://deno.land/) >= 2.0 (para Edge Functions)

## Setup rápido

```bash
# 1. Clonar e instalar
git clone <repo-url> && cd dobby-backend

# 2. Configurar git hooks
git config core.hooksPath .githooks

# 3. Levantar Supabase local (requiere Docker)
npm run dev

# 4. Ver URLs y keys
npm run status

# 5. Correr tests
npm run test
```

## Scripts disponibles

| Script | Descripción |
|--------|-------------|
| `npm run dev` | Levanta Supabase local |
| `npm run stop` | Detiene Supabase local |
| `npm run status` | Muestra URLs, keys y estado |
| `npm run migrate:new <nombre>` | Crea nueva migración |
| `npm run migrate:up` | Aplica migraciones pendientes |
| `npm run db:reset` | Reset completo (migraciones + seed) |
| `npm run db:push` | Push migraciones a producción |
| `npm run db:diff` | Genera diff del schema actual |
| `npm run db:lint` | Lint del schema SQL |
| `npm run test` | Tests pgTAP de base de datos |
| `npm run test:functions` | Tests de Edge Functions (Deno) |
| `npm run test:all` | Todos los tests |
| `npm run types` | Genera tipos TypeScript desde schema |
| `npm run functions:serve` | Sirve Edge Functions localmente |
| `npm run deploy` | Deploy a producción |

## Gitflow

- `main` — Producción. NO push directo.
- `dev` — Desarrollo/integración.
- `feat/<nombre>`, `fix/<nombre>`, `refactor/<nombre>` — desde `dev`.
- `hotfix/<nombre>` — desde `main`, merge a `main` Y `dev`.

## Documentación

Ver [CLAUDE.md](CLAUDE.md) para documentación completa del proyecto.

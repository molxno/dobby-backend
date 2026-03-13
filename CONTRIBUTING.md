# Guía de Contribución

Gracias por tu interés en contribuir a **dobby-backend**. Este documento explica cómo colaborar de forma efectiva.

## Primeros pasos

1. **Fork** del repositorio
2. **Clona** tu fork:
   ```bash
   git clone https://github.com/<tu-usuario>/dobby-backend.git
   cd dobby-backend
   ```
3. **Configura** el entorno:
   ```bash
   git config core.hooksPath .githooks
   git remote add upstream https://github.com/smola/dobby-backend.git
   ```
4. **Levanta** Supabase local:
   ```bash
   npm run dev
   ```

## Flujo de trabajo

### 1. Sincroniza tu fork

```bash
git checkout dev
git pull upstream dev
```

### 2. Crea una rama

Siempre desde `dev`:

```bash
git checkout -b feat/mi-nueva-tabla    # Nueva funcionalidad
git checkout -b fix/rls-policy         # Corrección de bug
git checkout -b refactor/optimizar-idx # Refactorización
```

### 3. Haz tus cambios

- Sigue las convenciones del proyecto (ver abajo)
- Agrega tests para cambios en schema, RLS, triggers o functions
- Verifica que los tests pasan: `npm run test`

### 4. Commits

Usamos **Conventional Commits** con scopes de backend:

```
<type>(<scope>): <descripción en español>
```

| Type | Uso |
|------|-----|
| `feat` | Nueva funcionalidad |
| `fix` | Corrección de bug |
| `refactor` | Refactorización sin cambio funcional |
| `perf` | Mejora de rendimiento |
| `docs` | Documentación |
| `test` | Tests |
| `chore` | Mantenimiento |
| `ci` | CI/CD |

| Scope | Uso |
|-------|-----|
| `schema` | Tablas, columnas, tipos |
| `rls` | Policies de Row Level Security |
| `migration` | Migraciones SQL |
| `function` | RPC functions o Edge Functions |
| `trigger` | Triggers de base de datos |
| `seed` | Seed data |
| `auth` | Autenticación |
| `deps` | Dependencias |
| `ci` | CI/CD |

**Ejemplos:**
```
feat(schema): agregar tabla de categorías personalizadas
fix(rls): corregir policy de delete en transactions
test(function): agregar tests para delete_user_account
```

### 5. Abre un Pull Request

- PR siempre hacia la rama `dev` (nunca directo a `main`)
- Usa el template de PR proporcionado
- Describe qué cambiaste y por qué
- Incluye evidencia de que los tests pasan

## Convenciones

### SQL

- **snake_case** para tablas, columnas, funciones, triggers
- **Timestamps** siempre `timestamptz` (con timezone)
- **RLS obligatorio** en toda tabla nueva
- **CHECK constraints** para enums y rangos
- **Indexes** por `user_id` en toda tabla con datos de usuario
- **ON DELETE CASCADE** en FKs hacia `profiles`
- Comentarios en español

### Migraciones

- **Inmutables**: una vez pusheada, NUNCA modificar. Crear una nueva.
- Nombres descriptivos: `supabase migration new agregar_tabla_categorias`
- Usar `IF NOT EXISTS` / `IF EXISTS` para idempotencia
- Incluir RLS policies, indexes y grants en la misma migración

### Tests

- Todo cambio de schema debe tener test en `tests/database/`
- Todo cambio de Edge Function debe tener test en `tests/functions/`
- Cobertura mínima: 80% en RLS policies y functions
- Los tests se ejecutan con pgTAP: `npm run test`

### Edge Functions

- Runtime: Deno 2.x
- Ubicación: `supabase/functions/<nombre>/index.ts`
- Tests: `tests/functions/<nombre>.test.ts`
- NUNCA exponer `service_role` key al frontend

## Tipos de contribuciones bienvenidas

- Nuevas tablas o mejoras al schema
- Mejoras en RLS policies
- Edge Functions para lógica de negocio
- Tests adicionales
- Mejoras de performance (indexes, queries)
- Documentación
- Corrección de bugs

## Reporte de bugs

Usa el template de [Bug Report](https://github.com/smola/dobby-backend/issues/new?template=bug_report.yml) para reportar bugs. Incluye:

- Qué tabla/function/policy está involucrada
- Query o operación que falla
- Error exacto que recibes
- Comportamiento esperado

## Código de conducta

Se espera que todos los participantes sean respetuosos y constructivos. No se tolera acoso, discriminación o comportamiento tóxico.

## Preguntas

Si tienes dudas, abre un [Discussion](https://github.com/smola/dobby-backend/discussions) o un issue con la etiqueta `question`.

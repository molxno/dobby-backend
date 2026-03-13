## Descripción

<!-- Describe qué cambiaste y por qué. Si resuelve un issue, enlázalo: Closes #123 -->

## Tipo de cambio

- [ ] `feat` — Nueva funcionalidad
- [ ] `fix` — Corrección de bug
- [ ] `refactor` — Refactorización sin cambio funcional
- [ ] `perf` — Mejora de rendimiento
- [ ] `test` — Tests nuevos o actualizados
- [ ] `docs` — Documentación
- [ ] `chore` — Mantenimiento

## Área afectada

- [ ] Schema (tablas, columnas)
- [ ] RLS policies
- [ ] Triggers / Functions
- [ ] Edge Functions
- [ ] Migraciones
- [ ] Seed data
- [ ] Config / CI

## Cambios en la base de datos

<!-- Si hay cambios en el schema, lista las migraciones creadas -->

| Migración | Descripción |
|-----------|-------------|
| `YYYYMMDD_nombre.sql` | ... |

## Checklist

- [ ] Los tests pasan (`npm run test`)
- [ ] Nuevas tablas tienen RLS habilitado con policies
- [ ] Nuevas tablas tienen index por `user_id`
- [ ] CHECK constraints para enums y rangos
- [ ] Migraciones usan `IF NOT EXISTS` / `IF EXISTS`
- [ ] Functions SECURITY DEFINER tienen `SET search_path`
- [ ] Commits siguen Conventional Commits
- [ ] Documentación actualizada si es necesario

## Screenshots / Evidencia

<!-- Si aplica, agrega capturas de los tests pasando o queries funcionando -->

## Notas para el reviewer

<!-- Algo que deba saber el reviewer? Riesgos, decisiones de diseño, etc. -->

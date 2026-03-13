# /project:security — Auditoría de seguridad

Eres el agente de seguridad. Tu trabajo es auditar RLS policies, permisos de funciones y configuración de seguridad.

## Checklist de auditoría

### 1. RLS Policies
Para CADA tabla en public:
- [ ] RLS está habilitado (`ALTER TABLE ... ENABLE ROW LEVEL SECURITY`)
- [ ] Existe policy para SELECT (solo datos propios)
- [ ] Existe policy para INSERT (solo como propio user_id)
- [ ] Existe policy para UPDATE (solo datos propios, WITH CHECK)
- [ ] Existe policy para DELETE (solo datos propios)
- [ ] No hay policies con `USING (true)` o sin filtro

### 2. Functions
Para CADA function en public:
- [ ] `SECURITY DEFINER` solo donde es necesario
- [ ] `SET search_path = public` en todas las SECURITY DEFINER
- [ ] Permisos correctos (REVOKE from public/anon, GRANT to authenticated)
- [ ] No hay SQL injection posible (no concatenación de strings)

### 3. Grants
- [ ] Verificar grants en schema public
- [ ] No hay permisos excesivos para anon o public roles

### 4. Auth config
- [ ] Verificar configuración de auth en config.toml
- [ ] Rate limiting configurado

## Ejecución
1. Consulta `pg_policies`, `pg_proc`, `information_schema.role_table_grants`
2. Verifica cada punto del checklist
3. Reporta hallazgos con severidad: 🔴 Crítico, 🟡 Medio, 🟢 OK
4. Sugiere migraciones correctivas si hay problemas

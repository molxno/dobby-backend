# /project:deploy — Deploy a producción

Eres el agente de deploy. Tu trabajo es verificar y ejecutar el deploy a Supabase hosted.

## Pre-deploy checklist

### 1. Verificaciones
- [ ] Estás en la rama `main` o `hotfix/*`
- [ ] No hay cambios sin commitear: `git status`
- [ ] Todos los tests pasan: `npm run test:all`
- [ ] No hay migraciones locales sin pushear: `supabase migration list`

### 2. Diff de migraciones
- Ejecuta: `supabase db diff` para ver cambios pendientes
- Revisa que no haya cambios destructivos (DROP TABLE, DROP COLUMN)
- Si hay cambios destructivos, CONFIRMA con el usuario

### 3. Deploy
1. Push migraciones: `supabase db push`
   - Si falla, muestra el error y sugiere corrección
   - NUNCA uses `--force` sin confirmación explícita
2. Deploy Edge Functions: `supabase functions deploy`
3. Verifica estado post-deploy

### 4. Post-deploy
- Verifica que las migraciones se aplicaron: `supabase migration list`
- Sugiere verificar el frontend contra producción

## Reglas
- NUNCA hacer deploy sin correr tests primero
- NUNCA usar `--force` sin confirmación del usuario
- Si hay dudas sobre un cambio destructivo, PARA y pregunta

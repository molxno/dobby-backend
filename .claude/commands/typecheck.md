# /project:typecheck — Generar tipos TypeScript

Eres el agente de generación de tipos. Tu trabajo es generar tipos TypeScript actualizados desde el schema de la base de datos.

## Pasos

1. Verifica que Supabase local esté corriendo: `supabase status`
2. Genera los tipos: `supabase gen types typescript --local > src/database.types.ts`
3. Muestra un resumen de los tipos generados:
   - Tablas incluidas
   - Tipos de cada tabla (Row, Insert, Update)
   - Enums detectados
   - Functions tipadas

## Uso
Los tipos generados se usan en el frontend (dobby-frontend) para tipar las queries de supabase-js.

El frontend copia este archivo o lo importa para tener autocompletado y validación de tipos en:
- `supabase.from('tabla').select()`
- `supabase.from('tabla').insert()`
- `supabase.rpc('funcion')`

## Notas
- El archivo generado va en `src/database.types.ts`
- Está en `.gitignore` porque se genera automáticamente
- Regenerar después de cada migración nueva

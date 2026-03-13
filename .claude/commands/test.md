# /project:test — Agente de testing

Eres el agente de testing. Tu trabajo es ejecutar y reportar los resultados de todos los tests.

## Pasos

1. Verifica que Supabase local esté corriendo: `supabase status`
   - Si no está corriendo, sugiere ejecutar `/project:dev` primero
2. Ejecuta tests pgTAP de base de datos: `supabase test db`
3. Si hay Edge Functions con tests, ejecuta: `deno test tests/functions/ --allow-all`
4. Analiza los resultados y reporta:
   - Total de tests ejecutados
   - Tests que pasaron / fallaron
   - Detalle de cada fallo con contexto
   - Sugerencias para arreglar fallos

## Si un test falla
- Muestra el test que falló
- Explica qué esperaba vs qué obtuvo
- Sugiere la corrección específica (migración o cambio en la policy/function)

## Formato
Reporta en formato tabla con ✓/✗ por cada suite de tests.

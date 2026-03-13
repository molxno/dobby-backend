# /project:dev — Levantar Supabase local

Eres el agente de desarrollo local. Tu trabajo es levantar y verificar el entorno de Supabase local.

## Pasos

1. Verifica que Docker esté corriendo: `docker info`
2. Levanta Supabase local: `supabase start`
3. Muestra el estado: `supabase status`
4. Presenta al usuario las URLs y keys relevantes:
   - API URL
   - DB URL
   - Studio URL
   - anon key
   - service_role key
5. Verifica que las migraciones se aplicaron correctamente: `supabase migration list`
6. Si hay errores, diagnostica y sugiere soluciones

## Formato de salida
Muestra un resumen claro con las URLs y keys, listo para copiar al `.env` del frontend.

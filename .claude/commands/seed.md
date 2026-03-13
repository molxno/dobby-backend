# /project:seed — Generar y aplicar seed data

Eres el agente de seed data. Tu trabajo es generar datos realistas de prueba para desarrollo local.

## Acciones

### Aplicar seed existente
1. Ejecuta: `supabase db reset` (esto aplica migraciones + seed.sql)
2. Verifica que los datos se insertaron correctamente

### Generar nuevo seed data
Si el usuario necesita datos específicos:
1. Genera SQL con datos realistas en COP (pesos colombianos)
2. Usa UUIDs válidos para users (registrados via auth)
3. Respeta todos los CHECK constraints del schema
4. Datos variados: diferentes categorías, montos, fechas
5. Escribe en `supabase/seed.sql`

## Reglas para seed data
- Montos en COP realistas (salarios 2-8M, arriendos 800K-2M, etc.)
- Categorías variadas de gastos y metas
- Fechas distribuidas en los últimos 3 meses
- Mínimo 2 usuarios con datos completos cada uno
- Todo en español (nombres, descripciones)
- Respetar constraints: payment_method, frequency, debt_strategy, etc.

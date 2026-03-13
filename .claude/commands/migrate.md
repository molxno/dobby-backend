# /project:migrate — Gestión de migraciones

Eres el agente de migraciones. Tu trabajo es crear, aplicar y verificar migraciones SQL.

## Acciones según el contexto

### Si el usuario quiere crear una migración
1. Pregunta qué cambio necesita (nueva tabla, columna, policy, function, etc.)
2. Genera el SQL correcto con:
   - `if not exists` / `if exists` para idempotencia
   - Constraints, indexes, RLS policies
   - Comentarios descriptivos en español
3. Crea la migración: `supabase migration new <nombre_descriptivo>`
4. Escribe el SQL en el archivo generado
5. Aplica: `supabase migration up --local`
6. Verifica: `supabase migration list`

### Si el usuario quiere aplicar migraciones pendientes
1. Lista pendientes: `supabase migration list`
2. Aplica: `supabase migration up --local`
3. Verifica estado

### Si hay un error
1. Muestra el error completo
2. Sugiere corrección
3. NUNCA modifiques una migración ya aplicada — crea una nueva

## Reglas
- snake_case siempre
- RLS obligatorio en nuevas tablas
- Incluir indexes por user_id
- NUNCA modificar migraciones existentes ya pusheadas

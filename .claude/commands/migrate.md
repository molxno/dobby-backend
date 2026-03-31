# /project:migrate — Migration management

You are the migration agent. Your job is to create, apply, and verify SQL migrations.

## Actions based on context

### If the user wants to create a migration
1. Ask what change is needed (new table, column, policy, function, etc.)
2. Generate the correct SQL with:
   - `if not exists` / `if exists` for idempotency
   - Constraints, indexes, RLS policies
   - Descriptive comments in English
3. Create the migration: `supabase migration new <descriptive_name>`
4. Write the SQL to the generated file
5. Apply: `supabase migration up --local`
6. Verify: `supabase migration list`

### If the user wants to apply pending migrations
1. List pending: `supabase migration list`
2. Apply: `supabase migration up --local`
3. Verify status

### If there is an error
1. Show the full error
2. Suggest a fix
3. NEVER modify an already applied migration — create a new one

## Rules
- snake_case always
- RLS mandatory on new tables
- Include indexes by user_id
- NEVER modify existing migrations that have already been pushed

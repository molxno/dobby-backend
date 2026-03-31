# /project:typecheck — Generate TypeScript types

You are the type generation agent. Your job is to generate up-to-date TypeScript types from the database schema.

## Steps

1. Verify that local Supabase is running: `supabase status`
2. Generate the types: `supabase gen types typescript --local > src/database.types.ts`
3. Show a summary of the generated types:
   - Tables included
   - Types for each table (Row, Insert, Update)
   - Detected enums
   - Typed functions

## Usage
The generated types are used in the frontend (dobby-frontend) to type supabase-js queries.

The frontend copies this file or imports it to have autocompletion and type validation in:
- `supabase.from('table').select()`
- `supabase.from('table').insert()`
- `supabase.rpc('function')`

## Notes
- The generated file goes in `src/database.types.ts`
- It is in `.gitignore` because it is generated automatically
- Regenerate after each new migration

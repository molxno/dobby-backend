# /project:debug — Database debugging

You are the debug agent. Your job is to diagnose problems with queries, policies, functions, and triggers.

## Capabilities

### RLS policy debugging
1. Identify which policy is blocking an operation
2. Verify the JWT user_id vs the record user_id
3. Suggest policy corrections

### Query debugging
1. Run `EXPLAIN ANALYZE` on slow queries
2. Identify missing indexes
3. Suggest optimizations

### Function/trigger debugging
1. Review Supabase logs: `supabase logs --type postgres`
2. Identify errors in functions
3. Verify that triggers are firing

### Edge Functions debugging
1. Review logs: `supabase functions logs <name>`
2. Verify environment variables
3. Test the function locally

## Workflow
1. Ask the user which operation is failing
2. Reproduce the problem locally
3. Diagnose the root cause
4. Suggest the fix (migration, policy change, etc.)

## Useful diagnostic queries
```sql
-- View active policies
SELECT * FROM pg_policies WHERE schemaname = 'public';

-- View functions in public
SELECT proname, prosecdef FROM pg_proc WHERE pronamespace = 'public'::regnamespace;

-- View triggers
SELECT trigger_name, event_object_table, action_statement FROM information_schema.triggers WHERE trigger_schema = 'public';
```

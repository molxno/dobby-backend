# /project:dev — Start local Supabase

You are the local development agent. Your job is to start and verify the local Supabase environment.

## Steps

1. Verify that Docker is running: `docker info`
2. Start local Supabase: `supabase start`
3. Show the status: `supabase status`
4. Present the user with the relevant URLs and keys:
   - API URL
   - DB URL
   - Studio URL
   - anon key
   - service_role key
5. Verify that migrations were applied correctly: `supabase migration list`
6. If there are errors, diagnose and suggest solutions

## Output format
Show a clear summary with the URLs and keys, ready to copy to the frontend `.env`.

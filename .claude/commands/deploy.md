# /project:deploy — Deploy to production

You are the deploy agent. Your job is to verify and execute the deploy to Supabase hosted.

## Pre-deploy checklist

### 1. Verifications
- [ ] You are on the `main` or `hotfix/*` branch
- [ ] No uncommitted changes: `git status`
- [ ] All tests pass: `npm run test:all`
- [ ] No local migrations pending push: `supabase migration list`

### 2. Migration diff
- Run: `supabase db diff` to see pending changes
- Review that there are no destructive changes (DROP TABLE, DROP COLUMN)
- If there are destructive changes, CONFIRM with the user

### 3. Deploy
1. Push migrations: `supabase db push`
   - If it fails, show the error and suggest a fix
   - NEVER use `--force` without explicit confirmation
2. Deploy Edge Functions: `supabase functions deploy`
3. Verify post-deploy status

### 4. Post-deploy
- Verify that migrations were applied: `supabase migration list`
- Suggest verifying the frontend against production

## Rules
- NEVER deploy without running tests first
- NEVER use `--force` without user confirmation
- If there is any doubt about a destructive change, STOP and ask

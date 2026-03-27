# /project:security — Security audit

You are the security agent. Your job is to audit RLS policies, function permissions, and security configuration.

## Audit checklist

### 1. RLS Policies
For EACH table in public:
- [ ] RLS is enabled (`ALTER TABLE ... ENABLE ROW LEVEL SECURITY`)
- [ ] A SELECT policy exists (own data only)
- [ ] An INSERT policy exists (only as own user_id)
- [ ] An UPDATE policy exists (own data only, WITH CHECK)
- [ ] A DELETE policy exists (own data only)
- [ ] No policies with `USING (true)` or without a filter

### 2. Functions
For EACH function in public:
- [ ] `SECURITY DEFINER` only where necessary
- [ ] `SET search_path = public` on all SECURITY DEFINER functions
- [ ] Correct permissions (REVOKE from public/anon, GRANT to authenticated)
- [ ] No SQL injection possible (no string concatenation)

### 3. Grants
- [ ] Verify grants on the public schema
- [ ] No excessive permissions for anon or public roles

### 4. Auth config
- [ ] Verify auth configuration in config.toml
- [ ] Rate limiting configured

## Execution
1. Query `pg_policies`, `pg_proc`, `information_schema.role_table_grants`
2. Verify each point on the checklist
3. Report findings with severity: 🔴 Critical, 🟡 Medium, 🟢 OK
4. Suggest corrective migrations if there are issues

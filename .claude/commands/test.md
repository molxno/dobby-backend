# /project:test — Testing agent

You are the testing agent. Your job is to run and report the results of all tests.

## Steps

1. Verify that local Supabase is running: `supabase status`
   - If it is not running, suggest running `/project:dev` first
2. Run pgTAP database tests: `supabase test db`
3. If there are Edge Functions with tests, run: `deno test tests/functions/ --allow-all`
4. Analyze the results and report:
   - Total tests executed
   - Tests that passed / failed
   - Details of each failure with context
   - Suggestions to fix failures

## If a test fails
- Show the test that failed
- Explain what was expected vs what was obtained
- Suggest the specific fix (migration or change in the policy/function)

## Format
Report in table format with ✓/✗ for each test suite.

# /project:seed — Generate and apply seed data

You are the seed data agent. Your job is to generate realistic test data for local development.

## Actions

### Apply existing seed
1. Run: `supabase db reset` (this applies migrations + seed.sql)
2. Verify that the data was inserted correctly

### Generate new seed data
If the user needs specific data:
1. Generate SQL with realistic data in COP (Colombian pesos)
2. Use valid UUIDs for users (registered via auth)
3. Respect all CHECK constraints from the schema
4. Varied data: different categories, amounts, dates
5. Write to `supabase/seed.sql`

## Rules for seed data
- Realistic amounts in COP (salaries 2-8M, rent 800K-2M, etc.)
- Varied expense and goal categories
- Dates distributed over the last 3 months
- Minimum 2 users with complete data each
- All in Spanish (names, descriptions)
- Respect constraints: payment_method, frequency, debt_strategy, etc.

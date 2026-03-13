-- =============================================================
-- Tests de Schema — Verificar que todas las tablas y columnas existen
-- =============================================================
begin;
select plan(42);

-- =====================
-- Verificar que las tablas existen
-- =====================
select has_table('public', 'profiles', 'La tabla profiles existe');
select has_table('public', 'incomes', 'La tabla incomes existe');
select has_table('public', 'expenses', 'La tabla expenses existe');
select has_table('public', 'debts', 'La tabla debts existe');
select has_table('public', 'goals', 'La tabla goals existe');
select has_table('public', 'transactions', 'La tabla transactions existe');

-- =====================
-- Columnas de profiles
-- =====================
select has_column('public', 'profiles', 'id', 'profiles tiene columna id');
select has_column('public', 'profiles', 'name', 'profiles tiene columna name');
select has_column('public', 'profiles', 'country', 'profiles tiene columna country');
select has_column('public', 'profiles', 'currency', 'profiles tiene columna currency');
select has_column('public', 'profiles', 'locale', 'profiles tiene columna locale');
select has_column('public', 'profiles', 'onboarding_completed', 'profiles tiene columna onboarding_completed');
select has_column('public', 'profiles', 'dark_mode', 'profiles tiene columna dark_mode');
select has_column('public', 'profiles', 'debt_strategy', 'profiles tiene columna debt_strategy');
select has_column('public', 'profiles', 'goal_mode', 'profiles tiene columna goal_mode');
select has_column('public', 'profiles', 'current_fund', 'profiles tiene columna current_fund');

-- =====================
-- Columnas de incomes
-- =====================
select has_column('public', 'incomes', 'id', 'incomes tiene columna id');
select has_column('public', 'incomes', 'user_id', 'incomes tiene columna user_id');
select has_column('public', 'incomes', 'name', 'incomes tiene columna name');
select has_column('public', 'incomes', 'amount', 'incomes tiene columna amount');
select has_column('public', 'incomes', 'frequency', 'incomes tiene columna frequency');
select has_column('public', 'incomes', 'pay_days', 'incomes tiene columna pay_days');
select has_column('public', 'incomes', 'is_net', 'incomes tiene columna is_net');

-- =====================
-- Columnas de expenses
-- =====================
select has_column('public', 'expenses', 'id', 'expenses tiene columna id');
select has_column('public', 'expenses', 'user_id', 'expenses tiene columna user_id');
select has_column('public', 'expenses', 'name', 'expenses tiene columna name');
select has_column('public', 'expenses', 'amount', 'expenses tiene columna amount');
select has_column('public', 'expenses', 'category', 'expenses tiene columna category');
select has_column('public', 'expenses', 'payment_method', 'expenses tiene columna payment_method');

-- =====================
-- Columnas de debts
-- =====================
select has_column('public', 'debts', 'id', 'debts tiene columna id');
select has_column('public', 'debts', 'user_id', 'debts tiene columna user_id');
select has_column('public', 'debts', 'current_balance', 'debts tiene columna current_balance');
select has_column('public', 'debts', 'interest_rate', 'debts tiene columna interest_rate');

-- =====================
-- Columnas de goals
-- =====================
select has_column('public', 'goals', 'id', 'goals tiene columna id');
select has_column('public', 'goals', 'user_id', 'goals tiene columna user_id');
select has_column('public', 'goals', 'target_amount', 'goals tiene columna target_amount');
select has_column('public', 'goals', 'current_saved', 'goals tiene columna current_saved');
select has_column('public', 'goals', 'priority', 'goals tiene columna priority');

-- =====================
-- Columnas de transactions
-- =====================
select has_column('public', 'transactions', 'id', 'transactions tiene columna id');
select has_column('public', 'transactions', 'user_id', 'transactions tiene columna user_id');
select has_column('public', 'transactions', 'date', 'transactions tiene columna date');
select has_column('public', 'transactions', 'amount', 'transactions tiene columna amount');
select has_column('public', 'transactions', 'type', 'transactions tiene columna type');
select has_column('public', 'transactions', 'category', 'transactions tiene columna category');

select * from finish();
rollback;

-- =============================================================
-- Tests de RLS — Verificar que RLS está habilitado y policies existen
-- =============================================================
begin;
select plan(30);

-- =====================
-- RLS habilitado en todas las tablas
-- =====================
select row_security_active('public.profiles', 'RLS habilitado en profiles');
select row_security_active('public.incomes', 'RLS habilitado en incomes');
select row_security_active('public.expenses', 'RLS habilitado en expenses');
select row_security_active('public.debts', 'RLS habilitado en debts');
select row_security_active('public.goals', 'RLS habilitado en goals');
select row_security_active('public.transactions', 'RLS habilitado en transactions');

-- =====================
-- Policies de profiles (SELECT, INSERT, UPDATE — no DELETE porque se borra via cascade)
-- =====================
select policies_are(
  'public', 'profiles',
  array[
    'Users can view own profile',
    'Users can update own profile',
    'Users can insert own profile'
  ],
  'profiles tiene las policies correctas'
);

-- =====================
-- Policies de incomes (CRUD completo)
-- =====================
select policies_are(
  'public', 'incomes',
  array[
    'Users can view own incomes',
    'Users can insert own incomes',
    'Users can update own incomes',
    'Users can delete own incomes'
  ],
  'incomes tiene las policies correctas'
);

-- =====================
-- Policies de expenses (CRUD completo)
-- =====================
select policies_are(
  'public', 'expenses',
  array[
    'Users can view own expenses',
    'Users can insert own expenses',
    'Users can update own expenses',
    'Users can delete own expenses'
  ],
  'expenses tiene las policies correctas'
);

-- =====================
-- Policies de debts (CRUD completo)
-- =====================
select policies_are(
  'public', 'debts',
  array[
    'Users can view own debts',
    'Users can insert own debts',
    'Users can update own debts',
    'Users can delete own debts'
  ],
  'debts tiene las policies correctas'
);

-- =====================
-- Policies de goals (CRUD completo)
-- =====================
select policies_are(
  'public', 'goals',
  array[
    'Users can view own goals',
    'Users can insert own goals',
    'Users can update own goals',
    'Users can delete own goals'
  ],
  'goals tiene las policies correctas'
);

-- =====================
-- Policies de transactions (SELECT, INSERT, DELETE — no UPDATE)
-- =====================
select policies_are(
  'public', 'transactions',
  array[
    'Users can view own transactions',
    'Users can insert own transactions',
    'Users can delete own transactions'
  ],
  'transactions tiene las policies correctas'
);

-- =====================
-- Verificar que cada tabla tiene al menos una policy por operación principal
-- =====================
select policy_cmd_is('public', 'profiles', 'Users can view own profile', 'select', 'Policy de profiles es SELECT');
select policy_cmd_is('public', 'profiles', 'Users can update own profile', 'update', 'Policy de profiles es UPDATE');
select policy_cmd_is('public', 'profiles', 'Users can insert own profile', 'insert', 'Policy de profiles es INSERT');

select policy_cmd_is('public', 'incomes', 'Users can view own incomes', 'select', 'Policy de incomes SELECT');
select policy_cmd_is('public', 'incomes', 'Users can insert own incomes', 'insert', 'Policy de incomes INSERT');
select policy_cmd_is('public', 'incomes', 'Users can update own incomes', 'update', 'Policy de incomes UPDATE');
select policy_cmd_is('public', 'incomes', 'Users can delete own incomes', 'delete', 'Policy de incomes DELETE');

select policy_cmd_is('public', 'expenses', 'Users can view own expenses', 'select', 'Policy de expenses SELECT');
select policy_cmd_is('public', 'expenses', 'Users can insert own expenses', 'insert', 'Policy de expenses INSERT');
select policy_cmd_is('public', 'expenses', 'Users can update own expenses', 'update', 'Policy de expenses UPDATE');
select policy_cmd_is('public', 'expenses', 'Users can delete own expenses', 'delete', 'Policy de expenses DELETE');

select policy_cmd_is('public', 'debts', 'Users can view own debts', 'select', 'Policy de debts SELECT');
select policy_cmd_is('public', 'debts', 'Users can insert own debts', 'insert', 'Policy de debts INSERT');
select policy_cmd_is('public', 'debts', 'Users can update own debts', 'update', 'Policy de debts UPDATE');
select policy_cmd_is('public', 'debts', 'Users can delete own debts', 'delete', 'Policy de debts DELETE');

select policy_cmd_is('public', 'goals', 'Users can view own goals', 'select', 'Policy de goals SELECT');
select policy_cmd_is('public', 'goals', 'Users can insert own goals', 'insert', 'Policy de goals INSERT');
select policy_cmd_is('public', 'goals', 'Users can update own goals', 'update', 'Policy de goals UPDATE');
select policy_cmd_is('public', 'goals', 'Users can delete own goals', 'delete', 'Policy de goals DELETE');

select policy_cmd_is('public', 'transactions', 'Users can view own transactions', 'select', 'Policy de transactions SELECT');
select policy_cmd_is('public', 'transactions', 'Users can insert own transactions', 'insert', 'Policy de transactions INSERT');
select policy_cmd_is('public', 'transactions', 'Users can delete own transactions', 'delete', 'Policy de transactions DELETE');

select * from finish();
rollback;

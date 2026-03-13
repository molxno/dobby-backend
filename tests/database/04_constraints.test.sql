-- =============================================================
-- Tests de Constraints — Verificar CHECK constraints y FKs
-- =============================================================
begin;
select plan(12);

-- =====================
-- Foreign Keys existen
-- =====================
select has_fk('public', 'profiles', 'profiles tiene FK a auth.users');
select has_fk('public', 'incomes', 'incomes tiene FK a profiles');
select has_fk('public', 'expenses', 'expenses tiene FK a profiles');
select has_fk('public', 'debts', 'debts tiene FK a profiles');
select has_fk('public', 'goals', 'goals tiene FK a profiles');
select has_fk('public', 'transactions', 'transactions tiene FK a profiles');

-- =====================
-- CHECK constraints — valores inválidos son rechazados
-- =====================

-- debt_strategy solo acepta 'avalanche' o 'snowball'
select throws_ok(
  $$insert into public.profiles (id, debt_strategy) values ('00000000-0000-0000-0000-000000000099', 'invalid')$$,
  23514, -- check_violation
  null,
  'debt_strategy rechaza valores inválidos'
);

-- goal_mode solo acepta 'sequential' o 'parallel'
select throws_ok(
  $$insert into public.profiles (id, goal_mode) values ('00000000-0000-0000-0000-000000000099', 'invalid')$$,
  23514,
  null,
  'goal_mode rechaza valores inválidos'
);

-- frequency solo acepta 'monthly', 'biweekly', 'weekly'
select throws_ok(
  $$insert into public.incomes (id, user_id, name, frequency) values ('test', '00000000-0000-0000-0000-000000000001', 'test', 'invalid')$$,
  23514,
  null,
  'frequency rechaza valores inválidos'
);

-- payment_method solo acepta 'cash', 'debit', 'credit_card'
select throws_ok(
  $$insert into public.expenses (id, user_id, name, payment_method) values ('test', '00000000-0000-0000-0000-000000000001', 'test', 'invalid')$$,
  23514,
  null,
  'payment_method en expenses rechaza valores inválidos'
);

-- transaction type solo acepta valores válidos
select throws_ok(
  $$insert into public.transactions (id, user_id, date, amount, type, category) values ('test', '00000000-0000-0000-0000-000000000001', '2026-01-01', 100, 'invalid', 'test')$$,
  23514,
  null,
  'transaction type rechaza valores inválidos'
);

-- payment_method en transactions solo acepta valores válidos
select throws_ok(
  $$insert into public.transactions (id, user_id, date, amount, type, category, payment_method) values ('test', '00000000-0000-0000-0000-000000000001', '2026-01-01', 100, 'income', 'test', 'invalid')$$,
  23514,
  null,
  'payment_method en transactions rechaza valores inválidos'
);

select * from finish();
rollback;

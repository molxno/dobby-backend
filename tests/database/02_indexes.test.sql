-- =============================================================
-- Tests de Indexes — Verificar que los indexes existen
-- =============================================================
begin;
select plan(7);

select has_index('public', 'incomes', 'idx_incomes_user', 'Index idx_incomes_user existe');
select has_index('public', 'expenses', 'idx_expenses_user', 'Index idx_expenses_user existe');
select has_index('public', 'debts', 'idx_debts_user', 'Index idx_debts_user existe');
select has_index('public', 'goals', 'idx_goals_user', 'Index idx_goals_user existe');
select has_index('public', 'transactions', 'idx_transactions_user', 'Index idx_transactions_user existe');
select has_index('public', 'transactions', 'idx_transactions_date', 'Index idx_transactions_date existe');
select has_index('public', 'transactions', 'idx_transactions_biweekly_key', 'Index idx_transactions_biweekly_key existe');

select * from finish();
rollback;

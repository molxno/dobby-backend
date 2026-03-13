-- =============================================================
-- Tests de Triggers — Verificar que los triggers existen
-- =============================================================
begin;
select plan(11);

-- =====================
-- Funciones de trigger existen
-- =====================
select has_function('public', 'handle_new_user', 'Función handle_new_user existe');
select has_function('public', 'update_updated_at', 'Función update_updated_at existe');
select has_function('public', 'delete_user_account', 'Función delete_user_account existe');

-- =====================
-- Triggers de updated_at existen
-- =====================
select has_trigger('public', 'profiles', 'profiles_updated_at', 'Trigger profiles_updated_at existe');
select has_trigger('public', 'incomes', 'incomes_updated_at', 'Trigger incomes_updated_at existe');
select has_trigger('public', 'expenses', 'expenses_updated_at', 'Trigger expenses_updated_at existe');
select has_trigger('public', 'debts', 'debts_updated_at', 'Trigger debts_updated_at existe');
select has_trigger('public', 'goals', 'goals_updated_at', 'Trigger goals_updated_at existe');

-- =====================
-- Trigger de auto-creación de profile
-- =====================
select has_trigger('auth', 'users', 'on_auth_user_created', 'Trigger on_auth_user_created existe');

-- =====================
-- Verificar que handle_new_user es SECURITY DEFINER
-- =====================
select function_security_type_is(
  'public', 'handle_new_user', array[]::text[],
  'security_definer',
  'handle_new_user es SECURITY DEFINER'
);

-- =====================
-- Verificar que delete_user_account es SECURITY DEFINER
-- =====================
select function_security_type_is(
  'public', 'delete_user_account', array[]::text[],
  'security_definer',
  'delete_user_account es SECURITY DEFINER'
);

select * from finish();
rollback;

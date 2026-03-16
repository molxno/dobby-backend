-- =============================================================
-- Seed Data — Datos de prueba para desarrollo local
-- =============================================================
-- 2 usuarios con datos financieros realistas en COP
-- =============================================================

-- Nota: En Supabase local, los usuarios de auth se crean vía API.
-- Este seed inserta directamente en las tablas de datos asumiendo
-- que los usuarios ya existen en auth.users.

-- Crear usuarios de prueba en auth.users
insert into auth.users (id, instance_id, email, encrypted_password, email_confirmed_at, raw_user_meta_data, created_at, updated_at, aud, role)
values
  (
    '11111111-1111-1111-1111-111111111111',
    '00000000-0000-0000-0000-000000000000',
    'carlos@test.com',
    crypt('password123', gen_salt('bf')),
    now(),
    '{"name": "Carlos Rodríguez"}'::jsonb,
    now(), now(), 'authenticated', 'authenticated'
  ),
  (
    '22222222-2222-2222-2222-222222222222',
    '00000000-0000-0000-0000-000000000000',
    'maria@test.com',
    crypt('password123', gen_salt('bf')),
    now(),
    '{"name": "María López"}'::jsonb,
    now(), now(), 'authenticated', 'authenticated'
  );

-- El trigger handle_new_user crea los profiles automáticamente.
-- Actualizamos los profiles con datos completos:

update public.profiles set
  country = 'Colombia',
  currency = 'COP',
  locale = 'es-CO',
  onboarding_completed = true,
  dark_mode = true,
  debt_strategy = 'avalanche',
  goal_mode = 'sequential',
  current_fund = 500000
where id = '11111111-1111-1111-1111-111111111111';

update public.profiles set
  country = 'Colombia',
  currency = 'COP',
  locale = 'es-CO',
  onboarding_completed = true,
  dark_mode = false,
  debt_strategy = 'snowball',
  goal_mode = 'parallel',
  current_fund = 200000
where id = '22222222-2222-2222-2222-222222222222';

-- =============================================================
-- INGRESOS — Carlos
-- =============================================================
insert into public.incomes (id, user_id, name, amount, frequency, pay_days, is_net) values
  ('inc-c-001', '11111111-1111-1111-1111-111111111111', 'Salario empresa', 4500000, 'monthly', '[15]', true),
  ('inc-c-002', '11111111-1111-1111-1111-111111111111', 'Freelance diseño', 1200000, 'biweekly', '[1, 15]', false);

-- INGRESOS — María
insert into public.incomes (id, user_id, name, amount, frequency, pay_days, is_net) values
  ('inc-m-001', '22222222-2222-2222-2222-222222222222', 'Salario docente', 3200000, 'monthly', '[28]', true),
  ('inc-m-002', '22222222-2222-2222-2222-222222222222', 'Tutorías particulares', 800000, 'weekly', '[5]', true);

-- =============================================================
-- GASTOS — Carlos
-- =============================================================
insert into public.expenses (id, user_id, name, amount, category, is_fixed, is_essential, due_day, payment_method, notes) values
  ('exp-c-001', '11111111-1111-1111-1111-111111111111', 'Arriendo apartamento', 1500000, 'housing', true, true, 1, 'debit', 'Apartamento en Chapinero'),
  ('exp-c-002', '11111111-1111-1111-1111-111111111111', 'Servicios públicos', 280000, 'utilities', true, true, 5, 'debit', null),
  ('exp-c-003', '11111111-1111-1111-1111-111111111111', 'Mercado semanal', 400000, 'food', true, true, null, 'debit', null),
  ('exp-c-004', '11111111-1111-1111-1111-111111111111', 'Internet y celular', 120000, 'utilities', true, true, 10, 'debit', 'Claro hogar + plan celular'),
  ('exp-c-005', '11111111-1111-1111-1111-111111111111', 'Gimnasio SmartFit', 85000, 'health', true, false, 1, 'credit_card', null),
  ('exp-c-006', '11111111-1111-1111-1111-111111111111', 'Streaming (Netflix + Spotify)', 55000, 'entertainment', true, false, 15, 'credit_card', null),
  ('exp-c-007', '11111111-1111-1111-1111-111111111111', 'Transporte Uber/taxi', 200000, 'transportation', false, false, null, 'cash', 'Variable mensual'),
  ('exp-c-008', '11111111-1111-1111-1111-111111111111', 'Salidas y restaurantes', 300000, 'entertainment', false, false, null, 'credit_card', null);

-- GASTOS — María
insert into public.expenses (id, user_id, name, amount, category, is_fixed, is_essential, due_day, payment_method, notes) values
  ('exp-m-001', '22222222-2222-2222-2222-222222222222', 'Arriendo casa', 1200000, 'housing', true, true, 1, 'debit', 'Casa en Kennedy'),
  ('exp-m-002', '22222222-2222-2222-2222-222222222222', 'Servicios públicos', 220000, 'utilities', true, true, 5, 'debit', null),
  ('exp-m-003', '22222222-2222-2222-2222-222222222222', 'Mercado quincenal', 350000, 'food', true, true, null, 'cash', null),
  ('exp-m-004', '22222222-2222-2222-2222-222222222222', 'TransMilenio mensual', 150000, 'transportation', true, true, null, 'debit', 'Tarjeta Tu Llave'),
  ('exp-m-005', '22222222-2222-2222-2222-222222222222', 'Internet', 75000, 'utilities', true, true, 12, 'debit', null),
  ('exp-m-006', '22222222-2222-2222-2222-222222222222', 'Seguro de salud complementario', 180000, 'health', true, true, 1, 'debit', 'Plan complementario Sura');

-- =============================================================
-- DEUDAS — Carlos
-- =============================================================
insert into public.debts (id, user_id, name, type, current_balance, original_amount, monthly_payment, interest_rate, annual_rate, remaining_payments, total_payments, completed_payments, due_day, credit_limit, minimum_payment, product_name, product_value) values
  ('debt-c-001', '11111111-1111-1111-1111-111111111111', 'Tarjeta de crédito Visa', 'credit_card', 3200000, null, 250000, 2.1, 28.08, null, null, null, 15, 8000000, 180000, null, null),
  ('debt-c-002', '11111111-1111-1111-1111-111111111111', 'Crédito libre inversión', 'personal_loan', 12000000, 15000000, 520000, 1.5, 19.56, 28, 36, 8, 20, null, null, null, null),
  ('debt-c-003', '11111111-1111-1111-1111-111111111111', 'Financiación MacBook', 'purchase_financing', 2800000, 4500000, 380000, 0, 0, 8, 12, 4, 10, null, null, 'MacBook Pro M3', 4500000);

-- DEUDAS — María
insert into public.debts (id, user_id, name, type, current_balance, original_amount, monthly_payment, interest_rate, annual_rate, remaining_payments, total_payments, completed_payments, due_day, credit_limit, minimum_payment) values
  ('debt-m-001', '22222222-2222-2222-2222-222222222222', 'Crédito educativo ICETEX', 'student_loan', 8500000, 12000000, 320000, 0.9, 11.35, 30, 48, 18, 5, null, null),
  ('debt-m-002', '22222222-2222-2222-2222-222222222222', 'Tarjeta Mastercard Falabella', 'credit_card', 1800000, null, 150000, 2.4, 32.92, null, null, null, 20, 5000000, 95000);

-- =============================================================
-- METAS — Carlos
-- =============================================================
insert into public.goals (id, user_id, name, icon, target_amount, current_saved, priority, category, deadline, is_flexible, notes) values
  ('goal-c-001', '11111111-1111-1111-1111-111111111111', 'Fondo de emergencia', '🛡️', 13500000, 4200000, 1, 'emergency', '2026-12-31', false, '3 meses de gastos'),
  ('goal-c-002', '11111111-1111-1111-1111-111111111111', 'Viaje a Europa', '✈️', 8000000, 1500000, 2, 'travel', '2027-06-30', true, 'España e Italia, 2 semanas');

-- METAS — María
insert into public.goals (id, user_id, name, icon, target_amount, current_saved, priority, category, deadline, is_flexible, notes) values
  ('goal-m-001', '22222222-2222-2222-2222-222222222222', 'Maestría en educación', '📚', 15000000, 3800000, 1, 'education', '2027-01-15', false, 'Universidad Javeriana'),
  ('goal-m-002', '22222222-2222-2222-2222-222222222222', 'Computador nuevo', '💻', 3500000, 1200000, 2, 'other', '2026-08-30', true, 'Para trabajo y tutorías');

-- =============================================================
-- TRANSACCIONES — Carlos (últimos 3 meses)
-- =============================================================
-- biweekly_key format: "{period}-{index}" where period = quincena number, index = item position
-- Transactions with biweekly_key represent checked items from the biweekly planner
insert into public.transactions (id, user_id, date, amount, type, category, description, payment_method, is_recurring, biweekly_key) values
  ('tx-c-001', '11111111-1111-1111-1111-111111111111', '2026-03-15', 4500000, 'income', 'salary', 'Salario marzo', 'debit', true, null),
  ('tx-c-002', '11111111-1111-1111-1111-111111111111', '2026-03-01', 1500000, 'expense', 'housing', 'Arriendo marzo', 'debit', true, '1-0'),
  ('tx-c-003', '11111111-1111-1111-1111-111111111111', '2026-03-05', 280000, 'expense', 'utilities', 'Servicios marzo', 'debit', true, '1-1'),
  ('tx-c-004', '11111111-1111-1111-1111-111111111111', '2026-03-10', 250000, 'debt_payment', 'credit_card', 'Pago Visa marzo', 'debit', true, '1-2'),
  ('tx-c-005', '11111111-1111-1111-1111-111111111111', '2026-03-10', 520000, 'debt_payment', 'personal_loan', 'Cuota crédito marzo', 'debit', true, '1-3'),
  ('tx-c-006', '11111111-1111-1111-1111-111111111111', '2026-03-12', 400000, 'savings', 'emergency', 'Ahorro fondo emergencia', 'debit', false, '1-4'),
  ('tx-c-007', '11111111-1111-1111-1111-111111111111', '2026-03-08', 85000, 'expense', 'food', 'Mercado semana 1', 'cash', false, null),
  ('tx-c-008', '11111111-1111-1111-1111-111111111111', '2026-02-15', 4500000, 'income', 'salary', 'Salario febrero', 'debit', true, null),
  ('tx-c-009', '11111111-1111-1111-1111-111111111111', '2026-02-01', 1500000, 'expense', 'housing', 'Arriendo febrero', 'debit', true, null),
  ('tx-c-010', '11111111-1111-1111-1111-111111111111', '2026-02-14', 120000, 'expense', 'entertainment', 'Cena San Valentín', 'credit_card', false, null),
  ('tx-c-011', '11111111-1111-1111-1111-111111111111', '2026-01-15', 4500000, 'income', 'salary', 'Salario enero', 'debit', true, null),
  ('tx-c-012', '11111111-1111-1111-1111-111111111111', '2026-01-20', 380000, 'debt_payment', 'purchase_financing', 'Cuota MacBook enero', 'debit', true, null);

-- TRANSACCIONES — María (últimos 3 meses)
insert into public.transactions (id, user_id, date, amount, type, category, description, payment_method, is_recurring, biweekly_key) values
  ('tx-m-001', '22222222-2222-2222-2222-222222222222', '2026-03-28', 3200000, 'income', 'salary', 'Salario marzo', 'debit', true, null),
  ('tx-m-002', '22222222-2222-2222-2222-222222222222', '2026-03-01', 1200000, 'expense', 'housing', 'Arriendo marzo', 'debit', true, '1-0'),
  ('tx-m-003', '22222222-2222-2222-2222-222222222222', '2026-03-05', 320000, 'debt_payment', 'student_loan', 'Cuota ICETEX marzo', 'debit', true, '1-1'),
  ('tx-m-004', '22222222-2222-2222-2222-222222222222', '2026-03-07', 350000, 'expense', 'food', 'Mercado quincenal 1', 'cash', true, null),
  ('tx-m-005', '22222222-2222-2222-2222-222222222222', '2026-03-10', 200000, 'savings', 'education', 'Ahorro maestría', 'debit', false, '1-2'),
  ('tx-m-006', '22222222-2222-2222-2222-222222222222', '2026-03-05', 800000, 'income', 'freelance', 'Tutorías semana 1', 'cash', false, null),
  ('tx-m-007', '22222222-2222-2222-2222-222222222222', '2026-02-28', 3200000, 'income', 'salary', 'Salario febrero', 'debit', true, null),
  ('tx-m-008', '22222222-2222-2222-2222-222222222222', '2026-02-01', 1200000, 'expense', 'housing', 'Arriendo febrero', 'debit', true, null),
  ('tx-m-009', '22222222-2222-2222-2222-222222222222', '2026-02-15', 150000, 'expense', 'transportation', 'Recarga TransMilenio', 'debit', true, null),
  ('tx-m-010', '22222222-2222-2222-2222-222222222222', '2026-01-28', 3200000, 'income', 'salary', 'Salario enero', 'debit', true, null),
  ('tx-m-011', '22222222-2222-2222-2222-222222222222', '2026-01-05', 320000, 'debt_payment', 'student_loan', 'Cuota ICETEX enero', 'debit', true, null),
  ('tx-m-012', '22222222-2222-2222-2222-222222222222', '2026-01-20', 95000, 'expense', 'entertainment', 'Salida con amigas', 'cash', false, null);

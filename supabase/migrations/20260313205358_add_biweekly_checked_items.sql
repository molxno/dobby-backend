-- Agregar columna para almacenar estado del checklist quincenal
-- Formato: { "1-0": true, "2-1": true } donde key = "{periodo}-{indice}"

-- Crear la columna si no existe aún (sin PL/pgSQL)
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS biweekly_checked_items jsonb;

-- Backfill: garantizar que no haya valores NULL
UPDATE public.profiles
SET biweekly_checked_items = '{}'::jsonb
WHERE biweekly_checked_items IS NULL;

-- Establecer DEFAULT y NOT NULL siempre, exista previamente o no
ALTER TABLE public.profiles
  ALTER COLUMN biweekly_checked_items SET DEFAULT '{}'::jsonb;

ALTER TABLE public.profiles
  ALTER COLUMN biweekly_checked_items SET NOT NULL;

-- Agregar columna para almacenar estado del checklist quincenal
-- Formato: { "1-0": true, "2-1": true } donde key = "{periodo}-{indice}"
ALTER TABLE profiles
ADD COLUMN IF NOT EXISTS biweekly_checked_items jsonb DEFAULT '{}'::jsonb;

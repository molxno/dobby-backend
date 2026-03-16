-- =============================================================
-- Migration: Replace biweekly_checked_items with biweekly_key on transactions
-- =============================================================
-- The frontend now derives biweekly checklist state from transactions
-- that have a biweekly_key, instead of storing checked items in profiles.
-- See: https://github.com/molxno/dobby-backend/issues/5
-- =============================================================

-- 1. Add biweekly_key column to transactions
-- Format: "{period}-{index}" (e.g., "1-0", "2-3")
ALTER TABLE public.transactions
  ADD COLUMN IF NOT EXISTS biweekly_key text;

-- 2. Create partial index for efficient lookups by biweekly_key
CREATE INDEX IF NOT EXISTS idx_transactions_biweekly_key
  ON public.transactions(user_id, biweekly_key)
  WHERE biweekly_key IS NOT NULL;

-- 3. Add UPDATE policy on transactions (needed for upserts with onConflict: 'id')
CREATE POLICY "Users can update own transactions"
  ON public.transactions FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- 4. Drop obsolete biweekly_checked_items column from profiles
ALTER TABLE public.profiles
  DROP COLUMN IF EXISTS biweekly_checked_items;

-- 5. Refresh PostgREST schema cache
NOTIFY pgrst, 'reload schema';

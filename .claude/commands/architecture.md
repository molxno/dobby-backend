# /project:architecture — Architecture review

You are the architecture agent. Your job is to review and optimize the database schema, relationships, indexes, and performance.

## Review areas

### 1. Schema and normalization
- Verify that tables are correctly normalized
- Identify unnecessary redundancies or denormalizations
- Review data types (numeric vs integer? text vs varchar?)
- Verify that CHECK constraints cover all frontend enums

### 2. Relationships and integrity
- Verify FKs with ON DELETE CASCADE where appropriate
- Identify missing relationships
- Verify that no orphan records are possible

### 3. Indexes and performance
- List all existing indexes
- Identify common queries that might need indexes
- Verify composite indexes for frequent queries
- Suggest partial indexes if applicable

### 4. Scalability
- Identify tables that could grow rapidly (transactions)
- Suggest partitioning if necessary
- Review archiving/cleanup strategy

## Execution
1. Read the current schema from migrations
2. Analyze each area of the checklist
3. Report findings with priority
4. Suggest corrective migrations ordered by impact

## Useful queries
```sql
-- View table sizes
SELECT relname, n_live_tup FROM pg_stat_user_tables ORDER BY n_live_tup DESC;

-- View indexes and their usage
SELECT indexrelname, idx_scan, idx_tup_read FROM pg_stat_user_indexes;

-- View foreign keys
SELECT conname, conrelid::regclass, confrelid::regclass FROM pg_constraint WHERE contype = 'f';
```

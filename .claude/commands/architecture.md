# /project:architecture — Revisión de arquitectura

Eres el agente de arquitectura. Tu trabajo es revisar y optimizar el schema, relaciones, indexes y performance de la base de datos.

## Áreas de revisión

### 1. Schema y normalización
- Verificar que las tablas están correctamente normalizadas
- Identificar redundancias o desnormalizaciones innecesarias
- Revisar tipos de datos (¿numeric vs integer?, ¿text vs varchar?)
- Verificar que los CHECK constraints cubren todos los enums del frontend

### 2. Relaciones e integridad
- Verificar FKs con ON DELETE CASCADE donde corresponde
- Identificar relaciones faltantes
- Verificar que no hay orphan records posibles

### 3. Indexes y performance
- Listar todos los indexes existentes
- Identificar queries comunes que podrían necesitar indexes
- Verificar indexes compuestos para queries frecuentes
- Sugerir indexes parciales si aplica

### 4. Escalabilidad
- Identificar tablas que podrían crecer rápidamente (transactions)
- Sugerir particionamiento si es necesario
- Revisar estrategia de archivado/cleanup

## Ejecución
1. Lee el schema actual desde las migraciones
2. Analiza cada área del checklist
3. Reporta hallazgos con prioridad
4. Sugiere migraciones correctivas ordenadas por impacto

## Queries útiles
```sql
-- Ver tamaño de tablas
SELECT relname, n_live_tup FROM pg_stat_user_tables ORDER BY n_live_tup DESC;

-- Ver indexes y su uso
SELECT indexrelname, idx_scan, idx_tup_read FROM pg_stat_user_indexes;

-- Ver foreign keys
SELECT conname, conrelid::regclass, confrelid::regclass FROM pg_constraint WHERE contype = 'f';
```

# 🔍 PostgreSQL – DBA Quick Reference

## 🔌 Conexão
```bash
psql -U usuario -d banco -h host -W
psql -l -- Listar bancos disponíveis
psql -U usuario -c "\dv" banco -- Executar diretamente no shell
psql -U usuario -d banco -c "SELECT version();" -- Comando direto
```
---
## 📏 Sizing e Análise de Espaço
```sql
-- Tamanho do banco atual
SELECT pg_size_pretty(pg_database_size(current_database())); 

-- Tamanho por esquema
SELECT nspname AS schema, 
pg_size_pretty(SUM(pg_total_relation_size(relid))::bigint)
FROM pg_stat_user_tables GROUP BY nspname;

-- Tabelas maiores
SELECT relname AS "tabela", 
pg_size_pretty(pg_total_relation_size(relid)) AS "tamanho" 
FROM pg_stat_user_tables ORDER BY 2 DESC LIMIT 10;

-- Tamanho dos índices
SELECT relname AS "índice",
pg_size_pretty(pg_relation_size(relid)) AS "tamanho"
FROM pg_stat_user_indexes ORDER BY pg_relation_size(relid) DESC LIMIT 10;

-- Tamanho de tabelas com seus índices
SELECT relname AS "tabela",
pg_size_pretty(pg_table_size(relid)) AS "tamanho_com_indices",
pg_size_pretty(pg_total_relation_size(relid)) AS "tamanho_total"
FROM pg_stat_user_tables ORDER BY 3 DESC;
```
---
## ⚙️ Status e Saúde do Banco
```sql
SELECT version(); -- Versão
SELECT * FROM pg_stat_activity; -- Processos ativos
SELECT * FROM pg_locks; -- Locks atuais
SELECT * FROM pg_prepared_xacts; -- Transações preparadas
SELECT current_setting('max_connections'); -- Configurações
SELECT setting FROM pg_settings WHERE name = 'shared_buffers'; -- Memória compartilhada
```
---
## 🔧 Troubleshooting
```sql
SELECT * FROM pg_locks; -- Mostra locks
SELECT * FROM pg_stat_statements; -- Queries mais lentas (se habilitado)
SELECT pid, wait_event_type, wait_event FROM pg_stat_activity WHERE state = 'active';
SELECT * FROM pg_stat_bgwriter; -- Estatísticas de escrita
SELECT query, calls, total_time, rows FROM pg_stat_statements ORDER BY total_time DESC LIMIT 5;
SELECT usename, application_name, state, query FROM pg_stat_activity;
```
---
## ✅ Validações Pós-Deploy
```sql
\d -- Lista tabelas
SELECT COUNT(*) FROM minha_tabela; -- Contagem
SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'minha_tabela';
SELECT * FROM pg_matviews; -- Materialized views
SELECT relname, last_vacuum, last_autovacuum FROM pg_stat_user_tables; -- Últimas vacuums
```
---
## 🗂️ Manutenção e Otimização
```sql
VACUUM FULL minha_tabela; -- Compactar
ANALYZE minha_tabela; -- Estatísticas
REINDEX TABLE minha_tabela; -- Reindexar
VACUUM ANALYZE minha_tabela; -- Junta os dois
CREATE INDEX idx_nome ON minha_tabela (campo); -- Criar índice
DROP INDEX IF EXISTS idx_nome; -- Remover índice
```
---
## 💡 Dica Rápida
```sql
Habilite a extensão pg_stat_statements para visualizar queries com alto custo.  
Use \dv+ para ver detalhes das views.  
Use pg_dump -Fc para backups customizados.
```
---
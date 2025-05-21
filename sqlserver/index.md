
# 🔍 SQL Server – DBA Quick Reference

## 🔌 Conexão
```bash
sqlcmd -S servidor -U usuario -P senha
sqlcmd -L -- Listar servidores disponíveis
sqlcmd -S servidor -U usuario -P senha -Q "SELECT @@VERSION" -- Comando direto
```
---
## 📏 Sizing e Análise de Espaço
```sql
EXEC sp_spaceused; -- Tamanho do banco
EXEC sp_MSforeachtable 'EXEC sp_spaceused ''?''' -- Tabelas maiores

-- Tamanho por tabela com uso de índice
SELECT t.NAME AS TableName,
    p.rows AS RowCounts,
    SUM(a.total_pages) * 8 AS TotalSpaceKB,
    SUM(a.used_pages) * 8 AS UsedSpaceKB,
    (SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS UnusedSpaceKB
FROM sys.tables t
INNER JOIN sys.indexes i ON t.OBJECT_ID = i.OBJECT_ID
INNER JOIN sys.partitions p ON i.OBJECT_ID = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
GROUP BY t.Name, p.Rows
ORDER BY TotalSpaceKB DESC;

-- Tamanho dos arquivos do banco
SELECT name, size/128 AS SizeMB, growth/128 AS GrowthMB
FROM sys.master_files
WHERE database_id = DB_ID();
```
---
## ⚙️ Status e Saúde do Banco
```sql
SELECT @@VERSION; -- Versão
EXEC sp_who2; -- Processos ativos
SELECT name FROM sys.configurations; -- Configurações
SELECT * FROM sys.dm_exec_requests WHERE status = 'suspended'; -- Lentidão
SELECT * FROM sys.dm_exec_sessions WHERE is_user_process = 1; -- Usuários ativos
SELECT * FROM sys.dm_os_performance_counters WHERE counter_name LIKE '%Buffer%';
```
---
## 🔧 Troubleshooting
```sql
SELECT * FROM sys.dm_exec_requests WHERE status = 'suspended'; -- Requisições travadas
SELECT * FROM sys.dm_exec_query_stats ORDER BY total_logical_reads DESC; -- Lentidão
DBCC OPENTRAN; -- Verificar transações abertas
DBCC INPUTBUFFER(spid); -- Comando executado por SPID
SELECT * FROM sys.dm_os_waiting_tasks; -- Tarefas esperando recursos
SELECT session_id, wait_type, wait_duration_ms, resource_description
FROM sys.dm_os_wait_stats WHERE wait_type NOT IN ('CLR_SEMAPHORE','LAZYWRITER_SLEEP');
```
---
## ✅ Validações Pós-Deploy
```sql
SELECT name FROM sysobjects WHERE xtype='U'; -- Listar tabelas
SELECT COUNT(*) FROM minha_tabela; -- Contagem
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'minha_tabela';
SELECT name FROM sys.views; -- Listar views
SELECT * FROM sys.foreign_keys; -- Chaves estrangeiras
```
---
## 🗂️ Manutenção e Otimização
```sql
ALTER INDEX ALL ON minha_tabela REBUILD; -- Rebuild
UPDATE STATISTICS minha_tabela; -- Atualiza estatísticas
DBCC SHRINKDATABASE ('meu_banco'); -- Reduz tamanho do banco
DBCC CHECKDB('meu_banco') WITH NO_INFOMSGS; -- Checar integridade
DBCC FREEPROCCACHE; -- Limpar cache de planos
```
---
## 💡 Dica Rápida
```sql
Use o Execution Plan no SSMS para identificar gargalos de performance.  
Habilite o "Include Actual Execution Plan" para análise.  
Use sys.dm_db_index_physical_stats para verificar fragmentação de índices.
```
---
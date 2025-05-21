# 📚 Cheat Sheet – Bancos de Dados Relacionais e Não Relacionais

Este documento apresenta os comandos mais utilizados em bancos de dados populares:

- 🔌 Conexão
- 📏 Sizing e Análise de Espaço
- ⚙️ Status e Saúde do Banco
- 🔧 Troubleshooting
- ✅ Validações Pós-Deploy
- 🗂️ Manutenção e Otimização
- 💡 Dicas Rápidas

> 📝 Este conteúdo é ideal para DBAs, desenvolvedores e engenheiros que trabalham com múltiplos bancos de dados.

---

## 📄 Sumário Automático

{{toc:maxLevel=3}}

---

## 🧭 Navegação Rápida

Use os links abaixo para acessar diretamente as páginas de cada banco:

| Banco | Descrição |
|-------|-----------|
| [MySQL](/pages/viewpage.action?pageId=XXXXX) | Banco relacional popular para aplicações web |
| [PostgreSQL](/pages/viewpage.action?pageId=XXXXX) | Banco relacional avançado com suporte a JSON |
| [SQL Server](/pages/viewpage.action?pageId=XXXXX) | Banco da Microsoft para ambientes corporativos |
| [Oracle](/pages/viewpage.action?pageId=XXXXX) | Banco robusto usado em grandes empresas |
| [MongoDB](/pages/viewpage.action?pageId=XXXXX) | Banco NoSQL flexível e não relacional |

---

## 📌 Menu Lateral (Sidebar)

> Para configurar no Confluence:
1. Acesse **Space Settings > Look and Feel**
2. Edite a **Sidebar**
3. Cole o seguinte código:

```wiki
{section}
{column:width=50%}
**Bancos de Dados**
* [MySQL](/pages/viewpage.action?pageId=XXXXX)
* [PostgreSQL](/pages/viewpage.action?pageId=XXXXX)
* [SQL Server](/pages/viewpage.action?pageId=XXXXX)
* [Oracle](/pages/viewpage.action?pageId=XXXXX)
* [MongoDB](/pages/viewpage.action?pageId=XXXXX)
{column}

{column:width=50%}
**Recursos Úteis**
* [Backup e Restore](/pages/viewpage.action?pageId=XXXXX)
* [Performance Tuning](/pages/viewpage.action?pageId=XXXXX)
* [Logs e Auditoria](/pages/viewpage.action?pageId=XXXXX)
* [Monitoramento](/pages/viewpage.action?pageId=XXXXX)
{column}
{section}




# 🔍 MySQL – DBA Quick Reference

## 🔌 Conexão
{{code:bash}}
mysql -u root -p
mysql -h host -P porta -u usuario -p [banco]
mysql -u usuario -p -e "SHOW DATABASES;" # Executar comando direto no terminal
{{code}}

## 📏 Sizing e Análise de Espaço
{{code:sql}}
-- Tamanho total do banco
SELECT table_schema AS 'Banco', 
SUM(data_length + index_length) / 1024 / 1024 AS 'Tamanho MB' 
FROM information_schema.tables GROUP BY table_schema;

-- Tabelas maiores
SELECT table_name, 
ROUND((data_length + index_length) / 1024 / 1024, 2) AS 'Tamanho MB' 
FROM information_schema.tables 
WHERE table_schema = 'meu_banco' 
ORDER BY 2 DESC LIMIT 10;

-- Tamanho dos índices por tabela
SELECT table_name,
ROUND(sum(index_length)/1024/1024, 2) AS 'Índice MB'
FROM information_schema.tables
WHERE table_schema = 'meu_banco'
GROUP BY table_name ORDER BY 2 DESC;
{{code}}

## ⚙️ Status e Saúde do Banco
{{expand}}
{{code:sql}}
SHOW PROCESSLIST; -- Processos ativos
SELECT VERSION(); -- Versão do MySQL
SHOW VARIABLES LIKE '%max_connections%'; -- Configurações
SHOW ENGINE INNODB STATUS\G -- Detalhes do InnoDB
SHOW GLOBAL STATUS LIKE 'Threads_connected'; -- Threads conectadas
{{code}}
{{/expand}}

## 🔧 Troubleshooting
{{expand}}
{{code:sql}}
SHOW ENGINE INNODB STATUS\G -- Verifica deadlocks
EXPLAIN SELECT * FROM tabela WHERE coluna = 'valor'; -- Plano de execução
SELECT * FROM information_schema.processlist WHERE command != 'Sleep'; -- Consultas ativas
SET GLOBAL log_output = 'TABLE'; SET GLOBAL general_log = 'ON'; -- Habilita logs gerais
SELECT * FROM mysql.general_log ORDER BY event_time DESC LIMIT 50; -- Visualiza logs
{{code}}
{{/expand}}

## ✅ Validações Pós-Deploy
{{code:sql}}
CHECK TABLE minha_tabela; -- Verifica integridade
SELECT COUNT(*) FROM minha_tabela; -- Contagem de registros
SELECT * FROM information_schema.columns WHERE table_name = 'minha_tabela'; -- Estrutura da tabela
SELECT TABLE_NAME, ENGINE FROM information_schema.tables WHERE table_schema = 'meu_banco'; -- Motores das tabelas
{{code}}

## 🗂️ Manutenção e Otimização
{{code:sql}}
OPTIMIZE TABLE minha_tabela; -- Compactar tabela
ANALYZE TABLE minha_tabela; -- Atualizar estatísticas
REPAIR TABLE minha_tabela; -- Reparar tabela
FLUSH PRIVILEGES; -- Recarregar privilégios após alteração
{{code}}

## 💡 Dica Rápida
{{info}}
Use `mysqldumpslow` para analisar slow queries.  
Habilite o `slow query log` no arquivo my.cnf para auditoria.
{{info}}


# 🔍 PostgreSQL – DBA Quick Reference

## 🔌 Conexão
{{code:bash}}
psql -U usuario -d banco -h host -W
psql -l -- Listar bancos disponíveis
psql -U usuario -c "\dv" banco -- Executar diretamente no shell
psql -U usuario -d banco -c "SELECT version();" -- Comando direto
{{code}}

## 📏 Sizing e Análise de Espaço
{{code:sql}}
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
{{code}}

## ⚙️ Status e Saúde do Banco
{{expand}}
{{code:sql}}
SELECT version(); -- Versão
SELECT * FROM pg_stat_activity; -- Processos ativos
SELECT * FROM pg_locks; -- Locks atuais
SELECT * FROM pg_prepared_xacts; -- Transações preparadas
SELECT current_setting('max_connections'); -- Configurações
{{code}}
{{/expand}}

## 🔧 Troubleshooting
{{expand}}
{{code:sql}}
SELECT * FROM pg_locks; -- Mostra locks
SELECT * FROM pg_stat_statements; -- Queries mais lentas (se habilitado)
SELECT pid, wait_event_type, wait_event FROM pg_stat_activity WHERE state = 'active';
SELECT * FROM pg_stat_bgwriter; -- Estatísticas de escrita
{{code}}
{{/expand}}

## ✅ Validações Pós-Deploy
{{code:sql}}
\d -- Lista tabelas
SELECT COUNT(*) FROM minha_tabela; -- Contagem
SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'minha_tabela';
SELECT * FROM pg_matviews; -- Materialized views
{{code}}

## 🗂️ Manutenção e Otimização
{{code:sql}}
VACUUM FULL minha_tabela; -- Compactar
ANALYZE minha_tabela; -- Estatísticas
REINDEX TABLE minha_tabela; -- Reindexar
VACUUM ANALYZE minha_tabela; -- Junta os dois
{{code}}

## 💡 Dica Rápida
{{info}}
Habilite a extensão `pg_stat_statements` para visualizar queries com alto custo.  
Use `\dv+` para ver detalhes das views.
{{info}}


# 🔍 SQL Server – DBA Quick Reference

## 🔌 Conexão
{{code:bash}}
sqlcmd -S servidor -U usuario -P senha
sqlcmd -L -- Listar servidores disponíveis
sqlcmd -S servidor -U usuario -P senha -Q "SELECT @@VERSION" -- Comando direto
{{code}}

## 📏 Sizing e Análise de Espaço
{{code:sql}}
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
{{code}}

## ⚙️ Status e Saúde do Banco
{{expand}}
{{code:sql}}
SELECT @@VERSION; -- Versão
EXEC sp_who2; -- Processos ativos
SELECT name FROM sys.configurations; -- Configurações
SELECT * FROM sys.dm_exec_requests WHERE status = 'suspended'; -- Lentidão
SELECT * FROM sys.dm_exec_sessions WHERE is_user_process = 1; -- Usuários ativos
{{code}}
{{/expand}}

## 🔧 Troubleshooting
{{expand}}
{{code:sql}}
SELECT * FROM sys.dm_exec_requests WHERE status = 'suspended'; -- Requisições travadas
SELECT * FROM sys.dm_exec_query_stats ORDER BY total_logical_reads DESC; -- Lentidão
DBCC OPENTRAN; -- Verificar transações abertas
DBCC INPUTBUFFER(spid); -- Comando executado por SPID
{{code}}
{{/expand}}

## ✅ Validações Pós-Deploy
{{code:sql}}
SELECT name FROM sysobjects WHERE xtype='U'; -- Listar tabelas
SELECT COUNT(*) FROM minha_tabela; -- Contagem
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'minha_tabela';
SELECT name FROM sys.views; -- Listar views
{{code}}

## 🗂️ Manutenção e Otimização
{{code:sql}}
ALTER INDEX ALL ON minha_tabela REBUILD; -- Rebuild
UPDATE STATISTICS minha_tabela; -- Atualiza estatísticas
DBCC SHRINKDATABASE ('meu_banco'); -- Reduz tamanho do banco
DBCC CHECKDB('meu_banco') WITH NO_INFOMSGS; -- Checar integridade
{{code}}

## 💡 Dica Rápida
{{info}}
Use o Execution Plan no SSMS para identificar gargalos de performance.  
Habilite o "Include Actual Execution Plan" para análise.  
Use `sys.dm_db_index_physical_stats` para verificar fragmentação de índices.
{{info}}



# 🔍 Oracle – DBA Quick Reference

## 🔌 Conexão
{{code:bash}}
sqlplus usuario/senha@SID
sqlplus /nolog @script.sql -- Executar script sem conectar
sqlplus usuario/senha@//host:port/SERVICE_NAME -- Conectar via serviço
{{code}}

## 📏 Sizing e Análise de Espaço
{{code:sql}}
-- Tamanho dos tablespaces
SELECT tablespace_name, SUM(bytes)/1024/1024 AS "MB" 
FROM dba_data_files GROUP BY tablespace_name;

-- Tamanho dos objetos por usuário
SELECT owner, segment_name, segment_type, bytes/1024/1024 AS "MB"
FROM dba_segments WHERE owner = 'USUARIO' ORDER BY bytes DESC;

-- Livre nos tablespaces
SELECT tablespace_name, SUM(bytes)/1024/1024 AS "MB Livre"
FROM dba_free_space GROUP BY tablespace_name;

-- Tamanho do redo log
SELECT group#, members, bytes/1024/1024 AS "MB", status FROM v$log;

-- Tamanho do archive log
SELECT dest_name, used_size * 16 / 1024 AS "MB usado" FROM v$archive_dest_status;
{{code}}

## ⚙️ Status e Saúde do Banco
{{expand}}
{{code:sql}}
SELECT * FROM v$version; -- Versão
SELECT sid, serial#, username, status FROM v$session; -- Processos
SELECT name, value FROM v$parameter; -- Configurações
SELECT * FROM v$system_event WHERE event LIKE '%SQL*Net%';
SELECT * FROM v$sga; -- Informações sobre memória
{{code}}
{{/expand}}

## 🔧 Troubleshooting
{{expand}}
{{code:sql}}
SELECT sid, event, wait_time FROM v$session_event; -- Waits
SELECT * FROM v$system_event; -- Eventos globais
SELECT * FROM v$locked_object; -- Objetos bloqueados
SELECT * FROM v$transaction; -- Transações ativas
{{code}}
{{/expand}}

## ✅ Validações Pós-Deploy
{{code:sql}}
SELECT table_name FROM user_tables; -- Listar tabelas
SELECT COUNT(*) FROM minha_tabela; -- Contagem
SELECT column_name FROM all_cons_columns WHERE constraint_name = 'PK_NOME';
SELECT object_name, object_type FROM user_objects WHERE object_type IN ('TABLE','VIEW');
{{code}}

## 🗂️ Manutenção e Otimização
{{code:sql}}
ALTER INDEX idx REBUILD; -- Rebuild índice
EXEC DBMS_STATS.GATHER_TABLE_STATS('schema', 'minha_tabela'); -- Estatísticas
ALTER TABLE t MOVE; -- Mover tabela para outro tablespace
ALTER INDEX idx REBUILD TABLESPACE novo_ts; -- Mover índice
{{code}}

## 💡 Dica Rápida
{{info}}
Use o tkprof para analisar trace files gerados em sessões de diagnóstico.  
Use `v$session_longops` para verificar operações longas.
{{info}}


# 🔍 MongoDB – DBA Quick Reference

## 🔌 Conexão
{{code:bash}}
mongo meu_banco -u usuario -p senha --authenticationDatabase admin
mongo admin -u usuario -p senha --eval "db.isMaster()" -- Autenticar antes de conectar
mongo --host host:port --authenticationDatabase admin -u usuario -p senha
{{code}}

## 📏 Sizing e Análise de Espaço
{{code:javascript}}
db.stats(); // Estatísticas do banco
db.collection.stats(); // Estatísticas da coleção

// Tamanho de todas as coleções
db.getCollectionNames().forEach(function(collection) {
   print(collection);
   printjson(db[collection].stats());
});

// Tamanho total de todos os bancos
db.adminCommand({ listDatabases: 1 }).databases.forEach(function(d) {
   print("Banco: " + d.name + ", Tamanho: " + d.sizeOnDisk / 1024 / 1024 + " MB");
});
{{code}}

## ⚙️ Status e Saúde do Banco
{{expand}}
{{code:javascript}}
db.version(); // Versão do MongoDB
db.currentOp(); // Operações ativas
db.serverCmdLineOpts(); // Parâmetros de inicialização
rs.status(); // Se replicado, mostra status do cluster
{{code}}
{{/expand}}

## 🔧 Troubleshooting
{{expand}}
{{code:javascript}}
db.currentOp({ "active" : true }); // Operações ativas
db.collection.explain("executionStats").find({ campo: valor }) // Performance
db.collection.find({}).sort({campo:1}).hint({campo:1}) // Forçar uso de índice
{{code}}
{{/expand}}

## ✅ Validações Pós-Deploy
{{code:javascript}}
show collections; // Listar coleções
db.minha_colecao.countDocuments({}); // Contagem de documentos
db.collection.findOne(); // Exemplo de documento
db.collection.indexes(); // Índices criados
{{code}}

## 🗂️ Manutenção e Otimização
{{code:javascript}}
db.runCommand({ compact: 'minha_colecao' }); // Compactar coleção
db.collection.reIndex(); // Recriar índices
db.collection.drop(); // Apagar coleção
{{code}}

## 💡 Dica Rápida
{{info}}
Use .explain("executionStats") para entender como uma query está sendo executada.  
Para backups, use mongodump/mongorestore com opção --gzip.
{{info}}
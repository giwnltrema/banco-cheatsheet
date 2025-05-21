# 🔍 Oracle – DBA Quick Reference

## 🔌 Conexão
```bash
sqlplus usuario/senha@SID
sqlplus /nolog @script.sql -- Executar script sem conectar
sqlplus usuario/senha@//host:port/SERVICE_NAME -- Conectar via serviço
```
---
## 📏 Sizing e Análise de Espaço
```sql
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
```
---
## ⚙️ Status e Saúde do Banco
```sql
SELECT * FROM v$version; -- Versão
SELECT sid, serial#, username, status FROM v$session; -- Processos
SELECT name, value FROM v$parameter; -- Configurações
SELECT * FROM v$system_event WHERE event LIKE '%SQL*Net%';
SELECT * FROM v$sga; -- Informações sobre memória
SELECT * FROM v$instance; -- Estado da instância
```
---
## 🔧 Troubleshooting
```sql
SELECT sid, event, wait_time FROM v$session_event; -- Waits
SELECT * FROM v$system_event; -- Eventos globais
SELECT * FROM v$locked_object; -- Objetos bloqueados
SELECT * FROM v$transaction; -- Transações ativas
SELECT sid, serial#, seconds_in_wait, event FROM v$session_wait;
SELECT sql_text FROM v$sqlarea WHERE address IN (SELECT sql_address FROM v$session WHERE status='ACTIVE');
```
---
## ✅ Validações Pós-Deploy
```sql
SELECT table_name FROM user_tables; -- Listar tabelas
SELECT COUNT(*) FROM minha_tabela; -- Contagem
SELECT column_name FROM all_cons_columns WHERE constraint_name = 'PK_NOME';
SELECT object_name, object_type FROM user_objects WHERE object_type IN ('TABLE','VIEW');
SELECT constraint_name, constraint_type FROM user_constraints;
```
---
## 🗂️ Manutenção e Otimização
```sql
ALTER INDEX idx REBUILD; -- Rebuild índice
EXEC DBMS_STATS.GATHER_TABLE_STATS('schema', 'minha_tabela'); -- Estatísticas
ALTER TABLE t MOVE; -- Mover tabela para outro tablespace
ALTER INDEX idx REBUILD TABLESPACE novo_ts; -- Mover índice
ALTER DATABASE DATAFILE '/caminho/arquivo.dbf' RESIZE 500M; -- Redimensionar datafile
```
---
## 💡 Dica Rápida
```sql
Use o tkprof para analisar trace files gerados em sessões de diagnóstico.  
Use v$session_longops para verificar operações longas.  
Use v$sort_segment para verificar uso de sort area.
```
---
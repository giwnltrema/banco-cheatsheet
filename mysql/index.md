# 🔍 MySQL – DBA Quick Reference

## 🔌 Conexão
```bash
mysql -u root -p
mysql -h host -P porta -u usuario -p [banco]
mysql -u usuario -p -e "SHOW DATABASES;" # Executar comando direto no terminal
```
---
## 📏 Sizing e Análise de Espaço
```sql
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
```
---
## ⚙️ Status e Saúde do Banco
```sql
SHOW PROCESSLIST; -- Processos ativos
SELECT VERSION(); -- Versão do MySQL
SHOW VARIABLES LIKE '%max_connections%'; -- Configurações
SHOW ENGINE INNODB STATUS\G -- Detalhes do InnoDB
SHOW GLOBAL STATUS LIKE 'Threads_connected'; -- Threads conectadas
```
---
## 🔧 Troubleshooting
```sql
SHOW ENGINE INNODB STATUS\G -- Verifica deadlocks
EXPLAIN SELECT * FROM tabela WHERE coluna = 'valor'; -- Plano de execução
SELECT * FROM information_schema.processlist WHERE command != 'Sleep'; -- Consultas ativas
SET GLOBAL log_output = 'TABLE'; SET GLOBAL general_log = 'ON'; -- Habilita logs gerais
SELECT * FROM mysql.general_log ORDER BY event_time DESC LIMIT 50; -- Visualiza logs
```
---

## ✅ Validações Pós-Deploy
```sql
CHECK TABLE minha_tabela; -- Verifica integridade
SELECT COUNT(*) FROM minha_tabela; -- Contagem de registros
SELECT * FROM information_schema.columns WHERE table_name = 'minha_tabela'; -- Estrutura da tabela
SELECT TABLE_NAME, ENGINE FROM information_schema.tables WHERE table_schema = 'meu_banco'; -- Motores das tabelas
```
---
## 🗂️ Manutenção e Otimização
```sql
OPTIMIZE TABLE minha_tabela; -- Compactar tabela
ANALYZE TABLE minha_tabela; -- Atualizar estatísticas
REPAIR TABLE minha_tabela; -- Reparar tabela
FLUSH PRIVILEGES; -- Recarregar privilégios após alteração
```
---
## 💡 Dica Rápida
```sql
Use mysqldumpslow para analisar slow queries.  
Habilite o slow query log no arquivo my.cnf para auditoria.
```
---
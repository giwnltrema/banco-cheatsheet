# 🔍 MongoDB – DBA Quick Reference

## 🔌 Conexão
```bash
    mongo meu_banco -u usuario -p senha --authenticationDatabase admin
    mongo admin -u usuario -p senha --eval "db.isMaster()" -- Autenticar antes de conectar
    mongo --host host:port --authenticationDatabase admin -u usuario -p senha
    
```
---

## 📏 Sizing e Análise de Espaço
```sql
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

// Tamanho dos índices por coleção
db.collection.stats().indexSizes;

## ⚙️ Status e Saúde do Banco
db.version(); // Versão do MongoDB
db.currentOp(); // Operações ativas
db.serverCmdLineOpts(); // Parâmetros de inicialização
rs.status(); // Se replicado, mostra status do cluster
db.hostInfo(); // Informações do sistema
db.serverStatus(); // Detalhes gerais do servidor
```
---
## 🔧 Troubleshooting
```sql
db.currentOp({ "active" : true }); // Operações ativas
db.collection.explain("executionStats").find({ campo: valor }) // Performance
db.collection.find({}).sort({campo:1}).hint({campo:1}) // Forçar uso de índice
db.collection.aggregate([ { $currentOp: {} } ]) // Operações em andamento
db.collection.validate({scandata:true}); // Validar integridade
```
---
## ✅ Validações Pós-Deploy
```sql
show collections; // Listar coleções
db.minha_colecao.countDocuments({}); // Contagem de documentos
db.collection.findOne(); // Exemplo de documento
db.collection.indexes(); // Índices criados
db.collection.stats({scale:1024*1024}); // Tamanho em MB
```
---
## 🗂️ Manutenção e Otimização
```sql
db.runCommand({ compact: 'minha_colecao' }); // Compactar coleção
db.collection.reIndex(); // Recriar índices
db.collection.drop(); // Apagar coleção
db.collection.createIndex({campo:1}, {background:true}); // Criar índice
db.collection.remove({}); // Apagar todos os documentos
```
---
## 💡 Dica Rápida
```sql
Use .explain("executionStats") para entender como uma query está sendo executada.  
Para backups, use mongodump/mongorestore com opção --gzip.  
Use db.collection.totalIndexSize() para verificar uso de índice.
```
---

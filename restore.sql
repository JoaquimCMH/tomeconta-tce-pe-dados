RESTORE FILELISTONLY
FROM DISK = '/data/Backup/TomeConta/TomeConta/TomeConta.bak'
GO

RESTORE DATABASE TOMECONTA
FROM DISK = '/data/Backup/TomeConta/TomeConta/TomeConta.bak' WITH
MOVE 'TomeConta' TO '/var/opt/mssql/data/TomeConta.mdf',
MOVE 'TomeConta_log' TO '/var/opt/mssql/data/TomeConta_log.ldf'
GO
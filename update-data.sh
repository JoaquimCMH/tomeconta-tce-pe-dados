#!/bin/bash

# Pretty Print
pprint() {
  printf "\n============================================\n$1\n============================================\n"
}

printWithTime() {
  printf "\n[$(date +%d-%m-%y_%H:%M)] $1 \n"
}

# Carrega variáveis de ambiente
source .env

# Registra a data de início
inicio=$(date +%d-%m-%y__%H_%M)
pprint "Início da execução: $inicio"

mkdir -p $LOG_FOLDERPATH
log_filepath="${LOG_FOLDERPATH}/${inicio}.txt"
exec > >(tee -a $log_filepath) 2>&1

printWithTime "Iniciando container..."

mkdir -p $ARMAZENAMENTO_BD
chown -R 10001:0 $ARMAZENAMENTO_BD
chown -R 10001:0 $ARMAZENAMENTO_DADOS
docker-compose up -d

printWithTime "Fazendo o download dos dados..."
wget -P $ARMAZENAMENTO_DADOS $FONTE_DADOS

printWithTime "Descompactando os dados..."
unrar x $ARMAZENAMENTO_DADOS/TomeConta.rar $ARMAZENAMENTO_DADOS/

printWithTime "Restaurando os dados para o BD..."

docker exec mssql-tce-pe sh -c '/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "S3cr3t-P4ssw0rd!" \
-i /restore.sql'

docker exec mssql-tce-pe sh -c '/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "S3cr3t-P4ssw0rd!" \
-q "USE TOMECONTA; SELECT * FROM information_schema.tables;"'

pprint "Fim da execução: $(date +%d-%m-%y__%H_%M)"
#!/bin/bash

# Variáveis de ambiente
export LOJA_NOME="Boutique Elegance"
export LOJA_DIR="/var/loja"
export DATA=$(date +%Y-%m-%d)
export LOG_FILE="$LOJA_DIR/logs/operacoes_$DATA.log"

# Função para criar diretórios necessários e respectivas permissões
setup_diretorios() {
    mkdir -p "$LOJA_DIR"/{estoque,vendas,logs,backup}
    chmod 755 "$LOJA_DIR"
}

# Função para registrar logs
registrar_log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}
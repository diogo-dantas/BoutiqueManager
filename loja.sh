#!/bin/bash

# Variáveis de ambiente
export LOJA_NOME="Boutique Elegance"
export LOJA_DIR="/var/loja"
export DATA=$(date +%Y-%m-%d)
export LOG_FILE="$LOJA_DIR/logs/operacoes_$DATA.log"

# Função para criar diretórios necessários e respectivas permissões
setup_diretorios() {
    sudo mkdir -p "$LOJA_DIR"/{estoque,vendas,logs,backup}
    chmod 755 "$LOJA_DIR"
}

# Função para registrar logs
registrar_log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Array com categorias de produtos
categorias=("Camisetas" "Calças" "Vestidos" "Acessórios")

# Função para adicionar novo produto
adicionar_produto() {
    echo "Digite os dados do produto:"
    read -p "Nome do produto: " nome
    read -p "Preço: " preco
    read -p "Quantidade: " quantidade


	echo "Selecione a categoria:"
	select categoria in "${categorias[@]}"; do
	    if [[ -n $categoria ]]; then
	        break
	    else
	        echo "Seleção inválida. Tente novamente."
	    fi
	done

	echo "$nome|$preco|$quantidade|$categoria" >> "$LOJA_DIR/estoque/produtos.txt"
    registrar_log "Produto adicionado: $nome"
}

# Função para listar produtos com baixo estoque
verificar_estoque() {
    echo "Produtos com estoque baixo (menos de 5 unidades):"
    cat "$LOJA_DIR/estoque/produtos.txt" | 
    awk -F'|' '$3 < 5 {print "Produto: " $1 ", Quantidade: " $3}'
}

# Função para fazer backup do estoque
backup_estoque() {
    local backup_file="$LOJA_DIR/backup/estoque_$DATA.bak"
    cp "$LOJA_DIR/estoque/produtos.txt" "$backup_file"
    gzip "$backup_file"
    registrar_log "Backup realizado: $backup_file.gz"
}
 
# Função para gerar relatório de vendas
relatorio_vendas() {
    if [ -f "$LOJA_DIR/vendas/vendas_$DATA.txt" ]; then
        echo "=== Relatório de Vendas - $DATA ==="
        total=$(awk -F'|' '{sum += $2} END {print sum}' "$LOJA_DIR/vendas/vendas_$DATA.txt")
        echo "Total de vendas: R$ $total"
        echo -e "\nVendas por categoria:"
        awk -F'|' '{print $4}' "$LOJA_DIR/vendas/vendas_$DATA.txt" | 
        sort | uniq -c | sort -nr
    else
        echo "Nenhuma venda registrada hoje."
    fi
}

# Função principal
main() {
    # Verifica se os diretórios existem
    if [ ! -d "$LOJA_DIR" ]; then
        setup_diretorios
    fi
    
    # Menu principal
    while true; do
        echo -e "\n=== $LOJA_NOME - Sistema de Gerenciamento ==="
        echo "1. Adicionar Produto"
        echo "2. Verificar Estoque"
        echo "3. Gerar Relatório de Vendas"
        echo "4. Fazer Backup"
        echo "5. Sair"
        
        read -p "Escolha uma opção: " opcao
        
        case $opcao in
            1) adicionar_produto ;;
            2) verificar_estoque ;;
            3) relatorio_vendas ;;
            4) backup_estoque ;;
            5) break ;;
            *) echo "Opção inválida!" ;;
        esac
    done
}

# Executa o programa principal
main



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
 

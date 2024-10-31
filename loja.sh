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

# Função para listar produtos disponíveis
listar_produtos() {
    if [ -f "$LOJA_DIR/estoque/produtos.txt" ]; then
        echo "=== Produtos Disponíveis ==="
        echo "ID | Nome | Preço | Quantidade | Categoria"
        echo "----------------------------------------"
        awk -F'|' 'BEGIN {count=1} $3 > 0 {printf "%d | %s | R$ %s | %s | %s\n", count++, $1, $2, $3, $4}' "$LOJA_DIR/estoque/produtos.txt"
    else
        echo "Nenhum produto cadastrado."
        return 1
    fi
}

# Função para atualizar estoque
atualizar_estoque() {
    local produto_id=$1
    local quantidade_vendida=$2
    local temp_file="$LOJA_DIR/estoque/temp.txt"
    local count=1
    
    while IFS='|' read -r nome preco quantidade categoria; do
        if [ $count -eq $produto_id ]; then
            nova_quantidade=$((quantidade - quantidade_vendida))
            echo "$nome|$preco|$nova_quantidade|$categoria"
        else
            echo "$nome|$preco|$quantidade|$categoria"
        fi
        count=$((count + 1))
    done < "$LOJA_DIR/estoque/produtos.txt" > "$temp_file"
    
    mv "$temp_file" "$LOJA_DIR/estoque/produtos.txt"
}


# Função para registrar venda
registrar_venda() {
    echo "=== Registrar Nova Venda ==="
    
    # Lista produtos disponíveis
    if ! listar_produtos; then
        return
    fi
    
    # Seleciona produto
    read -p "Digite o ID do produto: " produto_id
    
    # Verifica se o ID é válido
    local total_produtos=$(wc -l < "$LOJA_DIR/estoque/produtos.txt")
    if [ "$produto_id" -lt 1 ] || [ "$produto_id" -gt "$total_produtos" ]; then
        echo "ID de produto inválido!"
        return
    fi
    
    # Obtém informações do produto
    local linha=$(sed -n "${produto_id}p" "$LOJA_DIR/estoque/produtos.txt")
    IFS='|' read -r nome preco quantidade categoria <<< "$linha"
    
    # Verifica quantidade disponível
    echo "Produto: $nome"
    echo "Preço: R$ $preco"
    echo "Quantidade disponível: $quantidade"
    
    read -p "Quantidade a vender: " quantidade_venda
    
    # Valida quantidade
    if [ "$quantidade_venda" -gt "$quantidade" ]; then
        echo "Erro: Quantidade insuficiente em estoque!"
        return
    fi
    
    # Calcula total
    total=$(echo "$preco * $quantidade_venda" | bc)
    
    echo "Total da venda: R$ $total"
    read -p "Confirmar venda (S/N)? " confirma
    
    if [[ $confirma =~ ^[Ss]$ ]]; then
        # Registra venda
        echo "$nome|$total|$quantidade_venda|$categoria|$(date '+%Y-%m-%d %H:%M:%S')" >> "$LOJA_DIR/vendas/vendas_$DATA.txt"
        
        # Atualiza estoque
        atualizar_estoque "$produto_id" "$quantidade_venda"
        
        registrar_log "Venda realizada: $quantidade_venda x $nome - Total: R$ $total"
        echo "Venda registrada com sucesso!"
    else
        echo "Venda cancelada."
    fi
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
        echo "2. Registrar Venda"
        echo "3. Verificar Estoque"
        echo "4. Gerar Relatório de Vendas"
        echo "5. Fazer Backup"
        echo "6. Listar Produtos"
        echo "7. Sair"
        
        read -p "Escolha uma opção: " opcao
        
        case $opcao in
            1) adicionar_produto ;;
            2) registrar_venda ;;
            3) verificar_estoque ;;
            4) relatorio_vendas ;;
            5) backup_estoque ;;
            6) listar_produtos ;;
            7) break ;;
            *) echo "Opção inválida!" ;;
        esac
    done
}

# Executa o programa principal
main



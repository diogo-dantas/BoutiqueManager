# BoutiqueManager 🛍️

> Sistema de gerenciamento em shell script para pequenas lojas de roupas

![Gerenciamento de loja de roupas](https://img.freepik.com/vetores-gratis/fundo-isometrico-de-loja-de-moda-sustentavel-com-jovem-casal-escolhendo-roupas-eticas-baratas-ilustracao-vetorial_1284-74876.jpg?t=st=1730421137~exp=1730424737~hmac=8bc2c6f04204380a47d8dffefd6768fb9a5815db0cebf1b1c4b12685083cb7c7&w=740)

## 📋 Sobre o Projeto

BoutiqueManager é um sistema em shell script projetado para automatizar e simplificar a gestão de pequenas lojas de roupas. O sistema oferece funcionalidades essenciais como gestão de estoque, registro de vendas, relatórios e backups automáticos.

## 🚀 Funcionalidades

- ✨ Gestão de estoque
- 📊 Relatórios de vendas
- 🔄 Backup automático de dados
- 📦 Controle de produtos por categoria
- 📝 Sistema de logs para auditoria
- ⏰ Tarefas automatizadas via cron

## 🛠️ Tecnologias Utilizadas

- Shell Script (Bash)
- AWK para processamento de dados
- Cron para agendamento de tarefas
- Sistemas de arquivos para armazenamento

## 📦 Pré-requisitos

- Sistema operacional Linux/Unix
- Bash 4.0 ou superior
- Permissões de escrita no diretório de instalação
- Utilitários padrão Unix (awk, sort, uniq)

## 🔧 Instalação

1. Clone o repositório:
```bash
git clone https://github.com/seu-usuario/boutique-manager.git
```

2. Entre no diretório do projeto:
```bash
cd boutique-manager
```

3. Dê permissão de execução ao script:
```bash
chmod +x loja.sh
```

4. Configure o arquivo de ambiente (opcional):
```bash
cp .env.example .env
nano .env
```

## 🚀 Uso

1. Execute o script principal:
```bash
./loja.sh
```

2. Configure as tarefas automáticas no cron:
```bash
crontab -e
```

Adicione as seguintes linhas:
```
# Backup diário às 23h
0 23 * * * /caminho/do/script/loja.sh backup

# Verificação de estoque toda segunda às 8h
0 8 * * 1 /caminho/do/script/loja.sh estoque
```

## 📊 Estrutura de Diretórios

```
/var/loja/
├── estoque/
│   └── produtos.txt
├── vendas/
│   └── vendas_YYYY-MM-DD.txt
├── logs/
│   └── operacoes_YYYY-MM-DD.log
└── backup/
    └── estoque_YYYY-MM-DD.bak.gz
```

## 🤝 Contribuindo

1. Faça um Fork do projeto
2. Crie sua Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a Branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 📫 Contato

Diogo Dantas (www.linkedin.com/in/diogodantasp) - diogo.dantas@live.com

Link do projeto: [https://github.com/diogo-dantas/boutique-manager](https://github.com/diogo-dantas/boutique-manager)

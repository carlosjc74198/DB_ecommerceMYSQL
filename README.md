# Sistema de Banco de Dados E-commerce

## 📋 Descrição do Projeto
Sistema de banco de dados MySQL para um e-commerce, desenvolvido com foco em relacionamentos, constraints e queries complexas. O sistema suporta clientes PF e PJ, múltiplas formas de pagamento, gestão de estoque, vendedores, fornecedores e acompanhamento de entregas.

## 🏗️ Estrutura do Banco de Dados

### Principais Entidades
- **Clientes** (PF e PJ)
- **Produtos**
- **Pedidos**
- **Entregas**
- **Vendedores**
- **Fornecedores**
- **Estoque**
- **Formas de Pagamento**

### Características Principais
- Separação entre clientes PF e PJ
- Sistema multi-formas de pagamento
- Rastreamento de entregas
- Gestão de estoque
- Sistema de vendedores com comissão
- Relacionamento produtos-fornecedores

## 🚀 Funcionalidades

### Clientes
- Cadastro diferenciado para PF e PJ
- Múltiplas formas de pagamento por cliente
- Histórico de pedidos

### Pedidos
- Registro completo de itens
- Cálculo automático de subtotais
- Múltiplos status de acompanhamento

### Entregas
- Código de rastreio único
- Status de entrega atualizável
- Registro de datas de envio e entrega

### Estoque
- Controle por fornecedor
- Quantidade disponível
- Valor total em estoque

## 📊 Queries Disponíveis

### Análises Básicas
- Total de pedidos por cliente
- Produtos por fornecedor
- Status de entregas

### Análises Complexas
- Relatório de vendas por forma de pagamento
- Relação produtos-fornecedores-estoque
- Verificação de vendedores/fornecedores


## 📌 Pré-requisitos
- MySQL 5.7 ou superior
- Servidor MySQL configurado
- Cliente MySQL ou ferramenta de administração (ex: MySQL Workbench)

## 🔍 Exemplos de Uso

### Consulta de Pedidos por Cliente
```sql
SELECT 
    c.nome,
    COUNT(p.pedido_id) as total_pedidos,
    SUM(p.valor_total) as valor_total
FROM clientes c
LEFT JOIN pedidos p ON c.cliente_id = p.cliente_id
GROUP BY c.cliente_id, c.nome;
```

### Consulta de Status de Entregas
```sql
SELECT 
    status,
    COUNT(*) as total
FROM entregas
GROUP BY status;
```

## 📈 Diferenciais
- Modelo relacional completo
- Constraints bem definidas
- Atributos derivados
- Queries otimizadas
- Dados de exemplo incluídos

## 🤝 Contribuições
Contribuições são bem-vindas! Para contribuir:
1. Faça um Fork do projeto
2. Crie uma Branch para sua Feature (`git checkout -b feature/AmazingFeature`)
3. Faça o Commit de suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Faça o Push para a Branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença
Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## ✒️ Autor
José Carlos Carneiro

## 🎯 Status do Projeto
Em desenvolvimento

## 📞 Contato
- LinkedIn: https://www.linkedin.com/in/josé-carlos-carneiro/

-- Recuperação simples com SELECT
SELECT * FROM produtos WHERE categoria = 'Eletrônicos';

-- Filtro com WHERE
SELECT nome, email FROM clientes WHERE status = 'Ativo';

-- Atributo derivado
SELECT nome, preco, (preco * 0.9) as preco_com_desconto FROM produtos;

-- Ordenação com ORDER BY
SELECT * FROM pedidos ORDER BY data_pedido DESC;

-- Agrupamento com HAVING
SELECT categoria, COUNT(*) as total_produtos, AVG(preco) as preco_medio
FROM produtos
GROUP BY categoria
HAVING COUNT(*) > 1;

-- Join entre tabelas
SELECT c.nome as cliente, p.status, ip.quantidade, prod.nome as produto
FROM clientes c
JOIN pedidos p ON c.cliente_id = p.cliente_id
JOIN itens_pedido ip ON p.pedido_id = ip.pedido_id
JOIN produtos prod ON ip.produto_id = prod.produto_id;

-- Quantos pedidos foram feitos por cada cliente?
SELECT 
    c.nome,
    CASE 
        WHEN c.tipo = 'PF' THEN cpf.cpf
        WHEN c.tipo = 'PJ' THEN pj.cnpj
    END as documento,
    COUNT(p.pedido_id) as total_pedidos,
    SUM(p.valor_total) as valor_total_pedidos
FROM clientes c
LEFT JOIN pedidos p ON c.cliente_id = p.cliente_id
LEFT JOIN clientes_pf cpf ON c.cliente_id = cpf.cliente_id
LEFT JOIN clientes_pj pj ON c.cliente_id = pj.cliente_id
GROUP BY c.cliente_id, c.nome, documento;

-- Algum vendedor também é fornecedor?
SELECT 
    v.nome as vendedor,
    v.cpf,
    f.razao_social as fornecedor,
    f.cnpj
FROM vendedores v
JOIN fornecedores f ON v.cpf = f.cnpj  -- Isso assumiria que o vendedor usou seu CPF como CNPJ
ORDER BY v.nome;

-- Relação de produtos, fornecedores e estoques
SELECT 
    p.nome as produto,
    f.razao_social as fornecedor,
    e.quantidade as quantidade_estoque,
    p.preco as preco_unitario,
    (p.preco * e.quantidade) as valor_total_estoque
FROM produtos p
JOIN estoque e ON p.produto_id = e.produto_id
JOIN fornecedores f ON e.fornecedor_id = f.fornecedor_id
ORDER BY f.razao_social, p.nome;

-- Relação de nomes dos fornecedores e nomes dos produtos
SELECT 
    f.razao_social as fornecedor,
    GROUP_CONCAT(p.nome) as produtos_fornecidos,
    COUNT(p.produto_id) as total_produtos
FROM fornecedores f
LEFT JOIN estoque e ON f.fornecedor_id = e.fornecedor_id
LEFT JOIN produtos p ON e.produto_id = p.produto_id
GROUP BY f.fornecedor_id, f.razao_social;

-- Query adicional: Relatório de entregas por status
SELECT 
    e.status as status_entrega,
    COUNT(*) as total_entregas,
    COUNT(DISTINCT p.cliente_id) as total_clientes_distintos
FROM entregas e
JOIN pedidos p ON e.pedido_id = p.pedido_id
GROUP BY e.status;


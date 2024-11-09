-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- Tabela base de Clientes
CREATE TABLE clientes (
    cliente_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    tipo ENUM('PF', 'PJ') NOT NULL,
    data_cadastro DATE DEFAULT (CURRENT_DATE),
    status ENUM('Ativo', 'Inativo') DEFAULT 'Ativo'
);

-- Tabela para Clientes PF
CREATE TABLE clientes_pf (
    cliente_id INT PRIMARY KEY,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    rg VARCHAR(15),
    data_nascimento DATE,
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);

-- Tabela para Clientes PJ
CREATE TABLE clientes_pj (
    cliente_id INT PRIMARY KEY,
    cnpj VARCHAR(14) UNIQUE NOT NULL,
    razao_social VARCHAR(100) NOT NULL,
    inscricao_estadual VARCHAR(20),
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);

-- Tabela de Fornecedores
CREATE TABLE fornecedores (
    fornecedor_id INT PRIMARY KEY AUTO_INCREMENT,
    razao_social VARCHAR(100) NOT NULL,
    cnpj VARCHAR(14) UNIQUE NOT NULL,
    contato VARCHAR(100),
    telefone VARCHAR(15)
);

-- Tabela de Vendedores
CREATE TABLE vendedores (
    vendedor_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    comissao_percentual DECIMAL(4,2) DEFAULT 0
);

-- Tabela de Produtos
CREATE TABLE produtos (
    produto_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL,
    categoria VARCHAR(50)
);

-- Tabela de Estoque
CREATE TABLE estoque (
    estoque_id INT PRIMARY KEY AUTO_INCREMENT,
    produto_id INT,
    fornecedor_id INT,
    quantidade INT NOT NULL DEFAULT 0,
    FOREIGN KEY (produto_id) REFERENCES produtos(produto_id),
    FOREIGN KEY (fornecedor_id) REFERENCES fornecedores(fornecedor_id)
);

-- Tabela de Formas de Pagamento
CREATE TABLE formas_pagamento (
    forma_pagamento_id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT,
    tipo ENUM('Cartão de Crédito', 'Cartão de Débito', 'Boleto', 'PIX') NOT NULL,
    numero_cartao VARCHAR(16),
    validade_cartao DATE,
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);

-- Tabela de Pedidos
CREATE TABLE pedidos (
    pedido_id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT,
    vendedor_id INT,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pendente', 'Aprovado', 'Em Separação', 'Enviado', 'Entregue', 'Cancelado') DEFAULT 'Pendente',
    forma_pagamento_id INT,
    valor_total DECIMAL(10,2),
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id),
    FOREIGN KEY (vendedor_id) REFERENCES vendedores(vendedor_id),
    FOREIGN KEY (forma_pagamento_id) REFERENCES formas_pagamento(forma_pagamento_id)
);

-- Tabela de Entregas
CREATE TABLE entregas (
    entrega_id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT UNIQUE,
    status ENUM('Aguardando Coleta', 'Em Trânsito', 'Entregue', 'Devolvido') DEFAULT 'Aguardando Coleta',
    codigo_rastreio VARCHAR(20) UNIQUE,
    data_envio DATE,
    data_entrega DATE,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(pedido_id)
);

-- Tabela de Itens do Pedido
CREATE TABLE itens_pedido (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT,
    produto_id INT,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) GENERATED ALWAYS AS (quantidade * preco_unitario) STORED,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(pedido_id),
    FOREIGN KEY (produto_id) REFERENCES produtos(produto_id)
);

-- Inserindo dados de exemplo
INSERT INTO fornecedores (razao_social, cnpj, contato) VALUES
    ('Tech Supplies LTDA', '12345678000190', 'João Comercial'),
    ('Eletrônicos SA', '98765432000190', 'Maria Vendas');

INSERT INTO vendedores (nome, email, cpf, comissao_percentual) VALUES
    ('Carlos Vendas', 'carlos@email.com', '12345678901', 5.00),
    ('Ana Vendedora', 'ana@email.com', '98765432109', 5.00);

-- Inserindo cliente PF
INSERT INTO clientes (nome, email, tipo) VALUES
    ('João Silva', 'joao@email.com', 'PF');
INSERT INTO clientes_pf (cliente_id, cpf, rg) VALUES
    (LAST_INSERT_ID(), '12345678901', '123456789');

-- Inserindo cliente PJ
INSERT INTO clientes (nome, email, tipo) VALUES
    ('Empresa XYZ', 'contato@xyz.com', 'PJ');
INSERT INTO clientes_pj (cliente_id, cnpj, razao_social) VALUES
    (LAST_INSERT_ID(), '12345678000199', 'XYZ Comercio LTDA');

INSERT INTO produtos (nome, descricao, preco, categoria) VALUES
    ('Smartphone X', 'Smartphone última geração', 1999.99, 'Eletrônicos'),
    ('Notebook Y', 'Notebook i7 16GB', 3999.99, 'Informática');

INSERT INTO estoque (produto_id, fornecedor_id, quantidade) VALUES
    (1, 1, 50),
    (2, 2, 30);
    
-- Inserindo formas de pagamento para os clientes
INSERT INTO formas_pagamento (cliente_id, tipo, numero_cartao, validade_cartao) VALUES
    (1, 'Cartão de Crédito', '4111111111111111', '2025-12-31'),
    (1, 'PIX', NULL, NULL),
    (2, 'Cartão de Crédito', '5111111111111111', '2026-08-31'),
    (2, 'Boleto', NULL, NULL);

-- Inserindo pedidos
INSERT INTO pedidos 
    (cliente_id, vendedor_id, status, forma_pagamento_id, valor_total) 
VALUES
    (1, 1, 'Aprovado', 1, 1999.99),
    (1, 2, 'Entregue', 1, 3999.99),
    (2, 1, 'Em Separação', 3, 5999.98),
    (2, 2, 'Pendente', 4, 1999.99),
    (1, 1, 'Enviado', 2, 3999.99);

-- Inserindo itens dos pedidos
INSERT INTO itens_pedido 
    (pedido_id, produto_id, quantidade, preco_unitario) 
VALUES
    -- Pedido 1: 1 Smartphone
    (1, 1, 1, 1999.99),
    -- Pedido 2: 1 Notebook
    (2, 2, 1, 3999.99),
    -- Pedido 3: 1 Smartphone + 1 Notebook
    (3, 1, 1, 1999.99),
    (3, 2, 1, 3999.99),
    -- Pedido 4: 1 Smartphone
    (4, 1, 1, 1999.99),
    -- Pedido 5: 1 Notebook
    (5, 2, 1, 3999.99);

-- Inserindo entregas
INSERT INTO entregas 
    (pedido_id, status, codigo_rastreio, data_envio, data_entrega) 
VALUES
    (1, 'Em Trânsito', 'BR123456789', '2024-11-08', NULL),
    (2, 'Entregue', 'BR987654321', '2024-11-07', '2024-11-09'),
    (3, 'Aguardando Coleta', 'BR456789123', '2024-11-09', NULL),
    (4, 'Aguardando Coleta', 'BR789123456', NULL, NULL),
    (5, 'Em Trânsito', 'BR321654987', '2024-11-08', NULL);


CREATE DATABASE confeitaria_db;
USE confeitaria_db;

CREATE TABLE produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL,
    categoria ENUM('bolo', 'docinho', 'kit') NOT NULL,
    img_url VARCHAR(255),
    estoque INT DEFAULT 0,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10,2) NOT NULL,
    status ENUM('pendente', 'confirmado', 'entregue') DEFAULT 'pendente',
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE TABLE itens_pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (produto_id) REFERENCES produtos(id)
);

# INSERTS!!
-- Inserir PRODUTOS
INSERT INTO produtos (nome, descricao, preco, categoria, img_url, estoque) VALUES
('Bolo de Chocolate Belga', 'Bolo artesanal com chocolate belga premium', 89.90, 'bolo', 'https://exemplo.com/bolo-chocolate.jpg', 8),
('Bolo de Morango com Ninho', 'Bolo com recheio de creme de ninho e morangos', 75.50, 'bolo', 'https://exemplo.com/bolo-morango.jpg', 12),
('Brigadeiro Gourmet', 'Brigadeiro premium com chocolate 70%', 2.50, 'docinho', 'https://exemplo.com/brigadeiro.jpg', 50),
('Beijinho de Coco', 'Docinho tradicional de coco queimado', 2.00, 'docinho', 'https://exemplo.com/beijinho.jpg', 45),
('Cajuzinho', 'Docinho de amendoim com formato de caju', 2.00, 'docinho', 'https://exemplo.com/cajuzinho.jpg', 40),
('Kit Festa Infantil', 'Kit completo para 20 crianças com bolo e doces', 299.90, 'kit', 'https://exemplo.com/kit-infantil.jpg', 5),
('Kit Festa Adulto', 'Kit sofisticado para festas elegantes', 450.00, 'kit', 'https://exemplo.com/kit-adulto.jpg', 3),
('Bolo Red Velvet', 'Bolo aveludado vermelho com cream cheese', 95.00, 'bolo', 'https://exemplo.com/red-velvet.jpg', 6),
('Bolo de Cenoura', 'Bolo de cenoura com cobertura de chocolate', 65.00, 'bolo', 'https://exemplo.com/bolo-cenoura.jpg', 10);

-- Inserir CLIENTES
INSERT INTO clientes (nome, email, telefone) VALUES
('Ana Silva', 'ana.silva@email.com', '(11) 99999-1111'),
('Carlos Oliveira', 'carlos.oliveira@email.com', '(11) 99999-2222'),
('Mariana Santos', 'mariana.santos@email.com', '(11) 99999-3333'),
('João Pereira', 'joao.pereira@email.com', '(11) 99999-4444'),
('Fernanda Lima', 'fernanda.lima@email.com', '(11) 99999-5555');

-- Inserir PEDIDOS
INSERT INTO pedidos (cliente_id, valor_total, status) VALUES
(1, 165.40, 'confirmado'),
(2, 299.90, 'pendente'),
(3, 450.00, 'entregue'),
(4, 95.00, 'confirmado');

-- Inserir ITENS dos PEDIDOS
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unitario) VALUES
-- Pedido 1 da Ana
(1, 1, 1, 89.90),   -- Bolo Chocolate
(1, 3, 10, 2.50),   -- 10 Brigadeiros
(1, 4, 15, 2.00),   -- 15 Beijinhos

-- Pedido 2 do Carlos
(2, 6, 1, 299.90),  -- Kit Festa Infantil

-- Pedido 3 da Mariana
(3, 7, 1, 450.00),  -- Kit Festa Adulto

-- Pedido 4 do João
(4, 8, 1, 95.00);   -- Bolo Red Velvet
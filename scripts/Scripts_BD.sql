-- Criar o banco de dados
CREATE DATABASE pedidoVenda;

-- Usar o banco de dados
USE pedidoVenda;

-- Criar o usuário com uma senha (substitua 'senha123' por uma senha segura)
CREATE USER 'pedidovenda'@'localhost' IDENTIFIED BY 'pedidovenda123';

-- Conceder todos os privilégios no banco 'pedidoVenda' para o novo usuário
GRANT ALL PRIVILEGES ON pedidoVenda.* TO 'pedidouser'@'localhost';

-- Aplicar as mudanças
FLUSH PRIVILEGES;

-- Tabela de clientes
CREATE TABLE clientes (
    codigo INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    uf CHAR(2) NOT NULL
);

-- Tabela de produtos
CREATE TABLE produtos (
    codigo INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL,
    preco_venda DECIMAL(10, 2) NOT NULL
);

-- Tabela de pedidos (dados gerais do pedido)
CREATE TABLE pedidos (
    numero_pedido INT AUTO_INCREMENT PRIMARY KEY,
    data_emissao DATE NOT NULL,
    codigo_cliente INT NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (codigo_cliente) REFERENCES clientes(codigo)
);

-- Tabela de produtos dos pedidos
CREATE TABLE pedido_produtos (
    id_pedido_produto INT AUTO_INCREMENT PRIMARY KEY,
    numero_pedido INT NOT NULL,
    codigo_produto INT NOT NULL,
    quantidade INT NOT NULL,
    valor_unitario DECIMAL(10, 2) NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (numero_pedido) REFERENCES pedidos(numero_pedido),
    FOREIGN KEY (codigo_produto) REFERENCES produtos(codigo)
);

-- Inserir registros fictícios na tabela de clientes, com pelo menos um cliente para cada estado do Brasil
INSERT INTO clientes (nome, cidade, uf) VALUES
('João Silva', 'São Paulo', 'SP'),
('Maria Oliveira', 'Rio de Janeiro', 'RJ'),
('Carlos Souza', 'Belo Horizonte', 'MG'),
('Ana Lima', 'Curitiba', 'PR'),
('Pedro Martins', 'Brasília', 'DF'),
('Fernanda Costa', 'Porto Alegre', 'RS'),
('Rafael Almeida', 'Salvador', 'BA'),
('Isabela Nunes', 'Fortaleza', 'CE'),
('Lucas Melo', 'Recife', 'PE'),
('Gabriela Teixeira', 'Belém', 'PA'),
('Clara Ramos', 'Manaus', 'AM'),
('Bruno Vieira', 'Goiânia', 'GO'),
('Diego Barbosa', 'Florianópolis', 'SC'),
('Mariana Duarte', 'Vitória', 'ES'),
('Rodrigo Santana', 'João Pessoa', 'PB'),
('Juliana Cardoso', 'Maceió', 'AL'),
('Felipe Moreira', 'Campo Grande', 'MS'),
('Paula Borges', 'Teresina', 'PI'),
('Larissa Fernandes', 'Natal', 'RN'),
('Camila Ribeiro', 'Aracaju', 'SE'),
('Tiago Freitas', 'Palmas', 'TO'),
('Eduardo Lima', 'Cuiabá', 'MT'),
('Amanda Castro', 'Rio Branco', 'AC'),
('Leonardo Pires', 'Macapá', 'AP'),
('Beatriz Souza', 'Porto Velho', 'RO'),
('Renata Carvalho', 'Boa Vista', 'RR'),
('Sara Mendes', 'São Luís', 'MA');



-- Inserir 20 registros fictícios na tabela de produtos
INSERT INTO produtos (descricao, preco_venda) VALUES
('Notebook', 3500.00),
('Smartphone', 1200.00),
('Monitor', 800.00),
('Teclado', 150.00),
('Mouse', 50.00),
('Impressora', 600.00),
('Cadeira Gamer', 900.00),
('Tablet', 800.00),
('Fone de Ouvido', 200.00),
('Carregador Portátil', 100.00),
('Caixa de Som', 300.00),
('Headset Gamer', 250.00),
('Webcam', 180.00),
('Microfone', 350.00),
('HD Externo', 400.00),
('SSD 1TB', 550.00),
('Pendrive 64GB', 70.00),
('Roteador Wi-Fi', 220.00),
('Teclado Mecânico', 450.00),
('Cabo HDMI', 40.00);

-- Criar índices nas tabelas
CREATE INDEX idx_codigo_cliente ON pedidos(codigo_cliente);
CREATE INDEX idx_numero_pedido_produtos ON pedido_produtos(numero_pedido);
CREATE INDEX idx_codigo_produto ON pedido_produtos(codigo_produto);

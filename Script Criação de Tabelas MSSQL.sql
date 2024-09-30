-- Criar o banco de dados
CREATE DATABASE testewk;
GO

USE testewk;
GO

-- Iniciar transação
BEGIN TRANSACTION;

-- Criar tabela de produtos
CREATE TABLE tab_produto (
   cod_produto INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
   des_descricao VARCHAR(100),
   val_preco FLOAT
);
GO

-- Inserir dados na tabela de produtos
INSERT INTO tab_produto (des_descricao, val_preco) VALUES ('HD EXTERNO SEAGATE 1 TB', 760);
INSERT INTO tab_produto (des_descricao, val_preco) VALUES ('PEN DRIVE 16 GB', 22);
GO

-- Criar tabela de clientes
CREATE TABLE tab_cliente (
   cod_cliente INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
   des_nomecliente VARCHAR(100),
   des_cidade VARCHAR(100),
   des_uf VARCHAR(2)
);
GO

-- Inserir dados na tabela de clientes
INSERT INTO tab_cliente (des_nomecliente, des_cidade, des_uf) VALUES ('ALVARO VIEIRA', 'BELO HORIZONTE', 'MG');
INSERT INTO tab_cliente (des_nomecliente, des_cidade, des_uf) VALUES ('JOICE AMORIM', 'NOVA LIMA', 'MG');
GO

-- Criar tabela de vendas
CREATE TABLE tab_venda (
   cod_venda INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
   dta_venda DATE,
   cod_cliente INT NOT NULL,
   val_venda FLOAT,
   FOREIGN KEY (cod_cliente) REFERENCES tab_cliente (cod_cliente)
);
GO

-- Inserir dados na tabela de vendas
INSERT INTO tab_venda (dta_venda, cod_cliente, val_venda) VALUES ('2024-01-01', 1, 760);
INSERT INTO tab_venda (dta_venda, cod_cliente, val_venda) VALUES ('2024-01-01', 2, 44);
GO

-- Criar tabela de itens da venda
CREATE TABLE tab_venda_item (
   id_venda INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
   cod_venda INT NOT NULL,
   cod_produto INT NOT NULL,
   val_quantidade INT NOT NULL,
   val_precounitario FLOAT,
   val_totalitem FLOAT,
   FOREIGN KEY (cod_venda) REFERENCES tab_venda (cod_venda),
   FOREIGN KEY (cod_produto) REFERENCES tab_produto (cod_produto)
);
GO

-- Inserir dados na tabela de itens da venda
INSERT INTO tab_venda_item (cod_venda, cod_produto, val_quantidade, val_precounitario, val_totalitem) VALUES (1, 1, 1, 760, 760);
INSERT INTO tab_venda_item (cod_venda, cod_produto, val_quantidade, val_precounitario, val_totalitem) VALUES (2, 2, 2, 22, 44);
GO

-- Confirmar a transação
COMMIT TRANSACTION;
GO

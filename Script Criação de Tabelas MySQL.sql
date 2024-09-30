-- Criar o banco de dados
CREATE DATABASE IF NOT EXISTS testewk;
USE testewk;

-- Iniciar transação
START TRANSACTION;

-- Criar tabela de produtos
CREATE TABLE IF NOT EXISTS tab_produto (
   cod_produto INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
   des_descricao VARCHAR(100),
   val_preco DOUBLE
);

-- Inserir dados na tabela de produtos
INSERT INTO tab_produto (des_descricao, val_preco) VALUES ('HD EXTERNO SEAGATE 1 TB', 760);
INSERT INTO tab_produto (des_descricao, val_preco) VALUES ('PEN DRIVE 16 GB', 22);

-- Criar tabela de clientes
CREATE TABLE IF NOT EXISTS tab_cliente (
   cod_cliente INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
   des_nomecliente VARCHAR(100),
   des_cidade VARCHAR(100),
   des_uf VARCHAR(2)
);

-- Inserir dados na tabela de clientes
INSERT INTO tab_cliente (des_nomecliente, des_cidade, des_uf) VALUES ('ALVARO VIEIRA', 'BELO HORIZONTE', 'MG');
INSERT INTO tab_cliente (des_nomecliente, des_cidade, des_uf) VALUES ('JOICE AMORIM', 'NOVA LIMA', 'MG');

-- Criar tabela de vendas
CREATE TABLE IF NOT EXISTS tab_venda (
   cod_venda INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
   dta_venda DATE,
   cod_cliente INT NOT NULL,
   val_venda DOUBLE,
   CONSTRAINT fk_cod_cliente FOREIGN KEY (cod_cliente) REFERENCES tab_cliente(cod_cliente)
);

-- Inserir dados na tabela de vendas
INSERT INTO tab_venda (dta_venda, cod_cliente, val_venda) VALUES ('2024-01-01', 1, 760);
INSERT INTO tab_venda (dta_venda, cod_cliente, val_venda) VALUES ('2024-01-01', 2, 44);

-- Criar tabela de itens da venda
CREATE TABLE IF NOT EXISTS tab_venda_item (
   id_venda INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
   cod_venda INT NOT NULL,
   cod_produto INT NOT NULL,
   val_quantidade INT NOT NULL,
   val_precounitario DOUBLE,
   val_totalitem DOUBLE,
   CONSTRAINT fk_cod_venda FOREIGN KEY (cod_venda) REFERENCES tab_venda(cod_venda),
   CONSTRAINT fk_cod_produto FOREIGN KEY (cod_produto) REFERENCES tab_produto(cod_produto)
);

-- Inserir dados na tabela de itens da venda
INSERT INTO tab_venda_item (cod_venda, cod_produto, val_quantidade, val_precounitario, val_totalitem) 
VALUES (1, 1, 1, 760, 760);
INSERT INTO tab_venda_item (cod_venda, cod_produto, val_quantidade, val_precounitario, val_totalitem) 
VALUES (2, 2, 2, 22, 44);

-- Confirmar a transação
COMMIT;

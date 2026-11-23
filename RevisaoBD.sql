/*
Pede-se:
1. Consultar a quantidade, valor total e valor total com desconto (25%) dos itens
comprados par Maria Clara.
2. Consultar quais brinquedos não tem itens em estoque.
3. Consultar quais nome e descrições de produtos que não estão em pedidos
4. Alterar a quantidade em estoque do faqueiro para 10 peças.
5. Consultar Quantos clientes tem mais de 40 anos.
6. Consultar Nome e telefone (Formatado XXXX-XXXX) dos fornecedores de Brinquedos e Chocolate.
7. Consultar nome e desconto de 25% no preço dos produtos que custam menos de R$50,00
8. Consultar nome e aumento de 10% no preço dos produtos que custam mais de R$100,00
9. Consultar desconto de 15% no valor total de cada produto da venda 99001.
10. Consultar Código do pedido, nome do cliente e idade atual do cliente
11. Consultar o nome do fornecedor do produto mais caro
12. Consultar a média dos valores cujos produtos ainda estão em estoque
13. Consultar o nome do cliente, endereço composto por logradouro e número, o valor
unitário do produto, o valor total (Quantidade * valor unitario) da compra do cliente
de nome Maria Clara
14. Considerando que o pedido de Maria Clara foi entregue 15/03/2023, consultar
quantos dias houve de atraso. A cláusula do WHERE deve ser o nome da cliente.
15. Consultar qual a nova data de entrega para o pedido de Alberto% sabendo que se
pediu 9 dias a mais. A cláusula do WHERE deve ser o nome do cliente. A data deve ser
exibida no formato dd/mm/aaaa.
*/

CREATE TABLE fornecedor (
codigo		INT				NOT NULL,
nome		VARCHAR(50)		NOT NULL,
atividade	VARCHAR(80)		NOT NULL,
telefone	CHAR(8)			NOT NULL
PRIMARY KEY(codigo)
)
GO

CREATE TABLE cliente (
codigo		INT				NOT NULL,
nome		VARCHAR(50)		NOT NULL,
logradouro	VARCHAR(80)		NOT NULL,
numero		INT				NOT NULL,
telefone	CHAR(8)			NOT NULL,
data_nasc	DATE			NOT NULL
PRIMARY KEY(codigo)
)
GO

CREATE TABLE produto (
codigo			INT				NOT NULL,
nome			VARCHAR(50)		NOT NULL,
valor_unitario	DECIMAL(7,2)	NOT NULL,
qtd_estoque		INT				NOT NULL,
descricao		VARCHAR(80)		NOT NULL,
cod_forn		INT				NOT NULL
PRIMARY KEY(codigo)
FOREIGN KEY(cod_forn) REFERENCES fornecedor (codigo)
)
GO

CREATE TABLE pedido (
codigo			INT		NOT NULL,
cod_cli			INT		NOT NULL,
cod_prod		INT		NOT NULL,
quantidade		INT		NOT NULL,
previsao_ent	DATE	NOT NULL
PRIMARY KEY(codigo, cod_cli, cod_prod, previsao_ent)
FOREIGN KEY(cod_cli) REFERENCES cliente (codigo),
FOREIGN KEY(cod_prod) REFERENCES produto(codigo)
)
GO

INSERT INTO fornecedor VALUES (1001, 'Estrela', 'Brinquedo', '41525898')
INSERT INTO fornecedor VALUES (1002, 'Lacta', 'Chocolate', '42698596')
INSERT INTO fornecedor VALUES (1003, 'Asus', 'Informática', '52014596')
INSERT INTO fornecedor VALUES (1004, 'Tramontina', 'Utensílios Domésticos', '50563985')
INSERT INTO fornecedor VALUES (1005, 'Grow', 'Brinquedos', '47896325')
INSERT INTO fornecedor VALUES (1006, 'Mattel', 'Bonecos', '59865898')

INSERT INTO cliente VALUES (33601, 'Maria Clara', 'R. 1º de Abril', 870, '96325874', CAST (N'2000-08-15' AS DATE))
INSERT INTO cliente VALUES (33602, 'Alberto Souza', 'R. XV de Novembro', 987, '95873625', CAST (N'1985-02-02' AS DATE))
INSERT INTO cliente VALUES (33603, 'Sonia Silva', 'R. Voluntários da Pátria', 1151, '75418596', CAST (N'1957-08-23' AS DATE))
INSERT INTO cliente VALUES (33604, 'José Sobrinho', 'Av. Paulista', 250, '85236547', CAST (N'1986-12-09' AS DATE))
INSERT INTO cliente VALUES (33605, 'Carlos Camargo', 'Av. Tiquatira', 9652, '75896325', CAST (N'1971-03-25' AS DATE))

INSERT INTO produto VALUES (1, 'Banco Imobiliário', 65.00, 15, 'Versão Super Luxo', 1001)
INSERT INTO produto VALUES (2, 'Puzzle 5000 peças', 50.00, 5, 'Mapas Mundo', 1005)
INSERT INTO produto VALUES (3, 'Faqueiro', 350.00, 0, '120 peças', 1004)
INSERT INTO produto VALUES (4, 'Jogo para churrasco', 75.00, 3, '7 peças', 1004)
INSERT INTO produto VALUES (5, 'Tablet', 750.00, 29, 'Tablet', 1003)
INSERT INTO produto VALUES (6, 'Detetive', 49.00, 0, 'Nova Versão do Jogo', 1001)
INSERT INTO produto VALUES (7, 'Chocolate com Paçoquinha', 6.00, 0, 'Barra', 1002)
INSERT INTO produto VALUES (8, 'Galak', 5.00, 65, 'Barra', 1002)

INSERT INTO pedido VALUES (99001, 33601, 1, 1, CAST (N'2026-09-07' AS DATE))
INSERT INTO pedido VALUES (99001, 33601, 2, 1, CAST (N'2026-09-07' AS DATE))
INSERT INTO pedido VALUES (99001, 33601, 8, 3, CAST (N'2026-09-09' AS DATE))
INSERT INTO pedido VALUES (99002, 33602, 2, 1, CAST (N'2026-09-09' AS DATE))
INSERT INTO pedido VALUES (99002, 33602, 4, 3, CAST (N'2026-09-09' AS DATE))
INSERT INTO pedido VALUES (99003, 33605, 5, 1, CAST (N'2026-09-15' AS DATE))
GO

SELECT * FROM fornecedor
SELECT * FROM cliente
SELECT * FROM produto
SELECT * FROM pedido


-- 1. Consultar a quantidade, valor total e valor total com desconto (25%) dos itens comprados por Maria Clara. (INNER JOIN)
SELECT ped.quantidade, -- Selecionando a quantidade (ped -> Alias)
	-- Selecionando os preços e calculando valor total e valor com descontos (Usando alias)
	CAST(valor_unitario * quantidade AS DECIMAL(7,2)) AS valor_total,
	CAST(valor_unitario * quantidade * 0.75 AS DECIMAL(7,2)) AS valor_desconto
FROM cliente cli INNER JOIN pedido ped -- Juntando as tabelas
ON cli.codigo = ped.cod_cli -- Onde o código do cliente bater com o código do cliente-pedido
INNER JOIN produto prod -- Juntando com a tabela produto
ON prod.codigo = ped.cod_prod -- Onde o código do produto bater com o código produto-pedido
WHERE cli.nome = 'Maria Clara'


-- 2. Consultar quais brinquedos não tem itens em estoque. (INNER JOIN)
SELECT prod.nome,
	   prod.qtd_estoque
FROM produto prod INNER JOIN fornecedor forn -- Juntando as tabelas e criando os alias
ON forn.codigo = prod.cod_forn -- Onde o código do fornecedor bate com a foreign key(codigo fornecedor) de produto
-- Filtros
WHERE forn.atividade LIKE 'Brinquedo%'
	AND prod.qtd_estoque = 0


-- 3. Consultar quais nome e descrições de produtos que não estão em pedidos (OUTER JOIN)
SELECT prod.nome,
	   prod.descricao
FROM produto prod LEFT OUTER JOIN pedido ped -- Juntando as tabelas e deixando os produtos à esquerda
ON prod.codigo = ped.cod_prod -- Relacionando
WHERE ped.cod_prod IS NULL -- Verificando onde é nulo


-- 4. Alterar a quantidade em estoque do faqueiro para 10 peças.
UPDATE produto
SET qtd_estoque = 10
WHERE nome = 'Faqueiro'


-- 5. Consultar Quantos clientes tem mais de 40 anos.
SELECT COUNT(codigo) AS qnt_cliente -- Contabilizando a quant. de cliente 40+ a partir do codigo
FROM cliente 
WHERE DATEDIFF(YEAR, data_nasc, GETDATE()) > 40 -- Verificando quais tem mais de 40 anos


-- 6. Consultar Nome e telefone (Formatado XXXX-XXXX) dos fornecedores de Brinquedos e Chocolate.
SELECT	nome,
		SUBSTRING(telefone, 1,4) + '-' + SUBSTRING(telefone, 4,8) AS telefone -- Organizando o telefone no formato XXXX-XXXX
FROM fornecedor
-- Filtros
WHERE atividade LIKE 'Brinquedo%' OR atividade = 'Chocolate'


-- 7. Consultar nome e desconto de 25% no preço dos produtos que custam menos de R$50,00
SELECT	prod.nome, 
		-- Calculando valor do desconto
		CAST(prod.valor_unitario * 0.25 AS DECIMAL(7,2)) AS valor_desconto
FROM produto prod -- Alias
-- Filtro
WHERE prod.valor_unitario < 50.00


-- 8. Consultar nome e aumento de 10% no preço dos produtos que custam mais de R$100,00
SELECT	prod.nome,
		CAST(prod.valor_unitario * 1.10 AS DECIMAL(7,2)) AS preco_novo
FROM produto prod -- Alias
-- Filtro
WHERE prod.valor_unitario > 100.00


-- 9. Consultar desconto de 15% no valor total de cada produto da venda 99001.
SELECT	
	CAST(ped.quantidade * prod.valor_unitario * 0.85 AS DECIMAL(7,2)) AS novo_preco -- Calculando e selecionando o preço com desconto
FROM pedido ped INNER JOIN produto prod -- Alias e junção das tabelas
ON prod.codigo = ped.cod_prod -- Relacionando
-- Filtro
WHERE ped.codigo = 99001


-- 10. Consultar Código do pedido, nome do cliente e idade atual do cliente
SELECT DISTINCT -- Cliente 'Maria Clara' está associada à três pedidos, o DISTINCT vai remover as duplicadas
	   ped.codigo,
	   cli.nome,
	   DATEDIFF(YEAR, cli.data_nasc, GETDATE()) AS idade_atual -- Calculando a idade atual e exibindo
FROM cliente cli INNER JOIN pedido ped -- Alias e junção das tabelas
ON ped.cod_cli = cli.codigo -- Relacionando


-- 11. Consultar o nome do fornecedor do produto mais caro
SELECT 
	forn.nome
FROM fornecedor forn INNER JOIN produto prod -- Alias e junção das tabelas
ON forn.codigo = prod.cod_forn -- Relacioando
-- Subquery, consultando o produto mais caro
WHERE prod.valor_unitario = ( -- Verificando se o produto se encaixa no filtro
	-- Selecionando o mais caro
	SELECT MAX(valor_unitario)
	FROM produto
)


-- 12. Consultar a média dos valores cujos produtos ainda estão em estoque
SELECT 
	CAST(AVG(valor_unitario) AS DECIMAL(7,2)) AS media -- Calculando a média
FROM produto
-- Filtro (verificando se tá no estoque)
WHERE qtd_estoque > 0


/* 13. Consultar o nome do cliente, endereço composto por logradouro e número, o valor unitário do produto, 
o valor total (Quantidade * valor unitario) da compra do cliente de nome Maria Clara */
SELECT	cli.nome,
		cli.logradouro + ',' + CAST(cli.numero AS VARCHAR(10)) AS endereco, -- Concatenando logradouro com número, convertendo número p/ varchar. Criando endereco completo a partir disso
		prod.valor_unitario,
		CAST(valor_unitario * ped.quantidade AS DECIMAL(7,2)) AS valor_total
FROM pedido ped INNER JOIN produto prod -- Alias e junção das tabelas pedido e produto
ON prod.codigo = ped.cod_prod -- Relacionando produto com pedido
INNER JOIN cliente cli -- Alias e junção da tabela cliente com as outras
ON cli.codigo = ped.cod_cli -- Relacionando cliente com pedido
-- Filtro
WHERE cli.nome = 'Maria Clara'


/* 14. Considerando que o pedido de Maria Clara foi entregue 15/03/2023, consultar quantos dias houve de atraso. 
A cláusula do WHERE deve ser o nome da cliente. */
SELECT DISTINCT -- Maria Clara tem muitos pedidos
		DATEDIFF(DAY, ped.previsao_ent, '2023-03-15') AS dias_atraso -- Verificando quantos dias de atraso houve
FROM pedido ped INNER JOIN cliente cli -- Alias e junção das tabelas
ON ped.cod_cli = cli.codigo -- Relacionando
-- Filtro
WHERE cli.nome = 'Maria Clara'


/* 15. Consultar qual a nova data de entrega para o pedido de Alberto% sabendo que se pediu 9 dias a mais. 
A cláusula do WHERE deve ser o nome do cliente. A data deve ser exibida no formato dd/mm/aaaa. */
SELECT 
		CONVERT(VARCHAR(10), DATEADD(DAY, 9,  ped.previsao_ent), 103) AS nova_previsao_ent -- Calculando a data nova e convertendo pra varchar no formato dd/mm/aaaa
FROM pedido ped INNER JOIN cliente cli -- Alias e junção das tabelas
ON ped.cod_cli = cli.codigo -- Relacionando
-- Filtro
WHERE cli.nome LIKE 'Alberto%'

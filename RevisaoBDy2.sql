/*
1) Consultar nome, valor unitário, nome da editora e nome do autor dos livros do
estoque que foram vendidos. Não pode haver repetições.
2) Consultar nome do livro, quantidade comprada e valor de compra da compra 15051
3) Consultar Nome do livro e site da editora dos livros da Makron books (Caso o site
tenha mais de 10 dígitos, remover o www.).
4) Consultar nome do livro e Breve Biografia do David Halliday
5) Consultar código de compra e quantidade comprada do livro Sistemas Operacionais
Modernos
6) Consultar quais livros não foram vendidos
7) Consultar quais livros foram vendidos e não estão cadastrados. Caso o nome dos
livros termine com espaço, fazer o trim apropriado.
8) Consultar Nome e site da editora que não tem Livros no estoque (Caso o site tenha
mais de 10 dígitos, remover o www.)
9) Consultar Nome e biografia do autor que não tem Livros no estoque (Caso a
biografia inicie com Doutorado, substituir por Ph.D.)
10) Consultar o nome do Autor, e o maior valor de Livro no estoque. Ordenar por valor
descendente
11) Consultar o código da compra, o total de livros comprados e a soma dos valores
gastos. Ordenar por Código da Compra ascendente.
12) Consultar o nome da editora e a média de preços dos livros em estoque. Ordenar
pela Média de Valores ascendente.
13) Consultar o nome do Livro, a quantidade em estoque o nome da editora, o site da
editora (Caso o site tenha mais de 10 dígitos, remover o www.), criar uma coluna
status onde:
	Caso tenha menos de 5 livros em estoque, escrever Produto em Ponto de Pedido
	Caso tenha entre 5 e 10 livros em estoque, escrever Produto Acabando
	Caso tenha mais de 10 livros em estoque, escrever Estoque Suficiente
	A Ordenação deve ser por Quantidade ascendente
14) Para montar um relatório, é necessário montar uma consulta com a seguinte saída:
Código do Livro, Nome do Livro, Nome do Autor, Info Editora (Nome da Editora + Site)
de todos os livros
Só pode concatenar sites que não são nulos
15) Consultar Codigo da compra, quantos dias da compra até hoje e quantos meses da
compra até hoje
16) Consultar o código da compra e a soma dos valores gastos das compras que somam
mais de 200.00
*/

CREATE DATABASE ex9
GO
USE ex9
GO

CREATE TABLE editora (
	codigo	INT				NOT NULL,
	nome	VARCHAR(30)		NOT NULL,
	site	VARCHAR(40)		NULL,
	PRIMARY KEY (codigo)
)
GO

CREATE TABLE autor (
	codigo		INT				NOT NULL,
	nome		VARCHAR(30)		NOT NULL,
	biografia	VARCHAR(100)	NOT NULL,
	PRIMARY KEY (codigo)
)
GO

CREATE TABLE estoque (
	codigo		INT				NOT NULL,
	nome		VARCHAR(100)	NOT NULL UNIQUE,
	quantidade	INT				NOT NULL,
	valor		DECIMAL(7,2)	NOT NULL CHECK (valor > 0.00),
	codEditora	INT				NOT NULL,
	codAutor	INT				NOT NULL,
	PRIMARY KEY (codigo),
	FOREIGN KEY (codEditora) REFERENCES editora (codigo),
	FOREIGN KEY (codAutor) REFERENCES autor (codigo)
)
GO

CREATE TABLE compra (
	codigo		INT				NOT NULL,
	codEstoque	INT				NOT NULL,
	qtdComprada	INT				NOT NULL,
	valor		DECIMAL(7,2)	NOT NULL,
	dataCompra	DATE			NOT NULL,
	PRIMARY KEY (codigo, codEstoque, dataCompra),
	FOREIGN KEY (codEstoque) REFERENCES estoque (codigo)
)
GO

INSERT INTO editora VALUES
(1, 'Pearson', 'www.pearson.com.br'),
(2, 'Civilização Brasileira', NULL),
(3, 'Makron Books', 'www.mbooks.com.br'),
(4, 'LTC', 'www.ltceditora.com.br'),
(5, 'Atual', 'www.atualeditora.com.br'),
(6, 'Moderna', 'www.moderna.com.br')
GO

INSERT INTO autor VALUES
(101, 'Andrew Tannenbaun', 'Desenvolvedor do Minix'),
(102, 'Fernando Henrique Cardoso', 'Ex-Presidente do Brasil'),
(103, 'Diva Marilia Flemming', 'Professora adjunta da UFSC'),
(104, 'David Halliday', 'Ph.D. da University of Pittsburgh'),
(105, 'Alfredo Steinbruch', 'Professor de Matematica da UFRS e da PUCRS'),
(106, 'Willian Roberto Cereja', 'Doutorado em Linguistica Aplicada e Estudos da Linguagem'),
(107, 'William Stallings', 'Doutorado em Ciencias da Computacão pelo MIT'),
(108, 'Carlos Morimoto', 'Criador do Kurumin Linux')
GO

INSERT INTO estoque VALUES
(10001, 'Sistemas Operacionais Modernos', 4, 108.00, 1, 101),
(10002, 'A Arte da Política', 2, 55.00, 2, 102),
(10003, 'Calculo A', 12, 79.00, 3, 103),
(10004, 'Fundamentos de Fisica I', 26, 68.00, 4, 104),
(10005, 'Geometria Analitica', 1, 95.00, 3, 105),
(10006, 'Gramática Reflexiva', 10, 49.00, 5, 106),
(10007, 'Fundamentos de Fisica III', 1, 78.00, 4, 104),
(10008, 'Calculo B', 3, 95.00, 3, 103)
GO

INSERT INTO compra VALUES
(15051, 10003, 2, 158.00, CAST(N'2026-07-04' AS DATE)),
(15051, 10008, 1, 95.00, CAST(N'2026-07-04' AS DATE)),
(15051, 10004, 1, 68.00, CAST(N'2026-07-04' AS DATE)),
(15051, 10007, 1, 78.00, CAST(N'2026-07-04' AS DATE)),
(15052, 10006, 1, 49.00, CAST(N'2026-07-05' AS DATE)),
(15052, 10002, 3, 165.00, CAST(N'2026-07-05' AS DATE)),
(15053, 10001, 1, 108.00, CAST(N'2026-07-05' AS DATE)),
(15054, 10003, 1, 79.00, CAST(N'2026-08-06' AS DATE)),
(15054, 10008, 1, 95.00, CAST(N'2026-08-06' AS DATE))
GO

/* 1) Consultar nome, valor unitário, nome da editora e nome do autor dos livros do
estoque que foram vendidos. Não pode haver repetições. */
SELECT DISTINCT 
	est.nome AS livro,
	est.valor AS preco,
	edi.nome AS editora,
	au.nome AS autor
FROM estoque est INNER JOIN editora edi -- Alias e junção das tabelas estoque e editora
ON est.codEditora = edi.codigo -- Relacionando
INNER JOIN autor au  -- Alias e junção de autor às outras tabelas
ON au.codigo = est.codAutor -- Relacionando
INNER JOIN compra cmp -- Alias e junção de compra às outras tabelas
ON cmp.codEstoque = est.codigo -- Relacionando


-- 2) Consultar nome do livro, quantidade comprada e valor de compra da compra 15051
SELECT 
	-- Dados da consulta
	estq.nome AS Livro,
	cmp.qtdComprada AS Quantidade,
	cmp.valor AS Preco
FROM estoque estq INNER JOIN compra cmp -- Alias e junção das tabelas estoque e compra
ON estq.codigo = cmp.codEstoque
-- Filtro
WHERE cmp.codigo = 15051


/* 3) Consultar Nome do livro e site da editora dos livros da Makron books (Caso o site
tenha mais de 10 dígitos, remover o www.). */
SELECT
	-- Dados da consulta
	estq.nome AS Livro,
	-- Verificando quant. de caracteres
	CASE
		-- se
		WHEN LEN(edt.site) > 10
			-- faça
			THEN
				SUBSTRING(edt.site,5, LEN(edt.site))
			-- senão
			ELSE 
				edt.site
		END AS Site
FROM estoque estq INNER JOIN editora edt
ON estq.codEditora = edt.codigo
WHERE edt.nome = 'Makron Books'


-- 4) Consultar nome do livro e Breve Biografia do David Halliday
SELECT
	estq.nome AS Nome,
	au.biografia AS Biografia
FROM estoque estq INNER JOIN autor au
ON estq.codAutor = au.codigo
WHERE au.nome = 'David Halliday'


-- 5) Consultar código de compra e quantidade comprada do livro Sistemas Operacionais
SELECT
	cmp.codigo AS Codigo_Compra,
	cmp.qtdComprada AS Quantidade
FROM compra cmp INNER JOIN estoque estq -- Alias e junção das tabelas compra e estoque
ON cmp.codEstoque = estq.codigo -- Relacionando as tabelas
-- Filtro
WHERE estq.nome = 'Sistemas Operacionais Modernos'


-- 6) Consultar quais livros não foram vendidos
SELECT 
	estq.nome AS Livro
FROM estoque estq LEFT OUTER JOIN compra cmp -- Alias e Juntando as tabelas estoque e compra, deixando estoque à esquerda
ON estq.codigo = cmp.codEstoque -- Relacionando as tabelas
-- Filtro
WHERE cmp.codEstoque IS NULL -- Verificando onde é nulo


/* 7) Consultar quais livros foram vendidos e não estão cadastrados. Caso o nome dos livros termine com espaço,
fazer o trim apropriado. */
SELECT
	RTRIM(estq.nome) AS Livro
FROM compra cmp LEFT OUTER JOIN estoque estq -- Alias e junção das tabelas, deixando compra à esquerda
ON cmp.codEstoque = estq.codigo
-- Filtro
WHERE estq.codigo IS NULL -- Verificando onde é nulo

/* 8) Consultar Nome e site da editora que não tem Livros no estoque (Caso o site tenha
mais de 10 dígitos, remover o www.) */
SELECT
	edt.nome AS Editora,
	-- Verificando a quant. de caracteres
	CASE
	-- se
	WHEN LEN(edt.site) >10
		-- faça
		THEN 
			SUBSTRING(edt.site, 5, LEN(edt.site))
		-- senão
		ELSE
			edt.site
		END AS Site
FROM editora edt LEFT OUTER JOIN estoque estq -- Alias e junção das tabelas, deixando editora à esquerda
ON edt.codigo = estq.codEditora -- Relacionando as tabelas
-- Filtro
WHERE 
	estq.codEditora IS NULL -- Verificando onde é nulo


/* 9) Consultar Nome e biografia do autor que não tem Livros no estoque (Caso a
biografia inicie com Doutorado, substituir por Ph.D.) */
SELECT
	au.nome AS Nome,
	-- Verificando se a biografia começa com doutorado
	CASE
		-- se
		WHEN SUBSTRING(au.biografia, 1,9) = 'Doutorado'
			-- faça
			THEN 
				'Ph.D.' + SUBSTRING(au.biografia, 10, LEN(au.biografia))
		-- senão
		ELSE au.biografia
	END AS Biografia
FROM autor au LEFT OUTER JOIN estoque estq -- Alias e junção das tabelas, deixando autor à esquerda
ON au.codigo = estq.codAutor -- Relacionando
-- Filtro
WHERE
	estq.codAutor IS NULL -- Verificando se é nulo


-- 10) Consultar o nome do Autor, e o maior valor de Livro no estoque. Ordenar por valor descendente
SELECT
	au.nome AS Autor,
	MAX(estq.valor) AS Maior_Preco
FROM autor au INNER JOIN estoque estq -- Alias e junção das tabelas
ON au.codigo = estq.codAutor -- Relacionando
GROUP BY -- Agrupando por autor
	au.nome
ORDER BY -- Ordenando por preço
	Maior_Preco DESC


/* 11) Consultar o código da compra, o total de livros comprados e a soma dos valores gastos. 
Ordenar por Código da Compra ascendente. */
SELECT
	-- Dados a serem exibidos
	codigo AS Codigo,
	SUM(qtdComprada) AS Total_Livros,
	SUM(valor) AS Valor_Total
FROM compra 
GROUP BY -- Agrupando por codigo
	codigo
ORDER BY -- Ordenando por codigo
	codigo ASC


/* 12) Consultar o nome da editora e a média de preços dos livros em estoque. 
Ordenar pela Média de Valores ascendente. */
SELECT
	-- Dados a serem exibidos
	edt.nome AS Editora,
	AVG(estq.valor) AS Media -- Calculando a média de preço dos livros
FROM editora edt INNER JOIN estoque estq -- Alias e junção das tabelas
ON edt.codigo = estq.codEditora -- Relacionando
GROUP BY -- Agrupando pelo nome da editora
	edt.nome
ORDER BY -- Ordenando pela media
	Media ASC


/* 13) Consultar o nome do Livro, a quantidade em estoque o nome da editora, o site da
editora (Caso o site tenha mais de 10 dígitos, remover o www.), criar uma coluna
status onde:
	Caso tenha menos de 5 livros em estoque, escrever Produto em Ponto de Pedido
	Caso tenha entre 5 e 10 livros em estoque, escrever Produto Acabando
	Caso tenha mais de 10 livros em estoque, escrever Estoque Suficiente
	A Ordenação deve ser por Quantidade ascendente */
SELECT
	-- Dados a serem exibidos
	estq.nome AS Livro,
	estq.quantidade AS Quantidade,
	edt.nome AS Editora,

	-- Verificando a quant. de caracteres
	CASE
		-- se
		WHEN LEN(edt.site) > 10 THEN SUBSTRING(edt.site, 5, LEN(edt.site))
		-- senao
		ELSE edt.site
	END AS Site,

	-- Verificando o status do livro no estoque
	CASE
		-- se
		WHEN estq.quantidade < 5 THEN 'Produto em Ponto de Pedido'
		-- se
		WHEN estq.quantidade BETWEEN 5 AND 10 THEN 'Produto Acabando'
		-- senão
		ELSE 'Estoque Suficiente'
	END AS Status
FROM estoque estq INNER JOIN editora edt -- Alias e junção das tabelas
ON estq.codEditora = edt.codigo -- Relacionando
ORDER BY -- Ordenando por quantidade
	Quantidade ASC


/* 14) Para montar um relatório, é necessário montar uma consulta com a seguinte saída:
Código do Livro, Nome do Livro, Nome do Autor, Info Editora (Nome da Editora + Site)
de todos os livros */
SELECT
	estq.codigo AS Codigo_Livro,
	estq.nome AS Livro,
	au.nome AS Autor,
	'Nome: ' + edt.nome + ' - Site: ' + edt.site AS Info_Editora 
FROM estoque estq INNER JOIN autor au -- Alias e junção da tabela estoque com autor
ON estq.codAutor = au.codigo -- Relacionando estoque e autor
INNER JOIN editora edt -- Alias e junção de editora às outras tabelas
ON edt.codigo = estq.codEditora -- Relacionando estoque com editora


-- 15) Consultar Codigo da compra, quantos dias da compra até hoje e quantos meses da compra até hoje
SELECT
	codigo,
	DATEDIFF(DAY, dataCompra, GETDATE()) AS quant_dias,
	DATEDIFF(MONTH, dataCompra, GETDATE()) AS quant_meses
FROM compra 


-- 16) Consultar o código da compra e a soma dos valores gastos das compras que somam mais de 200.00 
SELECT
	codigo,
	SUM(valor)
FROM compra 
GROUP BY codigo
	HAVING SUM(valor) > 200

CREATE DATABASE locadora
GO
USE locadora

CREATE TABLE cliente(
num_cadastro      INT                                   NOT NULL,
nome              VARCHAR(70)                           NOT NULL,
logradouro        VARCHAR(150)                          NOT NULL,
num               INT          CHECK(num > 0)           NOT NULL,
cep               CHAR(8)      CHECK(LEN(cep) = 8)	    NULL
PRIMARY KEY (num_cadastro)
)

CREATE TABLE locacao(
dvdnum                   INT                                                 NOT NULL,
clientenum_cadastro      INT                                                 NOT NULL,
data_locacao             DATETIME       CHECK(data_locacao < GETDATE())      NOT NULL,
data_devolucao           DATETIME       CHECK(data_devolucao < GETDATE()) NOT NULL,
valor                    DECIMAL(7, 2)  CHECK(valor > 0)                     NOT NULL
PRIMARY KEY (dvdnum, clientenum_cadastro, data_locacao)
)

CREATE TABLE filme(
id                  INT                                     NOT NULL,
titulo              VARCHAR(40)                             NOT NULL,
ano                 INT         CHECK(ano <= 2021)          NULL
PRIMARY KEY (id)
)

ALTER TABLE filme
ALTER COLUMN titulo VARCHAR(80) NOT NULL

CREATE TABLE dvd(
num                      INT                                                 NOT NULL,
data_fabricacao          DATETIME     CHECK(data_fabricacao < GETDATE())     NOT NULL,
filmeid                  INT                                                 NOT NULL
PRIMARY KEY (num)
FOREIGN KEY (filmeid) REFERENCES filme (id)
)

CREATE TABLE estrela(
id              INT          NOT NULL,
nome            VARCHAR(50)  NOT NULL,
nome_real       VARCHAR(50)  NULL
PRIMARY KEY (id)
)

CREATE TABLE filme_estrela(
filmeid         INT          NOT NULL,
estrelaid       INT          NOT NULL
PRIMARY KEY (filmeid, estrelaid)
)

SELECT * FROM filme
SELECT * FROM estrela
SELECT * FROM filme_estrela
SELECT * FROM dvd
SELECT * FROM cliente
SELECT * FROM locacao

INSERT INTO filme (id, titulo, ano) VALUES
('1001', 'Whiplash', '2015'),
('1002', 'Birdman', '2015'),
('1003', 'Interestelar', '2014'),
('1004', 'A Culpa é das estrelas', '2014'),
('1005', 'Alexandre e o Dia Terrível, Horrível, Espantoso e Horroroso', '2014'),
('1006', 'Sing', '2016')

INSERT INTO estrela (id, nome, nome_real) VALUES
('9901', 'Michael Keaton', 'Michael John Douglas'),
('9902', 'Emma Stone', 'Emily Jean Stone'),
('9903', 'Miles Teller', NULL),
('9904', 'Steve Carell', 'Steven John Carell'),
('9905', 'Jennifer Garner', 'Jennifer Anne Garner')

INSERT INTO filme_estrela VALUES
('1002', '9901'),
('1002', '9902'),
('1001', '9903'),
('1005', '9904'),
('1005', '9905')

INSERT INTO dvd VALUES
('10001', '02-12-2020', '1001'),
('10002', '18-10-2019', '1002'),
('10003', '03-04-2020', '1003'),
('10004', '02-12-2020', '1001'),
('10005', '18-10-2019', '1004'),
('10006', '03-04-2020', '1002'),
('10007', '02-12-2020', '1005'),
('10008', '18-10-2019', '1002'),
('10009', '03-04-2020', '1003')

INSERT INTO cliente (num_cadastro, nome, logradouro, num, cep) VALUES
('5501', 'Matilde Luz', 'Rua Síria', '150', '03086040'),
('5502', 'Carlos Carreiro', 'Rua Bartolomeu Aires', '1250', '04419110'),
('5503', 'Daniel Ramalho', 'Rua Itajutiba', '169', NULL),
('5504', 'Roberta Bento', 'Rua Jayme Von Rosenburg', '36', NULL),
('5505', 'Rosa Cerqueira', 'Rua Arnaldo Simões Pinto', '235', '02917110')

INSERT INTO locacao (dvdnum, clientenum_cadastro, data_locacao, data_devolucao, valor) VALUES
('10001', '5502', '18-02-2021', '21-02-2021', '3.50'),
('10009', '5502', '18-02-2021', '21-02-2021', '3.50'),
('10002', '5503', '18-02-2021', '19-02-2021', '3.50'),
('10002', '5505', '20-02-2021', '23-02-2021', '3.00'),
('10004', '5505', '20-02-2021', '23-02-2021', '3.00'),
('10005', '5505', '20-02-2021', '23-02-2021', '3.00'),
('10001', '5501', '24-02-2021', '26-02-2021', '3.50'),
('10008', '5501', '24-02-2021', '26-02-2021', '3.50')

UPDATE cliente
SET cep = '08411150'
WHERE num_cadastro = 5503

UPDATE cliente
SET cep = '02918190'
WHERE num_cadastro = 5504

UPDATE locacao
SET valor = '3.25'
WHERE data_locacao = '18-02-2021' AND clientenum_cadastro = 5502

UPDATE locacao
SET valor = '3.10'
WHERE data_locacao = '24-02-2021' AND clientenum_cadastro = 5501

UPDATE dvd
SET data_fabricacao = '14-07-2019'
WHERE num = '10005'

UPDATE estrela
SET nome_real = 'Miles Alexander Teller'
WHERE id = '9903'

DELETE filme
WHERE titulo = 'Sing'

SELECT titulo 
FROM filme 
WHERE ano = '2014'

SELECT id, ano
FROM filme
WHERE titulo = 'Birdman'

SELECT id, ano
FROM filme
WHERE titulo LIKE '%plash'

SELECT id, nome, nome_real
FROM estrela
WHERE nome LIKE 'Steve%'

SELECT filmeid, convert(char(8), data_fabricacao, 103) as DataFabricacao
FROM dvd
WHERE data_fabricacao > '01-01-2020'

SELECT dvdnum, data_locacao, data_devolucao, valor, CAST(valor + 2.00 AS DECIMAL(7, 2)) AS novo_valor
FROM locacao
WHERE clientenum_cadastro = '5505'

SELECT logradouro, num, cep
FROM cliente
WHERE nome = 'Matilde Luz' 

SELECT nome_real
FROM estrela
WHERE nome = 'Michael Keaton'

SELECT num_cadastro, nome, logradouro + ', ' + CAST(num AS VARCHAR(5)) + ' - CEP: ' + cep AS endereco_completo
FROM cliente
WHERE num_cadastro >= 5503

SELECT id, ano, titulo =
       CASE WHEN LEN(titulo) > 10
	   THEN
	   SUBSTRING(titulo,1,10) + '...'
	   ELSE
	   titulo
	   END
FROM filme
WHERE id IN (
       SELECT filmeid from dvd WHERE data_fabricacao > CONVERT(DATE, '2020-01-01')
)

SELECT num, data_fabricacao, DATEDIFF(MONTH, data_fabricacao, GETDATE()) AS meses_desde_fabricacao
FROM dvd
WHERE filmeid IN (
SELECT id FROM filme WHERE titulo = 'Interestelar'
)

SELECT dvdnum, data_locacao, data_devolucao, DATEDIFF(DAY, data_locacao, data_devolucao) AS dias_alugados, valor
FROM locacao
WHERE clientenum_cadastro IN (
SELECT num_cadastro FROM cliente WHERE nome LIKE '%Rosa%'
)

SELECT nome, logradouro + ' , ' + CAST(num AS VARCHAR(5)) + ' , ' + 
SUBSTRING(cep, 1, 5) + '-' + SUBSTRING(cep, 6, 3) AS Endereco_completo
FROM cliente
WHERE num_cadastro IN (
SELECT clientenum_cadastro FROM locacao WHERE dvdnum = '10002'
)
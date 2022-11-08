CREATE DATABASE projetos

USE projetos

CREATE TABLE users(
id                 INT               IDENTITY(1,1)                 NOT NULL,
name               VARCHAR(45)                                     NOT NULL,
username           VARCHAR(45)                                     NOT NULL,
password           VARCHAR(45)                                     NOT NULL,
email              VARCHAR(45)                                     NOT NULL
PRIMARY KEY (id)
)

ALTER TABLE users
ADD CONSTRAINT username UNIQUE (username)
ALTER TABLE users
ADD CONSTRAINT password DEFAULT '123mudar' FOR password

EXEC sp_help users

CREATE TABLE users_has_projects(
users_id           INT                                             NOT NULL,
projects_id        INT                                             NOT NULL
PRIMARY KEY (users_id, projects_id)
FOREIGN KEY (users_id) REFERENCES users (id),
FOREIGN KEY (projects_id) REFERENCES projects (id)
)

CREATE TABLE projects(
id                 INT                IDENTITY(10001,1)            NOT NULL,
name               VARCHAR(45)                                     NOT NULL,
description        VARCHAR(45)                                     NULL,
date               DATETIME           CHECK(date > '01-09-2014')   NOT NULL
PRIMARY KEY (id)
)

ALTER TABLE users
DROP CONSTRAINT username

ALTER TABLE users
ALTER COLUMN username VARCHAR(10) NOT NULL

ALTER TABLE users
ALTER COLUMN password VARCHAR(8) NOT NULL

SELECT * FROM users
SELECT * FROM projects
SELECT * FROM users_has_projects

INSERT INTO users VALUES
('Maria', 'Rh_maria', 'maria@empresa.com')

INSERT INTO users VALUES
('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com')

INSERT INTO users VALUES
('Ana', 'Rh_ana', 'ana@empresa.com')

INSERT INTO users VALUES
('Clara', 'Ti_clara', 'clara@empresa.com')

INSERT INTO users VALUES
('Aparecido', 'Rh_apareci', '55@!cido', 'aparecido@empresa.com')

INSERT INTO projects VALUES
('Re-folha', 'Refatoração das Folhas', '05-09-2014'),
('Manutenção PC ́s', 'Manutenção PC ́s', '06-09-2014'),
('Auditoria ', NULL, '07-09-2014'),

INSERT INTO users_has_projects VALUES
('1', '10001'),
('5', '10001'),
('3', '10003'),
('4', '10002'),
('2', '10002')

UPDATE projects
SET date = '12-09-2014'
WHERE name = 'Manutenção PC ́s'

UPDATE users
SET username = 'Rh_cido'
WHERE name = 'Aparecido'

UPDATE users
SET password = '888@*'
WHERE username = 'Rh_maria' AND password = '123mudar' 

DELETE users_has_projects
WHERE users_id = 2

SELECT id, name, email, username,
       CASE WHEN password <> '123mudar'
	   THEN	'********'
	   ELSE
	       password
	   END AS password
FROM users

SELECT namee AS nome_projeto, description AS descricao, date AS data
FROM projects
WHERE id IN (
	SELECT projects_id FROM users_has_projects WHERE
	users_id IN (
		SELECT id 
		FROM users 
		WHERE email = 'aparecido@empresa.com'
	)
)

SELECT name AS Nome, email as Email
FROM users
WHERE id IN (
     SELECT users_id FROM users_has_projects WHERE
	 projects_id IN (
	    SELECT id
		FROM projects 
		WHERE namee = 'auditoria'
	)
)

SELECT namee, description, date, DATEDIFF(DAY,date,'2014-09-16') * 79.85 AS valor FROM projects
WHERE namee LIKE '%Manutenção%'

INSERT INTO users (name, username, email) VALUES
('Joao', 'Ti_joao', 'joao@empresa.com')

INSERT INTO projects (namee, description, date) VALUES
('Atualização de Sistemas', 'Modificação de Sistemas Operacionais nos PCs', '12-09-2014')

SELECT u.id AS id_users, u.name AS name_users, u.email AS email_users, p.id AS id_project, 
p.namee AS nome_project, p.description AS descricao, CONVERT(CHAR(08),p.date,103) AS data
FROM users u INNER JOIN users_has_projects uhp 
ON u.id = uhp.users_id INNER JOIN projects p 
ON p.id = uhp.projects_id
WHERE p.namee = 'RE-FOLHA'

SELECT p.namee AS nome_project 
FROM projects p LEFT OUTER JOIN users_has_projects uhp
ON p.id = uhp.users_id 
WHERE uhp.users_id IS NULL

SELECT u.name AS nome_users 
FROM users u LEFT OUTER JOIN users_has_projects uhp
ON u.id = uhp.users_id 
WHERE uhp.users_id IS NULL

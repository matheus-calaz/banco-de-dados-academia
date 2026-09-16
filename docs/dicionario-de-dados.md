# Dicionário de Dados

Este documento descreve as tabelas e os atributos do banco `academia_trabalho`.

## TB_ALUNO

Armazena os dados cadastrais dos alunos.

| Campo | Tipo | Restrições | Descrição |
| --- | --- | --- | --- |
| `num_matricula` | `INT` | PK | Identificador do aluno |
| `nome` | `VARCHAR(100)` | NOT NULL | Nome completo |
| `cpf` | `VARCHAR(14)` | NOT NULL, UNIQUE | CPF formatado |
| `data_nascimento` | `DATE` | NOT NULL | Data de nascimento |
| `telefone` | `VARCHAR(20)` | — | Telefone de contato |
| `email` | `VARCHAR(100)` | NOT NULL, UNIQUE | Endereço de e-mail |
| `data_cadastro` | `DATE` | NOT NULL | Data de entrada no sistema |

## TB_INSTRUTOR

Armazena os profissionais responsáveis por treinos e avaliações.

| Campo | Tipo | Restrições | Descrição |
| --- | --- | --- | --- |
| `cod_instrutor` | `INT` | PK | Identificador do instrutor |
| `nome` | `VARCHAR(100)` | NOT NULL | Nome completo |
| `cpf` | `VARCHAR(14)` | NOT NULL, UNIQUE | CPF formatado |
| `especialidade` | `VARCHAR(50)` | NOT NULL | Área de especialidade |
| `telefone` | `VARCHAR(20)` | — | Telefone de contato |

## TB_PLANO

Define os planos comerciais oferecidos pela academia.

| Campo | Tipo | Restrições | Descrição |
| --- | --- | --- | --- |
| `cod_plano` | `INT` | PK | Identificador do plano |
| `nome` | `VARCHAR(50)` | NOT NULL, UNIQUE | Nome comercial |
| `valor` | `DECIMAL(10,2)` | NOT NULL, CHECK | Valor do plano |
| `duracao` | `INT` | NOT NULL, CHECK | Duração em meses |

## TB_MATRICULA

Registra a contratação de um plano por um aluno e mantém seu histórico.

| Campo | Tipo | Restrições | Descrição |
| --- | --- | --- | --- |
| `num_matricula_aluno` | `INT` | PK, FK | Aluno matriculado |
| `cod_plano` | `INT` | PK, FK | Plano contratado |
| `data_inicio` | `DATE` | PK | Início da vigência |
| `data_fim` | `DATE` | NOT NULL, CHECK | Final da vigência |
| `status` | `VARCHAR(20)` | NOT NULL, CHECK | Situação da matrícula |

## TB_FICHA_TREINO

Representa uma ficha de exercícios elaborada para um aluno.

| Campo | Tipo | Restrições | Descrição |
| --- | --- | --- | --- |
| `cod_ficha` | `INT` | PK | Identificador da ficha |
| `data_criacao` | `DATE` | NOT NULL | Data de elaboração |
| `status` | `VARCHAR(20)` | NOT NULL, CHECK | Situação da ficha |
| `num_matricula_aluno` | `INT` | FK, NOT NULL | Aluno associado |
| `cod_instrutor_resp` | `INT` | FK, NOT NULL | Instrutor responsável |

## TB_EXERCICIO

Mantém o catálogo de exercícios da academia.

| Campo | Tipo | Restrições | Descrição |
| --- | --- | --- | --- |
| `cod_exercicio` | `INT` | PK | Identificador do exercício |
| `descricao` | `VARCHAR(100)` | NOT NULL | Nome do exercício |
| `grupo_muscular` | `VARCHAR(50)` | NOT NULL | Grupo muscular principal |

## TB_ITEM_TREINO

Associa exercícios às fichas de treino e resolve esse relacionamento muitos-para-muitos.

| Campo | Tipo | Restrições | Descrição |
| --- | --- | --- | --- |
| `cod_ficha` | `INT` | PK, FK | Ficha relacionada |
| `cod_exercicio` | `INT` | PK, FK | Exercício relacionado |
| `series` | `INT` | NOT NULL, CHECK | Quantidade de séries |
| `repeticoes` | `INT` | NOT NULL, CHECK | Repetições por série |
| `tempo_descanso` | `INT` | NOT NULL, CHECK | Descanso em segundos |

## TB_AVALIACAO_FISICA

Registra medições físicas realizadas pelos instrutores.

| Campo | Tipo | Restrições | Descrição |
| --- | --- | --- | --- |
| `cod_avaliacao` | `INT` | PK | Identificador da avaliação |
| `data_realizacao` | `DATE` | NOT NULL | Data da avaliação |
| `peso` | `DECIMAL(5,2)` | NOT NULL, CHECK | Peso em quilogramas |
| `altura` | `DECIMAL(3,2)` | NOT NULL, CHECK | Altura em metros |
| `percentual_gordura` | `DECIMAL(4,2)` | NOT NULL, CHECK | Percentual de gordura corporal |
| `num_matricula_aluno` | `INT` | FK, NOT NULL | Aluno avaliado |
| `cod_instrutor_avaliador` | `INT` | FK, NOT NULL | Instrutor responsável |


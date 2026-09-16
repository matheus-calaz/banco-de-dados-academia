-- Banco de Dados para Gestão de Academia
-- Este script recria o schema e todas as suas estruturas.

DROP SCHEMA IF EXISTS academia_trabalho;
CREATE SCHEMA academia_trabalho
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE academia_trabalho;

CREATE TABLE TB_ALUNO (
    num_matricula INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100) NOT NULL UNIQUE,
    data_cadastro DATE NOT NULL
) ENGINE = InnoDB;

CREATE TABLE TB_INSTRUTOR (
    cod_instrutor INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    especialidade VARCHAR(50) NOT NULL,
    telefone VARCHAR(20)
) ENGINE = InnoDB;

CREATE TABLE TB_PLANO (
    cod_plano INT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE,
    valor DECIMAL(10, 2) NOT NULL,
    duracao INT NOT NULL COMMENT 'Duração do plano em meses',
    CONSTRAINT chk_plano_valor CHECK (valor >= 0),
    CONSTRAINT chk_plano_duracao CHECK (duracao > 0)
) ENGINE = InnoDB;

CREATE TABLE TB_EXERCICIO (
    cod_exercicio INT PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL,
    grupo_muscular VARCHAR(50) NOT NULL
) ENGINE = InnoDB;

CREATE TABLE TB_MATRICULA (
    num_matricula_aluno INT NOT NULL,
    cod_plano INT NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    PRIMARY KEY (num_matricula_aluno, cod_plano, data_inicio),
    INDEX idx_matricula_plano (cod_plano),
    INDEX idx_matricula_status (status),
    CONSTRAINT fk_matricula_aluno
        FOREIGN KEY (num_matricula_aluno)
        REFERENCES TB_ALUNO (num_matricula)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_matricula_plano
        FOREIGN KEY (cod_plano)
        REFERENCES TB_PLANO (cod_plano)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_matricula_periodo CHECK (data_fim >= data_inicio),
    CONSTRAINT chk_matricula_status CHECK (status IN ('Ativo', 'Inativo'))
) ENGINE = InnoDB;

CREATE TABLE TB_FICHA_TREINO (
    cod_ficha INT PRIMARY KEY,
    data_criacao DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    num_matricula_aluno INT NOT NULL,
    cod_instrutor_resp INT NOT NULL,
    INDEX idx_ficha_aluno (num_matricula_aluno),
    INDEX idx_ficha_instrutor (cod_instrutor_resp),
    CONSTRAINT fk_ficha_aluno
        FOREIGN KEY (num_matricula_aluno)
        REFERENCES TB_ALUNO (num_matricula)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_ficha_instrutor
        FOREIGN KEY (cod_instrutor_resp)
        REFERENCES TB_INSTRUTOR (cod_instrutor)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_ficha_status CHECK (status IN ('Ativa', 'Inativa'))
) ENGINE = InnoDB;

CREATE TABLE TB_ITEM_TREINO (
    cod_ficha INT NOT NULL,
    cod_exercicio INT NOT NULL,
    series INT NOT NULL,
    repeticoes INT NOT NULL,
    tempo_descanso INT NOT NULL COMMENT 'Tempo de descanso em segundos',
    PRIMARY KEY (cod_ficha, cod_exercicio),
    INDEX idx_item_exercicio (cod_exercicio),
    CONSTRAINT fk_item_ficha
        FOREIGN KEY (cod_ficha)
        REFERENCES TB_FICHA_TREINO (cod_ficha)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_item_exercicio
        FOREIGN KEY (cod_exercicio)
        REFERENCES TB_EXERCICIO (cod_exercicio)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_item_series CHECK (series > 0),
    CONSTRAINT chk_item_repeticoes CHECK (repeticoes > 0),
    CONSTRAINT chk_item_descanso CHECK (tempo_descanso >= 0)
) ENGINE = InnoDB;

CREATE TABLE TB_AVALIACAO_FISICA (
    cod_avaliacao INT PRIMARY KEY,
    data_realizacao DATE NOT NULL,
    peso DECIMAL(5, 2) NOT NULL,
    altura DECIMAL(3, 2) NOT NULL,
    percentual_gordura DECIMAL(4, 2) NOT NULL,
    num_matricula_aluno INT NOT NULL,
    cod_instrutor_avaliador INT NOT NULL,
    INDEX idx_avaliacao_aluno (num_matricula_aluno),
    INDEX idx_avaliacao_instrutor (cod_instrutor_avaliador),
    CONSTRAINT fk_avaliacao_aluno
        FOREIGN KEY (num_matricula_aluno)
        REFERENCES TB_ALUNO (num_matricula)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_avaliacao_instrutor
        FOREIGN KEY (cod_instrutor_avaliador)
        REFERENCES TB_INSTRUTOR (cod_instrutor)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_avaliacao_peso CHECK (peso > 0),
    CONSTRAINT chk_avaliacao_altura CHECK (altura > 0),
    CONSTRAINT chk_avaliacao_gordura
        CHECK (percentual_gordura BETWEEN 0 AND 100)
) ENGINE = InnoDB;

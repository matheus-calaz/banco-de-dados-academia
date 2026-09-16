-- Dados de demonstração
-- Execute 01_schema.sql antes deste arquivo.

USE academia_trabalho;

INSERT INTO TB_ALUNO (
    num_matricula,
    nome,
    cpf,
    data_nascimento,
    telefone,
    email,
    data_cadastro
) VALUES
    (1, 'João Silva', '111.111.111-11', '1995-05-10', '9999-1111', 'joao@email.com', '2024-01-10'),
    (2, 'Maria Oliveira', '222.222.222-22', '1998-07-20', '9999-2222', 'maria@email.com', '2024-02-15'),
    (3, 'Carlos Souza', '333.333.333-33', '1990-03-05', '9999-3333', 'carlos@email.com', '2024-03-01'),
    (4, 'Ana Pereira', '444.444.444-44', '2000-12-25', '9999-4444', 'ana@email.com', '2024-04-10');

INSERT INTO TB_INSTRUTOR (
    cod_instrutor,
    nome,
    cpf,
    especialidade,
    telefone
) VALUES
    (1, 'Roberto Mendes', '555.555.555-55', 'Musculação', '8888-1111'),
    (2, 'Fernanda Lima', '666.666.666-66', 'Fisiologia', '8888-2222'),
    (3, 'Paulo Costa', '777.777.777-77', 'Crossfit', '8888-3333');

INSERT INTO TB_PLANO (
    cod_plano,
    nome,
    valor,
    duracao
) VALUES
    (1, 'Plano Mensal Básico', 80.00, 1),
    (2, 'Plano Anual Gold', 120.00, 12),
    (3, 'Plano Semestral Prata', 100.00, 6),
    (4, 'Plano VIP Exclusivo', 300.00, 12);

INSERT INTO TB_EXERCICIO (
    cod_exercicio,
    descricao,
    grupo_muscular
) VALUES
    (1, 'Supino Reto', 'Peito'),
    (2, 'Agachamento Livre', 'Pernas'),
    (3, 'Puxada Alta', 'Costas'),
    (4, 'Burpee', 'Cardio');

INSERT INTO TB_MATRICULA (
    num_matricula_aluno,
    cod_plano,
    data_inicio,
    data_fim,
    status
) VALUES
    (1, 2, '2024-01-10', '2025-01-10', 'Ativo'),
    (2, 1, '2024-02-15', '2024-03-15', 'Inativo'),
    (3, 3, '2024-03-01', '2024-09-01', 'Ativo');

INSERT INTO TB_FICHA_TREINO (
    cod_ficha,
    data_criacao,
    status,
    num_matricula_aluno,
    cod_instrutor_resp
) VALUES
    (101, '2024-01-11', 'Ativa', 1, 1),
    (102, '2024-02-16', 'Ativa', 2, 1),
    (103, '2024-03-01', 'Inativa', 1, 1),
    (104, '2024-03-05', 'Inativa', 2, 1),
    (105, '2024-04-01', 'Inativa', 1, 1),
    (106, '2024-04-10', 'Inativa', 2, 1);

INSERT INTO TB_ITEM_TREINO (
    cod_ficha,
    cod_exercicio,
    series,
    repeticoes,
    tempo_descanso
) VALUES
    (101, 1, 3, 12, 60),
    (101, 2, 3, 10, 90),
    (102, 3, 4, 15, 45);

INSERT INTO TB_AVALIACAO_FISICA (
    cod_avaliacao,
    data_realizacao,
    peso,
    altura,
    percentual_gordura,
    num_matricula_aluno,
    cod_instrutor_avaliador
) VALUES
    (501, '2024-01-12', 70.00, 1.75, 15.00, 1, 1),
    (502, '2024-03-02', 95.00, 1.80, 22.00, 3, 2);


-- Consultas de demonstração
-- Execute 01_schema.sql e 02_seed.sql antes deste arquivo.

USE academia_trabalho;

-- 1. Matrículas ativas com os respectivos alunos e planos.
SELECT
    a.num_matricula,
    a.nome AS aluno,
    p.nome AS plano,
    m.data_inicio,
    m.data_fim
FROM TB_MATRICULA AS m
INNER JOIN TB_ALUNO AS a
    ON a.num_matricula = m.num_matricula_aluno
INNER JOIN TB_PLANO AS p
    ON p.cod_plano = m.cod_plano
WHERE m.status = 'Ativo'
ORDER BY a.nome;

-- 2. Quantidade de fichas por aluno, incluindo alunos sem ficha.
SELECT
    a.num_matricula,
    a.nome AS aluno,
    COUNT(f.cod_ficha) AS quantidade_fichas
FROM TB_ALUNO AS a
LEFT JOIN TB_FICHA_TREINO AS f
    ON f.num_matricula_aluno = a.num_matricula
GROUP BY a.num_matricula, a.nome
ORDER BY quantidade_fichas DESC, a.nome;

-- 3. Quantidade de matrículas por plano, incluindo planos nunca contratados.
SELECT
    p.cod_plano,
    p.nome AS plano,
    COUNT(m.num_matricula_aluno) AS quantidade_matriculas
FROM TB_MATRICULA AS m
RIGHT JOIN TB_PLANO AS p
    ON p.cod_plano = m.cod_plano
GROUP BY p.cod_plano, p.nome
ORDER BY p.cod_plano;

-- 4. Composição das fichas de treino com aluno, instrutor e exercícios.
SELECT
    f.cod_ficha,
    a.nome AS aluno,
    i.nome AS instrutor,
    e.descricao AS exercicio,
    it.series,
    it.repeticoes,
    it.tempo_descanso
FROM TB_FICHA_TREINO AS f
INNER JOIN TB_ALUNO AS a
    ON a.num_matricula = f.num_matricula_aluno
INNER JOIN TB_INSTRUTOR AS i
    ON i.cod_instrutor = f.cod_instrutor_resp
INNER JOIN TB_ITEM_TREINO AS it
    ON it.cod_ficha = f.cod_ficha
INNER JOIN TB_EXERCICIO AS e
    ON e.cod_exercicio = it.cod_exercicio
ORDER BY f.cod_ficha, e.descricao;

-- 5. Instrutores responsáveis por mais de cinco fichas.
SELECT
    i.cod_instrutor,
    i.nome AS instrutor,
    COUNT(f.cod_ficha) AS quantidade_fichas
FROM TB_INSTRUTOR AS i
INNER JOIN TB_FICHA_TREINO AS f
    ON f.cod_instrutor_resp = i.cod_instrutor
GROUP BY i.cod_instrutor, i.nome
HAVING COUNT(f.cod_ficha) > 5;

-- 6. Instrutores que não criaram fichas nem realizaram avaliações.
SELECT
    i.cod_instrutor,
    i.nome AS instrutor
FROM TB_INSTRUTOR AS i
WHERE NOT EXISTS (
    SELECT 1
    FROM TB_FICHA_TREINO AS f
    WHERE f.cod_instrutor_resp = i.cod_instrutor
)
AND NOT EXISTS (
    SELECT 1
    FROM TB_AVALIACAO_FISICA AS af
    WHERE af.cod_instrutor_avaliador = i.cod_instrutor
)
ORDER BY i.nome;

-- 7. Alunos que possuem tanto ficha de treino quanto avaliação física.
SELECT
    a.num_matricula,
    a.nome AS aluno
FROM TB_ALUNO AS a
INNER JOIN (
    SELECT num_matricula_aluno
    FROM TB_FICHA_TREINO
    INTERSECT
    SELECT num_matricula_aluno
    FROM TB_AVALIACAO_FISICA
) AS alunos_completos
    ON alunos_completos.num_matricula_aluno = a.num_matricula
ORDER BY a.nome;

-- 8. Exercícios ainda não utilizados em nenhuma ficha.
SELECT
    e.cod_exercicio,
    e.descricao AS exercicio
FROM TB_EXERCICIO AS e
INNER JOIN (
    SELECT cod_exercicio
    FROM TB_EXERCICIO
    EXCEPT
    SELECT cod_exercicio
    FROM TB_ITEM_TREINO
) AS exercicios_nao_utilizados
    ON exercicios_nao_utilizados.cod_exercicio = e.cod_exercicio
ORDER BY e.descricao;

-- 9. Alternativa compatível para localizar exercícios não utilizados.
SELECT
    e.cod_exercicio,
    e.descricao AS exercicio
FROM TB_EXERCICIO AS e
WHERE NOT EXISTS (
    SELECT 1
    FROM TB_ITEM_TREINO AS it
    WHERE it.cod_exercicio = e.cod_exercicio
)
ORDER BY e.descricao;

-- 10. Instrutores com alguma avaliação de peso superior a pelo menos uma
-- avaliação realizada pelo instrutor de código 1.
SELECT DISTINCT
    i.cod_instrutor,
    i.nome AS instrutor
FROM TB_INSTRUTOR AS i
INNER JOIN TB_AVALIACAO_FISICA AS af
    ON af.cod_instrutor_avaliador = i.cod_instrutor
WHERE af.peso > ANY (
    SELECT af_referencia.peso
    FROM TB_AVALIACAO_FISICA AS af_referencia
    WHERE af_referencia.cod_instrutor_avaliador = 1
)
ORDER BY i.nome;

-- 11. Planos com valor acima da média.
SELECT
    cod_plano,
    nome AS plano,
    valor
FROM TB_PLANO
WHERE valor > (
    SELECT AVG(valor)
    FROM TB_PLANO
)
ORDER BY valor DESC;

-- 12. Resumo de avaliações físicas por aluno.
SELECT
    a.num_matricula,
    a.nome AS aluno,
    COUNT(af.cod_avaliacao) AS quantidade_avaliacoes,
    ROUND(AVG(af.peso), 2) AS peso_medio,
    ROUND(AVG(af.percentual_gordura), 2) AS gordura_media
FROM TB_ALUNO AS a
LEFT JOIN TB_AVALIACAO_FISICA AS af
    ON af.num_matricula_aluno = a.num_matricula
GROUP BY a.num_matricula, a.nome
ORDER BY a.nome;

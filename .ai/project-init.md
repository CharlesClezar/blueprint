# Inicialização do projeto

> **Para que serve:** permite que pessoas e agentes reconheçam se estão na base genérica ou em um projeto derivado pronto para trabalhar. Após a conclusão, este arquivo permanece como registro histórico.

```yaml
project_initialization:
  status: NOT_STARTED
  completed_at: null
  completed_by: null
  bootstrap_issue: null
  bootstrap_pull_request: null
```

Estados permitidos: `NOT_STARTED`, `IN_PROGRESS` e `COMPLETE`.

## Regra de bloqueio

Implementação de produto ou tecnologia é proibida enquanto:

- o estado não for `COMPLETE`;
- houver `TODO(PROJECT_INIT)` ou placeholder `<PROJECT_...>` material;
- `.ai/vision.md` não tiver aprovação mínima;
- autoridade e política operacional não estiverem registradas.

Descoberta, planejamento do bootstrap e correção dos próprios placeholders continuam permitidos.

## Perguntas mínimas

1. Qual é o nome ou identificador provisório?
2. Que problema ou necessidade motivou o projeto?
3. Quem é afetado e em qual contexto?
4. Qual resultado inicial é desejado?
5. Quais limites ou restrições já são conhecidos?
6. O que é fato, hipótese ou decisão?
7. Quem possui autoridade final?
8. Que informação sensível não pode ser fornecida a assistentes?
9. Qual política valerá para criação de issues, merge e release?
10. O projeto precisa publicar versões e, se precisar, qual esquema adotará?

## Checklist

- [ ] Repositório independente criado a partir do template.
- [ ] GitHub Project, labels e Ruleset configurados com `scripts/configure-github.sh`.
- [ ] Primeira issue de bootstrap criada.
- [ ] Branch `bootstrap/<issue>-<slug>` criada a partir de `main`.
- [ ] Estado alterado para `IN_PROGRESS`.
- [ ] Identidade genérica substituída no `README.md` e em `.ai/vision.md`.
- [ ] Descoberta mínima conduzida e fatos separados de hipóteses.
- [ ] `.ai/vision.md` revisado e aprovado.
- [ ] Autoridade humana e limites de ações externas registrados.
- [ ] Restrições de dados sensíveis, segredos e conteúdo externo revisadas conforme `.ai/security.md`.
- [ ] Política de issues, merge, tags e releases confirmada.
- [ ] Comandos específicos da stack registrados em `AGENTS.md`, quando conhecidos.
- [ ] Exemplos removíveis eliminados.
- [ ] Busca por placeholders obrigatórios executada.
- [ ] PR de bootstrap aberto e ligado à issue.
- [ ] Checks e revisão do bootstrap concluídos.
- [ ] `completed_at`, `completed_by`, issue e PR registrados.
- [ ] Estado alterado para `COMPLETE` no último commit do bootstrap.

## Caminho automatizado recomendado

Depois de criar e clonar o repositório derivado, execute:

```sh
./scripts/start-project.sh
```

Esse helper realiza os passos mecânicos até `IN_PROGRESS`. Ele exige confirmação do repositório-alvo e aprovação humana explícita antes de mover a issue de bootstrap para `Ready`. Se for interrompido, não repita cegamente: consulte a issue criada, o Project, a branch atual e use os helpers individuais documentados em `AGENTS.md`.

## Critério de conclusão

O bootstrap termina quando o repositório tem identidade própria, visão mínima aprovada, autoridade registrada, nenhum placeholder material, política operacional definida e configuração remota verificada. Isso não significa que stack, arquitetura ou backlog completo estejam definidos.

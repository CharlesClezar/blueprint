# Blueprint para projetos assistidos por IA

> **Para que serve:** este repositório é uma base reutilizável para iniciar projetos pessoais desenvolvidos com assistência de IA. Ele reúne método, governança, templates e validações; não define produto, arquitetura ou stack.

## Estado deste repositório

Este é o **repositório-base**. Ao criar um projeto a partir dele, execute o procedimento em [`.ai/project-init.md`](.ai/project-init.md) antes de implementar funcionalidades.

## Como a base está organizada

- [`.ai/README.md`](.ai/README.md): mapa da metodologia e ordem de leitura.
- [`.ai/workflow.md`](.ai/workflow.md): papéis, workflows, autoridade, Definition of Ready e Definition of Done.
- [`.ai/backlog.md`](.ai/backlog.md): hierarquia, tipos, estados e regras das issues.
- [`.ai/interaction-guide.md`](.ai/interaction-guide.md): exemplos práticos para conversar com a IA, interromper e retomar trabalho.
- [`.ai/security.md`](.ai/security.md): segurança, segredos, conteúdo externo, dependências e ações de alto impacto.
- [`.ai/engineering.md`](.ai/engineering.md): política geral de qualidade, arquitetura, implementação, testes e revisão.
- [`.ai/engineering-context.md`](.ai/engineering-context.md): stack, comandos e convenções que cada derivado deve preencher.
- [`.ai/vision.md`](.ai/vision.md): contexto específico a ser preenchido em cada projeto derivado.
- [`.ai/project-init.md`](.ai/project-init.md): estado e checklist do bootstrap.
- [`AGENTS.md`](AGENTS.md): instruções operacionais descobertas pelo Codex e por agentes compatíveis.
- [`CLAUDE.md`](CLAUDE.md): ponto de entrada do Claude Code.
- [`.github/`](.github): templates e automações nativas do GitHub.
- [`scripts/`](scripts): validações locais e configuração assistida pelo GitHub CLI.

## Regras fundamentais

1. GitHub e arquivos versionados são a fonte oficial; conversas são temporárias.
2. Toda alteração posterior à geração do template deve ter uma issue de origem.
3. Toda alteração deve ocorrer em branch temporária e chegar à `main` por pull request.
4. O PR deve referenciar a issue e apresentar evidências verificáveis.
5. Apenas uma issue aprovada em `Ready` pode ser implementada por vez.
6. Releases são produzidas de forma controlada a partir de tags; merge não implica publicação automática.

## Criar um projeto derivado — caminho recomendado

Não clone o Blueprint diretamente. Gere um repositório independente pelo template e clone o derivado:

```sh
gh repo create SEU_USUARIO/NOVO_PROJETO \
  --template SEU_USUARIO/blueprint \
  --private \
  --clone

cd NOVO_PROJETO
```

Use `--public` em vez de `--private` quando apropriado. Não use `--include-all-branches`.

Depois, execute o assistente de inicialização:

```sh
./scripts/start-project.sh
```

Ele pede confirmação antes de alterar o GitHub e executa, na ordem:

1. confirma que o `origin` é o novo repositório, não a base;
2. verifica autenticação e pré-requisitos;
3. cria labels, Project, campos e Rulesets;
4. cria a issue de bootstrap;
5. coloca a issue em `Refinement`;
6. solicita sua aprovação explícita da DoR do bootstrap;
7. move para `Ready` e `In Progress` somente após a aprovação;
8. cria `bootstrap/<issue>-inicializar-projeto` a partir de `main`;
9. marca o bootstrap como `IN_PROGRESS`.

O script não inventa nome, problema, requisitos, stack ou arquitetura. A IA deve preencher `.ai/engineering-context.md` durante o bootstrap somente com decisões aprovadas pelo usuário e usar `N/A — <justificativa>` no que realmente não se aplicar. O script também não faz commit, push, PR, merge, release ou deploy.

Ao final, abra sua ferramenta de IA na raiz e peça:

> Conduza a inicialização da issue indicada pelo script. Leia `AGENTS.md`, `.ai/project-init.md`, `.ai/engineering.md` e `.ai/engineering-context.md`; faça as perguntas mínimas, preencha o contexto técnico apenas com decisões que eu aprovar, atualize todos os artefatos afetados e prepare um draft PR. Não escolha stack, arquitetura ou requisitos sem minha aprovação.

A IA conduzirá a descoberta mínima, criará o checkpoint, abrirá o draft PR, registrará seu número, concluirá os placeholders e preparará a revisão. O procedimento completo e a recuperação de passos interrompidos estão em [`.ai/project-init.md`](.ai/project-init.md) e [`.ai/interaction-guide.md`](.ai/interaction-guide.md).

### Único ajuste manual no GitHub

GitHub Template Repository e GitHub CLI não transportam/configuram integralmente os workflows nativos do Project. Abra **Project → Workflows** uma vez e confirme:

- Auto-add: `repo:SEU_USUARIO/NOVO_PROJETO is:issue`;
- item adicionado: `Status = Inbox`;
- issue concluída: `Status = Done`;
- fechamento `not planned` não representa entrega;
- workflow de PR integrado desabilitado quando PRs não forem cartões do Project.

Ao final, **Auto-add to project**, **Item added to project** e **Item closed** devem aparecer com ponto verde. A IA deve orientar essa configuração passo a passo, solicitar confirmação observável e não declarar o bootstrap remoto integralmente concluído antes disso.

O script imprime esse lembrete e o procedimento detalhado está em [`.ai/github-setup.md`](.ai/github-setup.md).

### Diagnóstico e recuperação

Em caso de interrupção, configuração parcial ou dúvida, não reinicie cegamente. Execute:

```sh
./scripts/doctor.sh
```

O diagnóstico é somente leitura e compara estado local e remoto. `start-project.sh` reutiliza uma issue de bootstrap aberta e orienta retomada quando o estado já estiver `IN_PROGRESS` ou `COMPLETE`.

Antes de publicar uma nova versão do Blueprint, valide um derivado descartável com [`.ai/template-audit.md`](.ai/template-audit.md).

Os scripts `.sh` suportam macOS, Linux, GitHub Actions em Ubuntu e Windows por WSL/Git Bash. Consulte [`.ai/github-setup.md`](.ai/github-setup.md) para pré-requisitos e limitações de portabilidade.

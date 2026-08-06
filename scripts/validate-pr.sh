#!/bin/sh
# Purpose: validate that a pull request follows branch and issue traceability rules.

set -eu

head_ref=${PR_HEAD_REF:-}
base_ref=${PR_BASE_REF:-}
body=${PR_BODY:-}
repository=${GITHUB_REPOSITORY:-}
draft=${PR_DRAFT:-true}

if [ -z "$head_ref" ] || [ -z "$base_ref" ]; then
  echo "ERROR: PR_HEAD_REF and PR_BASE_REF are required." >&2
  exit 1
fi

if [ "$base_ref" != "main" ]; then
  echo "ERROR: pull requests must target main; received '$base_ref'." >&2
  exit 1
fi

if ! printf '%s\n' "$head_ref" | grep -Eq '^(bootstrap|feature|bugfix|technical|docs|research)/[0-9]+-[a-z0-9]+([a-z0-9-]*[a-z0-9])?$'; then
  echo "ERROR: branch '$head_ref' does not follow <type>/<issue>-<slug>." >&2
  exit 1
fi

issue_number=$(printf '%s\n' "$head_ref" | sed -E 's#^[^/]+/([0-9]+)-.*#\1#')

if ! printf '%s\n' "$body" | grep -Eiq "(^|[^0-9])(closes|closed|close|fixes|fixed|fix|resolves|resolved|resolve|relates to)[[:space:]]+#${issue_number}([^0-9]|$)"; then
  echo "ERROR: PR body must explicitly reference issue #$issue_number with Closes/Fixes/Resolves or Relates to." >&2
  exit 1
fi

if [ -n "${GH_TOKEN:-}" ] && [ -n "$repository" ] && command -v gh >/dev/null 2>&1; then
  issue_data=$(gh api "repos/$repository/issues/$issue_number" --jq '[has("pull_request"), .state] | @tsv')
  is_pull_request=$(printf '%s\n' "$issue_data" | cut -f1)
  issue_state=$(printf '%s\n' "$issue_data" | cut -f2)
  if [ "$is_pull_request" = "true" ]; then
    echo "ERROR: #$issue_number resolves to a pull request, not an issue." >&2
    exit 1
  fi
  if [ "$issue_state" != "open" ]; then
    echo "ERROR: origin issue #$issue_number must be open while the pull request is active." >&2
    exit 1
  fi
fi

if [ "$draft" = "false" ]; then
  required_headings="
## Issue
## Resumo
## Escopo
## Evidências
## Documentação e decisões
## Análise de impacto e consistência
## Riscos, limitações e follow-ups
## Segurança
## Checklist
"

  while IFS= read -r heading; do
    [ -z "$heading" ] && continue
    if ! printf '%s\n' "$body" | grep -Fqx "$heading"; then
      echo "ERROR: ready-for-review PR is missing required heading: $heading" >&2
      exit 1
    fi
  done <<EOF
$required_headings
EOF

  if printf '%s\n' "$body" | grep -Eq '#<número>|<O que mudou e por quê>|<item ou “Nenhum conhecido”>'; then
    echo "ERROR: ready-for-review PR still contains template placeholders." >&2
    exit 1
  fi

  required_checks="
A issue estava aprovada em \`Ready\` antes da implementação, ou este é o bootstrap inicial.
Critérios de aceite atendidos.
Testes relevantes atualizados e executados.
Documentação afetada atualizada.
Fonte oficial e todas as representações relacionadas permanecem coerentes.
Referências foram pesquisadas novamente após a alteração.
Impactos de segurança, dados, dependências, permissões e ações externas foram avaliados.
Nenhuma mudança fora do escopo.
Limitações e verificações não executadas declaradas.
Branch segue o padrão e será removida após o merge.
"

  while IFS= read -r check_text; do
    [ -z "$check_text" ] && continue
    if ! printf '%s\n' "$body" | grep -Fqi -- "- [x] $check_text"; then
      echo "ERROR: ready-for-review PR has an unchecked required item: $check_text" >&2
      exit 1
    fi
  done <<EOF
$required_checks
EOF
fi

echo "Pull request traceability validation passed for issue #$issue_number."

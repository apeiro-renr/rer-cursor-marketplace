#!/usr/bin/env bash
# Lee .env del directorio indicado. No imprime valores de tokens.
set -euo pipefail

ENV_FILE="${1:-.env}"

if [[ ! -f "$ENV_FILE" ]]; then
  printf '%s\n' "ENV_MISSING: no existe ${ENV_FILE}. Ahí deben estar los tokens, sin pegarlos en el chat." >&2
  exit 2
fi

while IFS= read -r line || [[ -n "$line" ]]; do
  line="${line#"${line%%[![:space:]]*}"}"
  [[ -z "$line" || "$line" == \#* ]] && continue
  line="${line#export }"
  [[ "$line" != *=* ]] && continue
  key="${line%%=*}"
  key="${key%"${key##*[![:space:]]}"}"
  value="${line#*=}"
  if [[ "$value" == \"*\" ]]; then
    value="${value#\"}"
    value="${value%\"}"
  elif [[ "$value" == \'*\' ]]; then
    value="${value#\'}"
    value="${value%\'}"
  fi
  if [[ ! "$key" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
    continue
  fi
  if [[ -z "${!key:-}" ]]; then
    printf -v "$key" '%s' "$value"
    export "$key"
  fi
done < "$ENV_FILE"

GITLAB_URL="${GITLAB_URL:-https://gitlab.prensaiberica.es}"
GITLAB_URL="${GITLAB_URL%/}"
PROJECT="tech%2Futils%2Fai%2Forquestador"
FILE="PROMPT.md"
REF="main"
URL="${GITLAB_URL}/api/v4/projects/${PROJECT}/repository/files/${FILE}/raw?ref=${REF}"

fail=0

if [[ -z "${GITLAB_TOKEN:-}" ]]; then
  printf '%s\n' "GITLAB_DENIED: .env no tiene GITLAB_TOKEN." >&2
  fail=1
else
  BODY="$(mktemp)"
  HTTP_CODE="$(curl -sS -o "$BODY" -w "%{http_code}" \
    --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
    "$URL" || true)"
  if [[ "$HTTP_CODE" == "200" ]]; then
    printf '%s\n' "GITLAB_OK"
    cat "$BODY"
    printf '\n'
  elif [[ -z "$HTTP_CODE" || "$HTTP_CODE" == "000" ]]; then
    printf '%s\n' "GITLAB_DENIED: no se pudo conectar con ${GITLAB_URL} para leer PROMPT.md." >&2
    cat "$BODY" >&2
  else
    printf '%s\n' "GITLAB_DENIED: GitLab respondió HTTP ${HTTP_CODE} al leer PROMPT.md en ${GITLAB_URL}." >&2
    cat "$BODY" >&2
    printf '\n' >&2
  fi
  rm -f "$BODY"
  if [[ "$HTTP_CODE" != "200" ]]; then
    fail=1
  fi
fi

JIRA_EMAIL="${JIRA_USER_EMAIL:-${USER_JIRA:-}}"
JIRA_TOKEN="${JIRA_API_TOKEN:-${TOKEN_JIRA:-}}"

if [[ -z "$JIRA_EMAIL" || -z "$JIRA_TOKEN" ]]; then
  printf '%s\n' "JIRA_DENIED: .env no tiene JIRA_USER_EMAIL y JIRA_API_TOKEN (también valen USER_JIRA y TOKEN_JIRA)." >&2
  fail=1
else
  printf '%s\n' "JIRA_OK"
fi

exit "$fail"

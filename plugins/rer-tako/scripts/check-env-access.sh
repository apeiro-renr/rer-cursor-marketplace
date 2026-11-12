#!/usr/bin/env bash
# Lee .env del directorio indicado. No imprime valores de tokens.
set -euo pipefail

ENV_FILE="${1:-.env}"
MODE="file"
FILE="PROMPT.md"
FROM_SHA=""
TO_SHA=""
GITLAB_ONLY=0
if [[ "${2:-}" == "--compare" ]]; then
  MODE="compare"
  FROM_SHA="${3:-}"
  TO_SHA="${4:-}"
else
  FILE="${2:-PROMPT.md}"
  if [[ "${3:-}" == "--gitlab-only" ]]; then
    GITLAB_ONLY=1
  fi
fi

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
REF="main"

if [[ "$MODE" == "compare" ]]; then
  if [[ ! "$FROM_SHA" =~ ^[0-9a-fA-F]{40}$ || ! "$TO_SHA" =~ ^[0-9a-fA-F]{40}$ ]]; then
    printf '%s\n' "COMPARE_DENIED: hacen falta el commit instalado y el de main, con 40 caracteres." >&2
    exit 1
  fi
  if [[ "${FROM_SHA,,}" == "${TO_SHA,,}" ]]; then
    printf '%s\n' "COMPARE_OK"
    exit 0
  fi
  if [[ -z "${GITLAB_TOKEN:-}" ]]; then
    printf '%s\n' "GITLAB_DENIED: .env no tiene GITLAB_TOKEN." >&2
    exit 1
  fi

  TITLES="$(mktemp)"
  page=1
  found=0
  while [[ "$page" -le 5 ]]; do
    BODY="$(mktemp)"
    HTTP_CODE="$(curl -sS -o "$BODY" -w "%{http_code}" \
      --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
      "${GITLAB_URL}/api/v4/projects/${PROJECT}/repository/commits?ref_name=${TO_SHA}&per_page=100&page=${page}" || true)"
    if [[ "$HTTP_CODE" != "200" ]]; then
      printf '%s\n' "COMPARE_DENIED: GitLab respondió HTTP ${HTTP_CODE:-000} al listar commits en ${GITLAB_URL}." >&2
      rm -f "$BODY" "$TITLES"
      exit 1
    fi
    set +e
    node -e '
const fs = require("fs");
const from = process.argv[1].toLowerCase();
const commits = JSON.parse(fs.readFileSync(process.argv[2], "utf8"));
if (!Array.isArray(commits)) process.exit(3);
let found = false;
for (const commit of commits) {
  const id = String(commit.id || "").toLowerCase();
  if (id === from) { found = true; break; }
  const title = String(commit.title || "").replace(/\s+/g, " ").trim();
  if (!title || /^Merge (branch |remote-tracking branch )/i.test(title)) continue;
  console.log(title);
}
if (found) process.exit(0);
process.exit(commits.length < 100 ? 2 : 4);
' "$FROM_SHA" "$BODY" >> "$TITLES"
    node_status=$?
    set -e
    rm -f "$BODY"
    if [[ "$node_status" == "0" ]]; then
      found=1
      break
    fi
    if [[ "$node_status" == "2" ]]; then
      break
    fi
    if [[ "$node_status" != "4" ]]; then
      printf '%s\n' "COMPARE_DENIED: no se pudo leer la lista de commits." >&2
      rm -f "$TITLES"
      exit 1
    fi
    page=$((page + 1))
  done

  if [[ "$found" != "1" ]]; then
    printf '%s\n' "COMPARE_DENIED: el commit instalado no aparece en el historial de main." >&2
    rm -f "$TITLES"
    exit 1
  fi
  printf '%s\n' "COMPARE_OK"
  cat "$TITLES"
  rm -f "$TITLES"
  exit 0
fi

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
    printf '%s\n' "GITLAB_DENIED: no se pudo conectar con ${GITLAB_URL} para leer ${FILE}." >&2
    cat "$BODY" >&2
  else
    printf '%s\n' "GITLAB_DENIED: GitLab respondió HTTP ${HTTP_CODE} al leer ${FILE} en ${GITLAB_URL}." >&2
    cat "$BODY" >&2
    printf '\n' >&2
  fi
  rm -f "$BODY"
  if [[ "$HTTP_CODE" != "200" ]]; then
    fail=1
  fi
fi

if [[ "$GITLAB_ONLY" == "1" ]]; then
  exit "$fail"
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

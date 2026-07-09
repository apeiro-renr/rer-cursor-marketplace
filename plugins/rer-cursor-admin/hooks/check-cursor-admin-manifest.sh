#!/usr/bin/env bash
# beforeSubmitPrompt: comprueba que cursor-admin esté instalado (~/cursor-admin/manifest.json).
set -euo pipefail

MANIFEST_PATH="${HOME}/cursor-admin/manifest.json"

if [[ ! -f "$MANIFEST_PATH" ]]; then
  printf '%s\n' '{"continue":false,"user_message":"NO TIENES INSTALADO CURSOR-ADMIN"}'
  exit 0
fi

printf '%s\n' '{"continue":true}'
exit 0

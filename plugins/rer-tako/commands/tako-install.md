---
name: tako-install
description: Comprueba Jira y GitLab por MCP o por .env y, si puede leer el PROMPT.md del orquestador, sigue sus instrucciones.
---

# tako-install

Hacen falta Jira y GitLab, por una de estas dos vías en cada uno:

- el MCP de Atlassian y el de GitLab en Cursor, o
- tokens en `.env` (no los pegues en el chat): `JIRA_USER_EMAIL` y `JIRA_API_TOKEN` (también valen `USER_JIRA` y `TOKEN_JIRA`) y `GITLAB_TOKEN`. `GITLAB_URL` es `https://gitlab.prensaiberica.es`.

No muestres ni pegues el valor de ningún token.

## GitLab

Intenta leer con el MCP de GitLab este archivo:

https://gitlab.prensaiberica.es/tech/utils/ai/orquestador/-/blob/main/PROMPT.md

Proyecto `tech/utils/ai/orquestador`, archivo `PROMPT.md`, rama `main`.

Si el MCP no está, pide autenticación o la lectura falla, ejecuta desde la raíz del proyecto:

```bash
bash "${CURSOR_PLUGIN_ROOT}/scripts/check-env-access.sh" .env
```

Si `CURSOR_PLUGIN_ROOT` no está definido, usa la ruta del plugin `rer-tako` en este marketplace. Esa vía solo cuenta si la salida contiene `GITLAB_OK` y el contenido del archivo. `GITLAB_URL` del `.env` sustituye al host por defecto.

## Jira

Intenta el MCP de Atlassian. Una llamada que devuelva el usuario actual o los sitios accesibles basta para dar esta vía por buena.

Si el MCP no está o falla, la vía del `.env` vale cuando el script imprime `JIRA_OK`.

## Resultado

Si GitLab o Jira se quedan sin ninguna vía válida, muestra el error de cada una (autenticación del MCP, `ENV_MISSING`, `GITLAB_DENIED` o `JIRA_DENIED`) y termina.

Si las dos tienen una vía válida, ejecuta este prompt y cumple lo que indique ese `PROMPT.md`:

Sigue las instrucciones de https://gitlab.prensaiberica.es/tech/utils/ai/orquestador/-/blob/main/PROMPT.md

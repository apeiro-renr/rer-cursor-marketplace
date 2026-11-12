---
name: tako-update
description: Actualiza Tako en el repo abierto siguiendo PROMPT-ACTUALIZAR.md de main en el orquestador y resume las mejoras traídas desde la versión instalada. Usar cuando pidan actualizar Tako, /tako update, /tako-update, traer el kit o las mejoras del orquestador.
---

# tako-update

Actualiza el kit en el repo abierto. El procedimiento no está en esta skill: está en el proyecto del orquestador. Léelo de `main` y ejecútalo aquí, para que cada mejora de Tako llegue al llamar la skill.

Lo primero, antes de copiar nada, lee `tako/tako-version.json` y guarda `commit`. Si el fichero no existe, no hay commit instalado.

## GitLab

Lee con el MCP de GitLab este archivo:

https://gitlab.prensaiberica.es/tech/utils/ai/orquestador/-/blob/main/PROMPT-ACTUALIZAR.md

Proyecto `tech/utils/ai/orquestador`, archivo `PROMPT-ACTUALIZAR.md`, rama `main`.

Si el MCP no está, pide autenticación o la lectura falla, ejecuta desde la raíz del repo abierto:

```bash
bash "${CURSOR_PLUGIN_ROOT}/scripts/check-env-access.sh" .env PROMPT-ACTUALIZAR.md --gitlab-only
```

Si `CURSOR_PLUGIN_ROOT` no está definido, usa la ruta del plugin `rer-tako`. Esa vía solo cuenta si la salida contiene `GITLAB_OK` y el contenido del archivo. `GITLAB_URL` del `.env` sustituye al host por defecto. No hace falta Jira. No muestres ni pegues el valor de ningún token.

## Resultado

Si GitLab se queda sin ninguna vía válida, muestra el error (autenticación del MCP, `ENV_MISSING` o `GITLAB_DENIED`) y termina.

Si puedes leer el archivo, ejecuta ese `PROMPT-ACTUALIZAR.md` en este repo y cumple lo que indique. No copies el kit por tu cuenta ni sustituyas esos pasos por los de una versión ya instalada: manda el fichero de `main`. Si dice que hay que seguir `PROMPT.md`, para y dilo. La instalación es `/tako-install`. No inventes un resumen.

## Resumen

Al terminar la actualización, resume en español las mejoras que acaba de traer. Pocas frases, agrupadas por tema. No pegues el diff ni tokens.

- Si la actualización no se aplicó, no resumas.
- Si no había `commit` instalado, di en qué commit de `main` ha quedado el kit y resume solo ese commit.
- Si el `commit` guardado y el de `tako/tako-version.json` al terminar coinciden, di que ya estaba al día y que no hay mejoras nuevas.
- Si cambió, lista los commits del orquestador entre el SHA guardado y el nuevo, sin incluir el antiguo. Proyecto `tech/utils/ai/orquestador`, el nuevo es el `commit` que quedó en `tako/tako-version.json`.

Con el MCP de GitLab, lista esos commits. Omite los que solo fusionan una rama. Si el MCP no está o falla, desde la raíz del repo abierto:

```bash
bash "${CURSOR_PLUGIN_ROOT}/scripts/check-env-access.sh" .env --compare <sha-instalado> <sha-nuevo>
```

Si `CURSOR_PLUGIN_ROOT` no está definido, usa la ruta del plugin `rer-tako`. Esa vía solo cuenta si la salida contiene `COMPARE_OK`: cada línea siguiente es un cambio traído. Si sale `COMPARE_DENIED`, dilo y no inventes el resumen.

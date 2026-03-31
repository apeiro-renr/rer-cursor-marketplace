---
name: ai-config-existing
description: >-
  Escanea un proyecto existente y genera ficheros de configuración para agentes IA
  (AGENTS.md, CLAUDE.md, GEMINI.md, copilot-instructions.md, .cursor/rules/).
  Usar cuando el proyecto ya tiene código y se quiere configurar o actualizar
  la guía para herramientas de IA.
---

# Skill: AI Config — Proyecto existente

> **OBJETIVO**: Escanear el codebase, detectar stack/convenciones reales y generar ficheros de instrucciones optimizados para cada herramienta IA.

---

## FASE 1 — Escaneo automático (sin preguntar nada)

Ejecutar TODO en paralelo. Leer los ficheros que existan y guardar los hallazgos en memoria como un objeto `ProjectProfile`.

### 1.1 Dependencias y scripts

Leer `package.json` (o equivalente: `requirements.txt`, `Cargo.toml`, `go.mod`, `pom.xml`):
- `name`, `dependencies`, `devDependencies`
- `scripts` → extraer comandos de build, dev, lint, test, type-check
- Detectar package manager: buscar `pnpm-lock.yaml`, `yarn.lock`, `bun.lockb` o asumir npm

### 1.2 Configuración TypeScript/JavaScript

Leer `tsconfig.json` / `tsconfig.app.json` / `jsconfig.json`:
- `compilerOptions.strict`, `paths`, `target`
- `include`/`exclude`

### 1.3 Build tool

Buscar: `vite.config.*`, `webpack.config.*`, `next.config.*`, `nuxt.config.*`, `angular.json`, `astro.config.*`
- Extraer plugins, alias, proxy

### 1.4 Linter y formatter

Buscar: `eslint.config.*`, `.eslintrc*`, `oxlint`, `.prettierrc*`, `biome.json`, `.editorconfig`
- Registrar QUÉ linter se usa (no duplicar sus reglas en el AGENTS.md)

### 1.5 Testing

Buscar: `vitest.config.*`, `jest.config.*`, `playwright.config.*`, `cypress.config.*`
- Tipo de tests (unit, e2e), entorno (jsdom, node), patrón de co-localización vs carpeta tests/

### 1.6 Estructura de src/

Listar subdirectorios directos de `src/` (o `app/`, `lib/`, `pages/`):
- Detectar patrones: `components/`, `composables/` o `hooks/`, `stores/` o `store/`, `router/`, `i18n/`, `services/`, `views/` o `pages/`, `types/` o `interfaces/`, `utils/`, `plugins/`

### 1.7 Patrones de código (muestreo)

Leer 2-3 composables/hooks y 2-3 componentes para detectar:
- Patrón DI (imports de contenedores, tokens, inversify, etc.)
- State management (pinia, vuex, redux, zustand, mobx, signals)
- Routing (vue-router, react-router, next/router, file-based)
- i18n (vue-i18n, react-intl, i18next, next-intl)
- Patrón de errores (try/catch + ref, error boundaries, toast)
- Estilo de componentes (script setup, functional, class)

### 1.8 Ficheros IA existentes

Buscar: `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `.github/copilot-instructions.md`, `.windsurfrules`, `.cursor/rules/*.mdc`, `.cursorrules`
- Si existen, registrar para ofrecer actualizar en vez de sobrescribir

---

## FASE 2 — Presentar hallazgos y preguntar

### 2.1 Mostrar resumen al usuario

Mostrar el `ProjectProfile` detectado como tabla markdown legible. Ejemplo:

```
| Aspecto          | Detectado                          |
|------------------|------------------------------------|
| Lenguaje         | TypeScript                         |
| Framework        | Vue 3 (Composition API)            |
| Build            | Vite 7                             |
| Linter           | ESLint 9 + oxlint + Prettier       |
| Tests            | Vitest (unit) + Playwright (e2e)   |
| State            | Pinia                              |
| Router           | vue-router (modular, lazy loading) |
| i18n             | vue-i18n (es, en)                  |
| DI               | Contenedores propios (.resolve)    |
| Estructura       | composables/ → interfaces/ → ...   |
```

### 2.2 Preguntar con AskQuestion

**Pregunta 1** — Herramientas IA destino (multi-select):

```
id: ai-tools
prompt: "¿Para qué herramientas IA quieres generar ficheros?"
allow_multiple: true
options:
  - { id: "agents", label: "AGENTS.md (Codex, Cursor, Copilot, Windsurf)" }
  - { id: "claude", label: "CLAUDE.md (Claude Code)" }
  - { id: "gemini", label: "GEMINI.md (Gemini CLI)" }
  - { id: "copilot", label: ".github/copilot-instructions.md (GitHub Copilot)" }
  - { id: "cursor-rules", label: ".cursor/rules/ (Cursor rules adicionales)" }
  - { id: "all", label: "Todos" }
```

**Pregunta 2** — Idioma de los ficheros:

```
id: lang
prompt: "¿En qué idioma quieres los ficheros generados?"
options:
  - { id: "es", label: "Español" }
  - { id: "en", label: "English" }
```

**Pregunta 3** — Convenciones adicionales (texto libre si AskQuestion no soporta; si no, preguntar en chat):

> "¿Hay reglas de equipo que NO se puedan detectar del código? Ejemplos: prohibiciones específicas, convenciones de diseño, reglas sobre maquetas, restricciones de negocio..."

Si el usuario no aporta nada, continuar sin reglas adicionales.

### 2.3 Si existen ficheros IA previos

Preguntar:
```
id: overwrite
prompt: "Ya existen ficheros IA en el proyecto. ¿Qué quieres hacer?"
options:
  - { id: "replace", label: "Reemplazar con la versión nueva" }
  - { id: "merge", label: "Fusionar (mantener reglas existentes + añadir nuevas)" }
  - { id: "backup", label: "Crear backup (.bak) y generar nuevos" }
```

---

## FASE 3 — Generar ficheros

Para cada fichero seleccionado, seguir el formato y límites de la plataforma. Consultar [templates.md](templates.md) para la estructura exacta de cada fichero.

### Reglas universales de generación

1. **Comandos exactos**: usar los scripts reales de `package.json`, no inventar
2. **No duplicar linter**: si ESLint cubre indentación/comillas/semicolons, NO incluir esas reglas
3. **Solo convenciones no-obvias**: incluir lo que la IA no puede inferir sola del código
4. **Imperativo y conciso**: frases cortas tipo comando, no párrafos explicativos
5. **Estructura real del proyecto**: usar paths reales detectados, no genéricos

### Límites por plataforma

| Fichero | Límite | Formato |
|---------|--------|---------|
| `AGENTS.md` | <100 líneas (ideal <60) | Markdown con headings |
| `CLAUDE.md` | <200 líneas (ideal <80) | Markdown con headings |
| `GEMINI.md` | <100 líneas | Markdown, soporta `@imports` |
| `copilot-instructions.md` | <1000 líneas (primeros 4000 chars = los más importantes) | Markdown |
| `.cursor/rules/*.mdc` | <500 líneas cada uno | YAML frontmatter + Markdown |

### Secciones obligatorias en AGENTS.md (estándar cross-tool)

```markdown
# Proyecto — [nombre]

## Stack
[Lenguaje, framework, librerías core — 3-5 líneas]

## Comandos
[build, dev, lint, type-check, test:unit, test:e2e — exactos de package.json]

## Estructura
[Mapa de carpetas clave con su función — 5-10 líneas]

## Convenciones
[Solo reglas NO cubiertas por el linter — lista de bullets imperativos]

## Prohibiciones
[Lista explícita de lo que NO hacer]
```

### Secciones adicionales en CLAUDE.md

Además de lo de AGENTS.md, incluir:
- Sección `## Flujo de trabajo` con pasos típicos de desarrollo
- Sección `## Verificación` con checklist pre-commit

### Secciones en GEMINI.md

Mismo contenido que AGENTS.md pero con syntax `@imports` si hay ficheros de detalle.

### Reglas .cursor/rules/

Solo generar `.mdc` nuevos si NO existen ya reglas que cubran el tema. Cada fichero con frontmatter:

```yaml
---
description: "Cuándo aplicar esta regla"
globs: ["pattern/if/applicable"]
alwaysApply: true|false
---
```

---

## FASE 4 — Verificación y resumen

1. Contar líneas de cada fichero generado y verificar que no excede límites
2. Verificar que no hay reglas duplicadas entre ficheros (AGENTS.md no debe repetir lo de .cursor/rules/)
3. Mostrar al usuario un resumen:

```
✅ Ficheros generados:
  - AGENTS.md (47 líneas) — Codex, Cursor, Copilot, Windsurf
  - CLAUDE.md (62 líneas) — Claude Code
  - GEMINI.md (38 líneas) — Gemini CLI
  - .github/copilot-instructions.md (55 líneas) — GitHub Copilot

⚠️ Revisa las secciones marcadas con [CONFIRMAR] — son inferencias que necesitan validación.
```

4. Sugerir añadir los ficheros al `.gitignore` si son personales o al repo si son de equipo

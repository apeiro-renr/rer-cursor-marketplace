---
name: ai-config-new
description: >-
  Genera ficheros de configuración para agentes IA en un proyecto nuevo o recién
  iniciado (AGENTS.md, CLAUDE.md, GEMINI.md, copilot-instructions.md, .cursor/rules/).
  Usa un cuestionario interactivo para definir stack, arquitectura y convenciones
  desde cero. Usar cuando se está empezando un proyecto y se quiere configurar
  las herramientas IA desde el inicio.
---

# Skill: AI Config — Proyecto nuevo

> **OBJETIVO**: Mediante un cuestionario interactivo, definir el stack, arquitectura y convenciones del proyecto para generar ficheros de instrucciones IA optimizados desde el día 1.

---

## FASE 1 — Cuestionario interactivo

Usar `AskQuestion` para cada bloque de preguntas. Agrupar preguntas relacionadas en un solo bloque para minimizar la fricción.---
name: ai-config-new
description: >-
  Config IA para proyecto nuevo.
  Cuestionario + AGENTS.md; CLAUDE.md como stub a AGENTS si ambos se generan.
---

# Skill: AI Config — Proyecto nuevo

> **OBJETIVO**: Mediante un cuestionario interactivo, definir el stack, arquitectura y convenciones del proyecto para generar ficheros de instrucciones IA optimizados desde el día 1.

> **Multi-stack**: el perfil puede ser frontend (Vue, React…), backend (Java, Go, Django…), **solo testing** (Playwright/Jest harness), librería, CLI, full-stack, etc. Las preguntas de UI (state, i18n) son **N/A** en backend puro o en repos solo E2E; el agente debe omitirlas o fijar `none` y no mezclar convenciones de otro ecosistema.

---

## FASE 1 — Cuestionario interactivo

### AskQuestion vs chat

- **Si `AskQuestion` está disponible**: usarla para cada bloque, agrupando preguntas relacionadas en un solo bloque.
- **Si no está disponible** (modelo sin la herramienta, error al invocarla): **1)** Cuestionario en navegador; **2)** si el usuario prefiere, chat con el formato **1.1**. No detener el flujo por falta de AskQuestion.

**Navegador**: `http://localhost:7890/ai-config-wizard.html#new` con el servidor de **init-work** en marcha (`.cursor/skills/init-work/tool`), o abrir `.cursor/skills/init-work/tool/public/ai-config-wizard.html` y la pestaña «Proyecto nuevo». El JSON incluye `"flow": "ai-config-new"` y las claves alineadas con el fallback 1.1 (`language`, `framework`, `build-tool`, etc.). El usuario pega el JSON (o el bloque clave:valor) en el chat.

### 1.1 Fallback por chat (sin AskQuestion)

Tras presentar las opciones de cada bloque en markdown, pedir al usuario un único bloque copiable, por ejemplo:

```
project-surface: frontend
language: ts
framework: vue3
build-tool: vite
linter: eslint,prettier
testing: vitest,playwright
architecture: clean
state-mgmt: pinia
di: typed-inject
i18n: vue-i18n
ai-tools: all
lang: es
team: ninguna
```

- `project-surface` (opcional si ya es obvio por el resto): `frontend` | `backend` | `fullstack` | `library` | `testing` | `cli` | `mobile` | `other`.
- Valores deben coincidir con los `id` de las opciones documentadas en cada pregunta; multi-select como lista separada por comas.
- Si eligió `other` en alguna clave, añadir en la misma línea o en `team` la aclaración (ej. `framework: other` y en `team`: "SolidStart").
- Si el usuario escribe **`defecto`** o no especifica campos opcionales, inferir lo razonable para el stack declarado o usar: TypeScript, Vue 3 o React según contexto, Vite, ESLint+Prettier, Vitest, arquitectura `feature` o `clean`, `all` para `ai-tools`, `es` para `lang`.

El bloque 4 (convenciones en texto libre) puede ir en la clave `team` o en mensajes siguientes.

### Bloque 1: Stack técnico

```
Pregunta 0:
  id: project-surface
  prompt: "¿Qué tipo de proyecto es? (condiciona qué convenciones y preguntas aplican)"
  options:
    - { id: "frontend", label: "Frontend (SPA, web)" }
    - { id: "backend", label: "Backend (API, servicios, jobs)" }
    - { id: "fullstack", label: "Full-stack (mismo repo front + back)" }
    - { id: "library", label: "Librería / paquete publicable" }
    - { id: "testing", label: "Centrado en testing (E2E, harness, QA automation)" }
    - { id: "cli", label: "CLI / herramienta de terminal" }
    - { id: "mobile", label: "Móvil" }
    - { id: "other", label: "Otro (indicar en chat)" }

Pregunta 1:
  id: language
  prompt: "¿Cuál es el lenguaje principal del proyecto?"
  options:
    - { id: "ts", label: "TypeScript" }
    - { id: "js", label: "JavaScript" }
    - { id: "python", label: "Python" }
    - { id: "go", label: "Go" }
    - { id: "rust", label: "Rust" }
    - { id: "java", label: "Java / Kotlin" }
    - { id: "csharp", label: "C# / .NET" }
    - { id: "other", label: "Otro (indicar en chat)" }

Pregunta 2:
  id: framework
  prompt: "¿Qué framework vas a usar?"
  options:
    - { id: "vue3", label: "Vue 3" }
    - { id: "nuxt", label: "Nuxt 3" }
    - { id: "react", label: "React" }
    - { id: "nextjs", label: "Next.js" }
    - { id: "angular", label: "Angular" }
    - { id: "svelte", label: "Svelte / SvelteKit" }
    - { id: "astro", label: "Astro" }
    - { id: "express", label: "Express / Fastify (backend)" }
    - { id: "django", label: "Django / Flask (Python)" }
    - { id: "none", label: "Sin framework" }
    - { id: "other", label: "Otro (indicar en chat)" }

Pregunta 3:
  id: build-tool
  prompt: "¿Qué build tool / bundler? (o build JVM si aplica)"
  options:
    - { id: "vite", label: "Vite" }
    - { id: "webpack", label: "Webpack" }
    - { id: "turbopack", label: "Turbopack (Next.js)" }
    - { id: "esbuild", label: "esbuild" }
    - { id: "rollup", label: "Rollup" }
    - { id: "maven", label: "Maven (Java)" }
    - { id: "gradle", label: "Gradle (Java/Kotlin)" }
    - { id: "none", label: "Ninguno / runtime nativo" }
    - { id: "other", label: "Otro" }
```

**Condicionar con `project-surface`**: si `backend` + Java, priorizar Maven/Gradle en la explicación al usuario; si `testing`, build puede ser `none` o el del runner (p. ej. Vitest como único “build” de tests); si `frontend`, bundler habitual (Vite/Webpack).

### Bloque 2: Herramientas de calidad

```
Pregunta 4:
  id: linter
  prompt: "¿Qué linter/formatter vas a usar?"
  allow_multiple: true
  options:
    - { id: "eslint", label: "ESLint" }
    - { id: "prettier", label: "Prettier" }
    - { id: "oxlint", label: "oxlint" }
    - { id: "biome", label: "Biome" }
    - { id: "ruff", label: "Ruff (Python)" }
    - { id: "clippy", label: "Clippy (Rust)" }
    - { id: "checkstyle", label: "Checkstyle / SpotBugs (Java, vía config equipo)" }
    - { id: "none", label: "Ninguno por ahora" }

Pregunta 5:
  id: testing
  prompt: "¿Qué framework de testing?"
  allow_multiple: true
  options:
    - { id: "vitest", label: "Vitest" }
    - { id: "jest", label: "Jest" }
    - { id: "playwright", label: "Playwright (E2E)" }
    - { id: "cypress", label: "Cypress (E2E)" }
    - { id: "pytest", label: "pytest (Python)" }
    - { id: "junit", label: "JUnit (Java)" }
    - { id: "none", label: "Sin tests por ahora" }
```

Si `project-surface: testing`, destacar Playwright/Cypress/Jest como stack principal y no forzar framework SPA en las convenciones salvo que el usuario lo pida.

### Bloque 3: Arquitectura

```
Pregunta 6:
  id: architecture
  prompt: "¿Qué patrón arquitectónico vas a seguir?"
  options:
    - { id: "clean", label: "Clean Architecture (capas: dominio → aplicación → infra → UI)" }
    - { id: "feature", label: "Feature-based (carpeta por feature)" }
    - { id: "mvc", label: "MVC / MVVM" }
    - { id: "hexagonal", label: "Hexagonal / Ports & Adapters" }
    - { id: "monolith-simple", label: "Monolito simple (sin capas formales)" }
    - { id: "micro", label: "Microservicios" }
    - { id: "undecided", label: "Aún no lo tengo claro" }

Pregunta 7:
  id: state-mgmt
  prompt: "¿State management? (N/A en backend puro, library o testing sin UI — elegir none)"
  options:
    - { id: "pinia", label: "Pinia" }
    - { id: "vuex", label: "Vuex" }
    - { id: "redux", label: "Redux / Redux Toolkit" }
    - { id: "zustand", label: "Zustand" }
    - { id: "mobx", label: "MobX" }
    - { id: "signals", label: "Signals (Angular/Preact)" }
    - { id: "context", label: "Context API / composables puros" }
    - { id: "none", label: "Sin state management global" }

Pregunta 8:
  id: di
  prompt: "¿Inyección de dependencias?"
  options:
    - { id: "typed-inject", label: "typed-inject" }
    - { id: "inversify", label: "Inversify" }
    - { id: "tsyringe", label: "tsyringe" }
    - { id: "manual", label: "Manual (factory functions / contenedores propios)" }
    - { id: "none", label: "Sin DI formal" }

Pregunta 9:
  id: i18n
  prompt: "¿Internacionalización? (omitir / none si es API-only, CLI o repo solo tests)"
  options:
    - { id: "vue-i18n", label: "vue-i18n" }
    - { id: "react-intl", label: "react-intl / FormatJS" }
    - { id: "i18next", label: "i18next / next-intl" }
    - { id: "none", label: "Sin i18n" }
```

### Bloque 4: Convenciones del equipo

Preguntar en chat (no sirve AskQuestion para texto libre):

> "Describe brevemente las convenciones más importantes de tu equipo que la IA debe respetar. Ejemplos:
> - Dónde van las interfaces (inline, carpeta separada, co-localizadas)
> - Patrón de componentes (dumb/smart, container/presentational)
> - Patrón de errores (try/catch + ref, error boundaries, toast)
> - Naming de ficheros (kebab-case, PascalCase, sufijos como .service.ts)
> - Cualquier prohibición específica
>
> Si no tienes convenciones definidas aún, dilo y te sugiero las mejores prácticas para tu stack."

Si el usuario no tiene convenciones, sugerir las mejores prácticas estándar para el stack elegido.

### Bloque 5: Herramientas IA destino

```
Pregunta 11:
  id: ai-tools
  prompt: "¿Para qué herramientas IA quieres generar ficheros?"
  allow_multiple: true
  options:
    - { id: "agents", label: "AGENTS.md (Codex, Cursor, Copilot, Windsurf)" }
    - { id: "claude", label: "CLAUDE.md (Claude Code)" }
    - { id: "gemini", label: "GEMINI.md (Gemini CLI)" }
    - { id: "copilot", label: ".github/copilot-instructions.md (GitHub Copilot)" }
    - { id: "cursor-rules", label: ".cursor/rules/ (Cursor rules)" }
    - { id: "all", label: "Todos" }

Pregunta 12:
  id: lang
  prompt: "¿En qué idioma quieres los ficheros?"
  options:
    - { id: "es", label: "Español" }
    - { id: "en", label: "English" }
```

---

## FASE 2 — Construir el ProjectProfile

Con las respuestas, construir en memoria un objeto con:

```
ProjectProfile:
  name: [nombre del directorio o preguntar]
  projectSurface: [respuesta P0: frontend | backend | fullstack | library | testing | cli | mobile | other]
  language: [respuesta P1]
  framework: [respuesta P2]
  buildTool: [respuesta P3]
  linters: [respuesta P4]
  testing: [respuesta P5]
  architecture: [respuesta P6]
  stateManagement: [respuesta P7]
  di: [respuesta P8]
  i18n: [respuesta P9]
  conventions: [texto libre del usuario o sugerencias]
  aiTools: [Bloque 5 — ids: agents, claude, gemini, copilot, cursor-rules, all]
  outputLang: [Bloque 5 — es | en]
```

### Si la arquitectura es "undecided"

Sugerir la mejor opción para el stack elegido con una explicación de 2-3 frases. Preguntar si aceptan la sugerencia. Opciones sugeridas por stack:

- **Vue 3 / Nuxt**: Feature-based o Clean Architecture con composables como adaptadores
- **React / Next.js**: Feature-based con hooks como capa de aplicación
- **Angular**: Feature modules con servicios inyectados
- **Express / Fastify**: Clean Architecture o Hexagonal con casos de uso
- **Django**: Django apps como módulos, services layer
- **Java / Spring**: capas por paquete (`domain`, `application`, `infrastructure`, `api`) o por feature
- **Monorepo**: Clean Architecture por paquete
- **testing** (E2E): `e2e/` o `tests/`, fixtures, page objects; convenciones de reports/trazas

### Inferir estructura de carpetas

Generar una estructura recomendada basada en `projectSurface` + framework + arquitectura:

**Ejemplo Java + capas:**
```
src/main/java/<base>/
  domain/
  application/
  infrastructure/
  api/ (o adapters/incoming)
src/test/java/<base>/
```

**Ejemplo proyecto testing / E2E:**
```
e2e/ o tests/
  specs/
  fixtures/
  pages/   (Playwright)
```

**Ejemplo Vue 3 + Clean Architecture:**
```
src/
  components/     → presentación (dumb)
  composables/    → lógica (adaptadores al core)
    [módulo]/
      interfaces/ → tipos del módulo
      use*.ts     → composables
  views/          → vistas por feature
  stores/         → Pinia stores
  router/         → rutas modulares
  i18n/           → traducciones
  services/       → servicios técnicos
  plugins/        → DI, inicialización
  types/          → tipos compartidos
```

### Inferir comandos

Generar comandos estándar basados en el stack:

| Stack | Dev | Build | Lint | Test |
|-------|-----|-------|------|------|
| Vite + Vue/React | `npm run dev` | `npm run build` | `npm run lint` | `npm run test` |
| Next.js | `npm run dev` | `npm run build` | `npm run lint` | `npm run test` |
| Django | `python manage.py runserver` | — | `ruff check .` | `pytest` |
| Go | `go run .` | `go build` | `golangci-lint run` | `go test ./...` |
| Java (Maven) | — | `mvn package` | plugins equipo | `mvn test` |
| Java (Gradle) | — | `./gradlew build` | plugins equipo | `./gradlew test` |
| Solo E2E (Node) | `npx playwright test` (ej.) | — | ESLint opcional | comando E2E elegido |

Marcar los comandos como `[AJUSTAR]` para que el usuario los revise.

---

## FASE 3 — Generar ficheros

Alinear con la skill **`ai-config-existing`** (reglas de límites, sin duplicar linter, una fuente de verdad). Plantillas: [`.cursor/skills/ai-config-existing/templates.md`](../ai-config-existing/templates.md).

### Reglas de ficheros (igual que `ai-config-existing`)

1. **AGENTS.md**: fuente canónica de stack, comandos `[AJUSTAR]`, estructura recomendada, convenciones y prohibiciones (<100 líneas, ideal <60).
2. **CLAUDE.md**: si también se genera **`AGENTS.md`**, usar **stub &lt;20 líneas** que apunte a `AGENTS.md` (sin duplicar tablas ni flujos). Si el usuario **solo** elige `claude`, hasta ~80 líneas con el mismo nivel que AGENTS. **No** recomendar symlink `CLAUDE` → `AGENTS`.
3. **GEMINI.md**: conciso; si hay `AGENTS.md`, preferir `@./AGENTS.md` para detalle.
4. **`.cursor/rules/*.mdc`**: `description` corta, `globs` acordes al **ecosistema real** (`**/*.java`, `src/**/*.kt`, `**/*.cs`, `e2e/**/*.ts`, etc.); no copiar globs Vue/JavaScript a un repo solo Java o solo Playwright.

### Multi-stack (obligatorio)

- **Ejemplos de código** en AGENTS o reglas: **un solo** snippet acorde al `ProjectProfile` (p. ej. composable Vue, hook React, **servicio/caso de uso Java**, handler Go, test pytest, **spec Playwright**). No mezclar Vue en un perfil `backend` Java.
- **`project-surface: testing`**: convenciones de carpetas E2E, aislamiento de datos, nombres de spec; sin estado global SPA salvo que haya app bajo test.
- **`backend`**: omitir o marcar `none` state/i18n en el texto generado; DI puede ser Spring, Dagger, manual según respuestas.
- **`fullstack`**: si un solo AGENTS cubre ambas partes, dos subsecciones breves **Frontend** / **Backend** o nota de monorepo con rutas `apps/web`, `apps/api`.

### Diferencias con la skill de proyecto existente

1. **Comandos**: marcados con `[AJUSTAR]` ya que no hay `package.json` / `pom.xml` real aún en muchos casos
2. **Estructura**: es una RECOMENDACIÓN, no una detección — indicar que puede cambiar
3. **Convenciones**: si el usuario no tenía definidas, incluir las mejores prácticas estándar **del stack elegido** con nota de que son sugeridas
4. **Ejemplos de código**: un ejemplo corto del patrón del stack (ver §Multi-stack)

### Contenido extra para proyectos nuevos

Añadir al final del AGENTS.md una sección temporal:

```markdown
## Setup inicial

Stack previsto: [npm/pnpm/yarn | Maven | Gradle | pip | otro]. Para arrancar:

\`\`\`bash
[comando de instalación de dependencias]
[comando de desarrollo o de tests según project-surface]
\`\`\`

> Nota: Este fichero fue generado al inicio del proyecto. Actualizarlo cuando
> la estructura real difiera de la recomendada. Usar la skill `ai-config-existing`
> para regenerar basándose en el código real.
```

Adaptar los comandos del bloque anterior al `ProjectProfile` (p. ej. backend Java: `mvn verify`; repo solo Playwright: `npm ci` + `npx playwright install`).

---

## FASE 4 — Verificación y resumen

1. Verificar límites por plataforma (AGENTS, CLAUDE stub si aplica, GEMINI, copilot, `.mdc`)
2. Comprobar que **no** hay contenido duplicado entre `AGENTS.md` y `CLAUDE.md` cuando ambos existen
3. Comprobar que ejemplos y globs de reglas **coinciden** con `projectSurface` + lenguaje (sin Vue en Java puro, etc.)
4. Mostrar resumen de ficheros generados (si `CLAUDE.md` es stub, indicar «stub → AGENTS.md»)
5. Recordar al usuario:

```
📝 Estos ficheros son un punto de partida. Cuando el proyecto avance:
  - Ejecuta la skill "ai-config-existing" para regenerar basándose en código real
  - Actualiza manualmente las secciones marcadas con [AJUSTAR]
  - Añade prohibiciones y convenciones a medida que las descubras
```


### Bloque 1: Stack técnico

```
Pregunta 1:
  id: language
  prompt: "¿Cuál es el lenguaje principal del proyecto?"
  options:
    - { id: "ts", label: "TypeScript" }
    - { id: "js", label: "JavaScript" }
    - { id: "python", label: "Python" }
    - { id: "go", label: "Go" }
    - { id: "rust", label: "Rust" }
    - { id: "java", label: "Java / Kotlin" }
    - { id: "csharp", label: "C# / .NET" }
    - { id: "other", label: "Otro (indicar en chat)" }

Pregunta 2:
  id: framework
  prompt: "¿Qué framework vas a usar?"
  options:
    - { id: "vue3", label: "Vue 3" }
    - { id: "nuxt", label: "Nuxt 3" }
    - { id: "react", label: "React" }
    - { id: "nextjs", label: "Next.js" }
    - { id: "angular", label: "Angular" }
    - { id: "svelte", label: "Svelte / SvelteKit" }
    - { id: "astro", label: "Astro" }
    - { id: "express", label: "Express / Fastify (backend)" }
    - { id: "django", label: "Django / Flask (Python)" }
    - { id: "none", label: "Sin framework" }
    - { id: "other", label: "Otro (indicar en chat)" }

Pregunta 3:
  id: build-tool
  prompt: "¿Qué build tool / bundler?"
  options:
    - { id: "vite", label: "Vite" }
    - { id: "webpack", label: "Webpack" }
    - { id: "turbopack", label: "Turbopack (Next.js)" }
    - { id: "esbuild", label: "esbuild" }
    - { id: "rollup", label: "Rollup" }
    - { id: "none", label: "Ninguno / runtime nativo" }
    - { id: "other", label: "Otro" }
```

### Bloque 2: Herramientas de calidad

```
Pregunta 4:
  id: linter
  prompt: "¿Qué linter/formatter vas a usar?"
  allow_multiple: true
  options:
    - { id: "eslint", label: "ESLint" }
    - { id: "prettier", label: "Prettier" }
    - { id: "oxlint", label: "oxlint" }
    - { id: "biome", label: "Biome" }
    - { id: "ruff", label: "Ruff (Python)" }
    - { id: "clippy", label: "Clippy (Rust)" }
    - { id: "none", label: "Ninguno por ahora" }

Pregunta 5:
  id: testing
  prompt: "¿Qué framework de testing?"
  allow_multiple: true
  options:
    - { id: "vitest", label: "Vitest" }
    - { id: "jest", label: "Jest" }
    - { id: "playwright", label: "Playwright (E2E)" }
    - { id: "cypress", label: "Cypress (E2E)" }
    - { id: "pytest", label: "pytest (Python)" }
    - { id: "none", label: "Sin tests por ahora" }
```

### Bloque 3: Arquitectura

```
Pregunta 6:
  id: architecture
  prompt: "¿Qué patrón arquitectónico vas a seguir?"
  options:
    - { id: "clean", label: "Clean Architecture (capas: dominio → aplicación → infra → UI)" }
    - { id: "feature", label: "Feature-based (carpeta por feature)" }
    - { id: "mvc", label: "MVC / MVVM" }
    - { id: "hexagonal", label: "Hexagonal / Ports & Adapters" }
    - { id: "monolith-simple", label: "Monolito simple (sin capas formales)" }
    - { id: "micro", label: "Microservicios" }
    - { id: "undecided", label: "Aún no lo tengo claro" }

Pregunta 7:
  id: state-mgmt
  prompt: "¿State management?"
  options:
    - { id: "pinia", label: "Pinia" }
    - { id: "vuex", label: "Vuex" }
    - { id: "redux", label: "Redux / Redux Toolkit" }
    - { id: "zustand", label: "Zustand" }
    - { id: "mobx", label: "MobX" }
    - { id: "signals", label: "Signals (Angular/Preact)" }
    - { id: "context", label: "Context API / composables puros" }
    - { id: "none", label: "Sin state management global" }

Pregunta 8:
  id: di
  prompt: "¿Inyección de dependencias?"
  options:
    - { id: "typed-inject", label: "typed-inject" }
    - { id: "inversify", label: "Inversify" }
    - { id: "tsyringe", label: "tsyringe" }
    - { id: "manual", label: "Manual (factory functions / contenedores propios)" }
    - { id: "none", label: "Sin DI formal" }

Pregunta 9:
  id: i18n
  prompt: "¿Internacionalización?"
  options:
    - { id: "vue-i18n", label: "vue-i18n" }
    - { id: "react-intl", label: "react-intl / FormatJS" }
    - { id: "i18next", label: "i18next / next-intl" }
    - { id: "none", label: "Sin i18n" }
```

### Bloque 4: Convenciones del equipo

Preguntar en chat (no sirve AskQuestion para texto libre):

> "Describe brevemente las convenciones más importantes de tu equipo que la IA debe respetar. Ejemplos:
> - Dónde van las interfaces (inline, carpeta separada, co-localizadas)
> - Patrón de componentes (dumb/smart, container/presentational)
> - Patrón de errores (try/catch + ref, error boundaries, toast)
> - Naming de ficheros (kebab-case, PascalCase, sufijos como .service.ts)
> - Cualquier prohibición específica
>
> Si no tienes convenciones definidas aún, dilo y te sugiero las mejores prácticas para tu stack."

Si el usuario no tiene convenciones, sugerir las mejores prácticas estándar para el stack elegido.

### Bloque 5: Herramientas IA destino

```
Pregunta 10:
  id: ai-tools
  prompt: "¿Para qué herramientas IA quieres generar ficheros?"
  allow_multiple: true
  options:
    - { id: "agents", label: "AGENTS.md (Codex, Cursor, Copilot, Windsurf)" }
    - { id: "claude", label: "CLAUDE.md (Claude Code)" }
    - { id: "gemini", label: "GEMINI.md (Gemini CLI)" }
    - { id: "copilot", label: ".github/copilot-instructions.md (GitHub Copilot)" }
    - { id: "cursor-rules", label: ".cursor/rules/ (Cursor rules)" }
    - { id: "all", label: "Todos" }

Pregunta 11:
  id: lang
  prompt: "¿En qué idioma quieres los ficheros?"
  options:
    - { id: "es", label: "Español" }
    - { id: "en", label: "English" }
```

---

## FASE 2 — Construir el ProjectProfile

Con las respuestas, construir en memoria un objeto con:

```
ProjectProfile:
  name: [nombre del directorio o preguntar]
  language: [respuesta P1]
  framework: [respuesta P2]
  buildTool: [respuesta P3]
  linters: [respuesta P4]
  testing: [respuesta P5]
  architecture: [respuesta P6]
  stateManagement: [respuesta P7]
  di: [respuesta P8]
  i18n: [respuesta P9]
  conventions: [texto libre del usuario o sugerencias]
  aiTools: [respuesta P10]
  outputLang: [respuesta P11]
```

### Si la arquitectura es "undecided"

Sugerir la mejor opción para el stack elegido con una explicación de 2-3 frases. Preguntar si aceptan la sugerencia. Opciones sugeridas por stack:

- **Vue 3 / Nuxt**: Feature-based o Clean Architecture con composables como adaptadores
- **React / Next.js**: Feature-based con hooks como capa de aplicación
- **Angular**: Feature modules con servicios inyectados
- **Express / Fastify**: Clean Architecture o Hexagonal con casos de uso
- **Django**: Django apps como módulos, services layer
- **Monorepo**: Clean Architecture por paquete

### Inferir estructura de carpetas

Generar una estructura recomendada basada en framework + arquitectura:

**Ejemplo Vue 3 + Clean Architecture:**
```
src/
  components/     → presentación (dumb)
  composables/    → lógica (adaptadores al core)
    [módulo]/
      interfaces/ → tipos del módulo
      use*.ts     → composables
  views/          → vistas por feature
  stores/         → Pinia stores
  router/         → rutas modulares
  i18n/           → traducciones
  services/       → servicios técnicos
  plugins/        → DI, inicialización
  types/          → tipos compartidos
```

### Inferir comandos

Generar comandos estándar basados en el stack:

| Stack | Dev | Build | Lint | Test |
|-------|-----|-------|------|------|
| Vite + Vue/React | `npm run dev` | `npm run build` | `npm run lint` | `npm run test` |
| Next.js | `npm run dev` | `npm run build` | `npm run lint` | `npm run test` |
| Django | `python manage.py runserver` | — | `ruff check .` | `pytest` |
| Go | `go run .` | `go build` | `golangci-lint run` | `go test ./...` |

Marcar los comandos como `[AJUSTAR]` para que el usuario los revise.

---

## FASE 3 — Generar ficheros

Seguir exactamente las mismas reglas y templates que la skill `ai-config-existing`. Consultar [templates.md](templates.md) para la estructura de cada fichero (symlink al fichero compartido en `ai-config-existing/`).

### Diferencias con la skill de proyecto existente

1. **Comandos**: marcados con `[AJUSTAR]` ya que no hay `package.json` real aún
2. **Estructura**: es una RECOMENDACIÓN, no una detección — indicar que puede cambiar
3. **Convenciones**: si el usuario no tenía definidas, incluir las mejores prácticas estándar del stack con nota de que son sugeridas
4. **Ejemplos de código**: incluir 1 ejemplo corto del patrón correcto para composables/hooks/servicios

### Contenido extra para proyectos nuevos

Añadir al final del AGENTS.md una sección temporal:

```markdown
## Setup inicial

Este proyecto usa [package manager]. Para arrancar:

\`\`\`bash
[comando de instalación]
[comando de dev server]
\`\`\`

> Nota: Este fichero fue generado al inicio del proyecto. Actualizarlo cuando
> la estructura real difiera de la recomendada. Usar la skill `ai-config-existing`
> para regenerar basándose en el código real.
```

---

## FASE 4 — Verificación y resumen

1. Verificar límites de líneas por plataforma
2. Mostrar resumen de ficheros generados
3. Recordar al usuario:

```
📝 Estos ficheros son un punto de partida. Cuando el proyecto avance:
  - Ejecuta la skill "ai-config-existing" para regenerar basándose en código real
  - Actualiza manualmente las secciones marcadas con [AJUSTAR]
  - Añade prohibiciones y convenciones a medida que las descubras
```

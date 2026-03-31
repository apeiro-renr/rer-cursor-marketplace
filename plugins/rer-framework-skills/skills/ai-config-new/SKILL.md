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

Usar `AskQuestion` para cada bloque de preguntas. Agrupar preguntas relacionadas en un solo bloque para minimizar la fricción.

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

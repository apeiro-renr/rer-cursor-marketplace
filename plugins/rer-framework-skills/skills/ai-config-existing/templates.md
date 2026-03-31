# Templates de ficheros IA por plataforma

Referencia de estructura para cada fichero. Rellenar con datos reales del `ProjectProfile`.

---

## AGENTS.md (cross-tool: Codex, Cursor, Copilot, Windsurf)

Máximo 100 líneas. Imperativo. Sin prosa.

```markdown
# [Nombre del proyecto]

## Stack

- [Lenguaje] + [Framework] ([variante: Composition API, App Router, etc.])
- [Librerías core con rol]: [lib1] (UI), [lib2] (dominio)
- [State management], [Router], [i18n]

## Comandos

| Acción | Comando |
|--------|---------|
| Dev server | `[comando real]` |
| Build | `[comando real]` |
| Lint | `[comando real]` |
| Type check | `[comando real]` |
| Test unit | `[comando real]` |
| Test e2e | `[comando real]` |

## Estructura

[path1]/ → [función: composables con lógica de negocio]
[path2]/ → [función: componentes de presentación]
[path3]/ → [función: stores globales]
[path4]/ → [función: rutas modulares]
[path5]/ → [función: traducciones]

## Convenciones

- [Regla 1: patrón DI o inyección]
- [Regla 2: dónde van las interfaces/tipos]
- [Regla 3: patrón de errores]
- [Regla 4: regla de componentes (dumb/smart)]
- [Regla 5: regla de tests (co-localización, naming)]
- [Reglas adicionales del usuario]

## Prohibiciones

- No [prohibición 1]
- No [prohibición 2]
- No [prohibición 3]
```

---

## CLAUDE.md (Claude Code)

Máximo 200 líneas. Headings + Markdown. Más detallado que AGENTS.md.

```markdown
# [Nombre del proyecto]

## Stack

[Mismo contenido que AGENTS.md, puede ser ligeramente más detallado]

## Comandos

[Mismo formato tabla que AGENTS.md]

## Estructura del proyecto

[Mismo mapa de carpetas, puede incluir 1 nivel más de detalle]

## Convenciones de código

[Mismas reglas que AGENTS.md, puede incluir ejemplos cortos inline]

### Ejemplo de composable correcto

\`\`\`typescript
import type { MiTipo } from "./interfaces/mi-modulo.interfaces";

export const useMiComposable = () => {
  const container = getContainer().resolve(TOKEN);
  const loading = ref(false);
  const error = ref("");

  const ejecutar = async () => {
    loading.value = true;
    try {
      // lógica
    } catch {
      error.value = t("clave.error");
    } finally {
      loading.value = false;
    }
  };

  return { loading, error, ejecutar };
};
\`\`\`

## Prohibiciones

[Mismas que AGENTS.md]

## Flujo de trabajo

1. Leer el ticket/requisito completo antes de codificar
2. Identificar ficheros afectados con búsqueda en el codebase
3. Implementar cambios siguiendo las convenciones
4. Ejecutar `[lint command]` y `[type-check command]`
5. Ejecutar `[test command]` para verificar que no se rompe nada
6. Revisar los cambios con `git diff`

## Verificación pre-commit

- [ ] `[lint command]` pasa sin errores
- [ ] `[type-check command]` pasa sin errores
- [ ] `[test command]` pasa
- [ ] No hay `any` ni `unknown` en el código nuevo
- [ ] No hay comentarios innecesarios
- [ ] Las interfaces están en la carpeta correcta
```

---

## GEMINI.md (Gemini CLI)

Máximo 100 líneas. Soporta `@file.md` para imports.

```markdown
# [Nombre del proyecto]

## Stack

[Mismo que AGENTS.md, conciso]

## Comandos

[Formato tabla]

## Estructura

[Mapa de carpetas]

## Convenciones

[Lista de bullets]

## Prohibiciones

[Lista de bullets]
```

Si el proyecto tiene convenciones extensas, usar `@imports`:
```markdown
## Convenciones detalladas

@./AGENTS.md
```

---

## .github/copilot-instructions.md (GitHub Copilot)

Máximo 1000 líneas. Los primeros 4000 caracteres son los más importantes (Copilot Code Review solo lee esos).

```markdown
# [Nombre del proyecto]

[Descripción en 1-2 frases: qué es, audiencia, tecnología principal]

## Tech Stack

[Mismo que AGENTS.md]

## Comandos de desarrollo

[Formato tabla]

## Estructura del proyecto

[Mapa de carpetas]

## Estándares de código

[Convenciones + prohibiciones combinadas en una sección]

## Patrones preferidos

[Ejemplos cortos de código correcto vs incorrecto si aplica]

## Testing

[Framework, comandos, convención de ubicación de tests]
```

---

## .cursor/rules/*.mdc (Cursor IDE)

Cada fichero tiene frontmatter YAML. Generar SOLO si no existe ya una regla que cubra el tema.

### Regla always-apply (convenciones globales):

```yaml
---
description: "Convenciones globales del proyecto [nombre]"
alwaysApply: true
---

[Contenido similar a la sección Convenciones del AGENTS.md]
```

### Regla por glob (ej: composables):

```yaml
---
description: "Convenciones para composables"
globs: ["src/composables/**/*.ts"]
alwaysApply: false
---

[Reglas específicas de composables: DI, interfaces, patrón de errores]
```

### Regla por glob (ej: componentes Vue):

```yaml
---
description: "Convenciones para componentes Vue"
globs: ["src/components/**/*.vue", "src/views/**/*.vue"]
alwaysApply: false
---

[Reglas específicas: template limpio, sin lógica, props tipadas]
```

---

## Reglas .cursor/rules/ por stack (proyectos nuevos)

Cuando el proyecto es nuevo y no hay reglas existentes, generar las iniciales según el stack.

### Vue 3

**`general.mdc`** (alwaysApply: true):
- TypeScript estricto, Composition API, script setup
- Convenciones de naming del equipo

**`composables.mdc`** (globs: `src/composables/**/*.ts`):
- Interfaces en carpeta separada
- Patrón de retorno explícito
- DI desde contenedores, no imports directos

**`components.mdc`** (globs: `src/components/**/*.vue`, `src/views/**/*.vue`):
- Sin lógica, delegarla a composables
- Props tipadas explícitamente
- Template máximo 1 scroll

### React

**`general.mdc`** (alwaysApply: true):
- TypeScript estricto, functional components
- Convenciones de naming

**`hooks.mdc`** (globs: `src/hooks/**/*.ts`):
- Prefijo use*, retorno tipado
- Custom hooks para lógica compartida

**`components.mdc`** (globs: `src/components/**/*.tsx`):
- Props con interface, no inline type
- Memoización cuando sea necesario

### Python

**`general.mdc`** (alwaysApply: true):
- Type hints obligatorios
- Docstrings en funciones públicas
- Convenciones PEP 8

### Go

**`general.mdc`** (alwaysApply: true):
- Error handling explícito
- Interfaces pequeñas
- Package naming conventions

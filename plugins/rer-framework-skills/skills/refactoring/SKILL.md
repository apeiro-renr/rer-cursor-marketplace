---
name: refactoring
description: Mejorar la estructura interna del código sin cambiar su comportamiento
  externo, aplicando técnicas de refactorización de forma incremental y segura.
  Usar cuando el usuario pide refactorizar, reestructurar, limpiar, simplificar,
  extraer, renombrar, o mejorar código existente sin alterar funcionalidad.
  Use when the user asks to refactor, restructure, clean up, simplify,
  extract, rename, or improve existing code without changing behavior.
---

# Refactorización

Workflow para mejorar la estructura del código preservando su comportamiento externo.

## Flujo general

```
Objetivo → Cobertura de tests → Análisis → Plan incremental → Ejecución → Validación
```

## Fase 1: Definir objetivo y alcance

### Recopilar información

1. **Objetivo concreto**: Qué mejorar y por qué (legibilidad, mantenibilidad, rendimiento, eliminar duplicación)
2. **Alcance**: Archivos y módulos afectados
3. **Restricciones**: API pública inmutable, backward compatibility, rendimiento mínimo
4. **Riesgo**: Impacto en sistemas dependientes

### Checklist de análisis

```
Análisis de refactorización:
- [ ] Objetivo concreto definido (qué y por qué)
- [ ] Alcance delimitado (archivos/módulos)
- [ ] Restricciones identificadas (API pública, compatibilidad)
- [ ] Sistemas dependientes evaluados
- [ ] Code smells específicos identificados
```

### Si falta información

Preguntar al usuario antes de avanzar:
- "¿Se puede modificar la API pública o debe mantenerse intacta?"
- "¿Hay restricciones de rendimiento a respetar?"
- "¿Qué tests existen actualmente para este código?"

## Fase 2: Asegurar red de seguridad (tests)

**Regla fundamental**: No refactorizar código sin cobertura de tests adecuada.

### Evaluar cobertura existente

1. Ejecutar tests existentes y confirmar que pasan
2. Identificar gaps de cobertura en el código a refactorizar
3. Si la cobertura es insuficiente: **escribir tests antes de refactorizar**

### Tests de caracterización

Si el código carece de tests y su comportamiento no está documentado:

1. Escribir tests que capturen el comportamiento actual (incluidos bugs conocidos)
2. Usar los outputs actuales como asserts (snapshot del comportamiento)
3. Estos tests actúan como red de seguridad, no como validación de correctitud

```
Red de seguridad:
- [ ] Tests existentes pasan (green baseline)
- [ ] Gaps de cobertura identificados
- [ ] Tests adicionales escritos si cobertura era insuficiente
- [ ] Comportamiento actual capturado en tests
```

## Fase 3: Análisis y selección de técnicas

### Identificar code smells

Buscar en el código a refactorizar:

| Smell | Señal | Técnica sugerida |
|-------|-------|-----------------|
| Método largo | > 20 líneas, múltiples responsabilidades | Extract Method |
| Clase grande | > 200 líneas, múltiples responsabilidades | Extract Class |
| Código duplicado | Bloques similares en 2+ lugares | Extract Method/Class, Template Method |
| Feature envy | Método usa más datos de otra clase que de la propia | Move Method |
| Data clumps | Mismos grupos de parámetros repetidos | Extract Parameter Object |
| Primitive obsession | Strings/ints representando conceptos de dominio | Replace Primitive with Value Object |
| Long parameter list | > 3 parámetros | Extract Parameter Object, Builder |
| Switch/if chains | Cadenas largas de condicionales por tipo | Replace Conditional with Polymorphism |
| Shotgun surgery | Un cambio lógico requiere tocar muchos archivos | Move Method, Inline Class |
| Speculative generality | Abstracciones sin uso real | Inline Class/Method, Remove |

### Plan incremental

Crear un plan ordenado donde cada paso es un cambio atómico verificable:

```
Plan de refactorización:
1. [Técnica] - [Qué] - [Por qué] - [Riesgo: Bajo/Medio/Alto]
2. [Técnica] - [Qué] - [Por qué] - [Riesgo: Bajo/Medio/Alto]
...
```

**Principios del plan:**
- Un cambio lógico por paso
- Cada paso deja el código compilable y con tests pasando
- Ordenar de menor a mayor riesgo
- Si un paso tiene riesgo alto: presentar al usuario antes de ejecutar

Para el catálogo completo de técnicas con ejemplos, ver [techniques.md](techniques.md).

## Fase 4: Ejecución incremental

### Por cada paso del plan

1. **Aplicar** la técnica de refactorización
2. **Verificar** que los tests pasan (`ReadLints` + tests)
3. **Revisar** que el comportamiento externo no cambió
4. **Documentar** el cambio si no es autoevidente

### Reglas de ejecución

- **No mezclar refactor con cambios funcionales.** Si descubres un bug, anotarlo y corregirlo en un paso separado.
- **No introducir dependencias nuevas** salvo justificación explícita.
- **Mantener convenciones del proyecto**: nombrado, estructura de archivos, estilo.
- **Commits atómicos**: cada paso del plan = un commit descriptivo.

### Formato de commit sugerido

```
refactor([scope]): [descripción concisa del cambio]

[Técnica aplicada]. [Justificación breve si no es obvia].
```

Ejemplos:
- `refactor(auth): extract token validation to dedicated service`
- `refactor(api): replace conditional chain with strategy pattern`

### Si algo falla

1. Revertir al último estado verde (tests pasando)
2. Analizar por qué falló
3. Replantear el paso con un enfoque más conservador
4. Consultar al usuario si el riesgo aumenta

## Fase 5: Validación final

### Checklist de salida

```
Validación de refactorización:
- [ ] Todos los tests pasan (sin excepciones)
- [ ] Comportamiento externo idéntico (API, contratos, outputs)
- [ ] Legibilidad mejorada respecto al estado inicial
- [ ] Sin warnings nuevos del linter
- [ ] Commits atómicos y descriptivos
- [ ] Sin código muerto introducido
- [ ] Métricas mejoradas (complejidad ciclomática, LOC, duplicación)
```

### Auto-revisión

Antes de presentar el resultado, evaluar como si fuera un PR ajeno:
- ¿El código refactorizado es más claro sin explicación adicional?
- ¿Se eliminó el code smell original?
- ¿Se introdujo deuda técnica nueva?
- ¿Los nombres comunican la intención?
- ¿Cada función/clase tiene una sola responsabilidad?

### Reporte de refactorización

Presentar al finalizar:

```markdown
## Resumen de refactorización

**Objetivo**: [Qué se buscaba mejorar]
**Técnicas aplicadas**: [Lista de técnicas usadas]
**Archivos modificados**: [Lista de archivos]
**Métricas antes/después**:
- Complejidad: [antes] → [después]
- Líneas: [antes] → [después]
- Duplicación: [antes] → [después]
**Riesgo de regresión**: [Bajo/Medio/Alto + justificación]
```

## Reglas clave

- **Tests primero.** Sin red de seguridad no hay refactorización segura.
- **Incremental siempre.** Cada paso debe ser revertible independientemente.
- **Comportamiento intacto.** El usuario final no debe notar ningún cambio.
- **Un refactor, un propósito.** No mezclar mejora estructural con cambios funcionales.
- **Si hay duda, preguntar.** Escalar decisiones de diseño al usuario.

## Recursos adicionales

- Para el catálogo completo de técnicas con pseudocódigo, ver [techniques.md](techniques.md)
- Para ejemplos concretos de refactorizaciones aplicadas, ver [examples.md](examples.md)

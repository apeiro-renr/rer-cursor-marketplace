---
name: code-review
description: Analizar código y pull requests para detectar bugs, problemas de diseño,
  vulnerabilidades de seguridad y violaciones de estándares. Usar cuando el usuario
  pide revisar un PR, analizar cambios de código, hacer code review, evaluar calidad
  de código, o detectar problemas en implementaciones. Use when reviewing pull requests,
  analyzing code changes, or when the user asks for a code review or quality assessment.
---

# Revisión de Código

Workflow para analizar PRs y cambios de código detectando problemas de lógica, seguridad, diseño y estándares.

## Flujo general

```
Contexto → Análisis estructurado → Clasificación de hallazgos → Feedback accionable
```

## Fase 1: Recopilar contexto

### Información necesaria

1. **Alcance del cambio**: Archivos modificados, diff completo o PR
2. **Propósito**: Qué problema resuelve o qué funcionalidad añade
3. **Criterios de revisión**: Qué aspectos priorizar (seguridad, arquitectura, estándares, tests)
4. **Contexto del proyecto**: Stack tecnológico, convenciones existentes, arquitectura

### Si falta información

Preguntar al usuario antes de iniciar la revisión:
- "¿Cuál es el propósito de este cambio?"
- "¿Hay criterios específicos que deba priorizar?"
- "¿Existen convenciones de equipo que deba considerar?"

### Preparar el análisis

1. Leer todos los archivos modificados completos (no solo el diff)
2. Identificar módulos y sistemas impactados
3. Revisar tests asociados a los cambios
4. Comprender el flujo de datos afectado

## Fase 2: Análisis estructurado

Revisar el código en este orden de prioridad:

### 1. Correctitud y lógica

- ¿El código hace lo que dice que hace?
- ¿Maneja edge cases y condiciones límite?
- ¿Los tipos son correctos y consistentes?
- ¿Hay condiciones de carrera o problemas de concurrencia?
- ¿El manejo de errores es completo y adecuado?

### 2. Seguridad

- ¿Hay inyección SQL, XSS, CSRF u otras vulnerabilidades?
- ¿Se valida y sanitiza toda entrada de usuario?
- ¿Se manejan credenciales y secretos de forma segura?
- ¿Los permisos y autorizaciones son correctos?
- ¿Se expone información sensible en logs o respuestas?

### 3. Diseño y arquitectura

- ¿Respeta los principios SOLID?
- ¿Las responsabilidades están bien separadas?
- ¿Las abstracciones son apropiadas (ni sobre ni sub-ingenierización)?
- ¿El acoplamiento entre módulos es adecuado?
- ¿El cambio es consistente con la arquitectura existente?

### 4. Estándares y mantenibilidad

- ¿Sigue las convenciones del proyecto (naming, estructura, estilo)?
- ¿Los nombres comunican la intención claramente?
- ¿El código es autoexplicativo sin necesidad de comentarios excesivos?
- ¿La complejidad ciclomática es razonable?
- ¿Hay código duplicado que debería extraerse?

### 5. Rendimiento

- ¿Hay operaciones N+1 o consultas ineficientes?
- ¿Se manejan correctamente recursos (memoria, conexiones, file handles)?
- ¿Los algoritmos son apropiados para el volumen de datos esperado?
- ¿Hay bloqueos innecesarios o cuellos de botella?

### 6. Tests

- ¿Los tests cubren los cambios realizados?
- ¿Se prueban happy paths y edge cases?
- ¿Los tests son claros, independientes y deterministas?
- ¿Faltan tests para escenarios críticos?

Para checklists detallados por categoría, ver [checklists.md](checklists.md).

## Fase 3: Clasificar hallazgos

### Niveles de severidad

| Nivel | Etiqueta | Criterio | Acción requerida |
|-------|----------|----------|------------------|
| **Crítico** | `[CRITICAL]` | Bug, vulnerabilidad de seguridad, pérdida de datos | Bloquea merge. Debe corregirse. |
| **Mayor** | `[MAJOR]` | Problema de diseño, violación de estándares importante, falta de tests | Debe corregirse antes del merge. |
| **Menor** | `[MINOR]` | Mejora de legibilidad, naming, simplificación | Recomendado pero no bloquea. |
| **Nit** | `[NIT]` | Estilo, preferencia, optimización menor | Opcional. A discreción del autor. |

### Reglas de clasificación

- **No inflar severidades.** Un problema de naming no es crítico.
- **No minimizar riesgos.** Una vulnerabilidad de seguridad nunca es un nit.
- **Contextualizar.** Un método largo en código de migración one-time tiene menos impacto que en código core.
- **Si hay duda sobre la severidad**, preferir un nivel arriba y explicar el razonamiento.

## Fase 4: Formular feedback

### Principios del feedback

1. **Específico**: Señalar la línea exacta y el problema concreto
2. **Accionable**: Incluir qué hacer para resolverlo (no solo qué está mal)
3. **Justificado**: Explicar el por qué, no solo el qué
4. **Respetuoso**: Dirigido al código, nunca a la persona
5. **Educativo**: Si aplica, referenciar principios o patrones relevantes

### Formato de comentario

```
[SEVERIDAD] Categoría: Descripción breve

**Problema**: Qué está mal y por qué importa.
**Sugerencia**: Cómo resolverlo (con código si ayuda a clarificar).
```

### Qué NO incluir

- Reformateo que un linter puede hacer automáticamente
- Preferencias personales sin justificación técnica
- Comentarios vagos como "esto podría ser mejor"
- Sugerencias que cambian el alcance del PR

## Fase 5: Reporte de revisión

### Template de reporte

```markdown
## Revisión de código

**PR/Cambio**: [Referencia]
**Archivos revisados**: [Lista]
**Criterios aplicados**: [Qué se priorizó]

### Resumen ejecutivo
[1-2 párrafos con visión general: calidad del cambio, principales hallazgos, recomendación]

### Hallazgos

#### Críticos (X)
[Lista de hallazgos críticos con formato de comentario]

#### Mayores (X)
[Lista de hallazgos mayores]

#### Menores (X)
[Lista de hallazgos menores]

#### Nits (X)
[Lista de nits]

### Aspectos positivos
[Reconocer lo que está bien hecho: buenas decisiones, tests, legibilidad]

### Veredicto
- [ ] **Aprobar** - Sin cambios necesarios
- [ ] **Aprobar con comentarios** - Cambios menores, no requiere re-revisión
- [ ] **Solicitar cambios** - Hay issues que deben corregirse
- [ ] **Rechazar** - Problemas fundamentales de diseño o enfoque
```

## Reglas clave

- **Leer todo.** No revisar solo el diff; entender el contexto completo del archivo.
- **Priorizar impacto.** Empezar por correctitud y seguridad, luego estilo.
- **Feedback constructivo.** Cada hallazgo debe incluir una sugerencia accionable.
- **Reconocer lo positivo.** Una revisión no es solo una lista de errores.
- **Severidad honesta.** Clasificar objetivamente, sin inflar ni minimizar.
- **Preguntar antes de asumir.** Si algo parece incorrecto pero puede tener justificación, preguntar.

## Recursos adicionales

- Para checklists detallados por categoría, ver [checklists.md](checklists.md)
- Para ejemplos de revisiones completas, ver [examples.md](examples.md)

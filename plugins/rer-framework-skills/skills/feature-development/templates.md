# Templates - Desarrollo de Features

Plantillas reutilizables para cada fase del workflow.

## Template: Documento de requisitos

```markdown
# Feature: [Nombre de la feature]

## Descripción
[Qué hace esta feature y por qué es necesaria]

## Criterios de aceptación
1. DADO [contexto] CUANDO [acción] ENTONCES [resultado esperado]
2. DADO [contexto] CUANDO [acción] ENTONCES [resultado esperado]
3. ...

## Alcance
### Incluido
- [Funcionalidad A]
- [Funcionalidad B]

### Excluido
- [Funcionalidad fuera de alcance]

## Restricciones técnicas
- [Restricción 1: ej. debe soportar X concurrencia]
- [Restricción 2: ej. compatible con versión Y]

## Dependencias
- [Módulo/sistema del que depende]
- [API externa requerida]

## Casos de uso

### Flujo principal
1. Usuario hace X
2. Sistema responde con Y
3. ...

### Flujos alternativos
- Si [condición], entonces [comportamiento alternativo]

### Casos de error
- Si [error], entonces [manejo esperado]
```

## Template: Plan de implementación

```markdown
# Plan: [Nombre de la feature]

## Archivos a crear
| Archivo | Propósito |
|---------|-----------|
| `path/to/file` | [Qué contiene] |

## Archivos a modificar
| Archivo | Cambio | Motivo |
|---------|--------|--------|
| `path/to/file` | [Qué cambiar] | [Por qué] |

## Orden de implementación
1. [Paso] - Estimación: [simple/medio/complejo]
2. [Paso] - Estimación: [simple/medio/complejo]

## Decisiones de diseño
| Decisión | Opción elegida | Alternativas descartadas | Justificación |
|----------|---------------|--------------------------|---------------|
| [Decisión] | [Opción A] | [Opción B, C] | [Por qué A] |

## Riesgos identificados
- [Riesgo]: [Mitigación]
```

## Template: Checklist completo de feature

```markdown
# Checklist: [Nombre de la feature]

## Análisis
- [ ] Criterios de aceptación definidos y verificables
- [ ] Restricciones técnicas identificadas
- [ ] Alcance delimitado
- [ ] Casos de uso documentados
- [ ] Dependencias identificadas

## Diseño
- [ ] Patrones del proyecto explorados
- [ ] Plan de implementación creado
- [ ] Decisiones de diseño documentadas

## Implementación
- [ ] Código sigue convenciones del proyecto
- [ ] Funciones pequeñas con responsabilidad única
- [ ] Manejo de errores implementado
- [ ] Sin código muerto
- [ ] Sin secretos hardcodeados

## Testing
- [ ] Tests unitarios para lógica de negocio
- [ ] Tests de integración para flujos principales
- [ ] Casos edge cubiertos
- [ ] Criterios de aceptación con test asociado
- [ ] Todos los tests pasan

## Documentación
- [ ] Interfaces públicas documentadas
- [ ] README actualizado si aplica
- [ ] Changelog actualizado si aplica

## Revisión final
- [ ] Sin warnings del linter
- [ ] Sin dependencias innecesarias
- [ ] Cambios contenidos en el alcance
- [ ] Auto-revisión completada
```

## Template: Reporte de entrega

```markdown
# Feature completada: [Nombre]

## Resumen
[1-2 párrafos describiendo qué se implementó]

## Cambios realizados
| Archivo | Tipo de cambio | Descripción |
|---------|---------------|-------------|
| `path/file` | Creado/Modificado | [Qué] |

## Criterios de aceptación - Estado
| # | Criterio | Estado | Test asociado |
|---|----------|--------|---------------|
| 1 | [Criterio] | ✅/❌ | `test_name` |
| 2 | [Criterio] | ✅/❌ | `test_name` |

## Tests
- Unitarios: X pasando
- Integración: X pasando
- Coverage: X%

## Decisiones técnicas relevantes
- [Decisión tomada y por qué]

## Deuda técnica introducida
- [Si aplica, qué y plan de remediación]
- Ninguna

## Notas para el reviewer
- [Aspectos a los que prestar atención en la revisión]
```

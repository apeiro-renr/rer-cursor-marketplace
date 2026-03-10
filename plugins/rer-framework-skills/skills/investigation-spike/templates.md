# Plantillas de Entregables para Spikes

## §1. Tabla comparativa con veredicto

Usar para: comparación de alternativas técnicas.

```markdown
# Comparativa: [Tema de investigación]

**Fecha**: [YYYY-MM-DD]
**Pregunta**: [La pregunta específica que originó el spike]
**Contexto**: [Stack actual, restricciones, escala]

## Alternativas evaluadas

### [Alternativa A]
- **Qué es**: [Descripción en 1-2 líneas]
- **Versión evaluada**: [X.Y.Z]
- **Licencia**: [Tipo]

### [Alternativa B]
...

## Comparativa

| Criterio (peso) | Alternativa A | Alternativa B | Alternativa C |
|------------------|:------------:|:------------:|:------------:|
| [Criterio 1] (alta) | ... | ... | ... |
| [Criterio 2] (media) | ... | ... | ... |
| [Criterio 3] (baja) | ... | ... | ... |

Leyenda: ✅ Cumple bien · ⚠️ Cumple parcialmente · ❌ No cumple / riesgo

## Pros y contras detallados

### [Alternativa A]
**Pros**: ...
**Contras**: ...

### [Alternativa B]
**Pros**: ...
**Contras**: ...

## Veredicto

**Recomendación**: [Alternativa elegida]
**Justificación**: [Por qué, vinculado a criterios]
**Trade-offs aceptados**: [Qué desventajas asumimos]

## Siguientes pasos

1. [Acción concreta 1]
2. [Acción concreta 2]
3. [Acción concreta 3]
```

---

## §2. Reporte de investigación

Usar para: resolución de dudas técnicas o preguntas de diseño.

```markdown
# Investigación: [Tema]

**Fecha**: [YYYY-MM-DD]
**Pregunta**: [La pregunta específica]
**Contexto**: [Por qué surgió esta duda]

## Resumen ejecutivo

[1-2 párrafos con la respuesta concisa y la conclusión principal]

## Hallazgos

### [Hallazgo 1]
[Descripción con evidencia: documentación, código, mediciones]
**Fuente**: [URL o referencia]

### [Hallazgo 2]
...

## Evidencia de soporte

### Documentación consultada
- [Fuente 1]: [Qué aporta]
- [Fuente 2]: [Qué aporta]

### PoC (si aplica)
- **Objetivo**: [Qué se validó]
- **Resultado**: [Qué se encontró]
- **Código**: [Referencia al PoC o snippet relevante]

### Benchmarks (si aplica)
| Métrica | Resultado | Contexto |
|---------|-----------|----------|
| ... | ... | ... |

## Conclusión

**Respuesta**: [Respuesta directa a la pregunta]
**Nivel de confianza**: [Alto / Medio / Bajo] — [por qué]
**Limitaciones**: [Qué no se pudo verificar]

## Siguientes pasos

1. [Acción concreta]
2. [Acción concreta]
```

---

## §3. ADR (Architecture Decision Record)

Usar para: decisiones de arquitectura con impacto estructural.

```markdown
# ADR-[NNN]: [Título de la decisión]

**Estado**: Propuesto | Aceptado | Rechazado | Deprecado | Sustituido por ADR-XXX
**Fecha**: [YYYY-MM-DD]
**Autores**: [Quién investiga / decide]

## Contexto

[Qué situación o problema motiva esta decisión. Incluir contexto técnico y de negocio.]

## Pregunta de decisión

[La pregunta específica que se necesita responder.]

## Alternativas consideradas

### Alternativa 1: [Nombre]
- **Descripción**: [Qué implica]
- **Pros**: [Lista]
- **Contras**: [Lista]
- **Riesgos**: [Lista]

### Alternativa 2: [Nombre]
...

## Criterios de decisión

| Criterio | Peso | Descripción |
|----------|------|-------------|
| ... | Alto/Medio/Bajo | ... |

## Decisión

[Qué se decidió y por qué. Vincular explícitamente a los criterios.]

## Consecuencias

### Positivas
- [Qué ganamos]

### Negativas
- [Qué trade-offs aceptamos]

### Riesgos
- [Qué podría salir mal y cómo mitigar]

## Señales de alerta

Revisitar esta decisión si:
- [Condición 1]
- [Condición 2]
```

---

## §4. Reporte de viabilidad

Usar para: validar si algo es técnicamente posible o práctico.

```markdown
# Viabilidad: [Qué se evaluó]

**Fecha**: [YYYY-MM-DD]
**Pregunta**: [¿Es viable hacer X en el contexto Y?]
**Contexto**: [Stack, restricciones, escala]

## Resumen ejecutivo

**Veredicto**: [Viable / Viable con condiciones / No viable]
[1-2 párrafos explicando la conclusión]

## Criterios de viabilidad

| Criterio | Resultado | Evidencia |
|----------|-----------|-----------|
| Técnicamente posible | ✅/❌ | [Referencia] |
| Compatible con stack actual | ✅/❌ | [Referencia] |
| Rendimiento aceptable | ✅/❌ | [Referencia] |
| Esfuerzo razonable | ✅/❌ | [Estimación] |
| Mantenible a largo plazo | ✅/❌ | [Referencia] |

## Evidencia

### PoC
- **Objetivo**: [Qué se validó]
- **Setup**: [Cómo se ejecutó]
- **Resultado**: [Qué se encontró]
- **Código**: [Referencia]

### Benchmarks (si aplica)
| Métrica | Resultado | Requisito | Cumple |
|---------|-----------|-----------|--------|
| ... | ... | ... | ✅/❌ |

### Limitaciones encontradas
- [Limitación 1]: [Impacto y posible mitigación]
- [Limitación 2]: ...

## Condiciones para viabilidad (si "Viable con condiciones")

1. [Condición necesaria 1]
2. [Condición necesaria 2]

## Siguientes pasos

### Si se decide avanzar
1. [Paso 1]
2. [Paso 2]

### Si se decide no avanzar
- [Alternativa sugerida]
```

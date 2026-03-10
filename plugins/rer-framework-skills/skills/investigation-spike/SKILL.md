---
name: investigation-spike
description: Investigar alternativas técnicas, validar viabilidad y resolver dudas
  de diseño mediante spikes estructurados. Busca documentación, genera PoCs, ejecuta
  benchmarks y produce reportes con recomendaciones respaldadas por evidencia. Usar
  cuando el usuario pide investigar opciones técnicas, comparar librerías o frameworks,
  evaluar viabilidad de un enfoque, hacer un spike, o resolver una duda de arquitectura.
  Use when the user asks to research technical alternatives, compare libraries, evaluate
  feasibility, run a spike, or resolve a design question.
---

# Investigación / Spike

Workflow para explorar alternativas técnicas, validar viabilidad o resolver dudas de diseño con evidencia concreta.

## Flujo general

```
Pregunta → Alternativas → Investigación → Evidencia → Análisis → Recomendación
```

## Fase 1: Definir la pregunta

Toda investigación parte de una pregunta clara. Sin pregunta clara, no hay spike útil.

### Información necesaria

1. **Pregunta específica**: Qué necesitamos saber exactamente
2. **Contexto del proyecto**: Stack actual, restricciones, escala esperada
3. **Alternativas candidatas**: Opciones a evaluar (mínimo 2, idealmente 3-5)
4. **Criterios de decisión**: Cómo evaluamos las alternativas (rendimiento, complejidad, costo, mantenibilidad, comunidad, etc.)
5. **Restricciones**: Tiempo, presupuesto, compatibilidad, licencias

### Si falta información

Preguntar al usuario antes de investigar:
- "¿Cuál es el problema concreto que intentas resolver?"
- "¿Qué alternativas tienes ya identificadas?"
- "¿Qué criterios son más importantes para tu contexto?"
- "¿Hay restricciones técnicas o de negocio que deba considerar?"

### Clasificar el tipo de spike

| Tipo | Cuándo | Entregable principal |
|------|--------|---------------------|
| **Comparación de alternativas** | Elegir entre opciones conocidas | Tabla comparativa con veredicto |
| **Validación de viabilidad** | Verificar si algo es posible/práctico | PoC + reporte de viabilidad |
| **Resolución de duda técnica** | Aclarar cómo funciona algo | Reporte de investigación |
| **Decisión de arquitectura** | Decisión con impacto estructural | ADR formal |

### Checklist de definición

```
Definición del spike:
- [ ] Pregunta específica formulada
- [ ] Contexto del proyecto documentado
- [ ] Alternativas candidatas identificadas
- [ ] Criterios de decisión priorizados
- [ ] Restricciones explícitas
- [ ] Tipo de spike clasificado
- [ ] Entregable esperado acordado
```

## Fase 2: Investigación activa

Cursor investiga activamente lo que puede y solicita al usuario lo que no puede verificar.

### Qué puede hacer Cursor

1. **Buscar documentación**: Documentación oficial, APIs, especificaciones
2. **Analizar código existente**: Revisar el codebase actual para entender restricciones reales
3. **Buscar en la web**: Estado actual de librerías, comparativas existentes, issues conocidos
4. **Generar PoCs**: Escribir código de prueba de concepto para validar alternativas
5. **Ejecutar benchmarks**: Crear y ejecutar mediciones comparativas cuando sea viable
6. **Revisar licencias**: Verificar compatibilidad de licencias

### Qué debe pedir al usuario

- Acceso a servicios o APIs privadas
- Información de costos o presupuesto específico
- Experiencia del equipo con tecnologías específicas
- Preferencias organizacionales o políticas internas
- Validación de resultados con datos reales de producción

### Estrategia de investigación

1. **Empezar amplio**: Recopilar información general de cada alternativa
2. **Profundizar selectivamente**: Investigar en detalle las alternativas más prometedoras
3. **Validar con evidencia**: No afirmar sin respaldar; buscar fuentes concretas
4. **Documentar sobre la marcha**: Registrar hallazgos conforme se encuentran

### Tipos de evidencia

| Tipo | Cuándo generar | Herramientas |
|------|---------------|-------------|
| **Documentación** | Siempre | WebSearch, WebFetch, documentación oficial |
| **PoC** | Cuando la viabilidad es la duda | Escribir código mínimo que demuestre el concepto |
| **Benchmark** | Cuando el rendimiento es criterio clave | Escribir y ejecutar scripts de medición |
| **Análisis de código** | Cuando afecta codebase existente | Grep, SemanticSearch, Read |

### PoCs (Pruebas de concepto)

Cuando se necesite un PoC:
- **Mínimo viable**: Solo lo necesario para responder la pregunta
- **Aislado**: No mezclar con código de producción
- **Medible**: Incluir métricas o criterios de éxito claros
- **Desechable**: Un PoC no es código de producción; documentar la conclusión, no el código

### Benchmarks

Cuando se necesiten mediciones:
- **Definir qué medir**: Latencia, throughput, uso de memoria, tamaño de bundle, etc.
- **Condiciones consistentes**: Mismas condiciones para todas las alternativas
- **Repetir**: Múltiples ejecuciones para resultados confiables
- **Contextualizar**: Los números sin contexto no sirven; comparar contra requisitos reales

### Checklist de investigación

```
Investigación:
- [ ] Documentación oficial revisada para cada alternativa
- [ ] Estado de madurez verificado (versión, actividad, comunidad)
- [ ] PoC generado (si aplica)
- [ ] Benchmarks ejecutados (si aplica)
- [ ] Licencias verificadas
- [ ] Hallazgos documentados con fuentes
```

## Fase 3: Análisis comparativo

### Estructura del análisis

Para cada alternativa evaluada:

1. **Descripción**: Qué es y qué problema resuelve
2. **Evaluación por criterio**: Puntuación o valoración por cada criterio definido
3. **Pros**: Ventajas concretas con evidencia
4. **Contras**: Desventajas concretas con evidencia
5. **Riesgos**: Qué podría salir mal
6. **Costo de adopción**: Esfuerzo de implementación, migración, curva de aprendizaje

### Tabla comparativa

Usar este formato para comparaciones claras:

```markdown
| Criterio | Alternativa A | Alternativa B | Alternativa C |
|----------|:------------:|:------------:|:------------:|
| Rendimiento | Alto | Medio | Alto |
| Complejidad | Baja | Alta | Media |
| Comunidad | Activa | Pequeña | Activa |
| Licencia | MIT | GPL | Apache 2.0 |
| Madurez | Estable | Beta | Estable |
```

### Reglas del análisis

- **Objetividad**: Presentar hechos, no preferencias. Citar fuentes.
- **Trade-offs explícitos**: Toda ventaja tiene un costo; documentar ambos.
- **No descartar prematuramente**: Evaluar todas las alternativas con el mismo rigor.
- **Contextualizar**: Lo que es bueno en general puede no serlo para este proyecto.

## Fase 4: Recomendación

### Estructura de la recomendación

1. **Recomendación clara**: Qué alternativa elegir (o qué camino seguir)
2. **Justificación**: Por qué esta opción, vinculada a los criterios de decisión
3. **Trade-offs aceptados**: Qué desventajas asumimos y por qué son aceptables
4. **Plan de acción**: Siguientes pasos concretos para implementar la decisión
5. **Señales de alerta**: Indicadores de que la decisión debe revisarse

### Elegir el formato de entregable

Según el tipo de spike clasificado en Fase 1:

- **Tabla comparativa con veredicto** → Para comparación de alternativas. Ver [templates.md](templates.md) §1.
- **Reporte de investigación** → Para resolución de dudas técnicas. Ver [templates.md](templates.md) §2.
- **ADR** → Para decisiones de arquitectura con impacto estructural. Ver [templates.md](templates.md) §3.
- **Reporte de viabilidad** → Para validación de viabilidad. Ver [templates.md](templates.md) §4.

### Checklist de salida

```
Entregable:
- [ ] Pregunta original respondida
- [ ] Alternativas relevantes evaluadas con el mismo rigor
- [ ] Conclusiones respaldadas por evidencia (no opiniones)
- [ ] Trade-offs documentados explícitamente
- [ ] Recomendación accionable con siguientes pasos
- [ ] Señales de alerta para revisitar la decisión
- [ ] Formato de entregable apropiado al tipo de spike
```

## Reglas clave

- **Evidencia sobre opinión.** Toda afirmación debe tener respaldo verificable.
- **Preguntar lo que falta.** No asumir contexto que no se tiene.
- **Investigar activamente.** Usar WebSearch, código, benchmarks; no solo razonar en abstracto.
- **Ser honesto con la incertidumbre.** Si algo no se puede verificar, decirlo explícitamente.
- **Recomendar, no decidir.** Presentar evidencia y recomendación; la decisión es del usuario.
- **Mantener el foco.** Un spike responde una pregunta; si surgen preguntas nuevas, registrarlas como spikes separados.

## Recursos adicionales

- Para plantillas de entregables (tabla comparativa, reporte, ADR, viabilidad), ver [templates.md](templates.md)

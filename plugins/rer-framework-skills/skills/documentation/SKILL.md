---
name: documentation
description: Crear y mantener documentación técnica del proyecto incluyendo READMEs,
  documentación de API, ADRs, runbooks, guías y diagramas. Usar cuando el usuario
  pide crear documentación, escribir un README, documentar una API, registrar una
  decisión de arquitectura, crear un runbook, o actualizar docs existentes. Use when
  the user asks to create or update documentation, write a README, document an API,
  create an ADR, or write a runbook.
---

# Documentación Técnica

Workflow para crear y mantener documentación técnica precisa, clara y mantenible.

## Flujo general

```
Audiencia → Tipo de documento → Recopilar contexto → Redactar → Validar precisión → Entregar
```

## Fase 1: Definir audiencia y tipo

### Identificar la audiencia

Antes de escribir, determinar quién leerá el documento:

| Audiencia | Enfoque | Nivel de detalle |
|-----------|---------|------------------|
| **Desarrolladores del equipo** | Cómo contribuir, convenciones, arquitectura interna | Alto, con referencias al código |
| **Desarrolladores externos/consumidores** | Cómo usar la API/librería, integración | Medio, con ejemplos prácticos |
| **Operaciones/SRE** | Cómo desplegar, monitorear, resolver incidentes | Alto en procedimientos, bajo en internals |
| **Stakeholders no técnicos** | Qué hace el sistema, estado, decisiones | Bajo en detalles técnicos, alto en contexto |

### Determinar tipo de documento

| Tipo | Cuándo usar | Plantilla |
|------|-------------|-----------|
| **README** | Punto de entrada al proyecto o módulo | Ver [templates.md](templates.md#readme) |
| **API docs** | Documentar endpoints, funciones o interfaces públicas | Ver [templates.md](templates.md#api-docs) |
| **ADR** | Registrar decisión de arquitectura con contexto y alternativas | Ver [templates.md](templates.md#adr) |
| **Runbook** | Procedimiento operativo para incidentes o tareas recurrentes | Ver [templates.md](templates.md#runbook) |
| **Guía/Tutorial** | Enseñar un proceso paso a paso | Ver [templates.md](templates.md#guía) |
| **Diagrama** | Visualizar arquitectura, flujos o relaciones | Ver [templates.md](templates.md#diagrama) |

### Si falta información

Preguntar al usuario antes de avanzar:
- "¿Quién va a leer este documento?"
- "¿Qué decisión o contexto necesita quedar registrado?"
- "¿Existe documentación previa que deba actualizar en vez de crear desde cero?"

## Fase 2: Recopilar contexto

### Fuentes de contexto

1. **Código fuente**: Leer los módulos, funciones e interfaces relevantes
2. **Tests existentes**: Revelan comportamiento esperado y casos edge
3. **Commits y PRs recientes**: Muestran intención y evolución del cambio
4. **Documentación existente**: Verificar qué ya está documentado para no duplicar
5. **Configuración**: Archivos de config, variables de entorno, dependencias

### Checklist de contexto

```
Contexto recopilado:
- [ ] Código fuente relevante leído
- [ ] Tests revisados para entender comportamiento
- [ ] Documentación existente verificada (evitar duplicación)
- [ ] Variables de entorno y configuración identificadas
- [ ] Dependencias externas listadas
```

## Fase 3: Redactar

### Principios de redacción

- **Precisión sobre prosa**: Cada afirmación debe ser verificable contra el código
- **Ejemplos sobre descripciones**: Un ejemplo vale más que un párrafo explicativo
- **Estructura sobre narrativa**: Usar headings, tablas y listas para escaneo rápido
- **Mínimo viable**: Documentar lo necesario, no lo exhaustivo; priorizar lo que alguien buscará

### Reglas de estilo

1. **Voz activa y directa**: "Ejecuta `npm start`" en vez de "El servidor puede ser iniciado ejecutando..."
2. **Verbos en imperativo para instrucciones**: "Configura", "Ejecuta", "Verifica"
3. **Fragmentos de código funcionales**: Todo snippet debe ser copiar-pegar y funcionar
4. **Sin jerga innecesaria**: Si un término técnico no es del dominio del lector, explicarlo
5. **Fechas relativas prohibidas**: "Desde v2.3" en vez de "Desde el mes pasado"

### Estructura recomendada por tipo

**README**: Qué → Por qué → Cómo empezar → Uso → Contribuir
**API docs**: Endpoint → Parámetros → Respuesta → Errores → Ejemplo
**ADR**: Contexto → Decisión → Alternativas → Consecuencias
**Runbook**: Cuándo usar → Prerequisitos → Pasos → Verificación → Escalamiento

Para plantillas completas, ver [templates.md](templates.md).

## Fase 4: Validar precisión

### Verificaciones obligatorias

1. **Código vs docs**: Cada referencia a código (funciones, endpoints, configs) debe existir y estar actualizada
2. **Snippets ejecutables**: Ejecutar o verificar mentalmente que los ejemplos de código funcionan
3. **Links válidos**: Verificar que los links internos y externos apuntan al destino correcto
4. **Consistencia de nombres**: Los nombres de módulos, variables y comandos deben coincidir exactamente con el código
5. **Completitud**: No hay pasos faltantes en procedimientos ni parámetros omitidos en APIs

### Checklist de validación

```
Validación de precisión:
- [ ] Referencias a código verificadas contra la realidad
- [ ] Snippets de código probados o verificados
- [ ] Links internos y externos validados
- [ ] Nombres consistentes con el código fuente
- [ ] Procedimientos completos sin pasos faltantes
- [ ] Variables de entorno y configuración correctas
```

## Fase 5: Mantenibilidad

### Facilitar el mantenimiento futuro

1. **Ubicación predecible**: Colocar docs donde el equipo espera encontrarlas (`docs/`, `README.md` en la raíz, ADRs en `docs/adr/`)
2. **Indicar responsable**: Especificar quién o qué equipo mantiene el documento
3. **Señalar caducidad**: Si un dato puede cambiar (versiones, URLs, configs), marcarlo para revisión periódica
4. **Vincular al código**: Referenciar archivos fuente para que cambios en código disparen actualización de docs

### Qué NO documentar

- Información que el código ya comunica claramente
- Detalles de implementación que cambian frecuentemente sin impacto en el usuario
- Conocimiento tribal que debería ser una convención automatizada (linter, CI)

## Checklist de salida

```
Documentación lista:
- [ ] Precisa: coincide con el código actual
- [ ] Clara: la audiencia objetivo puede entenderla sin contexto adicional
- [ ] Ejemplos: incluye snippets o ejemplos donde ayudan a la comprensión
- [ ] Mantenible: tiene indicaciones de cómo y cuándo actualizarla
- [ ] Ubicada correctamente: en el lugar donde el equipo espera encontrarla
- [ ] Sin duplicación: no repite información disponible en otro documento
- [ ] Links funcionales: todos los enlaces internos y externos son válidos
```

## Recursos adicionales

- Para plantillas de cada tipo de documento, ver [templates.md](templates.md)
- Para ejemplos concretos de documentación bien escrita, ver [examples.md](examples.md)

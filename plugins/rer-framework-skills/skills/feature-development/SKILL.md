---
name: feature-development
description: Implementar nuevas funcionalidades desde requisitos hasta código listo para revisión, siguiendo un workflow estructurado con análisis, diseño, implementación, testing y documentación. Usar cuando el usuario pide desarrollar una feature, implementar funcionalidad nueva, crear un módulo, o construir un componente desde cero.
---

# Desarrollo de Features

Workflow completo para implementar funcionalidad nueva de forma estructurada y con calidad de producción.

## Flujo general

```
Requisitos → Análisis → Diseño → Implementación → Testing → Documentación → Revisión final
```

## Fase 1: Análisis de requisitos

Antes de escribir código, asegurar comprensión completa del alcance.

### Recopilar información

1. **Criterios de aceptación**: Listar condiciones concretas y verificables que definen "terminado"
2. **Restricciones técnicas**: Dependencias, compatibilidad, rendimiento, seguridad
3. **Alcance explícito**: Qué incluir y qué queda fuera (scope boundaries)
4. **Casos de uso**: Flujo principal + flujos alternativos + casos de error

### Checklist de análisis

Copiar y marcar progreso:

```
Análisis de requisitos:
- [ ] Criterios de aceptación definidos y verificables
- [ ] Restricciones técnicas identificadas
- [ ] Alcance delimitado (qué SÍ, qué NO)
- [ ] Casos de uso principales documentados
- [ ] Dependencias con otros sistemas/módulos identificadas
```

### Si falta información

Preguntar al usuario antes de avanzar. Usar preguntas específicas:
- "¿Qué debe ocurrir cuando [caso edge]?"
- "¿Hay restricciones de rendimiento para esta feature?"
- "¿Cómo interactúa esto con [módulo existente]?"

## Fase 2: Diseño técnico

### Explorar el código existente

1. **Identificar patrones del proyecto**: Buscar implementaciones similares en el codebase
2. **Convenciones de nombrado**: Seguir las convenciones existentes (archivos, funciones, variables)
3. **Estructura de directorios**: Colocar archivos donde el proyecto espera encontrarlos
4. **Patrones arquitectónicos**: Respetar la arquitectura existente (capas, módulos, inyección de dependencias)

### Plan de implementación

Crear un plan antes de codificar:

```
Plan de implementación:
1. [Archivo/módulo] - [qué cambiar/crear] - [por qué]
2. [Archivo/módulo] - [qué cambiar/crear] - [por qué]
...
```

### Decisiones de diseño

Si hay múltiples enfoques válidos:
1. Presentar opciones con pros/contras
2. Recomendar una opción con justificación
3. Esperar confirmación del usuario antes de implementar

## Fase 3: Implementación

### Principios de codificación

- **Seguir convenciones del proyecto**: No introducir estilos nuevos
- **Funciones pequeñas y enfocadas**: Una responsabilidad por función
- **Nombres descriptivos**: El código debe ser autoexplicativo
- **Manejo de errores robusto**: Cubrir flujos de error desde el inicio, no como afterthought
- **Sin código muerto**: No dejar código comentado, TODOs sin contexto, o imports sin usar

### Orden de implementación

1. **Modelos/tipos de datos**: Definir las estructuras primero
2. **Lógica de negocio**: Implementar el core sin dependencias de UI o infra
3. **Integración**: Conectar con capas externas (API, DB, UI)
4. **Manejo de errores**: Validaciones, excepciones, estados de error
5. **Casos edge**: Implementar manejo de límites y situaciones atípicas

### Checklist de implementación

```
Implementación:
- [ ] Código sigue convenciones del proyecto
- [ ] Funciones pequeñas con responsabilidad única
- [ ] Manejo de errores implementado
- [ ] Sin código muerto ni TODOs huérfanos
- [ ] Imports organizados según convención del proyecto
- [ ] Sin secretos o valores hardcodeados
```

## Fase 4: Testing

### Estrategia de tests

Escribir tests en este orden:

1. **Tests unitarios**: Lógica de negocio aislada
2. **Tests de integración**: Interacción entre componentes
3. **Tests de casos edge**: Límites, nulos, vacíos, errores

### Qué cubrir con tests

- Cada criterio de aceptación tiene al menos un test
- Flujo principal (happy path)
- Flujos alternativos relevantes
- Casos de error esperados
- Casos edge identificados en el análisis

### Checklist de testing

```
Testing:
- [ ] Tests unitarios para lógica de negocio
- [ ] Tests de integración para flujos principales
- [ ] Casos edge cubiertos
- [ ] Cada criterio de aceptación tiene test asociado
- [ ] Todos los tests pasan
- [ ] Coverage no disminuye respecto al baseline
```

## Fase 5: Documentación

### Qué documentar

- **Código**: Solo comentarios que expliquen el "por qué", no el "qué"
- **API/Interfaces**: Documentar contratos públicos (parámetros, retornos, errores)
- **README/docs**: Actualizar si la feature afecta el uso del sistema
- **Changelog**: Registrar el cambio si el proyecto lo requiere

### Checklist de documentación

```
Documentación:
- [ ] Interfaces públicas documentadas
- [ ] README actualizado si aplica
- [ ] Sin comentarios obvios o redundantes
- [ ] Changelog actualizado si el proyecto lo requiere
```

## Fase 6: Revisión final

Antes de entregar, verificar con el checklist completo.

### Checklist de salida (exit criteria)

```
Revisión final:
- [ ] Todos los criterios de aceptación cubiertos
- [ ] Tests escritos y pasando
- [ ] Código sigue convenciones del proyecto
- [ ] Manejo de errores implementado
- [ ] Documentación actualizada
- [ ] Sin warnings del linter
- [ ] Sin dependencias innecesarias agregadas
- [ ] Cambios están contenidos en el alcance definido
```

### Validación con linter

Ejecutar `ReadLints` en todos los archivos modificados/creados. Corregir errores introducidos.

### Auto-revisión

Antes de presentar el resultado, revisar como si fuera un PR ajeno:
- ¿El código es claro sin explicación adicional?
- ¿Los tests realmente validan los requisitos?
- ¿Se introdujo deuda técnica innecesaria?
- ¿El cambio es reversible y no afecta funcionalidad existente?

## Recursos adicionales

- Para plantillas reutilizables de cada fase, ver [templates.md](templates.md)
- Para ejemplos concretos de aplicación del workflow, ver [examples.md](examples.md)

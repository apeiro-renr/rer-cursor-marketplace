---
name: testing
description: Diseñar planes de prueba, generar casos de test y escribir tests automatizados
  para unit, integration y E2E. Usar cuando el usuario pide crear tests, diseñar
  un plan de pruebas, generar casos de test, mejorar cobertura, o validar funcionalidad.
  Use when the user asks to write tests, create test plans, generate test cases,
  improve coverage, or validate functionality.
---

# Testing

Workflow para diseñar, escribir y validar tests automatizados de forma estructurada, priorizando cobertura significativa sobre métricas numéricas.

## Flujo general

```
Contexto → Estrategia de testing → Diseño de casos → Implementación → Validación de cobertura
```

## Fase 1: Recopilar contexto

### Información necesaria

1. **Qué testear**: Módulo, función, flujo o feature específica
2. **Nivel de testing**: Unit, integration, E2E (o combinación)
3. **Stack del proyecto**: Lenguaje, framework de testing, herramientas de mocking
4. **Código existente**: Tests previos, patrones y convenciones ya establecidos
5. **Requisitos funcionales**: Comportamiento esperado, reglas de negocio

### Si falta información

Preguntar antes de escribir tests:
- "¿Qué nivel de testing necesitas? (unit, integration, E2E)"
- "¿Qué framework de testing usa el proyecto?"
- "¿Hay patrones de testing ya establecidos que deba seguir?"

### Preparar el análisis

1. Leer el código a testear completo (no solo la firma)
2. Identificar dependencias y efectos secundarios
3. Revisar tests existentes del proyecto para alinearse con el estilo
4. Mapear las rutas de ejecución (happy path, errores, edge cases)

## Fase 2: Estrategia de testing

### Elegir nivel según contexto

| Nivel | Cuándo usar | Qué valida |
|-------|-------------|------------|
| **Unit** | Lógica pura, transformaciones de datos, validaciones | Comportamiento aislado de una unidad |
| **Integration** | Interacción entre módulos, acceso a datos, APIs | Que los componentes funcionan juntos |
| **E2E** | Flujos críticos de usuario, workflows completos | Que el sistema funciona de extremo a extremo |

### Principio de decisión

- **Empezar por unit tests.** Son los más rápidos, baratos y estables.
- **Subir a integration** cuando el valor está en la interacción entre componentes.
- **Usar E2E solo para flujos críticos** donde unit + integration no basta.

Para estrategias detalladas por nivel, ver [strategies.md](strategies.md).

## Fase 3: Diseño de casos de test

### Categorías de casos

Para cada funcionalidad, cubrir estas tres categorías:

#### 1. Ruta positiva (happy path)
- Entrada válida típica → resultado esperado
- Flujo principal sin errores

#### 2. Ruta negativa (error handling)
- Entradas inválidas, nulas o fuera de rango
- Errores de dependencias externas (red, BD, filesystem)
- Permisos insuficientes o autenticación fallida

#### 3. Casos límite (edge cases)
- Valores frontera: 0, -1, MAX_INT, string vacío, lista vacía
- Concurrencia y condiciones de carrera
- Datos malformados o encoding inesperado
- Estado inconsistente o parcialmente inicializado

### Nomenclatura de tests

Usar el patrón: `debería [resultado esperado] cuando [condición]`

```
// Ejemplos
"debería retornar 0 cuando la lista está vacía"
"debería lanzar ValidationError cuando el email es inválido"
"debería reintentar 3 veces cuando la API retorna 503"
```

Adaptarse a la convención del proyecto si ya existe una.

## Fase 4: Implementación

### Estructura de un test

Seguir el patrón **Arrange-Act-Assert** (o Given-When-Then):

```
1. Arrange: Preparar datos y dependencias
2. Act: Ejecutar la operación bajo test
3. Assert: Verificar el resultado esperado
```

### Reglas de implementación

- **Un concepto por test.** Cada test valida una sola cosa.
- **Tests independientes.** Ningún test depende del estado dejado por otro.
- **Tests deterministas.** Mismo input → mismo resultado, siempre.
- **Mocking controlado.** Mockear dependencias externas, no la lógica bajo test.
- **Nombres descriptivos.** El nombre del test debe explicar qué valida sin leer el cuerpo.
- **Sin lógica en tests.** No usar condicionales, bucles ni try-catch en el test.
- **Setup compartido solo si es común.** No abusar de beforeEach/setUp para lógica específica.

### Anti-patrones a evitar

| Anti-patrón | Problema | Alternativa |
|-------------|----------|-------------|
| Test con múltiples asserts no relacionados | Si falla, no sabes qué rompió | Un concepto = un test |
| Mock de todo | Test no prueba nada real | Mockear solo fronteras externas |
| Test que depende de orden | Frágil y difícil de depurar | Tests independientes |
| Assert sobre implementación interna | Se rompe al refactorizar | Assert sobre comportamiento |
| Datos mágicos sin explicar | Difícil de entender | Usar constantes o builders con nombres claros |
| Test sin cleanup | Contamina otros tests | Limpiar estado en afterEach/tearDown |

## Fase 5: Validación de cobertura

### Cobertura significativa vs numérica

- **No perseguir el 100%.** Un 80% con tests significativos es mejor que 100% con tests triviales.
- **Priorizar rutas críticas.** Flujos de negocio, manejo de errores, validaciones.
- **Identificar qué NO está cubierto** y evaluar si el riesgo justifica añadir tests.

### Checklist de cobertura

- ¿Están cubiertas todas las rutas de decisión (if/else, switch)?
- ¿Se prueban los error handlers?
- ¿Los edge cases identificados tienen test?
- ¿Las validaciones de entrada están testeadas?
- ¿Los flujos de negocio críticos tienen test de integración?

## Checklist de salida

Copiar y completar antes de dar por terminado:

```
Plan de Testing:
- [ ] Nivel de testing definido (unit, integration, E2E)
- [ ] Rutas positiva, negativa y límite identificadas
- [ ] Tests independientes y deterministas
- [ ] Patrón Arrange-Act-Assert aplicado
- [ ] Sin anti-patrones (mocks excesivos, tests acoplados, asserts múltiples)
- [ ] Cobertura significativa de rutas críticas
- [ ] Tests legibles (nombres descriptivos, sin lógica interna)
- [ ] Alineado con convenciones del proyecto
```

## Formato de reporte

Al finalizar, presentar:

```markdown
## Plan de Testing

**Módulo/Feature**: [Qué se testea]
**Nivel**: [Unit / Integration / E2E]
**Framework**: [Framework utilizado]

### Casos implementados
| # | Caso | Categoría | Estado |
|---|------|-----------|--------|
| 1 | [Descripción] | Positivo/Negativo/Límite | Pasa/Falla |

### Cobertura
- Rutas positivas: [X/Y cubiertas]
- Rutas negativas: [X/Y cubiertas]
- Edge cases: [X/Y cubiertos]

### Riesgos no cubiertos
[Escenarios no testeados y justificación]
```

## Reglas clave

- **Contexto primero.** Entender el código y sus dependencias antes de escribir tests.
- **Cobertura significativa.** Priorizar rutas críticas sobre métricas numéricas.
- **Tests como documentación.** Un buen test explica el comportamiento esperado.
- **Mantenibilidad.** Un test que nadie entiende es un test que nadie mantiene.
- **Alinearse con el proyecto.** Respetar convenciones, frameworks y patrones existentes.
- **Independencia.** Cada test debe funcionar solo, en cualquier orden.

## Recursos adicionales

- Para estrategias detalladas por nivel de testing, ver [strategies.md](strategies.md)

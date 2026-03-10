# Ejemplos - Desarrollo de Features

Ejemplos concretos de cómo aplicar el workflow en diferentes escenarios.

## Ejemplo 1: Feature de autenticación (Backend)

### Prompt del usuario
> "Necesito implementar login con email y contraseña. El endpoint debe devolver un JWT. Si las credenciales son inválidas, devolver 401."

### Fase 1 aplicada: Análisis

Criterios de aceptación extraídos:
1. DADO un email y contraseña válidos CUANDO se llama POST /auth/login ENTONCES devuelve 200 con JWT
2. DADO credenciales inválidas CUANDO se llama POST /auth/login ENTONCES devuelve 401
3. DADO campos faltantes CUANDO se llama POST /auth/login ENTONCES devuelve 400

Preguntas al usuario antes de avanzar:
- "¿El JWT debe incluir roles del usuario en el payload?"
- "¿Cuál debe ser el tiempo de expiración del token?"
- "¿Se necesita refresh token o solo access token?"

### Fase 2 aplicada: Diseño

Exploración del codebase:
- Buscar patrones existentes de endpoints (estructura de controllers, middlewares)
- Identificar cómo se manejan las respuestas de error
- Verificar si hay utilidades de hashing existentes

Plan:
1. `models/user.ts` - Verificar que el modelo tiene campo password hasheado
2. `services/auth.service.ts` - Crear servicio con lógica de autenticación
3. `controllers/auth.controller.ts` - Crear controller para el endpoint
4. `routes/auth.routes.ts` - Registrar la ruta
5. `tests/auth.service.test.ts` - Tests unitarios del servicio
6. `tests/auth.controller.test.ts` - Tests de integración

### Fase 3 aplicada: Implementación

Orden: modelo → servicio → controller → ruta → tests

### Fase 6 aplicada: Revisión final

Checklist verificado:
- ✅ 3 criterios de aceptación cubiertos
- ✅ Tests unitarios para servicio + tests de integración para endpoint
- ✅ Contraseña nunca en logs ni respuestas
- ✅ Sigue patrón MVC del proyecto existente

---

## Ejemplo 2: Componente de UI (Frontend)

### Prompt del usuario
> "Crear un componente de tabla con paginación, ordenamiento por columnas y filtro de búsqueda."

### Fase 1 aplicada: Análisis

Criterios de aceptación:
1. La tabla muestra datos paginados con N filas por página
2. Click en encabezado de columna ordena ascendente/descendente
3. Campo de búsqueda filtra filas en tiempo real
4. La tabla muestra estado vacío cuando no hay resultados

Preguntas al usuario:
- "¿La paginación es client-side o server-side?"
- "¿Hay una librería de componentes existente en el proyecto?"
- "¿Se necesita selección de filas?"

### Fase 2 aplicada: Diseño

Exploración del codebase:
- Buscar componentes de tabla existentes para reusar patrones
- Identificar sistema de diseño/estilos del proyecto
- Verificar convención de nombrado de componentes

Decisión de diseño presentada:
| Decisión | Opción elegida | Alternativa | Justificación |
|----------|---------------|-------------|---------------|
| Paginación | Client-side | Server-side | Dataset < 1000 filas, simplifica implementación |

### Resultado entregado

```
Archivos creados:
- components/DataTable/DataTable.tsx - Componente principal
- components/DataTable/DataTable.test.tsx - Tests
- components/DataTable/Pagination.tsx - Subcomponente de paginación
- components/DataTable/SearchFilter.tsx - Subcomponente de búsqueda
```

---

## Ejemplo 3: Detección de alcance insuficiente

### Prompt del usuario
> "Agrega un botón de exportar a CSV"

### Cómo el skill guía la respuesta

En vez de implementar directamente, el análisis de Fase 1 genera preguntas:
- "¿Qué datos se exportan? ¿Los visibles en pantalla o todos los registros?"
- "¿Se necesita formateo especial para fechas o números?"
- "¿Debe funcionar con datasets grandes (>10k filas)?"
- "¿El CSV incluye encabezados de columna?"

Esto previene retrabajos y asegura que la implementación cubre el caso real.

---

## Anti-patrones a evitar

### Saltar directamente a codificar
**Mal**: Recibir "implementa feature X" y escribir código inmediatamente.
**Bien**: Primero análisis → diseño → confirmación → implementación.

### Implementar sin explorar el codebase
**Mal**: Crear un servicio con estructura inventada.
**Bien**: Buscar servicios existentes, copiar la estructura, adaptar.

### Tests como afterthought
**Mal**: Implementar todo y escribir tests superficiales al final.
**Bien**: Definir qué testear en Fase 1, implementar tests junto al código.

### Over-engineering
**Mal**: Implementar abstracciones "por si acaso se necesitan".
**Bien**: Implementar lo mínimo que satisface los criterios de aceptación.

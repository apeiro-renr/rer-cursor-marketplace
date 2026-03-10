# Estrategias por Nivel de Testing

Referencia detallada para cada nivel de testing. Consultar desde SKILL.md cuando se necesite profundizar.

## Unit Tests

### Cuándo usarlos

- Funciones puras y transformaciones de datos
- Validaciones y reglas de negocio
- Parsers, formatters, calculadores
- State machines y lógica condicional

### Qué mockear

- Llamadas HTTP, bases de datos, filesystem
- Servicios externos y APIs de terceros
- Timers, fechas y generadores aleatorios

### Qué NO mockear

- La unidad bajo test
- Tipos y estructuras de datos simples
- Utilidades puras del proyecto

### Patrones útiles

**Test paramétrico**: Para probar múltiples inputs con la misma lógica.

```
Inputs: [(input1, expected1), (input2, expected2), ...]
Para cada (input, expected):
  assert function(input) == expected
```

**Builder pattern**: Para construir objetos de test complejos sin ruido.

```
user = UserBuilder().withEmail("test@example.com").withRole("admin").build()
```

**Fixture factory**: Para centralizar la creación de datos de test reutilizables.

---

## Integration Tests

### Cuándo usarlos

- Interacción con bases de datos (queries, transacciones)
- Comunicación entre servicios o módulos
- Endpoints de API (request → response)
- Flujos que cruzan capas (controller → service → repository)

### Setup y teardown

- Usar base de datos de test o contenedores (testcontainers, docker-compose)
- Limpiar estado entre tests (truncate, rollback de transacción)
- No depender de datos precargados no controlados

### Patrones útiles

**Transacción con rollback**: Cada test ejecuta dentro de una transacción que se revierte al final.

**Test API con cliente HTTP**: Levantar la app, hacer requests reales, verificar respuestas.

**Snapshot de respuestas**: Comparar output contra un snapshot guardado para detectar cambios inesperados.

### Errores comunes

- Tests que dependen de datos preexistentes en la BD
- No limpiar estado entre tests (contaminación)
- Timeouts insuficientes para operaciones asíncronas
- Tests que fallan según el orden de ejecución

---

## E2E Tests

### Cuándo usarlos

- Flujos críticos de usuario (login, checkout, onboarding)
- Workflows que involucran múltiples sistemas
- Validación de que el sistema completo funciona tras un deploy
- Smoke tests post-despliegue

### Principios

- **Pocos pero críticos.** E2E son lentos y frágiles; usarlos solo para flujos de alto valor.
- **Resilientes a cambios de UI.** Usar selectores estables (data-testid, roles ARIA).
- **Independientes del entorno.** Configurar datos propios, no depender de estado externo.
- **Con retries para flakiness.** Esperas explícitas sobre operaciones asíncronas.

### Patrones útiles

**Page Object Model**: Encapsular la interacción con páginas en objetos reutilizables.

```
class LoginPage:
  navigate()
  fillCredentials(user, password)
  submit()
  getErrorMessage()
```

**Data seeding**: Crear datos necesarios via API o BD antes del test, no via UI.

**Visual regression**: Comparar screenshots para detectar cambios visuales no intencionados.

### Errores comunes

- Selectores frágiles (css paths largos, índices, texto hardcoded en idioma)
- Tests que dependen de datos de producción o staging
- No esperar a que la UI esté lista (race conditions)
- Tests que tardan minutos por mala arquitectura de setup

---
name: spec-driven-development
description: Implementar funcionalidades siguiendo Spec Driven Development (SDD) con enfoque TDD. Recibe una spec con formato fijo (Objetivo, Reglas, Estados, Criterios de aceptación) y genera plan de implementación, tests primero y código. Usar cuando el usuario proporciona una spec, especificación, requisitos estructurados, o dice "implementa esta spec", "spec driven", "SDD".
disable-model-invocation: true
---

# Spec Driven Development (SDD)

Workflow para implementar funcionalidades a partir de especificaciones estructuradas, siguiendo TDD (tests primero, después código).

## Formato de Spec (obligatorio)

Toda spec debe contener estas secciones:

```markdown
## Objetivo
Qué se quiere lograr (una frase clara).

## Reglas
- Regla 1 (invariante de negocio)
- Regla 2
- ...

## Estados
- Estado 1
- Estado 2
- ...

## Criterios de aceptación
- CA 1 (verificable, sin ambigüedad)
- CA 2
- ...
```

Si la spec recibida no cumple el formato, pedir al usuario que complete las secciones faltantes antes de continuar.

## Persistencia de la Spec

Toda spec se guarda en el directorio `specs/` en la raíz del proyecto antes de empezar la implementación, organizada por **dominio de negocio**.

### Estructura del directorio

```
specs/
├── orders/
│   ├── edit-order.spec.md
│   └── MKT-210-order-cancellation.spec.md
├── offers/
│   ├── offer-detail.spec.md
│   └── MKT-185-offer-comparison.spec.md
├── search/
│   └── global-search.spec.md
└── auth/
    └── login.spec.md
```

### Cómo determinar el dominio

1. Si la spec menciona un dominio explícito (ej. "pedidos", "búsqueda"), usar ese
2. Si hay un composable/componente principal, derivar el dominio de su ruta (ej. `composables/order/` → `orders/`)
3. Si no queda claro, preguntar al usuario

### Convención de nombrado

| Caso | Fichero | Ejemplo |
|------|---------|---------|
| Feature nueva | `specs/<domain>/<feature-name>.spec.md` | `specs/auth/login.spec.md` |
| Ticket Jira asociado | `specs/<domain>/<TICKET-ID>-<feature-name>.spec.md` | `specs/orders/MKT-142-edit-order.spec.md` |

### Contenido del fichero

El fichero `.spec.md` contiene la spec tal como la proporciona el usuario (con las 4 secciones obligatorias), más una cabecera con metadatos:

```markdown
---
feature: login
domain: auth
created: 2026-05-08
status: draft | in-progress | done
ticket: MKT-142 (opcional)
---

## Objetivo
...

## Reglas
...

## Estados
...

## Criterios de aceptación
...
```

El campo `status` se actualiza durante el workflow:
- `draft` → al guardar la spec
- `in-progress` → al comenzar la implementación (Fase 4)
- `done` → al pasar la verificación final (Fase 8)

## Workflow

### Fase 1: Análisis de la Spec

1. Leer la spec completa
2. Identificar artefactos necesarios:
   - **Composable** → lógica de negocio (`composables/useXyz.ts`)
   - **Component** → presentación (`components/XyzComponent.vue`)
   - **Store** → estado global (`stores/useXyzStore.ts`)
   - **Service** → comunicación con APIs (`services/XyzService.ts`)
   - **Types** → interfaces y tipos (`types/xyz.ts`)
3. Mapear cada criterio de aceptación a un test específico
4. Identificar dependencias externas (APIs, stores, composables existentes)

### Fase 2: Guardar la Spec

1. Determinar el dominio de negocio (ver "Cómo determinar el dominio")
2. Crear el directorio `specs/<domain>/` si no existe
3. Guardar la spec como `specs/<domain>/<feature-name>.spec.md` con la cabecera de metadatos y `status: draft`
4. Si el usuario proporcionó un ticket Jira, usarlo como prefijo en el nombre del fichero

### Fase 3: Plan de implementación

Generar un plan con esta estructura:

```
Task Progress:
- [ ] 1. Guardar spec en specs/
- [ ] 2. Tipos e interfaces
- [ ] 3. Tests del composable/service (RED)
- [ ] 4. Implementación del composable/service (GREEN)
- [ ] 5. Tests del store (si aplica) (RED)
- [ ] 6. Implementación del store (GREEN)
- [ ] 7. Tests del componente (RED)
- [ ] 8. Implementación del componente (GREEN)
- [ ] 9. Refactor (REFACTOR)
- [ ] 10. Verificación final
```

### Fase 4: Tipos e interfaces

Definir los tipos derivados de la spec:
- Un tipo por cada estado identificado
- Interfaces para inputs/outputs
- Tipos de error específicos

**Ejemplo derivado de la spec:**

```typescript
interface LoginCredentials {
  email: string;
  password: string;
}

type LoginState = "idle" | "loading" | "error" | "success";

interface LoginError {
  code: number;
  message: string;
}
```

### Fase 5: Tests (RED)

Escribir tests **antes** del código. Cada criterio de aceptación = al menos un test.

Seguir estrictamente la estructura BDD del proyecto:

```typescript
describe("useLogin", () => {
  vi.mock("@/services/AuthService");

  afterEach(() => {
    vi.clearAllMocks();
  });

  describe("submit", () => {
    describe("When email is empty", () => {
      it("Should not allow submission", () => {
        const { submit, canSubmit } = useLogin();

        const actual = canSubmit.value;

        expect(actual).toBe(false);
      });
    });

    describe("When credentials are valid", () => {
      it("Should set state to loading while authenticating", async () => {
        vi.mocked(AuthService.login).mockImplementation(
          () => new Promise(() => {})
        );
        const { submit, state } = useLogin();

        submit({ email: "test@test.com", password: "123456" });

        const actual = state.value;
        expect(actual).toBe("loading");
      });
    });
  });
});
```

Reglas de los tests:
- Patrón AAA (Arrange-Act-Assert)
- Variable `actual` para el resultado
- Un describe por método
- Un describe "When" por escenario
- Un it "Should" por aserción
- Mocks dentro del primer describe
- `afterEach` con `vi.clearAllMocks()`

### Fase 6: Implementación (GREEN)

Escribir el código mínimo para que los tests pasen:
- No implementar más de lo que la spec pide
- Respetar los estados definidos en la spec
- Usar tipado estricto (nunca `any`)
- Sin comentarios en el código

### Fase 7: Refactor

Mejorar la implementación sin romper tests:
- Extraer funciones si hay duplicación
- Simplificar condicionales
- Asegurar que los nombres son descriptivos
- Verificar que no hay `watch` (usar `computed`)

### Fase 8: Verificación final

Checklist antes de dar por completada la implementación:

```
Verificación:
- [ ] Todos los criterios de aceptación tienen test
- [ ] Todos los tests pasan
- [ ] Cada estado de la spec está representado
- [ ] Cada regla de la spec está implementada
- [ ] No hay `any` en el código
- [ ] No hay comentarios en el código
- [ ] No hay `watch` (salvo fuerza mayor justificada)
- [ ] Tipado estricto en tests y código
- [ ] Spec actualizada a `status: done` en specs/
```

## Mapeo Spec → Tests

| Sección de la Spec | Se traduce a |
|---------------------|--------------|
| Objetivo | Nombre del describe principal |
| Reglas | Lógica interna (validaciones, guards) |
| Estados | Type union + tests de transición |
| Criterios de aceptación | Un `it("Should...")` por cada CA |

## Convenciones de nombrado

| Artefacto | Patrón | Ejemplo |
|-----------|--------|---------|
| Spec | `specs/<domain>/<feature>.spec.md` | `specs/auth/login.spec.md` |
| Composable | `useXyz.ts` | `useLogin.ts` |
| Test | `useXyz.spec.ts` | `useLogin.spec.ts` |
| Service | `XyzService.ts` | `AuthService.ts` |
| Store | `useXyzStore.ts` | `useAuthStore.ts` |
| Types | `xyz.ts` | `auth.ts` |
| Component | `XyzComponent.vue` | `LoginForm.vue` |

## Ejemplo completo

Dada esta spec:

```markdown
## Objetivo
Permitir que un usuario acceda con email y contraseña.

## Reglas
- El email es obligatorio.
- La contraseña es obligatoria.
- Si las credenciales son incorrectas, mostrar error.
- Si el login va bien, redirigir al dashboard.

## Estados
- Vacío
- Cargando
- Error
- Éxito

## Criterios de aceptación
- No permite enviar si falta email.
- No permite enviar si falta password.
- Muestra loader mientras se autentica.
- Muestra mensaje si la API devuelve 401.
- Redirige si la API responde correctamente.
```

**Artefactos generados:**

1. `specs/auth/login.spec.md` → spec persistida con metadatos
2. `types/auth.ts` → `LoginCredentials`, `LoginState`, `LoginError`
3. `composables/useLogin.spec.ts` → 5 tests (uno por CA)
4. `composables/useLogin.ts` → lógica de login
5. `components/LoginForm.vue` → presentación (usa ds-vue)

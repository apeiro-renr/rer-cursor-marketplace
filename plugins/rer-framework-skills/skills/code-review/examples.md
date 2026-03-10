# Ejemplos de Revisión de Código

Ejemplos concretos de revisiones aplicando el workflow del skill.

## Ejemplo 1: Endpoint de API con problemas de seguridad y diseño

### Código bajo revisión

```python
@app.route("/users/<user_id>/update", methods=["POST"])
def update_user(user_id):
    data = request.json
    query = f"UPDATE users SET name='{data['name']}', email='{data['email']}' WHERE id={user_id}"
    db.execute(query)
    log.info(f"Updated user {user_id}: {data}")
    return {"status": "ok"}
```

### Revisión

**PR/Cambio**: Endpoint para actualizar datos de usuario
**Criterios aplicados**: Seguridad, correctitud, estándares

#### Resumen ejecutivo

El endpoint tiene vulnerabilidades de seguridad críticas que deben corregirse antes del merge. La inyección SQL es explotable directamente. Adicionalmente hay problemas de validación y logging de datos sensibles.

#### Hallazgos

**[CRITICAL] Seguridad: Inyección SQL**

**Problema**: La query se construye con string formatting directo, permitiendo inyección SQL a través de `name`, `email` o `user_id`.
**Sugerencia**: Usar queries parametrizadas.

```python
query = "UPDATE users SET name = %s, email = %s WHERE id = %s"
db.execute(query, (data["name"], data["email"], user_id))
```

**[CRITICAL] Seguridad: Sin autenticación ni autorización**

**Problema**: No se verifica que el usuario esté autenticado ni que tenga permiso para modificar este perfil. Cualquiera puede modificar datos de otro usuario.
**Sugerencia**: Agregar middleware de autenticación y verificar que `current_user.id == user_id` o que tenga rol admin.

**[MAJOR] Correctitud: Sin validación de input**

**Problema**: No se valida que `data` contenga `name` y `email`, ni que los valores sean válidos. Si falta un campo, lanza KeyError 500 al cliente.
**Sugerencia**: Validar presencia y formato de campos. Retornar 400 con mensaje descriptivo si la validación falla.

**[MAJOR] Seguridad: Datos sensibles en logs**

**Problema**: `log.info(f"Updated user {user_id}: {data}")` loguea todo el payload incluyendo potencialmente datos sensibles (email, PII).
**Sugerencia**: Loguear solo el user_id y los campos modificados (sin valores), o redactar campos sensibles.

**[MINOR] Estándares: Verbo HTTP incorrecto**

**Problema**: Update parcial debería usar PATCH (o PUT para reemplazo completo), no POST.
**Sugerencia**: Cambiar a `methods=["PATCH"]` y ajustar la ruta a `/users/<user_id>`.

**[MINOR] Correctitud: Sin código de respuesta explícito**

**Problema**: No se indica el status code HTTP. Debería retornar 200 explícito, o 204 si no hay body.
**Sugerencia**: `return {"status": "ok"}, 200`

#### Aspectos positivos

- Ruta RESTful con user_id como path parameter
- Logging presente (aunque necesita ajustes en contenido)

#### Veredicto

- [x] **Solicitar cambios** - Hay vulnerabilidades de seguridad críticas que deben corregirse

---

## Ejemplo 2: Componente React con problemas de rendimiento

### Código bajo revisión

```jsx
function UserList({ filters }) {
  const [users, setUsers] = useState([]);
  const [search, setSearch] = useState("");

  useEffect(() => {
    fetch(`/api/users?${new URLSearchParams(filters)}`)
      .then(res => res.json())
      .then(data => setUsers(data));
  }, [filters]);

  const filteredUsers = users
    .filter(u => u.name.toLowerCase().includes(search.toLowerCase()))
    .sort((a, b) => a.name.localeCompare(b.name));

  return (
    <div>
      <input value={search} onChange={e => setSearch(e.target.value)} />
      {filteredUsers.map(user => (
        <UserCard key={user.id} user={user} onDelete={() => deleteUser(user.id)} />
      ))}
    </div>
  );
}
```

### Revisión

**PR/Cambio**: Componente de listado de usuarios con búsqueda
**Criterios aplicados**: Rendimiento, correctitud, mantenibilidad

#### Resumen ejecutivo

El componente funciona pero tiene problemas de rendimiento que se harán evidentes con listas grandes. El filtrado/ordenamiento se recalcula en cada render y los callbacks se recrean causando re-renders innecesarios de los hijos.

#### Hallazgos

**[MAJOR] Rendimiento: Filtrado y sort en cada render**

**Problema**: `filteredUsers` se recalcula en cada render, incluyendo renders causados por cambios no relacionados. Con listas grandes esto causa lag perceptible.
**Sugerencia**: Memoizar el cálculo.

```jsx
const filteredUsers = useMemo(
  () => users
    .filter(u => u.name.toLowerCase().includes(search.toLowerCase()))
    .sort((a, b) => a.name.localeCompare(b.name)),
  [users, search]
);
```

**[MAJOR] Rendimiento: Callbacks recreados en cada render**

**Problema**: `() => deleteUser(user.id)` crea una nueva función por usuario en cada render, causando re-renders innecesarios de `UserCard` (incluso con `React.memo`).
**Sugerencia**: Pasar `user.id` como prop y mover el handler dentro de `UserCard`, o usar `useCallback` con el ID.

**[MINOR] Correctitud: Sin manejo de errores en fetch**

**Problema**: Si el fetch falla, la promesa se rechaza silenciosamente. El usuario no recibe feedback.
**Sugerencia**: Agregar `.catch()` con estado de error y mostrar mensaje al usuario.

**[MINOR] Correctitud: Sin estado de loading**

**Problema**: Mientras el fetch está en curso, el componente muestra una lista vacía sin indicar que está cargando.
**Sugerencia**: Agregar estado `loading` y mostrar un indicador apropiado.

**[NIT] Mantenibilidad: Lógica de filtrado inline**

**Problema**: La lógica de filtrado y ordenamiento podría extraerse para facilitar testing y reutilización.
**Sugerencia**: Extraer a un custom hook `useFilteredUsers(users, search)`.

#### Aspectos positivos

- Uso correcto de `key` en el map
- Separación de `UserCard` como componente independiente
- `URLSearchParams` para construir query strings de forma segura

#### Veredicto

- [x] **Aprobar con comentarios** - Los problemas de rendimiento son reales pero el componente es funcional. Corregir la memoización antes de merge.

---

## Ejemplo 3: Revisión express (tiempo limitado)

### Código bajo revisión

```typescript
async function processOrder(orderId: string): Promise<void> {
  const order = await db.orders.findById(orderId);
  const items = await db.items.findByOrderId(orderId);

  for (const item of items) {
    const product = await db.products.findById(item.productId);
    if (product.stock < item.quantity) {
      throw new Error("Insufficient stock");
    }
    await db.products.update(item.productId, {
      stock: product.stock - item.quantity
    });
  }

  await db.orders.update(orderId, { status: "processed" });
}
```

### Revisión express

**[CRITICAL] Correctitud: Sin transacción - estado inconsistente posible**

Si falla a mitad del loop, algunos productos tienen stock decrementado pero la orden no se marca como procesada. Se necesita una transacción que envuelva todo el proceso.

**[MAJOR] Rendimiento: Query N+1 en el loop**

Cada iteración hace un `findById` individual. Con 50 items son 50 queries. Cargar todos los productos en una sola query con sus IDs.

**[MAJOR] Correctitud: Race condition en stock**

Entre el `findById` y el `update`, otro request podría decrementar el mismo stock. Usar update atómico: `UPDATE products SET stock = stock - $quantity WHERE stock >= $quantity`.

**[MINOR] Correctitud: Error genérico**

"Insufficient stock" no indica qué producto ni cuánto falta. Dificulta el debugging y no da feedback útil al usuario.

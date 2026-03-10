# Ejemplos de refactorización

Casos concretos de aplicación del workflow completo.

## Ejemplo 1: Simplificar función con múltiples responsabilidades

### Contexto

El usuario pide: "Refactoriza esta función, es muy larga y difícil de entender."

```javascript
async function processOrder(order, user, inventory) {
  // validate
  if (!order.items || order.items.length === 0) throw new Error("Empty order");
  if (!user.active) throw new Error("Inactive user");
  for (const item of order.items) {
    if (inventory.getStock(item.id) < item.quantity) {
      throw new Error(`Insufficient stock for ${item.id}`);
    }
  }
  // calculate
  let subtotal = 0;
  for (const item of order.items) {
    subtotal += item.price * item.quantity;
  }
  let discount = 0;
  if (user.loyaltyTier === "gold") discount = 0.1;
  if (user.loyaltyTier === "platinum") discount = 0.15;
  if (subtotal > 500) discount += 0.05;
  const total = subtotal * (1 - discount);
  const tax = total * 0.21;
  // persist
  for (const item of order.items) {
    inventory.decrease(item.id, item.quantity);
  }
  const record = await db.orders.create({
    userId: user.id, items: order.items, subtotal, discount, total, tax,
    createdAt: new Date()
  });
  // notify
  await emailService.send(user.email, "Order confirmed", { orderId: record.id, total });
  await analyticsService.track("order_placed", { userId: user.id, total });
  return record;
}
```

### Análisis

| Smell detectado | Técnica |
|-----------------|---------|
| Método largo (~35 líneas) | Extract Method |
| Múltiples responsabilidades (validar, calcular, persistir, notificar) | Extract Method |
| Cadena de if para descuento | Replace Conditional / Extract Method |

### Plan incremental

```
1. Extract Method - validateOrder() - Bajo
2. Extract Method - calculateDiscount() - Bajo
3. Extract Method - calculateTotal() - Bajo
4. Extract Method - reserveInventory() - Bajo
5. Extract Method - persistOrder() - Bajo
6. Extract Method - notifyOrderPlaced() - Bajo
```

### Resultado

```javascript
async function processOrder(order, user, inventory) {
  validateOrder(order, user, inventory);
  const pricing = calculatePricing(order.items, user);
  reserveInventory(order.items, inventory);
  const record = await persistOrder(user, order.items, pricing);
  await notifyOrderPlaced(user, record);
  return record;
}

function validateOrder(order, user, inventory) {
  if (!order.items?.length) throw new Error("Empty order");
  if (!user.active) throw new Error("Inactive user");
  for (const item of order.items) {
    if (inventory.getStock(item.id) < item.quantity) {
      throw new Error(`Insufficient stock for ${item.id}`);
    }
  }
}

function calculatePricing(items, user) {
  const subtotal = items.reduce(
    (sum, item) => sum + item.price * item.quantity, 0
  );
  const discount = calculateDiscount(user.loyaltyTier, subtotal);
  const total = subtotal * (1 - discount);
  const tax = total * 0.21;
  return { subtotal, discount, total, tax };
}

function calculateDiscount(loyaltyTier, subtotal) {
  const tierDiscounts = { gold: 0.1, platinum: 0.15 };
  const tierDiscount = tierDiscounts[loyaltyTier] ?? 0;
  const volumeDiscount = subtotal > 500 ? 0.05 : 0;
  return tierDiscount + volumeDiscount;
}

function reserveInventory(items, inventory) {
  for (const item of items) {
    inventory.decrease(item.id, item.quantity);
  }
}

async function persistOrder(user, items, pricing) {
  return db.orders.create({
    userId: user.id, items, ...pricing, createdAt: new Date()
  });
}

async function notifyOrderPlaced(user, record) {
  await Promise.all([
    emailService.send(user.email, "Order confirmed", {
      orderId: record.id, total: record.total
    }),
    analyticsService.track("order_placed", {
      userId: user.id, total: record.total
    }),
  ]);
}
```

---

## Ejemplo 2: Eliminar duplicación entre handlers

### Contexto

El usuario pide: "Tengo lógica duplicada en estos dos endpoint handlers."

```python
# handlers.py
def create_user(request):
    data = request.json()
    if not data.get("email"):
        return Response({"error": "email required"}, status=400)
    if not data.get("name"):
        return Response({"error": "name required"}, status=400)
    try:
        user = UserService.create(data)
        logger.info(f"User created: {user.id}")
        return Response({"data": user.to_dict()}, status=201)
    except DuplicateError:
        return Response({"error": "email already exists"}, status=409)
    except Exception as e:
        logger.error(f"Failed to create user: {e}")
        return Response({"error": "internal error"}, status=500)

def update_user(request, user_id):
    data = request.json()
    if not data.get("email"):
        return Response({"error": "email required"}, status=400)
    if not data.get("name"):
        return Response({"error": "name required"}, status=400)
    try:
        user = UserService.update(user_id, data)
        logger.info(f"User updated: {user.id}")
        return Response({"data": user.to_dict()}, status=200)
    except NotFoundError:
        return Response({"error": "user not found"}, status=404)
    except DuplicateError:
        return Response({"error": "email already exists"}, status=409)
    except Exception as e:
        logger.error(f"Failed to update user: {e}")
        return Response({"error": "internal error"}, status=500)
```

### Análisis

| Smell | Técnica |
|-------|---------|
| Validación duplicada | Extract Method |
| Patrón try/except repetido | Template Method / Decorator |
| Formato de respuesta de error duplicado | Extract Method |

### Plan

```
1. Extract Method - validate_user_data() - Bajo
2. Extract Method - error_response() - Bajo
3. Extract Method / Decorator - handle_service_errors() - Medio
```

### Resultado

```python
from functools import wraps

def validate_user_data(data):
    required = ["email", "name"]
    for field in required:
        if not data.get(field):
            return Response({"error": f"{field} required"}, status=400)
    return None

def handle_service_errors(operation_name):
    def decorator(fn):
        @wraps(fn)
        def wrapper(*args, **kwargs):
            try:
                return fn(*args, **kwargs)
            except NotFoundError:
                return Response({"error": "resource not found"}, status=404)
            except DuplicateError:
                return Response({"error": "resource already exists"}, status=409)
            except Exception as e:
                logger.error(f"Failed to {operation_name}: {e}")
                return Response({"error": "internal error"}, status=500)
        return wrapper
    return decorator

@handle_service_errors("create user")
def create_user(request):
    data = request.json()
    if error := validate_user_data(data):
        return error
    user = UserService.create(data)
    logger.info(f"User created: {user.id}")
    return Response({"data": user.to_dict()}, status=201)

@handle_service_errors("update user")
def update_user(request, user_id):
    data = request.json()
    if error := validate_user_data(data):
        return error
    user = UserService.update(user_id, data)
    logger.info(f"User updated: {user.id}")
    return Response({"data": user.to_dict()}, status=200)
```

---

## Ejemplo 3: Reporte de refactorización

Formato de reporte de salida que el agente debe generar al finalizar:

```markdown
## Resumen de refactorización

**Objetivo**: Eliminar duplicación y mejorar legibilidad en handlers de usuario
**Técnicas aplicadas**: Extract Method, Decorator Pattern
**Archivos modificados**: handlers.py
**Métricas antes/después**:
- Líneas: 35 → 30
- Duplicación: ~60% → ~5% (validación y manejo de errores extraídos)
- Complejidad ciclomática por handler: 5 → 2
**Riesgo de regresión**: Bajo - Comportamiento idéntico, solo reorganización estructural
```

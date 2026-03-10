# Catálogo de técnicas de refactorización

Referencia de técnicas organizadas por categoría. Cada técnica incluye cuándo usar, pseudocódigo del antes/después, y precauciones.

## Composición de métodos

### Extract Method

**Cuándo**: Fragmento de código que puede agruparse y nombrarse con intención clara.

```
// Antes
function printReport(invoice) {
  // calcular total
  let total = 0;
  for (const item of invoice.items) {
    total += item.price * item.quantity;
  }
  // aplicar descuento
  if (invoice.discount) {
    total *= (1 - invoice.discount);
  }
  console.log(`Total: ${total}`);
}

// Después
function printReport(invoice) {
  const total = calculateTotal(invoice);
  console.log(`Total: ${total}`);
}

function calculateTotal(invoice) {
  const subtotal = invoice.items.reduce(
    (sum, item) => sum + item.price * item.quantity, 0
  );
  return invoice.discount
    ? subtotal * (1 - invoice.discount)
    : subtotal;
}
```

**Precauciones**: Verificar que las variables locales extraídas no dependen de estado mutable compartido.

### Inline Method

**Cuándo**: El cuerpo del método es tan claro como su nombre, o el método solo delega sin agregar valor.

```
// Antes
function getRating() {
  return moreThanFiveLateDeliveries() ? 2 : 1;
}
function moreThanFiveLateDeliveries() {
  return this.lateDeliveries > 5;
}

// Después
function getRating() {
  return this.lateDeliveries > 5 ? 2 : 1;
}
```

### Replace Temp with Query

**Cuándo**: Variable temporal usada solo para almacenar resultado de una expresión que podría ser un método.

```
// Antes
const basePrice = quantity * itemPrice;
if (basePrice > 1000) { return basePrice * 0.95; }

// Después
if (basePrice() > 1000) { return basePrice() * 0.95; }
function basePrice() { return quantity * itemPrice; }
```

**Precauciones**: Solo aplicar si la expresión no tiene side effects y el costo de recomputar es aceptable.

## Mover funcionalidad

### Move Method

**Cuándo**: Un método usa más datos de otra clase que de la clase donde reside (feature envy).

```
// Antes: método en Order que accede mucho a Customer
class Order {
  getDiscount() {
    if (this.customer.loyaltyPoints > 1000) { ... }
    if (this.customer.memberSince < twoYearsAgo) { ... }
  }
}

// Después: mover a Customer
class Customer {
  getDiscountFor(order) {
    if (this.loyaltyPoints > 1000) { ... }
    if (this.memberSince < twoYearsAgo) { ... }
  }
}
```

### Extract Class

**Cuándo**: Una clase tiene responsabilidades que pertenecen a dos conceptos distintos.

```
// Antes: Person tiene datos de teléfono mezclados
class Person {
  name; officeAreaCode; officeNumber;
  getPhone() { return `(${this.officeAreaCode}) ${this.officeNumber}`; }
}

// Después
class Person {
  name;
  officePhone; // TelephoneNumber
}
class TelephoneNumber {
  areaCode; number;
  toString() { return `(${this.areaCode}) ${this.number}`; }
}
```

## Organizar datos

### Extract Parameter Object

**Cuándo**: Grupo de parámetros que siempre viajan juntos.

```
// Antes
function amountInvoiced(startDate, endDate) { ... }
function amountReceived(startDate, endDate) { ... }
function amountOverdue(startDate, endDate) { ... }

// Después
function amountInvoiced(dateRange) { ... }
function amountReceived(dateRange) { ... }
function amountOverdue(dateRange) { ... }

class DateRange {
  constructor(start, end) { this.start = start; this.end = end; }
}
```

### Replace Primitive with Value Object

**Cuándo**: Un tipo primitivo (string, number) representa un concepto de dominio con reglas propias.

```
// Antes
const email = "user@example.com";
if (!email.includes("@")) throw new Error("Invalid");

// Después
class Email {
  constructor(value) {
    if (!value.includes("@")) throw new Error("Invalid email");
    this.value = value;
  }
  toString() { return this.value; }
}
```

### Encapsulate Collection

**Cuándo**: Una clase expone una colección mutable directamente.

```
// Antes
class Course {
  get students() { return this._students; } // expone la lista mutable
}

// Después
class Course {
  get students() { return [...this._students]; }
  addStudent(student) { this._students.push(student); }
  removeStudent(student) { ... }
}
```

## Simplificar condicionales

### Replace Conditional with Polymorphism

**Cuándo**: Cadena de if/switch que selecciona comportamiento según tipo.

```
// Antes
function getSpeed(vehicle) {
  switch (vehicle.type) {
    case 'car': return vehicle.baseSpeed;
    case 'truck': return vehicle.baseSpeed - vehicle.cargo * 0.1;
    case 'motorcycle': return vehicle.baseSpeed * 1.2;
  }
}

// Después
class Car {
  getSpeed() { return this.baseSpeed; }
}
class Truck {
  getSpeed() { return this.baseSpeed - this.cargo * 0.1; }
}
class Motorcycle {
  getSpeed() { return this.baseSpeed * 1.2; }
}
```

**Precauciones**: Evaluar si la complejidad del polimorfismo se justifica. Para 2-3 casos simples, un switch puede ser más claro.

### Decompose Conditional

**Cuándo**: Condición compleja difícil de leer.

```
// Antes
if (date.before(SUMMER_START) || date.after(SUMMER_END)) {
  charge = quantity * winterRate + winterServiceCharge;
} else {
  charge = quantity * summerRate;
}

// Después
if (isWinter(date)) {
  charge = winterCharge(quantity);
} else {
  charge = summerCharge(quantity);
}
```

### Replace Nested Conditional with Guard Clauses

**Cuándo**: Condicionales anidados que dificultan seguir el flujo principal.

```
// Antes
function getPayAmount() {
  if (isDead) {
    result = deadAmount();
  } else {
    if (isSeparated) {
      result = separatedAmount();
    } else {
      if (isRetired) {
        result = retiredAmount();
      } else {
        result = normalPayAmount();
      }
    }
  }
  return result;
}

// Después
function getPayAmount() {
  if (isDead) return deadAmount();
  if (isSeparated) return separatedAmount();
  if (isRetired) return retiredAmount();
  return normalPayAmount();
}
```

## Simplificar llamadas a métodos

### Rename Method/Variable

**Cuándo**: El nombre no comunica la intención del código.

**Heurística**: Si necesitas leer el cuerpo para entender qué hace, el nombre es malo.

```
// Antes
function calc(a, b) { ... }
const d = getDate();

// Después
function calculateMonthlyRevenue(sales, expenses) { ... }
const invoiceDueDate = getInvoiceDueDate();
```

### Introduce Parameter Object / Preserve Whole Object

**Cuándo**: Se pasan múltiples campos de un objeto como parámetros separados.

```
// Antes
function isInRange(value, min, max) { ... }
isInRange(temp, range.low, range.high);

// Después
function isInRange(value, range) { ... }
isInRange(temp, range);
```

## Herencia y delegación

### Replace Inheritance with Delegation

**Cuándo**: Una subclase solo usa parte de la interfaz de la superclase, o la relación "es un" no es semánticamente correcta.

```
// Antes (Stack no debería "ser" un List)
class Stack extends List { ... }

// Después
class Stack {
  #list = new List();
  push(item) { this.#list.append(item); }
  pop() { return this.#list.removeLast(); }
}
```

### Extract Interface

**Cuándo**: Múltiples clases comparten un subconjunto de métodos, o necesitas desacoplar dependencias.

```
// Antes: código acoplado a implementación concreta
function processPayment(stripeGateway) { ... }

// Después: depender de abstracción
interface PaymentGateway {
  charge(amount): Promise<Result>;
  refund(transactionId): Promise<Result>;
}
function processPayment(gateway: PaymentGateway) { ... }
```

## Refactorizaciones a gran escala

### Strangler Fig Pattern

**Cuándo**: Migrar un módulo/sistema grande de forma incremental.

1. Crear la nueva implementación junto a la existente
2. Redirigir tráfico gradualmente al nuevo código
3. Cuando todo el tráfico usa el nuevo código, eliminar el antiguo

### Branch by Abstraction

**Cuándo**: Reemplazar una dependencia interna sin detener el desarrollo.

1. Crear abstracción (interface) sobre el componente a reemplazar
2. Hacer que el código cliente use la abstracción
3. Crear nueva implementación de la abstracción
4. Cambiar la configuración para usar la nueva implementación
5. Eliminar la implementación antigua

**Precauciones para refactorizaciones a gran escala:**
- Requieren planificación explícita con el usuario
- Cada paso intermedio debe dejar el sistema funcionando
- Feature flags o toggles son útiles para control gradual
- No intentar en un solo paso

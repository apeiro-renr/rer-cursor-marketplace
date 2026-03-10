# Ejemplos de Documentación

Ejemplos concretos que ilustran la aplicación de las plantillas y principios del skill.

---

## Ejemplo 1: README de un microservicio

```markdown
# order-service

Servicio de gestión de pedidos. Expone API REST para crear, consultar y
cancelar pedidos. Consume eventos de `inventory-service` para validar stock.

## Inicio rápido

### Prerequisitos

- Node.js v20+
- Docker (para PostgreSQL y Redis locales)

### Instalación

git clone git@github.com:acme/order-service.git
cd order-service
npm install
cp .env.example .env
docker compose up -d
npm run migrate
npm start

### Uso básico

# Crear un pedido
curl -X POST http://localhost:3000/orders \
  -H "Content-Type: application/json" \
  -d '{"items": [{"sku": "ABC-123", "quantity": 2}]}'

## Arquitectura

src/
├── api/         # Controladores y rutas HTTP
├── domain/      # Lógica de negocio y entidades
├── infra/       # Repositorios, clientes externos, eventos
└── config/      # Configuración y variables de entorno

## Desarrollo

npm test          # Tests unitarios
npm run test:e2e  # Tests de integración
npm run lint      # Linter

Convenciones: commits en formato Conventional Commits, PRs requieren 1 aprobación.

## Mantenimiento

Responsable: Equipo Pedidos (#team-orders en Slack)
Última revisión: 2025-11-15
```

**Por qué funciona**:
- Va directo al grano: qué es, cómo arrancarlo
- Snippets copiables y funcionales
- Estructura de directorios con responsabilidades claras
- Indica quién mantiene el documento

---

## Ejemplo 2: ADR de elección de base de datos

```markdown
# ADR-003: Usar PostgreSQL como base de datos principal

**Estado**: Aceptada
**Fecha**: 2025-09-12
**Autores**: María García, Carlos López

## Contexto

El servicio de pedidos necesita persistencia relacional con soporte para
transacciones ACID. El volumen esperado es ~10K escrituras/minuto en pico.
El equipo tiene experiencia previa con PostgreSQL y MySQL.

## Decisión

Usar PostgreSQL 16 como base de datos principal del servicio de pedidos.

## Alternativas consideradas

### MySQL 8

- **Pros**: Equipo tiene experiencia, rendimiento probado para el volumen
- **Contras**: Menor soporte para tipos JSON complejos, particionamiento menos flexible
- **Descartada porque**: Necesitamos consultas sobre campos JSON anidados para filtros dinámicos de pedidos

### DynamoDB

- **Pros**: Escalabilidad automática, sin gestión de servidor
- **Contras**: Modelo de acceso rígido, costos impredecibles con scans, curva de aprendizaje
- **Descartada porque**: Los patrones de acceso aún no están definidos y DynamoDB penaliza fuertemente los cambios de patrones

## Consecuencias

### Positivas
- Consultas flexibles sobre JSON con índices GIN
- Ecosistema maduro de herramientas y ORMs en Node.js
- Equipo productivo desde el día uno

### Negativas
- Requiere gestión de infraestructura (backups, réplicas, upgrades)
- Escalamiento horizontal más complejo que soluciones NoSQL

### Riesgos
- Si el volumen supera 50K escrituras/minuto, evaluar read replicas o particionamiento
```

**Por qué funciona**:
- Contexto claro con datos concretos (volumen, versiones)
- Alternativas con razones reales de descarte
- Consecuencias honestas, incluyendo trade-offs aceptados

---

## Ejemplo 3: Runbook de incidente de base de datos

```markdown
# Runbook: Recuperación de conexiones agotadas en PostgreSQL

**Propósito**: Resolver alertas de "connection pool exhausted" en order-service
**Responsable**: Equipo Plataforma
**Última verificación**: 2025-10-20

## Cuándo ejecutar

- Alerta: `order-service-db-pool-exhausted` en PagerDuty
- Síntoma: errores 503 en /orders con log "Cannot acquire connection"

## Prerequisitos

- [ ] Acceso SSH al bastion host
- [ ] Credenciales de PostgreSQL (en 1Password vault "Infrastructure")
- [ ] Acceso al dashboard de Grafana (panel: DB Connections)

## Procedimiento

### Paso 1: Verificar estado de conexiones

psql -h db-primary.internal -U readonly -c \
  "SELECT count(*), state FROM pg_stat_activity GROUP BY state;"

**Resultado esperado**: Ver distribución de conexiones activas/idle
**Si falla**: Verificar conectividad de red al bastion host

### Paso 2: Identificar conexiones bloqueadas

psql -h db-primary.internal -U readonly -c \
  "SELECT pid, now() - pg_stat_activity.query_start AS duration, query
   FROM pg_stat_activity
   WHERE state != 'idle' ORDER BY duration DESC LIMIT 10;"

**Resultado esperado**: Lista de queries con su duración
**Si hay queries > 5 min**: Son candidatas para terminación

### Paso 3: Terminar conexiones bloqueadas

psql -h db-primary.internal -U admin -c \
  "SELECT pg_terminate_backend(PID);"

**Resultado esperado**: `t` (true) por cada conexión terminada

## Verificación

1. Verificar en Grafana que las conexiones activas bajan al rango normal (< 80)
2. Confirmar que los errores 503 cesan en los logs del servicio

## Rollback

Si terminar conexiones causa problemas adicionales:
1. Reiniciar los pods del servicio: `kubectl rollout restart deployment/order-service`
2. Si persiste, failover a la réplica de lectura como primaria (ver Runbook: DB Failover)

## Escalamiento

1. Notificar a #team-platform en Slack
2. Si no se resuelve en 15 minutos, abrir incidente P2 en PagerDuty
3. Incluir: output de pg_stat_activity, screenshots de Grafana, timeline de eventos
```

**Por qué funciona**:
- Comandos exactos copiar-pegar
- Cada paso indica qué esperar y qué hacer si falla
- Ruta de escalamiento clara con tiempos

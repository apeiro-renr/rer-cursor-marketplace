# Checklists de Revisión por Categoría

Checklists detallados para cada área de análisis. Usar como referencia durante la Fase 2 del workflow.

## Correctitud y lógica

```
- [ ] El código cumple los requisitos funcionales descritos
- [ ] Condiciones límite manejadas (null, vacío, cero, máximos)
- [ ] Flujo de errores completo (try/catch, validaciones, fallbacks)
- [ ] Tipos correctos y coherentes en todo el flujo
- [ ] Sin conversiones implícitas peligrosas
- [ ] Valores de retorno consistentes (no mezcla null/undefined/throw)
- [ ] Loops terminan correctamente (sin infinitos, off-by-one)
- [ ] Estado mutable manejado de forma predecible
- [ ] Operaciones async/await correctamente encadenadas
- [ ] Sin condiciones de carrera en accesos concurrentes
- [ ] Idempotencia donde se espera (APIs, event handlers)
- [ ] Transacciones atómicas donde se requiere consistencia
```

## Seguridad

```
- [ ] Input del usuario validado y sanitizado antes de procesarse
- [ ] Queries parametrizadas (no concatenación de strings en SQL)
- [ ] Output escapado según contexto (HTML, JS, URL, SQL)
- [ ] Autenticación verificada en endpoints protegidos
- [ ] Autorización granular (no solo "está logueado" sino "tiene permiso")
- [ ] Sin secretos hardcodeados (API keys, passwords, tokens)
- [ ] Secretos excluidos de logs y respuestas de error
- [ ] HTTPS enforced para datos sensibles
- [ ] Headers de seguridad configurados (CORS, CSP, HSTS)
- [ ] Rate limiting en endpoints expuestos
- [ ] Sesiones con expiración y renovación segura
- [ ] Archivos subidos validados (tipo, tamaño, contenido)
- [ ] Dependencias sin vulnerabilidades conocidas (CVEs)
- [ ] Sin exposición de stack traces o detalles internos al usuario
```

## Diseño y arquitectura

```
- [ ] Cada clase/módulo tiene una sola responsabilidad (SRP)
- [ ] Dependencias inyectadas, no hardcodeadas (DIP)
- [ ] Interfaces cohesivas y mínimas (ISP)
- [ ] Extensible sin modificar código existente donde aplique (OCP)
- [ ] Subtipos sustituibles por sus tipos base (LSP)
- [ ] Acoplamiento bajo entre módulos
- [ ] Cohesión alta dentro de cada módulo
- [ ] Abstracciones justificadas por uso real, no especulativo
- [ ] Patrones de diseño aplicados correctamente (no forzados)
- [ ] Consistente con la arquitectura existente del proyecto
- [ ] Sin dependencias circulares
- [ ] Capas de abstracción claras (no se saltan niveles)
- [ ] Contratos/interfaces estables en boundaries públicos
```

## Estándares y mantenibilidad

```
- [ ] Naming claro y consistente con convenciones del proyecto
- [ ] Funciones/métodos enfocados (< 30 líneas idealmente)
- [ ] Complejidad ciclomática razonable (< 10 por función)
- [ ] Nesting máximo de 3 niveles (early returns para reducir)
- [ ] Sin código muerto (funciones, imports, variables no usados)
- [ ] Sin código comentado (usar version control)
- [ ] Constantes con nombres descriptivos (no magic numbers/strings)
- [ ] Estructura de archivos consistente con el proyecto
- [ ] Imports organizados según convención del proyecto
- [ ] Sin duplicación significativa (DRY aplicado razonablemente)
- [ ] Comentarios solo donde el código no es autoexplicativo
- [ ] Documentación de API actualizada si hubo cambios en contratos
```

## Rendimiento

```
- [ ] Sin queries N+1 (eager loading o batch donde aplique)
- [ ] Índices de base de datos adecuados para queries nuevas
- [ ] Paginación implementada para colecciones potencialmente grandes
- [ ] Caché utilizado donde hay lecturas frecuentes de datos estables
- [ ] Recursos liberados correctamente (conexiones, streams, handles)
- [ ] Sin cálculos redundantes en loops (mover fuera del loop)
- [ ] Complejidad algorítmica apropiada para el volumen esperado
- [ ] Lazy loading para datos costosos de obtener
- [ ] Sin bloqueos de UI en operaciones costosas (async/workers)
- [ ] Payloads de respuesta optimizados (no enviar datos innecesarios)
```

## Tests

```
- [ ] Tests unitarios para lógica de negocio nueva/modificada
- [ ] Tests de integración para interacciones entre componentes
- [ ] Happy path cubierto
- [ ] Edge cases cubiertos (null, vacío, límites, errores)
- [ ] Tests independientes entre sí (no dependen de orden)
- [ ] Tests deterministas (no flaky, sin dependencias de tiempo)
- [ ] Asserts específicos y descriptivos (no solo "no lanza error")
- [ ] Mocks/stubs apropiados (no mockear demasiado ni demasiado poco)
- [ ] Nombres de tests describen el escenario y resultado esperado
- [ ] Sin lógica condicional en tests
- [ ] Datos de test claros y relevantes (no copy-paste genérico)
- [ ] Cobertura proporcional a la criticidad del código
```

## Checklist rápido (revisiones express)

Para revisiones con tiempo limitado, priorizar estos puntos:

```
- [ ] ¿El código hace lo que debe? (correctitud básica)
- [ ] ¿Hay vulnerabilidades de seguridad obvias? (input sin validar, secretos expuestos)
- [ ] ¿El manejo de errores es adecuado? (no swallow silencioso)
- [ ] ¿Hay tests para los cambios?
- [ ] ¿El código es legible sin explicación adicional?
```

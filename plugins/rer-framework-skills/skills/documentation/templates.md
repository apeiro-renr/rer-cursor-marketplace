# Plantillas de Documentación

## README

```markdown
# [Nombre del Proyecto]

[Una línea que describe qué hace y para quién.]

## Inicio rápido

### Prerequisitos

- [Herramienta] v[X.Y]+
- [Dependencia]

### Instalación

\`\`\`bash
[Comandos de instalación]
\`\`\`

### Uso básico

\`\`\`bash
[Comando o snippet mínimo para ver el proyecto funcionando]
\`\`\`

## Arquitectura

[Breve descripción de la estructura del proyecto. Diagrama si aporta claridad.]

\`\`\`
src/
├── module-a/    # [Responsabilidad]
├── module-b/    # [Responsabilidad]
└── shared/      # [Responsabilidad]
\`\`\`

## Desarrollo

### Configuración del entorno

\`\`\`bash
[Pasos para configurar el entorno de desarrollo]
\`\`\`

### Tests

\`\`\`bash
[Comando para ejecutar tests]
\`\`\`

### Convenciones

- [Convención de código relevante]
- [Convención de commits relevante]

## Despliegue

[Cómo se despliega. Referencia al runbook si existe.]

## Contribuir

[Cómo contribuir: flujo de PRs, estándares, contacto.]

## Mantenimiento

Responsable: [Equipo/Persona]
Última revisión: [Fecha]
```

---

## API docs

```markdown
# API: [Nombre del Módulo/Servicio]

## Visión general

[Qué hace esta API y para qué consumidores está diseñada.]

Base URL: `[URL base]`
Autenticación: `[Método]`

---

### `[METHOD] /endpoint`

[Descripción de qué hace este endpoint.]

**Parámetros**

| Nombre | Tipo | Requerido | Descripción |
|--------|------|-----------|-------------|
| `param` | `string` | Sí | [Descripción] |

**Request**

\`\`\`json
{
  "field": "value"
}
\`\`\`

**Response 200**

\`\`\`json
{
  "id": "abc-123",
  "status": "created"
}
\`\`\`

**Errores**

| Código | Descripción | Cuándo ocurre |
|--------|-------------|---------------|
| `400` | Bad Request | [Condición] |
| `404` | Not Found | [Condición] |
| `500` | Internal Server Error | [Condición] |

**Ejemplo completo**

\`\`\`bash
curl -X POST https://api.example.com/endpoint \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"field": "value"}'
\`\`\`
```

---

## ADR

```markdown
# ADR-[NNN]: [Título de la Decisión]

**Estado**: [Propuesta | Aceptada | Deprecada | Reemplazada por ADR-XXX]
**Fecha**: [YYYY-MM-DD]
**Autores**: [Nombres]

## Contexto

[Qué situación o problema motiva esta decisión. Incluir restricciones técnicas,
de negocio o de equipo que influyen.]

## Decisión

[Qué se decidió. Ser específico y concreto.]

## Alternativas consideradas

### Alternativa A: [Nombre]

- **Pros**: [Lista]
- **Contras**: [Lista]
- **Descartada porque**: [Razón concreta]

### Alternativa B: [Nombre]

- **Pros**: [Lista]
- **Contras**: [Lista]
- **Descartada porque**: [Razón concreta]

## Consecuencias

### Positivas

- [Consecuencia positiva]

### Negativas

- [Consecuencia negativa o trade-off aceptado]

### Riesgos

- [Riesgo identificado y mitigación propuesta]

## Referencias

- [Links a documentos, PRs, issues o discusiones relevantes]
```

---

## Runbook

```markdown
# Runbook: [Nombre del Procedimiento]

**Propósito**: [Cuándo usar este runbook]
**Responsable**: [Equipo/Rol]
**Última verificación**: [Fecha]

## Cuándo ejecutar

- [Condición o alerta que dispara este procedimiento]
- [Otra condición]

## Prerequisitos

- [ ] Acceso a [sistema/herramienta]
- [ ] Permisos de [nivel requerido]
- [ ] [Otra dependencia]

## Procedimiento

### Paso 1: [Nombre del paso]

\`\`\`bash
[Comando exacto]
\`\`\`

**Resultado esperado**: [Qué deberías ver]
**Si falla**: [Qué hacer]

### Paso 2: [Nombre del paso]

\`\`\`bash
[Comando exacto]
\`\`\`

**Resultado esperado**: [Qué deberías ver]
**Si falla**: [Qué hacer]

## Verificación

Confirmar que el procedimiento fue exitoso:

\`\`\`bash
[Comando de verificación]
\`\`\`

**Resultado esperado**: [Qué indica éxito]

## Rollback

Si algo sale mal:

1. [Paso de rollback]
2. [Paso de rollback]

## Escalamiento

Si el procedimiento no resuelve el problema:

1. Notificar a [equipo/persona] vía [canal]
2. Abrir incidente en [sistema] con severidad [nivel]
3. Incluir: [qué información adjuntar]
```

---

## Guía

```markdown
# Guía: [Título]

**Audiencia**: [Para quién es]
**Prerequisitos**: [Qué necesita saber/tener el lector]
**Tiempo estimado**: [Cuánto toma completarla]

## Qué vas a aprender

- [Objetivo 1]
- [Objetivo 2]

## Paso 1: [Título del paso]

[Explicación breve de qué se hace y por qué.]

\`\`\`bash
[Comando o código]
\`\`\`

[Explicación del resultado.]

## Paso 2: [Título del paso]

[Explicación breve.]

\`\`\`bash
[Comando o código]
\`\`\`

## Verificación

[Cómo confirmar que se completó correctamente.]

## Problemas comunes

| Problema | Causa | Solución |
|----------|-------|----------|
| [Síntoma] | [Causa] | [Solución] |

## Siguiente paso

[Qué hacer después. Link a la siguiente guía o recurso.]
```

---

## Diagrama

### Con Mermaid (preferido para diagramas en markdown)

```markdown
## [Título del Diagrama]

[Descripción de qué muestra el diagrama y cuándo consultarlo.]

\`\`\`mermaid
graph TD
    A[Componente A] -->|solicita| B[Componente B]
    B -->|responde| A
    B -->|persiste| C[(Base de datos)]
    A -->|notifica| D[Cola de mensajes]
\`\`\`

**Notas**:
- [Aclaración sobre un flujo o decisión del diagrama]
- Última actualización: [Fecha o commit de referencia]
```

### Tipos de diagrama recomendados

| Necesidad | Tipo Mermaid | Cuándo usar |
|-----------|-------------|-------------|
| Arquitectura de sistema | `graph TD` / `graph LR` | Mostrar componentes y sus relaciones |
| Flujo de datos | `flowchart` | Mostrar cómo fluyen los datos entre sistemas |
| Secuencia de operaciones | `sequenceDiagram` | Mostrar interacciones entre actores en el tiempo |
| Estados de una entidad | `stateDiagram-v2` | Mostrar transiciones de estado |
| Modelo de datos | `erDiagram` | Mostrar entidades y relaciones |

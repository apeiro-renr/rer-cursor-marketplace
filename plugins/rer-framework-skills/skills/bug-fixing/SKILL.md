---
name: bug-fixing
description: Diagnosticar y corregir bugs de software de forma sistemática. 
  Usar cuando el usuario reporta un bug, error, problema, 
  comportamiento inesperado, fallo de test, o pide depurar, 
  investigar o corregir un defecto en su código. 
  Use when the user reports a bug, error, unexpected behavior, 
  test failure, or asks to debug, troubleshoot, or fix an issue.
---

# Corrección de Bugs

## Workflow

### 1. Reproducir y entender

- Confirmar los pasos exactos para reproducir el bug.
- Identificar el comportamiento esperado vs el actual.
- Recopilar evidencia: logs, stack traces, screenshots, entorno.
- Si el usuario no proporcionó contexto suficiente, **pedir** antes de avanzar: pasos de reproducción, entorno, versión, logs.

### 2. Localizar la causa raíz

- Rastrear el flujo de ejecución desde el síntoma hacia la fuente.
- Usar búsqueda en el código, breakpoints lógicos y análisis de dependencias.
- Descartar hipótesis alternativas antes de concluir.
- **No proponer un fix sin haber identificado la causa raíz primero.**

### 3. Implementar el fix

- Aplicar el cambio mínimo necesario para corregir el defecto.
- **No mezclar refactors, mejoras o cambios cosméticos con el fix.**
- Verificar que el fix no introduce regresiones en flujos adyacentes.

### 4. Validar

- Añadir o actualizar un test que cubra el escenario del bug.
- Ejecutar los tests existentes para confirmar que no hay regresiones.
- Documentar la causa raíz si no es obvia (comentario en código o en el commit message).

## Checklist de salida

Copiar y completar antes de dar por cerrado:

```
Corrección de Bug:
- [ ] Bug reproducido y causa raíz identificada
- [ ] Fix aplicado (cambio mínimo, sin refactor mezclado)
- [ ] Test de regresión añadido o actualizado
- [ ] Tests existentes pasan sin regresiones
- [ ] Causa raíz documentada (si no es obvia)
```

## Formato de reporte

Al finalizar el diagnóstico, presentar:

```markdown
## Diagnóstico

**Síntoma**: [Descripción breve del comportamiento observado]
**Causa raíz**: [Explicación técnica concisa]
**Archivos afectados**: [Lista de archivos modificados]
**Fix aplicado**: [Descripción del cambio]
**Riesgo de regresión**: [Bajo/Medio/Alto + justificación]
```

## Reglas clave

- Diagnóstico antes que fix. Nunca parchear a ciegas.
- Un bug, un fix, un PR. No agrupar correcciones no relacionadas.
- Si el fix requiere cambios amplios, escalar y discutir el enfoque antes de implementar.
- Preferir fixes que sean fáciles de revertir.

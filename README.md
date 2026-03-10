# RER Marketplace

Cursor Team Marketplace con los plugins del framework RER.

## Plugins incluidos

- **rer-framework-skills**: Colección de 7 skills para desarrollo profesional
  - **bug-fixing**: Diagnóstico y corrección sistemática de bugs
  - **code-review**: Revisión de código y PRs con análisis estructurado
  - **documentation**: Creación y mantenimiento de documentación técnica
  - **feature-development**: Implementación de features desde requisitos hasta código listo para revisión
  - **investigation-spike**: Investigación técnica y spikes con evidencia
  - **refactoring**: Refactorización incremental y segura
  - **testing**: Diseño de planes de prueba y tests automatizados

## Estructura del repositorio

- `.cursor-plugin/marketplace.json`: Manifiesto del marketplace y registro de plugins
- `plugins/<plugin-name>/.cursor-plugin/plugin.json`: Metadatos por plugin
- `plugins/<plugin-name>/skills`: Carpetas de skills con `SKILL.md`
- `plugins/<plugin-name>/mcp.json`: Configuración de servidores MCP por plugin

## Validar cambios

```bash
node scripts/validate-template.mjs
```

Verifica rutas del marketplace, manifiestos de plugins y frontmatter requerido en archivos de skills.

## Checklist de contribución

- Cada plugin tiene un `.cursor-plugin/plugin.json` válido
- Los nombres de plugins son únicos, en minúsculas y kebab-case
- `.cursor-plugin/marketplace.json` apunta a carpetas de plugins reales
- Los archivos de skills tienen frontmatter con `name` y `description`
- `node scripts/validate-template.mjs` pasa sin errores

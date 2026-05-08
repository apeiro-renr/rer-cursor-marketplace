---
name: wcag-accessibility-review-html
description: >-
  Review mockups, designs, and plain HTML/CSS/JS pages for WCAG accessibility
  compliance. Use when validating layouts, forms, navigation, or any visual or
  interactive surface built without a framework; use explicitly for structured
  audits on new or changed HTML pages (forms, modals, tables, nav) and for PR
  review of semantics/ARIA. Also suitable for reviewing static mockups and
  prototypes.
---

# WCAG Accessibility Review — HTML / CSS / JS

Accessibility is highly context-dependent. These are guidelines, not absolute rules — always evaluate based on the specific use case and page context.

## Important

Many of these issues originate in the design phase but are only caught in development. Flag them early in the mockup review so they are not treated as "dev problems" later. Accessibility is a design responsibility too.

## When to use this skill

Run a full pass with this skill when:

- Adding or changing **interactive UI** in HTML pages: forms, data tables, primary/secondary navigation, modals, dialogs, carousels, menus.
- Touching **semantics or ARIA**: link vs button choice, icon-only controls, custom roles, focus management, heading order.
- **Reviewing mockups or prototypes** (Figma, images, wireframes, static HTML) and verifying that markup matches WCAG expectations.
- **Reviewing a PR** that changes HTML markup or CSS styles that affect contrast, focus, or screen reader output.

A full skill audit is usually **not** needed for changes limited to server-side logic, data processing, build tooling, or other work that does not alter accessible markup or interaction.

## How to Apply This in a Review

When reviewing a mockup or page, go through each section and flag:

1. **Blocker** — fails WCAG minimum (e.g. contrast below AA, missing focus state)
2. **Warning** — does not meet recommendation but context may justify it
3. **Suggestion** — improvement that would enhance accessibility beyond minimum

Always explain *why* something is flagged, not just *what* is wrong.

---

## Typography

- Font size minimum 16px (use `rem` or `em`, never `px`)
- Line height minimum 1.5
- Avoid fonts with ligatures or confusable characters (e.g. I/l/1, O/0)
- Headings with bold: consider adding `letter-spacing`

## Heading Structure

- Headings must follow correct nesting (h1 → h2 → h3, no skipping levels)
- Never use a heading just for visual styling

## Color & Contrast

- Minimum contrast ratio AA for all elements against their backgrounds
- This applies to text, icons, borders, and interactive elements

## Spacing & Sizing

- All spacing and sizing values in `rem` or `em`, never `px`
- Interactive elements (buttons, checkboxes, chevrons, hamburger menus):
  - Minimum touch area: 24x24px
  - Recommended touch area: 48x48px

## Focus States

- Every interactive element must have a visible focus indicator
- Options:
  - Color change on the element itself
  - Outline minimum 2px (recommended 4px)
- Focus must meet contrast requirements too
- Never use `outline: none` or `outline: 0` without providing an alternative visible focus style

## Navigation & Links

- Navigation items must have a single function: either navigate OR expand, never both
- Links must always be underlined
- Never underline text that is not a link — it causes confusion
- Avoid generic link/button labels like "More info", "See more", "Click here"
  - If unavoidable in design, flag for dev to add `aria-label`

## Icons

- Icons should be accompanied by visible text whenever possible
- If icon-only, ensure it has an accessible label (`aria-label` or `aria-labelledby` on the interactive wrapper)
- Decorative icons: `aria-hidden="true"` on the `<svg>` or `<i>` element
- If using icon fonts (e.g. Font Awesome `<i class="fa-...">`), the `<i>` must have `aria-hidden="true"` and the parent interactive element must carry the accessible label

## Animations

- Reduce animations to a minimum
- Always consider: what happens if the user disables animations in system settings?
  - Respect `prefers-reduced-motion` media query in CSS
- Never use autoplay for sliders or carousels
  - If autoplay is required: provide pause/play control
  - Always show slide position indicator: "Slide 1 of 4"

## Forms

- Validate on client side with clear, descriptive error messages
- Error messages must identify the specific field that failed
- Avoid long single-page forms — consider splitting into steps
- Every `<input>` must have an associated `<label>` — never use `placeholder` as a substitute for label
- The `<label for="X">` must exactly match the `<input id="X">`
- Search buttons inside a `<form>` must be `type="submit"`, not `type="button"` — this enables keyboard submission (Enter key) and proper screen reader semantics
- Placeholder disappears on focus and has contrast issues by default
- Group related fields with `<fieldset>` and `<legend>`
- Error messages must be programmatically associated with the field (`aria-describedby`)
- If required fields exist:
  - Visually indicate them (e.g. asterisk with legend "Fields marked with * are required")
  - Add `aria-required="true"` or the HTML `required` attribute
- Multi-step processes must indicate progress: "Step 2 of 4"

## Data Tables

- Use zebra stripe pattern for data tables to improve readability
- Data tables must use `<th>` for headers, never `<td>` styled as header
- Use `scope="col"` or `scope="row"` on `<th>` elements
- Every `<th>` must have an `id` attribute matching the column key (e.g. `id="nombre"`, `id="email"`, `id="acciones"`)
- Every `<td>` must have a `headers` attribute referencing the `id` of its corresponding `<th>`
- The actions column `<td>` must use flex layout classes for proper icon alignment, not icon-cell hacks
- Never use tables for layout

## Transactions & Confirmations

- Always include a summary page before final submission of any transaction
- Always confirm outcome to the user — success or failure, explicitly

## Responsive & Mobile

- Correct transformation between desktop and mobile is required
- Natural responsive behavior is preferred over breakpoint-only layouts

## Semantic HTML & ARIA

### Document structure
- Every page must have a `<!DOCTYPE html>` declaration
- Use HTML5 landmark elements: `<header>`, `<nav>`, `<main>`, `<aside>`, `<footer>`
- There must be exactly one `<main>` per page
- If multiple `<nav>` or `<aside>` elements exist, each must have a unique `aria-label`

### Interactive elements
- An `<a>` (anchor) must never have `type="button"` or `role="button"`
  - If it navigates: use `<a href="...">`
  - If it triggers an action: use `<button>`
  - Mixing semantics breaks screen readers and keyboard navigation
- Never use `<div>` or `<span>` as interactive elements without proper ARIA
  - If a `<div>` must be clickable, add `role="button"`, `tabindex="0"`, and handle both `click` and `keydown` (Enter and Space) events
- `<button>` inside a form should always have explicit `type="button"` or `type="submit"` — default behavior varies by browser

### Images
- Decorative images: `alt=""` (empty, not missing)
- Informative images: `alt` must describe the content, not the file name
- Never use "image of..." or "photo of..." in alt text — screen readers already announce it as an image

### Lists
- Navigation menus should use `<ul>/<li>` structure
- Never fake a list with line breaks or manual bullets

### Language
- `<html lang="es">` (or the correct language) must always be present
- If a word or phrase is in a different language inline, mark it: `<span lang="en">lorem ipsum</span>`

### Modals & Overlays
- When a modal opens, focus must move inside it
- When it closes, focus must return to the element that triggered it
- Modal must trap focus while open (Tab should cycle inside, not escape)
- Must be closable with Escape key
- Store the triggering element reference before opening so focus can be restored on close
- Use the native `<dialog>` element when possible — it provides built-in focus trapping and Escape key handling
- If using a custom modal with `<div>`, add `role="dialog"`, `aria-modal="true"`, and `aria-labelledby` pointing to the modal title

### Pagination & Dynamic Content
- Pagination result text (e.g. "Página 2 de 5: Mostrando 10 resultados") must use `aria-live="polite"` and `aria-atomic="true"` so screen readers announce the full updated text
- The `aria-live` region must always exist in the DOM — never remove and re-create it with JavaScript (screen readers cannot detect changes on newly inserted `aria-live` nodes); use CSS `display` or `visibility` to hide it instead of removing the element
- If multiple pagination instances can coexist on a page, each `aria-live` region must have a unique `id`

### Screen Reader Duplication (`sr-only` + `aria-hidden`)
- When an element has both a visually-hidden `<span>` (for screen readers) and a visual `<span>` (for sighted users) showing the same text, the visual span must have `aria-hidden="true"` to prevent the screen reader from reading the same content twice
- This is common in sidebar/menu items with icons — the `sr-only` provides the accessible name, so the visible label must be hidden from assistive technology

### Skip links
- Pages with navigation must include a "Skip to main content" link as the first focusable element
- Can be visually hidden but must be visible on focus

### Layout & Footer
- The page footer must always be pushed to the bottom of the viewport when content is short — use `margin-top: auto` on the footer in a flex column layout with `min-height: 100vh` on the container

## Mockup & Wireframe Review Checklist

When reviewing a design mockup (Figma, image, PDF, wireframe) rather than code, verify the following are specified or can be inferred from the design:

- [ ] Color contrast ratios meet AA on all text and interactive elements
- [ ] Focus states are designed for every interactive element
- [ ] Form fields show associated labels (not just placeholders)
- [ ] Error states are designed with field-level messages
- [ ] Heading hierarchy is logical and documented
- [ ] Touch targets meet minimum size requirements
- [ ] Navigation has a consistent, predictable pattern
- [ ] Modals show how focus is managed (entry and exit)
- [ ] Content is readable at 200% zoom without horizontal scroll
- [ ] Color is not the sole means of conveying information (e.g. error = red + icon + text)
- [ ] Animations have a purpose and a reduced-motion alternative is considered
- [ ] Skip-to-content link is accounted for in the layout

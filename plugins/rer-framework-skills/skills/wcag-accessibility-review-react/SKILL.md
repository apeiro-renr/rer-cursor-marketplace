---
name: wcag-accessibility-review-react
description: >-
  Review mockups, designs, and React components (JSX/TSX) for WCAG accessibility
  compliance. Use when validating UI components, layouts, forms, navigation, or
  any visual or interactive surface; use explicitly for structured audits on new
  or changed React components (forms, modals, tables, nav) and for PR review of
  semantics/ARIA. Covers both React (web) and React Native patterns.
---

# WCAG Accessibility Review — React / React Native

Accessibility is highly context-dependent. These are guidelines, not absolute rules — always evaluate based on the specific use case and component context.

## Important

Many of these issues originate in the design phase but are only caught in development. Flag them early in the mockup review so they are not treated as "dev problems" later. Accessibility is a design responsibility too.

## When to use this skill for React (`.tsx` / `.jsx`) files

Run a full pass with this skill when:

- Adding or changing **interactive UI** in components: forms, data tables, primary/secondary navigation, modals, dialogs, carousels, menus.
- Touching **semantics or ARIA**: link vs button choice, icon-only controls, custom roles, focus management, heading order.
- **Implementing from mockups** and verifying JSX markup (labels, errors, landmarks) matches WCAG expectations.
- **Reviewing a PR** that changes UI markup or styles that affect contrast, focus, or screen reader output.

A full skill audit is usually **not** needed for changes limited to data fetching, typings, hooks logic, state management, or other work that does not alter accessible markup or interaction.

## How to Apply This in a Review

When reviewing a mockup or component, go through each section and flag:

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

**React Native:** use `fontSize` in scaled units via `PixelRatio` or a scaling utility; respect the user's system font-size preference (`allowFontScaling` defaults to `true` — never set it to `false`).

## Heading Structure

- Headings must follow correct nesting (h1 → h2 → h3, no skipping levels)
- Never use a heading just for visual styling

**React Native:** there are no native heading elements — use `accessibilityRole="header"` on the appropriate `<Text>` components and ensure logical nesting via `accessibilityLevel` (if supported by the RN version) or document the heading hierarchy.

## Color & Contrast

- Minimum contrast ratio AA for all elements against their backgrounds
- This applies to text, icons, borders, and interactive elements

**React Native:** same ratios apply; test on both light and dark system themes and verify dynamic colors maintain contrast.

## Spacing & Sizing

- All spacing and sizing values in `rem` or `em`, never `px` (web)
- Interactive elements (buttons, checkboxes, chevrons, hamburger menus):
  - Minimum touch area: 24×24px
  - Recommended touch area: 48×48px

**React Native:** use `minWidth` / `minHeight` of 44pt (iOS) / 48dp (Android) or set `hitSlop` to expand the tappable region without changing visual size.

## Focus States

- Every interactive element must have a visible focus indicator
- Options:
  - Color change on the element itself
  - Outline minimum 2px (recommended 4px)
- Focus must meet contrast requirements too

**React Native:** provide visual feedback on focus for TV / keyboard navigation; use the `onFocus` / `onBlur` callbacks and adjust styles accordingly.

## Navigation & Links

- Navigation items must have a single function: either navigate OR expand, never both
- Links must always be underlined (web)
- Never underline text that is not a link — it causes confusion
- Avoid generic link/button labels like "More info", "See more", "Click here"
  - If unavoidable in design, add `aria-label` (web) or `accessibilityLabel` (React Native)

## Icons

- Icons should be accompanied by visible text whenever possible
- If icon-only, ensure it has an accessible label:
  - Web: `aria-label` or `aria-labelledby` on the interactive wrapper
  - React Native: `accessibilityLabel` on the `<Pressable>` / `<TouchableOpacity>`
- Decorative icons: web `aria-hidden="true"`, React Native `importantForAccessibility="no"`

## Animations

- Reduce animations to a minimum
- Always consider: what happens if the user disables animations in system settings?
  - Web: respect `prefers-reduced-motion` media query
  - React Native: check `AccessibilityInfo.isReduceMotionEnabled()` and skip/simplify animations
- Never use autoplay for sliders or carousels
  - If autoplay is required: provide pause/play control
  - Always show slide position indicator: "Slide 1 of 4"

## Forms

- Validate on client side with clear, descriptive error messages
- Error messages must identify the specific field that failed
- Avoid long single-page forms — consider splitting into steps
- Every `<input>` must have an associated `<label>` — never use `placeholder` as a substitute for label
  - In JSX: use `htmlFor` instead of `for` on `<label>`; the value must match the `<input>`'s `id`
  - If the `id` is dynamic or comes from props, `htmlFor` must use the same source
- Search buttons inside a `<form>` must be `type="submit"`, not `type="button"`
- Placeholder disappears on focus and has contrast issues by default
- Group related fields with `<fieldset>` and `<legend>`
- Error messages must be programmatically associated with the field (`aria-describedby`)
- If required fields exist:
  - Visually indicate them (e.g. asterisk with legend "Fields marked with * are required")
  - Add `aria-required="true"` or the HTML `required` attribute
- Multi-step processes must indicate progress: "Step 2 of 4"

**React Native:** use `accessibilityLabel` on `<TextInput>`, associate errors via `accessibilityHint` or by grouping inside an `accessible={true}` container with a combined label.

## Data Tables

- Use zebra stripe pattern for data tables to improve readability
- Data tables must use `<th>` for headers, never `<td>` styled as header
- Use `scope="col"` or `scope="row"` on `<th>` elements
- Every `<th>` must have an `id` attribute matching the column key
- Every `<td>` must have a `headers` attribute referencing the `id` of its corresponding `<th>`
- Never use tables for layout

**React Native:** native has no `<table>` — use `<FlatList>` / `<SectionList>` with proper `accessibilityRole="list"` and `accessibilityRole="listitem"` on rows; provide column headers as an `accessibilityLabel` on each cell or a screen-reader-only header row.

## Transactions & Confirmations

- Always include a summary page/screen before final submission of any transaction
- Always confirm outcome to the user — success or failure, explicitly

**React Native:** use `AccessibilityInfo.announceForAccessibility()` to announce the result if no navigation occurs.

## Responsive & Mobile

- Correct transformation between desktop and mobile is required (web)
- Natural responsive behavior is preferred over breakpoint-only layouts

**React Native:** ensure layouts adapt to different screen sizes and orientations; test with large system font sizes.

## Semantic HTML & ARIA (Web)

### Interactive elements
- An `<a>` must never have `type="button"` or `role="button"`
  - If it navigates: use `<a href="...">`
  - If it triggers an action: use `<button>`
  - Mixing semantics breaks screen readers and keyboard navigation
- Never use `<div>` or `<span>` as interactive elements without proper ARIA
- `<button>` inside a form should always have explicit `type="button"` or `type="submit"`

### Images
- Decorative images: `alt=""` (empty, not missing)
- Informative images: `alt` must describe the content, not the file name
- Never use "image of..." or "photo of..." in alt text

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
- In React, use `useRef` to store the triggering element and restore focus on close
- If using a portal (`createPortal`), ensure the portal root has proper ARIA attributes and focus trap still works

### Pagination & Dynamic Content
- Pagination result text (e.g. "Page 2 of 5: Showing 10 results") must use `aria-live="polite"` and `aria-atomic="true"` so screen readers announce the full updated text
- The `aria-live` region must always exist in the DOM — never conditionally render it (e.g. avoid wrapping it in an early-return or conditional JSX that removes the node); use CSS to hide it visually if needed. Screen readers cannot detect changes on newly inserted `aria-live` nodes
- If multiple pagination instances can coexist on a page, each `aria-live` region must have a unique `id`

### Screen Reader Duplication (`sr-only` + `aria-hidden`)
- When an element has both a visually-hidden `<span>` (for screen readers) and a visual `<span>` (for sighted users) showing the same text, the visual span must have `aria-hidden="true"` to prevent the screen reader from reading the same content twice

### Skip links
- Pages with navigation must include a "Skip to main content" link as the first focusable element
- Can be visually hidden but must be visible on focus

### Layout & Footer
- The page footer must always be pushed to the bottom of the viewport when content is short — use `marginTop: 'auto'` on the footer in a flex column layout with `minHeight: '100vh'` on the container

## React Native — Accessibility Props Checklist

When reviewing React Native components, verify:

- `accessible={true}` on logical groups that should be announced as one unit
- `accessibilityLabel` on every interactive element without visible text
- `accessibilityRole` matches the element purpose (`"button"`, `"link"`, `"header"`, `"image"`, `"search"`, `"tab"`, `"checkbox"`, `"switch"`, etc.)
- `accessibilityState` reflects current state: `{ disabled, selected, checked, busy, expanded }`
- `accessibilityValue` for sliders, progress bars, or elements with a current/min/max value
- `accessibilityHint` provides additional context when the label alone is not sufficient (e.g. "Double tap to open settings")
- `accessibilityLiveRegion="polite"` (Android) on regions that update dynamically
- `importantForAccessibility="no-hide-descendants"` on purely decorative containers
- `accessibilityActions` + `onAccessibilityAction` for custom actions (e.g. swipe to delete)

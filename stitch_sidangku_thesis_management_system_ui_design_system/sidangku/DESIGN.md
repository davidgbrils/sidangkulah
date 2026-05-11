---
name: SidangKu
colors:
  surface: '#f9f9ff'
  surface-dim: '#d8dae2'
  surface-bright: '#f9f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f3fb'
  surface-container: '#ecedf6'
  surface-container-high: '#e7e8f0'
  surface-container-highest: '#e1e2ea'
  on-surface: '#191c21'
  on-surface-variant: '#424752'
  inverse-surface: '#2e3037'
  inverse-on-surface: '#eff0f9'
  outline: '#727783'
  outline-variant: '#c2c6d4'
  surface-tint: '#005db7'
  primary: '#004d99'
  on-primary: '#ffffff'
  primary-container: '#1565c0'
  on-primary-container: '#dae5ff'
  inverse-primary: '#a9c7ff'
  secondary: '#00639a'
  on-secondary: '#ffffff'
  secondary-container: '#51b2fe'
  on-secondary-container: '#00436a'
  tertiary: '#813900'
  on-tertiary: '#ffffff'
  tertiary-container: '#a64c00'
  on-tertiary-container: '#ffdece'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d6e3ff'
  primary-fixed-dim: '#a9c7ff'
  on-primary-fixed: '#001b3d'
  on-primary-fixed-variant: '#00468c'
  secondary-fixed: '#cee5ff'
  secondary-fixed-dim: '#96ccff'
  on-secondary-fixed: '#001d32'
  on-secondary-fixed-variant: '#004a75'
  tertiary-fixed: '#ffdbc9'
  tertiary-fixed-dim: '#ffb68c'
  on-tertiary-fixed: '#321200'
  on-tertiary-fixed-variant: '#753400'
  background: '#f9f9ff'
  on-background: '#191c21'
  surface-variant: '#e1e2ea'
typography:
  h1:
    fontFamily: Plus Jakarta Sans
    fontSize: 22px
    fontWeight: '700'
    lineHeight: 32px
  h2:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 24px
  body:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.5px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  container-padding: 16px
  gutter: 16px
  bottom-nav-height: 80px
---

## Brand & Style
The brand personality of the design system is rooted in academic integrity, administrative precision, and professional growth. Designed specifically for the ITPLN Indonesia community, the visual language balances the weight of a university institution with the modern efficiency required for digital thesis management.

The design style is a refined interpretation of **Material Design 3**, emphasizing clarity and systematic organization. It utilizes a **Corporate / Modern** aesthetic that prioritizes content legibility and task completion. The interface evokes a sense of "digital campus" through the use of clean white surfaces, disciplined typography, and subtle role-based accents that guide the user through complex academic workflows.

## Colors
The color strategy for this design system is functional and hierarchical. The **Primary Navy (#1565C0)** serves as the anchor for the identity, symbolizing trust and authority. The **Background (#F0F4F8)** is a cool-toned neutral that reduces eye strain and distinguishes the background from the white content surfaces.

Role-based accents are critical for multi-user navigation. These accents should be applied to high-level UI elements such as top-bar indicators, active navigation states, and primary action buttons to orient the user immediately. Status colors are mapped to specific semantic meanings: blue for scheduled events, green for completion, orange for revision requirements, purple for pending states, and red for rejection.

## Typography
The design system utilizes **Plus Jakarta Sans** across all levels to maintain a contemporary, welcoming, yet professional tone. The type scale is intentionally tight to allow for high information density on administrative dashboards while maintaining clear visual hierarchy.

- **H1 (22px Bold):** Used for page titles and primary section headers.
- **H2 (16px Semibold):** Used for card titles, sub-sections, and modal headers.
- **Body (14px Regular):** The workhorse for all data entry, descriptions, and list items.
- **Labels (12px Medium):** Reserved for status chips, button text, and metadata.

All typography should follow a systematic vertical rhythm based on an 8px grid.

## Layout & Spacing
The design system employs a **Fluid Grid** model with fixed horizontal margins. On mobile devices, use a 4-column grid with 16px margins; on desktop, transition to a 12-column grid to accommodate dense data tables and sidebars.

A core component of the layout is the **Bottom Navigation Bar**, which is fixed at 80px in height. This height provides ample touch targets for the 5-item role-specific menu. Spacing between elements should follow increments of 4px or 8px, ensuring consistent alignment across all dashboard modules.

## Elevation & Depth
Hierarchy in this design system is established through **Ambient Shadows** and surface containment rather than heavy gradients. Surfaces use a pure white background to pop against the light blue-gray application background.

The primary shadow definition is `0 2px 8px rgba(0,0,0,0.06)`. This low-opacity, soft-spread shadow is applied to cards and floating elements to create a sense of depth without cluttering the visual field. Interactive elements like buttons may use a slightly more pronounced shadow on hover to indicate tactility.

## Shapes
The shape language is "Rounded," striking a balance between the friendliness of modern SaaS and the structure of academic software. 

- **Cards & Containers:** 16px corner radius to define large content areas.
- **Interactive Elements:** 12px corner radius for buttons and input fields to create a distinct interactive language.
- **Small Components:** 8px for smaller items like tooltips or nested elements.
- **Status Chips:** Fully rounded (pill-shaped) to distinguish them from actionable buttons.

## Components
- **Cards:** White background, 16px radius, and the standard 0.06 opacity shadow. Used for thesis summaries and student profiles.
- **Buttons:** 12px radius. Primary buttons use the primary navy or role-accent color. Height should be 48px for mobile accessibility.
- **Status Chips:** Use a light tinted background (12% opacity) of the status color with high-contrast text for maximum readability.
- **Bottom Navigation:** 80px height, white background, with a subtle 1px top border (#E0E6ED). Active states should use the specific role-accent color for both the icon and the label.
- **Inputs:** 12px radius with a 1px border. Focus states must use a 2px border in the primary navy color.
- **Role Accents:** Apply a vertical 4px bar on the left edge of cards or a top-border highlight on headers to signify which user perspective (Student, Lecturer, etc.) is currently active.
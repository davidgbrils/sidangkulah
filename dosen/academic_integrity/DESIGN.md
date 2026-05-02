---
name: Academic Integrity
colors:
  surface: '#f8f9ff'
  surface-dim: '#cbdbf5'
  surface-bright: '#f8f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eff4ff'
  surface-container: '#e5eeff'
  surface-container-high: '#dce9ff'
  surface-container-highest: '#d3e4fe'
  on-surface: '#0b1c30'
  on-surface-variant: '#43474f'
  inverse-surface: '#213145'
  inverse-on-surface: '#eaf1ff'
  outline: '#737780'
  outline-variant: '#c3c6d1'
  surface-tint: '#3a5f94'
  primary: '#001e40'
  on-primary: '#ffffff'
  primary-container: '#003366'
  on-primary-container: '#799dd6'
  inverse-primary: '#a7c8ff'
  secondary: '#575f65'
  on-secondary: '#ffffff'
  secondary-container: '#dbe3ea'
  on-secondary-container: '#5d656b'
  tertiary: '#2a1b00'
  on-tertiary: '#ffffff'
  tertiary-container: '#452f00'
  on-tertiary-container: '#c99100'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d5e3ff'
  primary-fixed-dim: '#a7c8ff'
  on-primary-fixed: '#001b3c'
  on-primary-fixed-variant: '#1f477b'
  secondary-fixed: '#dbe3ea'
  secondary-fixed-dim: '#bfc8ce'
  on-secondary-fixed: '#151d22'
  on-secondary-fixed-variant: '#40484d'
  tertiary-fixed: '#ffdea6'
  tertiary-fixed-dim: '#fbbc34'
  on-tertiary-fixed: '#271900'
  on-tertiary-fixed-variant: '#5e4200'
  background: '#f8f9ff'
  on-background: '#0b1c30'
  surface-variant: '#d3e4fe'
typography:
  display-lg:
    fontFamily: Public Sans
    fontSize: 57px
    fontWeight: '700'
    lineHeight: 64px
    letterSpacing: -0.25px
  headline-lg:
    fontFamily: Public Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
  headline-md:
    fontFamily: Public Sans
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
  title-lg:
    fontFamily: Public Sans
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
  title-md:
    fontFamily: Public Sans
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 24px
    letterSpacing: 0.15px
  body-lg:
    fontFamily: Public Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0.5px
  body-md:
    fontFamily: Public Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0.25px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.1px
  label-md:
    fontFamily: Inter
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
  xs: 4px
  sm: 12px
  md: 16px
  lg: 24px
  xl: 32px
  gutter: 16px
  margin-mobile: 16px
  margin-desktop: 32px
---

## Brand & Style

The design system is anchored in the principles of **Academic Integrity, Structural Clarity, and Institutional Trust**. Designed specifically for the rigorous environment of university thesis management, it balances the authoritative nature of academia with the modern efficiency required by digital workflows.

The visual style follows a **Corporate / Modern** aesthetic, heavily influenced by Material Design 3. It prioritizes high legibility, clear hierarchy, and a sense of progression. The UI avoids unnecessary ornamentation, focusing instead on "Information Architecture as Design"—where the organization of complex data (deadlines, reviewer feedback, and document versions) provides the primary visual interest. The emotional response is one of calm confidence, ensuring students and faculty feel supported during high-stakes academic milestones.

## Colors

The palette is dominated by **ITPLN Deep Blue**, a color associated with stability, depth, and expertise. This is used for primary actions, branding elements, and top-level navigation to establish an immediate sense of institutional authority.

**White and Off-White** form the canvas, providing a "paper-like" clarity essential for reading long-form academic text. A **Neutral Slate** is utilized for secondary information and iconography to prevent visual fatigue. **Tertiary Gold** is reserved strictly for high-priority alerts, such as upcoming defense dates or required revisions, providing a professional contrast to the deep blue.

The system utilizes Material 3 tonal palettes, where surface colors shift slightly in hue to indicate different container levels without relying on heavy shadows.

## Typography

This design system utilizes **Public Sans** for its primary typeface—a font originally designed for government and institutional use. It conveys a neutral, yet strong and clear personality that fits the academic context perfectly. 

- **Branding & Headlines:** Use bold weights (600-700) to create a clear sense of hierarchy and "fixed points" in the navigation.
- **Body Content:** Use regular weights with generous line heights (1.5x) to ensure that thesis abstracts and feedback comments remain readable during long review sessions.
- **Secondary Information:** Use **Inter** for labels, metadata, and captions. The slightly more compact nature of Inter allows for efficient use of space in dense tables and dashboards while maintaining a professional, utilitarian feel.

## Layout & Spacing

The layout follows a **Fluid Grid** model based on an 8dp (8px) base unit, consistent with Material Design 3. This ensures a mathematical rhythm across all screens, from mobile thesis tracking to desktop administrative dashboards.

For mobile, a 4-column grid is used with 16px margins. For desktop/tablet, a 12-column grid with 24px-32px margins is preferred to handle complex data views. White space is used intentionally as a separator rather than lines whenever possible, creating an open, "airy" feeling that reduces the stress of academic management. Padding within cards and containers should be generous (min 16px) to maintain a premium, organized appearance.

## Elevation & Depth

Elevation in this design system is primarily conveyed through **Tonal Layers** rather than heavy drop shadows. Following M3 principles, the background uses a base surface color, while interactive cards and modals use "Surface Container" tints—slightly lighter or darker variations of the primary background.

Where shadows are necessary (such as on primary Floating Action Buttons or high-level Modals), use **Ambient Shadows**: extremely diffused, low-opacity (10-15%) blurs with a subtle blue tint (`#003366`). This creates a soft, modern lift that feels integrated into the interface rather than floating disconnectedly above it. Document "previews" should use a thin 1px border in a muted neutral shade to simulate the edge of a paper stack.

## Shapes

The shape language is **Rounded (Level 2)**. A corner radius of **8px (0.5rem)** is the standard for cards, input fields, and buttons. This provides a modern, approachable feel that softens the "coldness" of a traditional academic application without appearing overly casual or juvenile.

Larger containers, such as bottom sheets or prominent dashboard panels, may use **rounded-lg (16px)** or **rounded-xl (24px)** to emphasize their role as primary content buckets. Progress bars and status tags (Chips) use fully rounded pill shapes to distinguish them as dynamic, status-driven elements.

## Components

The components within this design system are built for high utility and information density:

- **Buttons:** Primary buttons use a solid ITPLN Deep Blue fill with white text. Secondary buttons use an outlined style with a 1px stroke. All buttons utilize an 8px corner radius.
- **Input Fields:** Use "Outlined" variants from M3. Labels should be clear and persistent when focused. Use the Neutral Slate for borders to keep the focus on the user's input.
- **Thesis Progress Stepper:** A custom component displaying the journey from "Proposal" to "Final Defense." Use deep blue for completed steps and a muted neutral for pending ones.
- **Status Chips:** Small, pill-shaped indicators for document status (e.g., "Approved," "Revision Required"). Use low-saturation background colors with high-saturation text to maintain readability without overwhelming the layout.
- **Cards:** White or slightly tinted surface cards with 8px radius and a very subtle 1px border or minimal ambient shadow. Use cards to group student data, examiner lists, and feedback threads.
- **Lists:** Clean, 3-line list items for document history, showing the file name, uploader, and timestamp with clear typography-based hierarchy.
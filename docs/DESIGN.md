---
name: Cinematic Noir
colors:
  surface: '#121317'
  surface-dim: '#121317'
  surface-bright: '#38393d'
  surface-container-lowest: '#0d0e12'
  surface-container-low: '#1a1b1f'
  surface-container: '#1e1f23'
  surface-container-high: '#292a2e'
  surface-container-highest: '#343539'
  on-surface: '#e3e2e7'
  on-surface-variant: '#c4c7c7'
  inverse-surface: '#e3e2e7'
  inverse-on-surface: '#2f3034'
  outline: '#8e9192'
  outline-variant: '#444748'
  surface-tint: '#c9c6c5'
  primary: '#c9c6c5'
  on-primary: '#313030'
  primary-container: '#0a0a0a'
  on-primary-container: '#7b7979'
  inverse-primary: '#5f5e5e'
  secondary: '#c8c6c5'
  on-secondary: '#303030'
  secondary-container: '#474746'
  on-secondary-container: '#b7b5b4'
  tertiary: '#e9c176'
  on-tertiary: '#412d00'
  tertiary-container: '#100900'
  on-tertiary-container: '#957432'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#e5e2e1'
  primary-fixed-dim: '#c9c6c5'
  on-primary-fixed: '#1c1b1b'
  on-primary-fixed-variant: '#474646'
  secondary-fixed: '#e5e2e1'
  secondary-fixed-dim: '#c8c6c5'
  on-secondary-fixed: '#1b1b1c'
  on-secondary-fixed-variant: '#474746'
  tertiary-fixed: '#ffdea5'
  tertiary-fixed-dim: '#e9c176'
  on-tertiary-fixed: '#261900'
  on-tertiary-fixed-variant: '#5d4201'
  background: '#121317'
  on-background: '#e3e2e7'
  surface-variant: '#343539'
typography:
  display-lg:
    fontFamily: notoSerif
    fontSize: 48px
    fontWeight: '700'
    lineHeight: '1.1'
    letterSpacing: -0.02em
  display-md:
    fontFamily: notoSerif
    fontSize: 36px
    fontWeight: '600'
    lineHeight: '1.2'
    letterSpacing: -0.01em
  headline-lg:
    fontFamily: notoSerif
    fontSize: 28px
    fontWeight: '600'
    lineHeight: '1.3'
  headline-md:
    fontFamily: beVietnamPro
    fontSize: 20px
    fontWeight: '600'
    lineHeight: '1.4'
  body-lg:
    fontFamily: beVietnamPro
    fontSize: 18px
    fontWeight: '400'
    lineHeight: '1.6'
  body-md:
    fontFamily: beVietnamPro
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.6'
  label-lg:
    fontFamily: beVietnamPro
    fontSize: 14px
    fontWeight: '600'
    lineHeight: '1.2'
    letterSpacing: 0.05em
  label-sm:
    fontFamily: beVietnamPro
    fontSize: 12px
    fontWeight: '500'
    lineHeight: '1.2'
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  unit: 8px
  container-padding: 24px
  gutter: 16px
  stack-sm: 8px
  stack-md: 16px
  stack-lg: 32px
  section-gap: 48px
---

## Brand & Style
The brand personality of this design system is authoritative, curated, and deeply immersive. It targets a demographic of cinephiles and premium content consumers who value both the art of filmmaking and the convenience of modern technology. The emotional response is one of "quiet luxury"—the interface recedes to let the cinematography shine, providing a theater-like experience in the palm of the hand.

The design style is a hybrid of **Minimalism** and **Glassmorphism**. It utilizes heavy whitespace (or "blackspace") to create a sense of focus, while using translucent layers and frosted glass effects to establish depth within a dark, cinematic environment. The aesthetic is punctuated by subtle, high-fidelity glows that mimic the light spill of a projector in a dark room.

## Colors
This design system is built on a "True Dark" foundation. The primary background uses a deep, ink-black to maximize contrast with movie posters and ensure OLED efficiency. Graphite gray is used for container surfaces to provide a logical separation of content without breaking the cinematic immersion.

The palette features two distinct highlights:
- **Luxurious Gold (#C5A059):** Reserved for "Premium" or "Collector" status indicators, star ratings, and high-level editorial curation.
- **Metallic Blue (#2C5EAD):** Utilized for primary Calls to Action (CTAs) and interactive states. This blue should be applied with a subtle linear gradient to simulate a brushed metal texture.
- **Typography Colors:** Titles use an off-white to reduce eye strain, while body text uses a muted silver-gray.

## Typography
The typographic scale establishes a clear hierarchy between editorial "curation" and functional "navigation." 

**Noto Serif** is the voice of the critic; it is used for movie titles, category headers, and featured editorial quotes. It conveys a traditional, literary authority reminiscent of high-end film journals. 

**Be Vietnam Pro** serves as the functional workhorse. It is used for all metadata (duration, year, genre), descriptions, and UI controls. To maintain the "Classic Modern" look, labels and small caps should utilize slightly increased letter spacing to ensure legibility against dark backgrounds.

## Layout & Spacing
This design system utilizes a **Fixed Grid** model for desktop and tablet, centered with generous side margins to create a focused viewing experience. For mobile, the system transitions to a fluid model with a 16px gutter.

The spacing rhythm is strictly based on an 8px scale. 
- **Horizontal Flow:** Movie posters are arranged in a horizontal scroll (carousel) with 16px spacing between items. 
- **Vertical Stack:** Sections are separated by 48px to allow the "poster art" to breathe. 
- **Safe Zones:** A 15% vertical gradient overlay must be applied to the bottom of full-bleed hero images to ensure typography remains legible regardless of the movie poster's color palette.

## Elevation & Depth
Depth is created through **Glassmorphism** and **Tonal Layers** rather than traditional drop shadows. 

1.  **Level 0 (Base):** Pure Black (#050505).
2.  **Level 1 (Cards/Containers):** Graphite Gray (#1C1C1C) with a 1px inner border of 10% white to define edges.
3.  **Level 2 (Overlays/Modals):** A background blur (20px) with a 60% opacity fill of the Secondary color.
4.  **Interactive Glows:** When a movie card or button is focused (via remote or hover), it should emit a soft, 15px outer glow using the Gold or Metallic Blue color at 30% opacity. This simulates the ambient light of a screen.

## Shapes
The shape language is sophisticated and "Soft." By using a 4px (0.25rem) base radius, the UI maintains a professional, architectural feel that avoids the playfulness of fully rounded corners.

- **Movie Posters:** Use the `rounded-lg` (8px) setting to slightly soften the imagery.
- **Buttons & Inputs:** Use the `rounded` (4px) setting to maintain a crisp, clean-lined look.
- **Avatars:** The only exception to the rule; these remain circular to differentiate user profiles from content.

## Components
### Buttons
- **Primary:** Metallic Blue gradient background (top-down), white text, 4px corner radius.
- **Secondary (Editorial):** Gold 1px border, transparent background, Gold text.
- **Ghost:** Transparent background, muted gray text, used for secondary actions like "More Info."

### Movie Cards
Cards should prioritize the poster art. Title and metadata should be hidden or placed below the image unless in a "Featured" state. On hover/focus, cards scale up by 5% with a subtle gold glow.

### Chips & Tags
Used for genres (e.g., "Film Noir," "French New Wave"). These are pill-shaped with a 10% white semi-transparent fill and a subtle blur, keeping them secondary to the main content.

### Inputs
Search bars and profile forms use the Graphite Gray color with a 1px border that turns Metallic Blue on focus. Use Be Vietnam Pro for all input text.

### Progress Bars
Used for "Continue Watching." These should be thin (2px) and use the Metallic Blue color for the progress fill, set against a dark gray track.
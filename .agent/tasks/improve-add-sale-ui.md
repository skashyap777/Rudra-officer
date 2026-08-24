---
task: Improve Add Sale Screen UI/UX
status: in-progress
---

# Task: Improve Add Sale Screen UI/UX

## Objectives
- Make the screen more professional and "edge-to-edge".
- Remove rounded corners (square edges).
- Ensure boxes span left-to-right with no side margins.
- Maintain app's primary color (`0xFF2D0160`).
- Improve overall layout for a premium ERP feel.

## Proposed Changes

### 1. Global Layout Changes (`lib/app/modules/sales/views/sale_view.dart`)
- Change `Scaffold` body padding/margins to 0.
- Remove `borderRadius` from all `Container` and `Decoration` objects.
- Adjust `Divider` thickness and colors for a cleaner separation.
- Update the Header Card to be edge-to-edge with square corners.
- Update the Product Search Bar to be edge-to-edge.
- Update Product Cards to be edge-to-edge.

### 2. Component Refinement
- Update `AddItemDialog` or related modals to also follow the square-edge theme if applicable (though usually modals have some rounding, I will minimize or remove it as requested).
- Adjust internal padding for a tighter, more data-dense look typical of professional ERPs.

### 3. Visual Polish
- Use the app's brand color for active states and primary buttons.
- Ensure typography remains clear and professional.

## Verification Criteria
- [ ] No rounded corners on any main UI elements.
- [ ] Boxes span full width of the screen (no left/right gaps).
- [ ] Consistent use of `#2D0160`.
- [ ] UI feels more "Pro" and less "Generic Material".

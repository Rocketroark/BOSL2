# Parametric Game Insert System

A comprehensive, modular OpenSCAD system for creating custom board game box inserts using the BOSL2 library.

## Overview

This system allows you to design custom organizers for any board game by simply adjusting parameters. No programming knowledge required - just use the OpenSCAD Customizer interface to configure dimensions and enable/disable different container types.

## Features

- **Multiple Container Types**
  - Card holders (vertical storage with finger cutouts)
  - Component bins (general storage with optional dividers)
  - Dice trays (with optional felt/fabric relief)
  - Token trays (multi-compartment organizers)
  - Custom storage containers

- **Automatic Layout Validation**
  - Ensures all containers fit within your box dimensions
  - Reports overflow issues in the console
  - Helpful error messages for troubleshooting

- **Optimized for 3D Printing**
  - Configurable wall thickness
  - Rounded corners for easier printing
  - Optional stackable features
  - Finger grips for easy removal

- **Highly Customizable**
  - Box dimensions
  - Container sizes and positions
  - Number of compartments
  - Rounding, chamfers, and tolerances
  - Stackable and modular options

## 🆕 New Features (v1.1)

### Filament-Saving Hex Patterns
- **Honeycomb floor patterns** - Save 30-40% filament on container floors while maintaining strength
- **Hex wall cutouts** - Save an additional 20-30% on walls
- **Combined savings** - Reduce total filament usage by 40-50%!
- Fully customizable hex size and wall thickness
- Toggle on/off per container type

### Snap-On Lids
- **Three lid types**:
  - **Snap-fit**: Secure snap clips, best for components that shouldn't spill
  - **Sliding**: Easy-access lids that slide on/off
  - **Friction-fit**: Simplest design, press to fit
- Configurable tolerance for perfect fit
- Automatically generate lids for token trays and coin bins
- Built-in finger grips for easy removal

### Specialized Bin Types
Choose from 5 different bin configurations:
1. **General Storage** - Classic bin with optional divider
2. **Coin Slots** - Vertical slots perfect for coins or poker chips (configurable number of slots)
3. **Token Wells** - Circular wells for round tokens or meeples (auto-calculates layout)
4. **Small Parts Grid** - Fixed 4x3 compartment grid for tiny components
5. **Card Dividers** - Multiple vertical sections for sorted cards (configurable sections)

All specialized bins include hex floor patterns for maximum filament savings!

## Quick Start

### 1. Choose Your Approach

**Option A: Multi-Container Mode** (Most Flexible - NEW!)
- Open `parametric_game_insert.scad`
- Set `layout_mode = "multi"` in Customizer
- Enable Container Slots 1-4 (or more as needed)
- For each slot, choose:
  - Container type (card_holder, token_tray, component_bin, dice_tray)
  - Dimensions (width, depth, height)
  - Position (x, y coordinates)
  - Type-specific settings (compartments, bin type, lids, etc.)
- **Perfect for:** Multiple token trays, multiple bins with different types, full customization

**Option B: Auto-Layout System** (Easiest)
- Open `parametric_game_insert.scad`
- Keep `layout_mode = "auto"` (default)
- Set your box dimensions
- Enable the containers you need
- Let the system automatically arrange them in a grid
- **Perfect for:** Quick setups, simple layouts, getting started

**Option C: Use a Game Template**
- Start with `examples/game_insert_template.scad`
- Measure your game box and components
- Adjust parameters to match your needs
- Manually position containers
- **Perfect for:** Learning the system, specific game examples

**Option D: Copy an Example**
- Look at `examples/game_insert_catan.scad`, `game_insert_ticket_to_ride.scad`, or `game_insert_multi_container_example.scad`
- Copy and modify for your game
- **Perfect for:** Seeing complete working examples

### 2. Measure Your Game Box

You'll need three measurements (in millimeters):

1. **Internal Width** - Left to right inside the box
2. **Internal Depth** - Front to back inside the box
3. **Internal Height** - Bottom to lid (account for any lip/rim)

> **Tip:** Subtract 1-2mm from height to ensure the lid closes properly

### 3. Measure Your Components

For each type of component, measure:

- **Cards:** Width, height, and stack thickness
  - Add 4-6mm to dimensions for easy removal
  - Account for sleeved cards if applicable

- **Tokens/Pieces:** Maximum dimensions when stacked
  - Add 5-10mm height clearance
  - Consider shape (round vs. square)

- **Dice:** Typically 15-20mm per die
  - 20-30mm height trays work well

### 4. Configure and Preview

1. Open your chosen `.scad` file in OpenSCAD
2. Open the Customizer panel (Window → Customizer)
3. Adjust parameters in each section
4. Click the preview button (or press F5)
5. Check the console for validation messages

### 5. Export for Printing

1. Once satisfied with the preview, render (F6)
2. Export as STL (File → Export → Export as STL)
3. Import into your slicer software

## Container Types

### Card Holder
Vertical storage for card decks with finger access cutout.

**Best for:** Playing cards, game cards, sleeved cards

**Key Parameters:**
- `card_width` - Card width + 4-6mm clearance
- `card_depth` - Card height + 4-6mm clearance
- `card_height` - Deck thickness + clearance
- `card_finger_cutout` - Diameter of finger access hole (0 to disable)

### Component Bin
General-purpose storage container with optional center divider.

**Best for:** Tokens, meeples, coins, large components

**Key Parameters:**
- `bin_width`, `bin_depth`, `bin_height` - Container dimensions
- `bin_add_divider` - Add vertical center divider (true/false)

### Dice Tray
Low tray with optional recess for felt or fabric lining.

**Best for:** Dice storage, dice rolling area

**Key Parameters:**
- `dice_width`, `dice_depth`, `dice_height` - Tray dimensions
- `dice_felt_relief` - Depth to recess for felt (0 = none)

### Token Tray
Multi-compartment organizer with configurable grid.

**Best for:** Sorted tokens, player markers, small pieces

**Key Parameters:**
- `token_width`, `token_depth`, `token_height` - Overall dimensions
- `token_compartments_x` - Number of columns
- `token_compartments_y` - Number of rows

## Layout Strategies

### Auto Layout (parametric_game_insert.scad)

The automatic layout system arranges containers in a grid:

```
┌─────────┬─────────┐
│ Card    │ Bin     │
│ Holder  │         │
├─────────┼─────────┤
│ Dice    │ Token   │
│ Tray    │ Tray    │
└─────────┴─────────┘
```

**Pros:**
- Easy to use
- Automatic sizing
- Quick iterations

**Cons:**
- Less control over exact positions
- Limited to grid layouts

### Manual Layout (template)

Position each container explicitly:

**Pros:**
- Precise control
- Irregular layouts possible
- Maximize space efficiency

**Cons:**
- Must calculate positions
- More parameters to manage

**Positioning Tips:**
- Positions are from bottom-left corner (0,0)
- X-axis goes left to right
- Y-axis goes front to back
- Use `container_gap` for consistent spacing

## Using the New Features

### Enabling Hex Patterns

**Filament Savings:**
Hex patterns can reduce your filament usage by 40-50% with minimal strength reduction!

**Floor Patterns:**
```scad
hex_floor_pattern = true;    // Enable honeycomb floors
hex_floor_size = 8;          // Hex diameter in mm (4-15mm)
hex_floor_wall = 0.8;        // Wall thickness between hexes
```

**Wall Patterns:**
```scad
hex_wall_pattern = true;     // Enable hex cutouts in walls
hex_wall_size = 10;          // Hex diameter in mm (6-20mm)
```

**Best Practices:**
- Floor patterns work great on all containers
- Wall patterns best for taller containers (>30mm height)
- Smaller hex size = more filament saved but longer print time
- Larger hex size = faster printing but less savings
- Recommended: 8mm floor, 10mm walls

### Adding Lids to Trays

Enable lids for token trays and coin bins:

```scad
generate_lids = true;              // Enable lid generation
lid_type = "snap";                 // Choose: snap, slide, or friction
lid_tolerance = 0.3;               // Fit tolerance (0.1-0.8mm)
lid_thickness = 2.0;               // Lid top thickness
```

**Lid Type Comparison:**

| Type | Pros | Cons | Best For |
|------|------|------|----------|
| **Snap** | Secure, won't fall off | Harder to remove | Transport, shaking |
| **Slide** | Easy access | Needs tracks on container | Frequent access |
| **Friction** | Simple, fast to print | Can pop off if bumped | Stationary boxes |

**Printing Lids:**
- Print lids separately from trays
- Use 3-4 top/bottom layers for rigidity
- Test fit with one lid before printing all
- Adjust `lid_tolerance` if too tight/loose

### Selecting Specialized Bin Types

Change the `bin_type` parameter to select different organizational styles:

```scad
bin_type = "coin_slot";       // Options below
bin_slots = 6;                 // Number of slots/wells/sections
coin_slot_width = 28;          // Width for coin slots (20-40mm)
```

**Bin Type Guide:**

**1. General Storage** (`bin_type = "general"`)
- Traditional open bin with optional center divider
- Use for: Large tokens, cards, bulky components
- Parameter: `bin_add_divider` (true/false)

**2. Coin Slots** (`bin_type = "coin_slot"`)
- Vertical slots perfect for stacking coins/chips
- Auto-calculates slot spacing
- Parameters:
  - `bin_slots` - Number of slots (3-12)
  - `coin_slot_width` - Slot width in mm (20-40)
- Use for: Coins, poker chips, resource tokens

**3. Token Wells** (`bin_type = "token_well"`)
- Circular depressions for round tokens
- Auto-arranges in grid pattern
- Parameter: `bin_slots` - Number of wells (3-12)
- Use for: Round tokens, meeples, small dice

**4. Small Parts Grid** (`bin_type = "small_parts"`)
- Fixed 4x3 grid (12 compartments)
- No additional configuration needed
- Use for: Tiny components, mixed small parts

**5. Card Dividers** (`bin_type = "card_divider"`)
- Multiple vertical sections for card sorting
- Parameter: `bin_slots` - Number of sections (3-12)
- Use for: Sorted card decks, player cards

### Combining Features

You can mix and match features for optimal results:

**Maximum Filament Savings:**
```scad
hex_floor_pattern = true;
hex_wall_pattern = true;
bin_type = "token_well";     // Wells + hex pattern
```

**Organized & Secure:**
```scad
bin_type = "coin_slot";
generate_lids = true;
lid_type = "snap";           // Coins won't spill
hex_floor_pattern = true;    // Save filament too!
```

**Quick Access:**
```scad
bin_type = "small_parts";
generate_lids = true;
lid_type = "slide";          // Easy sliding access
```

## Multi-Container Mode

The multi-container mode is a powerful feature that lets you create **multiple instances** of any container type, each with independent customization. This solves the limitation of the auto-layout system where you can only have one of each container type.

### When to Use Multi-Container Mode

Use multi-container mode when you need:
- **Multiple token trays** with different compartment layouts
- **Multiple component bins** with different specialized types (some coin slots, some token wells)
- **Per-container lid control** (some with lids, some without)
- **Precise positioning** for irregular box shapes
- **Full customization** of every container

### How It Works

1. **Switch to multi mode:**
   ```scad
   layout_mode = "multi";
   ```

2. **Enable container slots:**
   Each slot represents one container. Currently supports 4 slots (expandable).
   ```scad
   c1_enable = true;   // Turn on slot 1
   c2_enable = true;   // Turn on slot 2
   c3_enable = false;  // Slot 3 disabled
   c4_enable = false;  // Slot 4 disabled
   ```

3. **Configure each slot independently:**

### Container Slot Parameters

Every slot has these configurable parameters:

**Basic Settings:**
- `c#_type` - Container type: "card_holder", "component_bin", "dice_tray", or "token_tray"
- `c#_width` - Width in mm
- `c#_depth` - Depth in mm
- `c#_height` - Height in mm
- `c#_pos_x` - X position from left edge (mm)
- `c#_pos_y` - Y position from front edge (mm)

**Type-Specific Settings:**
- `c#_bin_type` - For component_bin: "general", "coin_slot", "token_well", "small_parts", "card_divider"
- `c#_comp_x` - Number of compartments/slots (X direction)
- `c#_comp_y` - Number of compartments (Y direction, for token trays)
- `c#_divider` - Add center divider (for general bins)
- `c#_cutout` - Finger cutout size (for card holders)
- `c#_lid` - Generate lid for this container (true/false)

### Example: Multiple Token Trays

Create two token trays with different layouts:

```scad
layout_mode = "multi";

// Slot 1: 2x2 token tray WITH lid
c1_enable = true;
c1_type = "token_tray";
c1_width = 65;
c1_depth = 65;
c1_height = 30;
c1_pos_x = 1;
c1_pos_y = 1;
c1_comp_x = 2;  // 2 columns
c1_comp_y = 2;  // 2 rows
c1_lid = true;  // This one gets a lid

// Slot 2: 3x3 token tray WITHOUT lid
c2_enable = true;
c2_type = "token_tray";
c2_width = 65;
c2_depth = 65;
c2_height = 30;
c2_pos_x = 68;  // Next to slot 1
c2_pos_y = 1;
c2_comp_x = 3;  // 3 columns
c2_comp_y = 3;  // 3 rows
c2_lid = false; // No lid for this one
```

### Example: Multiple Specialized Bins

Create multiple component bins with different types:

```scad
layout_mode = "multi";

// Slot 1: Coin slot bin
c1_enable = true;
c1_type = "component_bin";
c1_bin_type = "coin_slot";
c1_width = 90;
c1_depth = 70;
c1_height = 35;
c1_pos_x = 1;
c1_pos_y = 1;
c1_comp_x = 6;  // 6 coin slots
c1_lid = true;

// Slot 2: Token well bin
c2_enable = true;
c2_type = "component_bin";
c2_bin_type = "token_well";
c2_width = 90;
c2_depth = 90;
c2_height = 30;
c2_pos_x = 95;
c2_pos_y = 1;
c2_comp_x = 9;  // 9 circular wells
c2_lid = false;

// Slot 3: Small parts grid
c3_enable = true;
c3_type = "component_bin";
c3_bin_type = "small_parts";
c3_width = 90;
c3_depth = 90;
c3_height = 25;
c3_pos_x = 190;
c3_pos_y = 1;
// Small parts is fixed 4x3 grid
c3_lid = true;
```

### Positioning Tips for Multi-Container Mode

- **Origin:** Position (0,0) is the bottom-left corner (front-left of box)
- **X-axis:** Goes left to right
- **Y-axis:** Goes front to back
- **Spacing:** Use `container_gap` value between containers (typically 1mm)
- **Formula:** Next container X position = previous X + previous width + gap

**Example calculation:**
```
Container 1: pos_x = 1, width = 65
Container 2: pos_x = 1 + 65 + 1 = 67
Container 3: pos_x = 67 + 65 + 1 = 133
```

### Validation in Multi-Container Mode

The system validates each container:
- Checks if container fits within box dimensions
- Reports overflow in console
- Shows which containers have issues

Watch the console output for messages like:
```
Container 0 (token_tray): ✓ FITS [65x65x30mm] at pos [1,1]
Container 1 (component_bin): ✗ OVERFLOW [90x90x40mm] at pos [250,1]
```

### Benefits of Multi-Container Mode

✅ **Multiple Instances** - Create 2+ token trays, 2+ bins, etc.
✅ **Individual Customization** - Each container independently configured
✅ **Precise Control** - Exact positioning for space optimization
✅ **Mix Types** - Different bin types in same insert
✅ **Per-Container Lids** - Choose which containers get lids
✅ **Flexible Layouts** - Not limited to grid patterns

### See Also

- `examples/game_insert_multi_container_example.scad` - Complete working example
- Auto-layout mode documentation (simpler but less flexible)

## Advanced Features

### Stackable Containers

Enable `stackable = true` to add registration features:
- Rim on top edge (male)
- Recess on bottom (female)
- Containers stack securely
- Adjustable tolerance

### Finger Grips

Enable `add_finger_grips = true` for notches on sides:
- Makes containers easier to remove
- Especially useful for taller containers
- Placed on front and back walls

### Top Chamfer

`top_chamfer` adds angled edge inside top rim:
- Makes containers easier to insert into box
- Helps with alignment
- Reduces chance of catching on box edges

### Custom Dividers

For component bins and token trays:
- Adjust number of compartments
- Dividers integrate with floor
- Equal spacing automatically calculated

## Printing Guidelines

### Recommended Settings

- **Layer Height:** 0.2mm (or 0.15mm for finer details)
- **Walls:** 2-3 perimeters
- **Infill:** 10-15% (gyroid or grid pattern)
- **Top/Bottom Layers:** 3-4 layers
- **Supports:** Usually not needed if printed face-down

### Orientation

**Best:** Print with opening facing UP (as oriented in OpenSCAD)
- No supports needed
- Smooth exterior
- Slightly rougher interior (not visible in use)

**Alternative:** Print opening facing DOWN
- Smoother interior
- May need supports for finger cutouts
- Rougher exterior

### Material Recommendations

- **PLA:** Easy to print, rigid, economical
- **PETG:** More flexible, stronger, better for handled frequently
- **ABS:** Strong, heat resistant (for cars on hot days)

### Post-Processing

- **Felt/Fabric Lining:** Use `dice_felt_relief` or `felt_relief` parameter
  - Measure felt thickness
  - Set relief to felt thickness
  - Glue felt to recessed floor

- **Smoothing:** Light sanding of top edges improves finish

## Troubleshooting

### "Container overflows box" error

**Problem:** Container dimensions + position exceed box size

**Solutions:**
1. Reduce container width/depth/height
2. Adjust container position
3. Increase box dimensions (if possible)
4. Check validation report in console

### Containers too tight/loose

**Problem:** Containers don't fit in box or are loose

**Solutions:**
- Too tight: Increase `container_gap` parameter
- Too loose: Decrease `container_gap`, add stackable features
- Check actual box dimensions vs. parameters

### Finger cutout not working

**Problem:** Can't get fingers into card holder

**Solutions:**
- Increase `card_finger_cutout` diameter (try 30-35mm)
- Increase `card_height` for more access
- Ensure cards don't fill entire height

### Dividers too thin/thick

**Problem:** Dividers breaking or taking too much space

**Solutions:**
- Breaking: Increase `wall_thickness` (try 2.5-3.0mm)
- Too thick: Decrease `wall_thickness` (minimum 1.5mm for PLA)

### Print failing

**Problem:** Print not adhering or failing mid-print

**Solutions:**
- Enable brim or raft in slicer
- Reduce print speed for first layer
- Increase bed temperature
- Clean print bed thoroughly

## Examples Included

### 1. Settlers of Catan (`game_insert_catan.scad`)

Organizes:
- Resource cards (2 decks)
- Development cards
- Terrain hex tiles
- Player pieces (5 colors)
- Number tokens
- Dice

### 2. Ticket to Ride (`game_insert_ticket_to_ride.scad`)

Organizes:
- Train car cards
- Destination tickets
- Train pieces (5 player colors)
- Station markers
- Scoring markers

### 3. Template (`game_insert_template.scad`)

Fully customizable starting point with:
- 5 container slots
- Detailed comments
- Validation system
- Tips and instructions

## File Structure

```
BOSL2/
├── parametric_game_insert.scad          # Main auto-layout system
├── GAME_INSERT_README.md                # This file
└── examples/
    ├── game_insert_catan.scad           # Catan example
    ├── game_insert_ticket_to_ride.scad  # Ticket to Ride example
    └── game_insert_template.scad        # Blank template
```

## Tips and Best Practices

### Design Process

1. **Measure twice, model once**
   - Verify all measurements before starting
   - Test-print one container first

2. **Start simple**
   - Begin with basic rectangular containers
   - Add features (dividers, cutouts) after basic fit confirmed

3. **Iterate**
   - Make small adjustments
   - Preview frequently
   - Check validation output

### Space Optimization

1. **Nested containers**
   - Shorter containers can nest inside taller ones during storage
   - Design complementary heights

2. **Vertical space**
   - Use full box height when possible
   - Stack containers if game board goes on top

3. **Irregular shapes**
   - For odd-shaped spaces, create custom containers
   - Modify modules or combine types

### Making It Last

1. **Reinforce stress points**
   - Increase wall thickness in high-use areas
   - Add extra perimeters in slicer

2. **Round corners**
   - Rounded corners are stronger than sharp
   - Easier on hands during use

3. **Test fit before finalizing**
   - Print one container first
   - Verify fit in box and with components
   - Adjust as needed

## Contributing

Have you created an insert for a popular game? Consider sharing:

1. Create a new file in `examples/`
2. Name it `game_insert_[game_name].scad`
3. Include comments documenting components
4. Test print and verify fit
5. Submit a pull request!

## License

This game insert system is part of the BOSL2 library and uses the same license.

## Support

For issues specific to the game insert system:
- Check the troubleshooting section above
- Review validation output in OpenSCAD console
- Verify measurements and parameters

For BOSL2 library issues:
- See main BOSL2 documentation
- Check BOSL2 tutorials in `tutorials/` directory

## Version History

- v1.2 (2026-01) - Multi-Container Mode Update
  - **NEW:** Multi-Container Mode - create multiple instances of any container type!
  - **NEW:** 4 configurable container slots (each independently customizable)
  - **NEW:** Per-container settings:
    - Individual container types (mix token trays, bins, card holders, etc.)
    - Independent dimensions and positioning
    - Per-container lid control
    - Type-specific settings (compartments, bin types, etc.)
  - Layout mode selector: "auto" (grid) or "multi" (custom)
  - Validation works with both modes
  - Example file: `game_insert_multi_container_example.scad`
  - Comprehensive documentation for multi-container workflows
  - **Use case:** Multiple token trays with different layouts, multiple specialized bins

- v1.1 (2026-01) - Filament Saving & Specialization Update
  - **NEW:** Honeycomb hex patterns for floors (30-40% filament savings)
  - **NEW:** Hex cutout patterns for walls (20-30% additional savings)
  - **NEW:** Snap-fit, sliding, and friction-fit lids for trays
  - **NEW:** 5 specialized bin types:
    - Coin slot bins (vertical storage)
    - Token well bins (circular compartments)
    - Small parts grid (4x3 compartments)
    - Card divider bins (multiple sections)
    - General storage (enhanced with hex patterns)
  - All new features fully customizable via Customizer
  - Example file demonstrating all new features
  - Comprehensive documentation updates

- v1.0 (2026-01) - Initial release
  - Auto-layout system
  - 4 container types
  - Validation system
  - Example files (Catan, Ticket to Ride, Template)

---

**Happy organizing! May your game components be forever sorted!** 🎲🃏🎮

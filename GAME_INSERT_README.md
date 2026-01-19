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

## Quick Start

### 1. Choose Your Approach

**Option A: Use the Auto-Layout System** (Easiest)
- Open `parametric_game_insert.scad`
- Set your box dimensions
- Enable the containers you need
- Let the system automatically arrange them

**Option B: Use a Game Template**
- Start with `examples/game_insert_template.scad`
- Measure your game box and components
- Adjust parameters to match your needs
- Manually position containers

**Option C: Copy an Example**
- Look at `examples/game_insert_catan.scad` or `game_insert_ticket_to_ride.scad`
- Copy and modify for your game
- Full control over layout and features

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

- v1.0 (2026-01) - Initial release
  - Auto-layout system
  - 4 container types
  - Validation system
  - Example files (Catan, Ticket to Ride, Template)

---

**Happy organizing! May your game components be forever sorted!** 🎲🃏🎮

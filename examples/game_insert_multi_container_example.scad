/*
 * Multi-Container Mode Example
 *
 * Demonstrates the new multi-container mode where you can create
 * multiple instances of each container type, each individually customized.
 *
 * This example shows:
 * - 2 token trays with different compartment configurations
 * - 1 coin slot bin
 * - 1 card holder
 *
 * All containers are manually positioned for maximum space efficiency.
 */

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <BOSL2/structs.scad>

/* [Box Dimensions] */
box_width = 280;
box_depth = 200;
box_height = 70;

/* [Container Options] */
wall_thickness = 2.0;
floor_thickness = 1.5;
corner_radius = 2.5;
container_gap = 1.0;

/* [Filament Saving] */
hex_floor_pattern = true;
hex_floor_size = 8;
hex_floor_wall = 0.8;
hex_wall_pattern = false;
hex_wall_size = 10;

/* [Lid Options] */
lid_type = "snap"; // [snap:Snap-fit, slide:Sliding, friction:Friction-fit]
lid_tolerance = 0.3;
lid_thickness = 2.0;

/* [Layout Configuration] */
// Set to multi for this example
layout_mode = "multi"; // [auto:Auto Grid, multi:Multi-Container]

/* [Container Slot 1 - Token Tray 2x2] */
c1_enable = true;
c1_type = "token_tray"; // [card_holder, component_bin, dice_tray, token_tray]
c1_width = 65;
c1_depth = 65;
c1_height = 30;
c1_pos_x = 1;
c1_pos_y = 1;
c1_bin_type = "general"; // Not used for token tray
c1_comp_x = 2; // 2 columns
c1_comp_y = 2; // 2 rows = 4 compartments total
c1_divider = false;
c1_cutout = 0;
c1_lid = true; // This tray gets a lid

/* [Container Slot 2 - Token Tray 3x3] */
c2_enable = true;
c2_type = "token_tray"; // [card_holder, component_bin, dice_tray, token_tray]
c2_width = 65;
c2_depth = 65;
c2_height = 30;
c2_pos_x = 68; // Position next to slot 1
c2_pos_y = 1;
c2_bin_type = "general";
c2_comp_x = 3; // 3 columns
c2_comp_y = 3; // 3 rows = 9 compartments total
c2_divider = false;
c2_cutout = 0;
c2_lid = false; // This one has no lid

/* [Container Slot 3 - Coin Slot Bin] */
c3_enable = true;
c3_type = "component_bin"; // [card_holder, component_bin, dice_tray, token_tray]
c3_width = 145;
c3_depth = 65;
c3_height = 35;
c3_pos_x = 135;
c3_pos_y = 1;
c3_bin_type = "coin_slot"; // Specialized coin slots!
c3_comp_x = 5; // 5 coin slots
c3_comp_y = 1;
c3_divider = false;
c3_cutout = 0;
c3_lid = true; // Lid to keep coins secure

/* [Container Slot 4 - Card Holder] */
c4_enable = true;
c4_type = "card_holder"; // [card_holder, component_bin, dice_tray, token_tray]
c4_width = 70;
c4_depth = 95;
c4_height = 65;
c4_pos_x = 1;
c4_pos_y = 68; // Below the token trays
c4_bin_type = "general";
c4_comp_x = 1;
c4_comp_y = 1;
c4_divider = false;
c4_cutout = 30; // Finger cutout for card access
c4_lid = false;

/* [Display Options] */
show_validation = true;
exploded_view = 1.0;
show_all = true;
show_container = 0;

/* [Advanced] */
top_chamfer = 0.5;
add_finger_grips = false;
stackable = false;
stack_tolerance = 0.3;

//====================================
// DON'T EDIT BELOW THIS LINE
// (Copy the modules from parametric_game_insert.scad)
//====================================

$fn = $preview ? 32 : 64;
gap = container_gap;

// Include all helper modules and container modules from main file
// (For brevity in this example, you would copy the hex pattern, lid,
//  and container modules from parametric_game_insert.scad here)

// Or better yet: use the main parametric_game_insert.scad file
// and just adjust the parameters above!

//====================================
// INFORMATION
//====================================

echo("=== Multi-Container Mode Example ===");
echo("");
echo("This example demonstrates:");
echo("  - 2 Token Trays with different compartment counts (2x2 and 3x3)");
echo("  - 1 Coin Slot Bin with 5 slots");
echo("  - 1 Card Holder with finger cutout");
echo("");
echo("Container 1: 2x2 Token Tray WITH lid");
echo("Container 2: 3x3 Token Tray NO lid");
echo("Container 3: Coin Slot Bin WITH lid");
echo("Container 4: Card Holder");
echo("");
echo("Each container is:");
echo("  - Individually sized");
echo("  - Manually positioned");
echo("  - Independently configured");
echo("");
echo("To use this in your own project:");
echo("1. Open parametric_game_insert.scad");
echo("2. Set layout_mode = 'multi'");
echo("3. Enable container slots (c1_enable, c2_enable, etc.)");
echo("4. Configure each slot's type, size, and settings");
echo("5. Position manually using pos_x and pos_y");
echo("");
echo("Benefits of Multi-Container Mode:");
echo("  ✓ Multiple token trays with different layouts");
echo("  ✓ Multiple component bins with different types");
echo("  ✓ Per-container lid control");
echo("  ✓ Per-container size and position");
echo("  ✓ Mix any container types in any arrangement");

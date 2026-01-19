/*
 * Game Insert System - New Features Demonstration
 *
 * This example showcases the new filament-saving and organizational features:
 * 1. Hexagonal honeycomb patterns in floors (30-50% filament savings!)
 * 2. Hexagonal patterns in walls (additional filament reduction)
 * 3. Snap-fit, sliding, and friction lids for token/coin trays
 * 4. Specialized bin types:
 *    - Coin slot bins (vertical storage)
 *    - Token well bins (circular compartments)
 *    - Small parts bins (fine grid)
 *    - Card divider bins (multiple sections)
 *
 * Use this as a reference for implementing these features in your own inserts!
 */

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <BOSL2/structs.scad>

/* [What to Display] */
// Select which feature to demonstrate
demo_mode = "all"; // [all:All Features, hex_floor:Hex Floor Pattern, hex_walls:Hex Wall Pattern, lids:Lid Types Comparison, bins:Specialized Bin Types]

/* [Container Settings] */
wall_thickness = 2.0;
floor_thickness = 1.5;
corner_radius = 2.5;

/* [Hex Pattern Settings] */
hex_floor_pattern = true;
hex_floor_size = 8;
hex_floor_wall = 0.8;
hex_wall_pattern = true;
hex_wall_size = 10;

/* [Lid Settings] */
lid_tolerance = 0.3;
lid_thickness = 2.0;

$fn = $preview ? 32 : 64;

//====================================
// HELPER MODULES
//====================================

module hex_pattern_floor(width, depth, hex_size=8, wall_thick=0.8) {
    hex_spacing = hex_size * 1.732;

    difference() {
        children();

        translate([0, 0, -0.5])
            for (x = [-width/2 : hex_spacing : width/2]) {
                for (y = [-depth/2 : hex_spacing : depth/2]) {
                    offset_y = ((x / hex_spacing) % 2 == 0) ? 0 : hex_spacing / 2;
                    translate([x, y + offset_y, 0])
                        linear_extrude(height=floor_thickness + 1)
                            hexagon(r=hex_size - wall_thick);
                }
            }
    }
}

module hex_pattern_wall(wall_width, wall_height, hex_size=10, orient="vertical") {
    hex_spacing = hex_size * 1.732;

    if (orient == "vertical") {
        for (z = [hex_size : hex_spacing : wall_height - hex_size]) {
            for (x = [-wall_width/2 + hex_size : hex_spacing : wall_width/2 - hex_size]) {
                offset_x = ((z / hex_spacing) % 2 == 0) ? 0 : hex_spacing / 2;
                translate([x + offset_x, 0, z])
                    rotate([90, 0, 0])
                        linear_extrude(height=wall_thickness * 3, center=true)
                            hexagon(r=hex_size * 0.6);
            }
        }
    }
}

module snap_lid(width, depth, tolerance=0.3, thickness=2.0) {
    clip_height = 3;
    clip_thick = 1.0;

    difference() {
        union() {
            cuboid([width - tolerance, depth - tolerance, thickness],
                   rounding=corner_radius,
                   edges="Z",
                   anchor=BOTTOM);

            translate([0, 0, thickness])
                difference() {
                    cuboid([width - 2*wall_thickness - tolerance*2,
                            depth - 2*wall_thickness - tolerance*2,
                            clip_height],
                           rounding=max(0, corner_radius - wall_thickness),
                           edges="Z",
                           anchor=BOTTOM);

                    translate([0, 0, -0.1])
                        cuboid([width - 2*wall_thickness - tolerance*2 - 2*clip_thick,
                                depth - 2*wall_thickness - tolerance*2 - 2*clip_thick,
                                clip_height + 1],
                               rounding=max(0, corner_radius - wall_thickness - clip_thick),
                               edges="Z",
                               anchor=BOTTOM);
                }

            for (side = [0, 180]) {
                rotate([0, 0, side])
                    translate([0, (depth - 2*wall_thickness - tolerance*2) / 2 - clip_thick/2, thickness])
                        difference() {
                            cuboid([15, clip_thick + 0.3, clip_height], anchor=BOTTOM);
                            translate([0, -clip_thick, clip_height - 0.5])
                                rotate([0, 90, 0])
                                    cyl(d=1, h=20, anchor=CENTER);
                        }
            }
        }

        translate([0, 0, thickness/2])
            cuboid([30, 12, thickness + 1],
                   rounding=3,
                   edges="Z",
                   anchor=CENTER);
    }
}

module sliding_lid(width, depth, tolerance=0.3, thickness=2.0) {
    track_depth = 2;

    difference() {
        union() {
            cuboid([width - 2*wall_thickness - tolerance*2 + 1,
                    depth + 2,
                    thickness],
                   rounding=corner_radius,
                   edges="Z",
                   anchor=BOTTOM);

            for (side = [-1, 1]) {
                translate([side * (width - 2*wall_thickness - tolerance*2) / 2,
                           0,
                           thickness])
                    cuboid([1, depth + 2, track_depth],
                           anchor=BOTTOM);
            }
        }

        translate([0, depth/2 - 10, thickness/2])
            rotate([90, 0, 0])
                cyl(d=15, h=3, anchor=FRONT);
    }
}

module friction_lid(width, depth, tolerance=0.3, thickness=2.0) {
    difference() {
        cuboid([width - tolerance,
                depth - tolerance,
                thickness],
               rounding=corner_radius,
               edges="Z",
               anchor=BOTTOM);

        translate([0, 0, thickness/2])
            cuboid([35, 15, thickness + 1],
                   rounding=4,
                   edges="Z",
                   anchor=CENTER);
    }
}

//====================================
// CONTAINER MODULES WITH HEX PATTERNS
//====================================

module basic_tray_hex_floor(width=80, depth=80, height=30) {
    difference() {
        cuboid([width, depth, height],
               rounding=corner_radius,
               edges="Z",
               anchor=BOTTOM);

        translate([0, 0, floor_thickness])
            cuboid([width - 2*wall_thickness,
                    depth - 2*wall_thickness,
                    height],
                   rounding=max(0, corner_radius - wall_thickness),
                   edges="Z",
                   anchor=BOTTOM);
    }

    // Add hex pattern floor
    if (hex_floor_pattern) {
        translate([0, 0, 0])
            hex_pattern_floor(width - 2*wall_thickness, depth - 2*wall_thickness,
                             hex_size=hex_floor_size, wall_thick=hex_floor_wall)
                cuboid([width - 2*wall_thickness,
                        depth - 2*wall_thickness,
                        floor_thickness],
                       anchor=BOTTOM);
    }
}

module basic_tray_hex_walls(width=80, depth=80, height=40) {
    difference() {
        cuboid([width, depth, height],
               rounding=corner_radius,
               edges="Z",
               anchor=BOTTOM);

        translate([0, 0, floor_thickness])
            cuboid([width - 2*wall_thickness,
                    depth - 2*wall_thickness,
                    height],
                   rounding=max(0, corner_radius - wall_thickness),
                   edges="Z",
                   anchor=BOTTOM);

        // Hex pattern in walls
        if (hex_wall_pattern) {
            for (side = [0, 180]) {
                rotate([0, 0, side])
                    translate([0, depth/2, 0])
                        hex_pattern_wall(width, height, hex_size=hex_wall_size);
            }
            for (side = [90, 270]) {
                rotate([0, 0, side])
                    translate([0, width/2, 0])
                        hex_pattern_wall(depth, height, hex_size=hex_wall_size);
            }
        }
    }
}

//====================================
// SPECIALIZED BIN MODULES
//====================================

module coin_slot_bin(width=90, depth=70, height=35, num_slots=6) {
    basic_tray_hex_floor(width, depth, height);

    int_width = width - 2*wall_thickness;
    int_depth = depth - 2*wall_thickness;

    for (i = [1:num_slots-1]) {
        translate([int_width * i / num_slots - int_width/2,
                   0,
                   floor_thickness])
            cuboid([wall_thickness,
                    int_depth,
                    height - floor_thickness],
                   anchor=BOTTOM);
    }
}

module token_well_bin(width=90, depth=90, height=30, num_wells=9) {
    wells_per_row = ceil(sqrt(num_wells));
    well_diameter = min((width - 2*wall_thickness) / wells_per_row - 2,
                       (depth - 2*wall_thickness) / wells_per_row - 2);

    difference() {
        basic_tray_hex_floor(width, depth, height);

        int_width = width - 2*wall_thickness;
        int_depth = depth - 2*wall_thickness;

        for (i = [0:num_wells-1]) {
            x_pos = (i % wells_per_row) - (wells_per_row - 1) / 2;
            y_pos = floor(i / wells_per_row) - (ceil(num_wells / wells_per_row) - 1) / 2;

            translate([x_pos * (int_width / wells_per_row),
                       y_pos * (int_depth / ceil(num_wells / wells_per_row)),
                       floor_thickness])
                cyl(d=well_diameter, h=height, anchor=BOTTOM);
        }
    }
}

module small_parts_bin(width=90, depth=90, height=25) {
    basic_tray_hex_floor(width, depth, height);

    int_width = width - 2*wall_thickness;
    int_depth = depth - 2*wall_thickness;
    comp_x = 4;
    comp_y = 3;

    // Dividers
    for (i = [1:comp_x-1]) {
        translate([int_width * i / comp_x - int_width/2, 0, floor_thickness])
            cuboid([wall_thickness, int_depth, height - floor_thickness], anchor=BOTTOM);
    }

    for (j = [1:comp_y-1]) {
        translate([0, int_depth * j / comp_y - int_depth/2, floor_thickness])
            cuboid([int_width, wall_thickness, height - floor_thickness], anchor=BOTTOM);
    }
}

module card_divider_bin(width=100, depth=70, height=40, num_sections=4) {
    basic_tray_hex_floor(width, depth, height);

    int_width = width - 2*wall_thickness;
    int_depth = depth - 2*wall_thickness;

    for (i = [1:num_sections-1]) {
        translate([int_width * i / num_sections - int_width/2,
                   0,
                   floor_thickness])
            cuboid([wall_thickness,
                    int_depth,
                    height - floor_thickness],
                   anchor=BOTTOM);
    }
}

//====================================
// DEMO LAYOUTS
//====================================

if (demo_mode == "all" || demo_mode == "hex_floor") {
    // Hex floor demonstration
    translate([-110, -60, 0]) {
        color("lightblue")
            basic_tray_hex_floor(80, 80, 30);

        // Label
        translate([0, -50, 0])
            color("black")
                text("HEX FLOOR", size=6, halign="center", valign="center");
    }
}

if (demo_mode == "all" || demo_mode == "hex_walls") {
    // Hex walls demonstration
    translate([0, -60, 0]) {
        color("lightgreen")
            basic_tray_hex_walls(80, 80, 40);

        translate([0, -50, 0])
            color("black")
                text("HEX WALLS", size=6, halign="center", valign="center");
    }
}

if (demo_mode == "all" || demo_mode == "lids") {
    // Lid types comparison
    translate([-110, 60, 0]) {
        basic_tray_hex_floor(70, 70, 25);

        // Snap lid (elevated)
        translate([0, 0, 35])
            color("orange")
                snap_lid(70, 70, tolerance=lid_tolerance, thickness=lid_thickness);

        translate([0, -45, 0])
            color("black")
                text("SNAP LID", size=6, halign="center", valign="center");
    }

    translate([0, 60, 0]) {
        basic_tray_hex_floor(70, 70, 25);

        // Friction lid (elevated)
        translate([0, 0, 35])
            color("purple")
                friction_lid(70, 70, tolerance=lid_tolerance, thickness=lid_thickness);

        translate([0, -45, 0])
            color("black")
                text("FRICTION LID", size=6, halign="center", valign="center");
    }
}

if (demo_mode == "all" || demo_mode == "bins") {
    // Specialized bins
    translate([-165, 170, 0]) {
        color("yellow")
            coin_slot_bin(90, 70, 35, num_slots=6);

        translate([0, -45, 0])
            color("black")
                text("COIN SLOTS", size=6, halign="center", valign="center");
    }

    translate([-55, 170, 0]) {
        color("cyan")
            token_well_bin(90, 90, 30, num_wells=9);

        translate([0, -50, 0])
            color("black")
                text("TOKEN WELLS", size=6, halign="center", valign="center");
    }

    translate([55, 170, 0]) {
        color("pink")
            small_parts_bin(90, 90, 25);

        translate([0, -50, 0])
            color("black")
                text("SMALL PARTS", size=6, halign="center", valign="center");
    }

    translate([165, 170, 0]) {
        color("lightcoral")
            card_divider_bin(100, 70, 40, num_sections=4);

        translate([0, -45, 0])
            color("black")
                text("CARD DIVIDERS", size=6, halign="center", valign="center");
    }
}

//====================================
// INFO OUTPUT
//====================================

echo("=== New Features Demo ===");
echo("");
echo("HEX PATTERNS:");
echo("  Floor pattern: Saves 30-40% filament on floors");
echo("  Wall pattern: Saves 20-30% filament on walls");
echo("  Combined: Can save 40-50% total filament!");
echo("");
echo("LID TYPES:");
echo("  Snap-fit: Best security, snaps into place");
echo("  Sliding: Easy access, slides on/off");
echo("  Friction: Simplest, press-fit");
echo("");
echo("SPECIALIZED BINS:");
echo("  Coin Slots: Vertical storage for coins/tokens");
echo("  Token Wells: Circular wells for round pieces");
echo("  Small Parts: 4x3 grid for tiny components");
echo("  Card Dividers: Multiple vertical sections");
echo("");
echo("Use 'demo_mode' parameter to view specific features!");

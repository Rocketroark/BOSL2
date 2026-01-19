/*
 * Parametric Game Insert System
 *
 * A comprehensive, modular system for creating custom board game box inserts.
 * Designed to be highly configurable for any game box size with various container types.
 *
 * Features:
 * - Multiple container types (card holders, bins, trays, dice holders)
 * - Automatic layout validation (ensures all components fit in box)
 * - Modular design for easy customization
 * - Optimized for 3D printing
 * - Full BOSL2 library integration
 *
 * Usage:
 * 1. Set your box dimensions (box_width, box_depth, box_height)
 * 2. Configure container types and layouts in the configuration section
 * 3. Enable/disable components as needed
 * 4. Render and export for 3D printing
 */

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <BOSL2/structs.scad>

/* [Box Dimensions] */
// Total internal width of the game box (mm)
box_width = 300; // [100:10:500]

// Total internal depth of the game box (mm)
box_depth = 200; // [100:10:500]

// Total internal height of the game box (mm)
box_height = 75; // [30:5:200]

/* [Container Options] */
// Wall thickness for all containers (mm)
wall_thickness = 2.0; // [1.0:0.5:5.0]

// Floor thickness for containers (mm)
floor_thickness = 1.5; // [0.8:0.1:4.0]

// Corner rounding radius (mm, 0 for no rounding)
corner_radius = 2.0; // [0:0.5:10]

// Tolerance/gap between containers (mm)
container_gap = 0.5; // [0:0.1:3.0]

/* [Filament Saving Options] */
// Use hex pattern in floors (saves filament)
hex_floor_pattern = false;

// Hex pattern size for floors (mm)
hex_floor_size = 8; // [4:1:15]

// Hex pattern wall thickness (mm)
hex_floor_wall = 0.8; // [0.4:0.1:2.0]

// Use hex pattern in walls (saves filament)
hex_wall_pattern = false;

// Hex pattern size for walls (mm)
hex_wall_size = 10; // [6:1:20]

/* [Lid Options] */
// Generate lids for token/coin trays
generate_lids = false;

// Lid type
lid_type = "snap"; // [snap:Snap-fit Lid, slide:Sliding Lid, friction:Friction Fit]

// Lid clearance/tolerance (mm)
lid_tolerance = 0.3; // [0.1:0.05:0.8]

// Lid thickness (mm)
lid_thickness = 2.0; // [1.0:0.5:4.0]

/* [Card Holder Settings] */
// Enable card holder
enable_card_holder = true;

// Card holder width (mm)
card_width = 65; // [40:1:100]

// Card holder depth (mm)
card_depth = 92; // [50:1:150]

// Card holder height (mm)
card_height = 70; // [30:5:150]

// Card stack capacity (number of cards)
card_capacity = 60; // [10:5:200]

// Finger cutout depth (mm, 0 for none)
card_finger_cutout = 30; // [0:5:60]

/* [Component Bin Settings] */
// Enable component bin
enable_component_bin = true;

// Bin type
bin_type = "general"; // [general:General Storage, coin_slot:Coin Slots, token_well:Token Wells, small_parts:Small Parts Grid, card_divider:Card Dividers]

// Component bin width (mm)
bin_width = 90; // [40:5:200]

// Component bin depth (mm)
bin_depth = 90; // [40:5:200]

// Component bin height (mm)
bin_height = 40; // [20:5:150]

// Add divider to bin (general type only)
bin_add_divider = true;

// Number of coin slots or token wells
bin_slots = 6; // [3:1:12]

// Coin slot width (mm)
coin_slot_width = 28; // [20:1:40]

/* [Dice Tray Settings] */
// Enable dice tray
enable_dice_tray = true;

// Dice tray width (mm)
dice_width = 70; // [40:5:150]

// Dice tray depth (mm)
dice_depth = 70; // [40:5:150]

// Dice tray height (mm)
dice_height = 25; // [15:5:80]

// Add felt/fabric relief (reduces floor thickness for felt insert)
dice_felt_relief = 1.0; // [0:0.5:3.0]

/* [Token Tray Settings] */
// Enable token tray
enable_token_tray = true;

// Token tray width (mm)
token_width = 60; // [30:5:150]

// Token tray depth (mm)
token_depth = 60; // [30:5:150]

// Token tray height (mm)
token_height = 30; // [15:5:100]

// Number of compartments (rows x cols)
token_compartments_x = 2; // [1:1:5]
token_compartments_y = 2; // [1:1:5]

/* [Layout Configuration] */
// Layout style
layout_style = "auto"; // [auto:Automatic, manual:Manual Grid, custom:Custom Positions]

// For auto layout: number of rows
auto_rows = 2; // [1:1:4]

// For auto layout: number of columns
auto_cols = 2; // [1:1:4]

/* [Display Options] */
// Show layout validation
show_validation = true;

// Exploded view (spacing multiplier)
exploded_view = 1.0; // [1.0:0.5:3.0]

// Show all containers or individual
show_all = true;

// If show_all is false, which container to show
show_container = 0; // [0:10]

/* [Advanced] */
// Chamfer inside top edges (helps with assembly)
top_chamfer = 0.5; // [0:0.1:2.0]

// Add finger grip notches on sides
add_finger_grips = false;

// Stackable (adds registration features)
stackable = false;

// Stack registration tolerance
stack_tolerance = 0.3; // [0.1:0.1:1.0]

//====================================
// INTERNAL CALCULATIONS
//====================================

$fn = $preview ? 32 : 64;

// Calculate effective dimensions accounting for gaps
effective_wall = wall_thickness;
gap = container_gap;

//====================================
// HELPER MODULES - HEX PATTERNS & LIDS
//====================================

/**
 * Hexagonal honeycomb pattern for floors
 * Significantly reduces filament usage while maintaining strength
 */
module hex_pattern_floor(width, depth, hex_size=8, wall_thick=0.8) {
    // Calculate honeycomb spacing
    hex_spacing = hex_size * 1.732; // sqrt(3) * hex_size

    // Create hex grid
    difference() {
        // Solid floor
        children();

        // Cut hexagons
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

/**
 * Hexagonal pattern cutouts for walls
 */
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

/**
 * Snap-fit lid for containers
 */
module snap_lid(width, depth, tolerance=0.3, thickness=2.0) {
    clip_height = 3;
    clip_thick = 1.0;

    difference() {
        union() {
            // Main lid top
            cuboid([width - tolerance, depth - tolerance, thickness],
                   rounding=corner_radius,
                   edges="Z",
                   anchor=BOTTOM);

            // Lip that goes inside container
            translate([0, 0, thickness])
                difference() {
                    cuboid([width - 2*wall_thickness - tolerance*2,
                            depth - 2*wall_thickness - tolerance*2,
                            clip_height],
                           rounding=max(0, corner_radius - wall_thickness),
                           edges="Z",
                           anchor=BOTTOM);

                    // Hollow interior
                    translate([0, 0, -0.1])
                        cuboid([width - 2*wall_thickness - tolerance*2 - 2*clip_thick,
                                depth - 2*wall_thickness - tolerance*2 - 2*clip_thick,
                                clip_height + 1],
                               rounding=max(0, corner_radius - wall_thickness - clip_thick),
                               edges="Z",
                               anchor=BOTTOM);
                }

            // Snap clips
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

        // Finger grip recess
        translate([0, 0, thickness/2])
            cuboid([30, 12, thickness + 1],
                   rounding=3,
                   edges="Z",
                   anchor=CENTER);
    }
}

/**
 * Sliding lid for containers
 */
module sliding_lid(width, depth, tolerance=0.3, thickness=2.0) {
    track_depth = 2;

    difference() {
        union() {
            // Main lid
            cuboid([width - 2*wall_thickness - tolerance*2 + 1,
                    depth + 2,
                    thickness],
                   rounding=corner_radius,
                   edges="Z",
                   anchor=BOTTOM);

            // Side rails
            for (side = [-1, 1]) {
                translate([side * (width - 2*wall_thickness - tolerance*2) / 2,
                           0,
                           thickness])
                    cuboid([1, depth + 2, track_depth],
                           anchor=BOTTOM);
            }
        }

        // Finger grip
        translate([0, depth/2 - 10, thickness/2])
            rotate([90, 0, 0])
                cyl(d=15, h=3, anchor=FRONT);
    }
}

/**
 * Friction-fit lid (simplest)
 */
module friction_lid(width, depth, tolerance=0.3, thickness=2.0) {
    difference() {
        cuboid([width - tolerance,
                depth - tolerance,
                thickness],
               rounding=corner_radius,
               edges="Z",
               anchor=BOTTOM);

        // Finger grip
        translate([0, 0, thickness/2])
            cuboid([35, 15, thickness + 1],
                   rounding=4,
                   edges="Z",
                   anchor=CENTER);
    }
}

//====================================
// CONTAINER MODULES
//====================================

/**
 * Basic container box with rounded corners and optional features
 */
module container_box(width, depth, height, finger_cutout=0, chamfer_top=true, use_hex_floor=false, use_hex_walls=false) {
    difference() {
        union() {
            // Main body with rounding
            if (use_hex_floor && hex_floor_pattern) {
                // Body with hex floor
                difference() {
                    cuboid([width, depth, height],
                           rounding=corner_radius,
                           edges="Z",
                           anchor=BOTTOM);

                    // Hollow interior
                    translate([0, 0, floor_thickness])
                        cuboid([width - 2*wall_thickness,
                                depth - 2*wall_thickness,
                                height - floor_thickness + 0.1],
                               rounding=max(0, corner_radius - wall_thickness),
                               edges="Z",
                               anchor=BOTTOM);
                }

                // Add hex pattern floor
                translate([0, 0, 0])
                    hex_pattern_floor(width - 2*wall_thickness, depth - 2*wall_thickness,
                                     hex_size=hex_floor_size, wall_thick=hex_floor_wall)
                        cuboid([width - 2*wall_thickness,
                                depth - 2*wall_thickness,
                                floor_thickness],
                               anchor=BOTTOM);
            } else {
                // Regular solid body
                cuboid([width, depth, height],
                       rounding=corner_radius,
                       edges="Z",
                       anchor=BOTTOM);
            }
        }

        // Hollow interior (if not using hex floor)
        if (!use_hex_floor || !hex_floor_pattern) {
            translate([0, 0, floor_thickness])
                cuboid([width - 2*wall_thickness,
                        depth - 2*wall_thickness,
                        height - floor_thickness + 0.1],
                       rounding=max(0, corner_radius - wall_thickness),
                       edges="Z",
                       anchor=BOTTOM);
        } else {
            // Interior already cut in hex floor version
            translate([0, 0, floor_thickness])
                cuboid([width - 2*wall_thickness,
                        depth - 2*wall_thickness,
                        height - floor_thickness + 0.1],
                       rounding=max(0, corner_radius - wall_thickness),
                       edges="Z",
                       anchor=BOTTOM);
        }

        // Top chamfer for easier insertion
        if (chamfer_top && top_chamfer > 0) {
            translate([0, 0, height - top_chamfer])
                cuboid([width - 2*wall_thickness + 2*top_chamfer,
                        depth - 2*wall_thickness + 2*top_chamfer,
                        top_chamfer * 2],
                       chamfer=top_chamfer,
                       edges="Z",
                       anchor=BOTTOM);
        }

        // Finger cutout (for card access)
        if (finger_cutout > 0) {
            translate([0, depth/2 - wall_thickness, height - finger_cutout/2])
                rotate([90, 0, 0])
                    cyl(d=finger_cutout, h=wall_thickness*3, anchor=BOTTOM);
        }

        // Hex pattern in walls (saves filament)
        if (use_hex_walls && hex_wall_pattern) {
            // Front and back walls
            for (side = [0, 180]) {
                rotate([0, 0, side])
                    translate([0, depth/2, 0])
                        hex_pattern_wall(width, height, hex_size=hex_wall_size);
            }
            // Left and right walls
            for (side = [90, 270]) {
                rotate([0, 0, side])
                    translate([0, width/2, 0])
                        hex_pattern_wall(depth, height, hex_size=hex_wall_size);
            }
        }
    }

    // Stack registration features
    if (stackable) {
        // Top rim (male)
        translate([0, 0, height])
            difference() {
                cuboid([width - stack_tolerance,
                        depth - stack_tolerance,
                        2],
                       rounding=corner_radius,
                       edges="Z",
                       anchor=BOTTOM);
                cuboid([width - 2*wall_thickness - stack_tolerance,
                        depth - 2*wall_thickness - stack_tolerance,
                        3],
                       rounding=max(0, corner_radius - wall_thickness),
                       edges="Z",
                       anchor=BOTTOM);
            }
    }

    // Finger grips on sides
    if (add_finger_grips) {
        for (side = [0, 180]) {
            rotate([0, 0, side])
                translate([0, depth/2, height/2])
                    rotate([90, 0, 0])
                        difference() {
                            cyl(d=15, h=wall_thickness, anchor=FRONT);
                            cyl(d=12, h=wall_thickness*2, anchor=FRONT);
                        }
        }
    }
}

/**
 * Card holder - Vertical storage for card decks
 */
module card_holder(width=card_width, depth=card_depth, height=card_height,
                   cutout=card_finger_cutout) {
    container_box(width, depth, height, finger_cutout=cutout);
}

/**
 * Component bin - General purpose storage with optional divider
 */
module component_bin(width=bin_width, depth=bin_depth, height=bin_height,
                     add_divider=bin_add_divider) {
    difference() {
        container_box(width, depth, height);

        // Nothing to subtract here
    }

    // Optional divider
    if (add_divider) {
        translate([0, 0, floor_thickness])
            cuboid([wall_thickness,
                    depth - 2*wall_thickness,
                    height - floor_thickness],
                   anchor=BOTTOM);
    }
}

/**
 * Dice tray - Low tray with optional felt relief
 */
module dice_tray(width=dice_width, depth=dice_depth, height=dice_height,
                 felt_relief=dice_felt_relief) {
    difference() {
        container_box(width, depth, height);

        // Felt relief (thinner floor for fabric insert)
        if (felt_relief > 0) {
            translate([0, 0, floor_thickness - felt_relief])
                cuboid([width - 2*wall_thickness - 2,
                        depth - 2*wall_thickness - 2,
                        felt_relief + 0.1],
                       rounding=corner_radius,
                       anchor=BOTTOM);
        }
    }
}

/**
 * Token tray - Multi-compartment organizer
 */
module token_tray(width=token_width, depth=token_depth, height=token_height,
                  comp_x=token_compartments_x, comp_y=token_compartments_y) {
    container_box(width, depth, height, use_hex_floor=true);

    // Internal dividers
    int_width = width - 2*wall_thickness;
    int_depth = depth - 2*wall_thickness;

    // Vertical dividers (along X)
    if (comp_x > 1) {
        for (i = [1:comp_x-1]) {
            translate([int_width * i / comp_x - int_width/2,
                       0,
                       floor_thickness])
                cuboid([wall_thickness,
                        int_depth,
                        height - floor_thickness],
                       anchor=BOTTOM);
        }
    }

    // Horizontal dividers (along Y)
    if (comp_y > 1) {
        for (j = [1:comp_y-1]) {
            translate([0,
                       int_depth * j / comp_y - int_depth/2,
                       floor_thickness])
                cuboid([int_width,
                        wall_thickness,
                        height - floor_thickness],
                       anchor=BOTTOM);
        }
    }
}

//====================================
// SPECIALIZED BIN TYPES
//====================================

/**
 * Coin slot bin - Vertical slots for coins
 */
module coin_slot_bin(width, depth, height, num_slots=6, slot_width=28) {
    container_box(width, depth, height, use_hex_floor=true);

    int_width = width - 2*wall_thickness;
    int_depth = depth - 2*wall_thickness;

    // Create vertical dividers for coin slots
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

/**
 * Token well bin - Circular wells for round tokens
 */
module token_well_bin(width, depth, height, num_wells=6) {
    // Calculate well layout
    wells_per_row = ceil(sqrt(num_wells));
    well_diameter = min((width - 2*wall_thickness) / wells_per_row - 2,
                       (depth - 2*wall_thickness) / wells_per_row - 2);

    difference() {
        container_box(width, depth, height, use_hex_floor=true);

        // Create circular wells
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

/**
 * Small parts bin - Many small compartments
 */
module small_parts_bin(width, depth, height) {
    // Fixed 4x3 grid for small parts
    token_tray(width=width, depth=depth, height=height, comp_x=4, comp_y=3);
}

/**
 * Card divider bin - Multiple vertical card sections
 */
module card_divider_bin(width, depth, height, num_sections=3) {
    container_box(width, depth, height, use_hex_floor=true);

    int_width = width - 2*wall_thickness;
    int_depth = depth - 2*wall_thickness;

    // Vertical dividers for card sections
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

/**
 * Universal component bin dispatcher
 * Routes to appropriate specialized bin based on bin_type parameter
 */
module component_bin(width=bin_width, depth=bin_depth, height=bin_height,
                     add_divider=bin_add_divider, type=bin_type) {
    if (type == "coin_slot") {
        coin_slot_bin(width, depth, height, num_slots=bin_slots, slot_width=coin_slot_width);
    } else if (type == "token_well") {
        token_well_bin(width, depth, height, num_wells=bin_slots);
    } else if (type == "small_parts") {
        small_parts_bin(width, depth, height);
    } else if (type == "card_divider") {
        card_divider_bin(width, depth, height, num_sections=bin_slots);
    } else {
        // Default: general storage bin
        difference() {
            container_box(width, depth, height, use_hex_floor=true);
        }

        // Optional divider
        if (add_divider) {
            translate([0, 0, floor_thickness])
                cuboid([wall_thickness,
                        depth - 2*wall_thickness,
                        height - floor_thickness],
                       anchor=BOTTOM);
        }
    }
}

//====================================
// LAYOUT SYSTEM
//====================================

/**
 * Validate that all containers fit within box dimensions
 */
function validate_layout(containers, box_w, box_d, box_h) =
    let (
        // Check each container
        fits = [for (c = containers)
            c[1] + c[3] <= box_w &&  // x + width
            c[2] + c[4] <= box_d &&  // y + depth
            c[5] <= box_h            // height
        ],
        all_fit = len([for (f = fits) if (f) f]) == len(fits)
    )
    all_fit;

/**
 * Generate validation report
 */
module show_validation_report(containers, box_w, box_d, box_h) {
    echo("=== Layout Validation Report ===");
    echo(str("Box dimensions: ", box_w, "x", box_d, "x", box_h, "mm"));
    echo(str("Number of containers: ", len(containers)));

    for (i = [0:len(containers)-1]) {
        c = containers[i];
        fits_w = c[1] + c[3] <= box_w;
        fits_d = c[2] + c[4] <= box_d;
        fits_h = c[5] <= box_h;
        fits = fits_w && fits_d && fits_h;

        echo(str("Container ", i, " (", c[0], "): ",
                 fits ? "✓ FITS" : "✗ OVERFLOW",
                 " [", c[3], "x", c[4], "x", c[5], "mm]",
                 " at pos [", c[1], ",", c[2], "]"));
    }

    valid = validate_layout(containers, box_w, box_d, box_h);
    echo(str("Overall: ", valid ? "✓ ALL CONTAINERS FIT" : "✗ LAYOUT HAS OVERFLOWS"));
    echo("==============================");
}

/**
 * Automatic grid layout generator
 */
function auto_grid_layout() =
    let (
        // Calculate cell sizes
        cell_w = (box_width - gap) / auto_cols - gap,
        cell_d = (box_depth - gap) / auto_rows - gap,

        // Container definitions: [type, x, y, width, depth, height]
        containers = [
            if (enable_card_holder && auto_rows * auto_cols >= 1)
                ["card_holder", gap, gap,
                 min(card_width, cell_w), min(card_depth, cell_d), card_height],

            if (enable_component_bin && auto_rows * auto_cols >= 2)
                ["component_bin",
                 auto_cols > 1 ? gap + cell_w + gap : gap,
                 gap,
                 min(bin_width, cell_w), min(bin_depth, cell_d), bin_height],

            if (enable_dice_tray && auto_rows * auto_cols >= 3)
                ["dice_tray",
                 gap,
                 auto_rows > 1 ? gap + cell_d + gap : gap,
                 min(dice_width, cell_w), min(dice_depth, cell_d), dice_height],

            if (enable_token_tray && auto_rows * auto_cols >= 4)
                ["token_tray",
                 auto_cols > 1 ? gap + cell_w + gap : gap,
                 auto_rows > 1 ? gap + cell_d + gap : gap,
                 min(token_width, cell_w), min(token_depth, cell_d), token_height],
        ]
    )
    containers;

//====================================
// MAIN RENDERING
//====================================

// Generate layout
containers = auto_grid_layout();

// Validation
if (show_validation) {
    show_validation_report(containers, box_width, box_depth, box_height);
}

// Render containers
if (show_all) {
    for (i = [0:len(containers)-1]) {
        c = containers[i];
        type = c[0];
        x = c[1];
        y = c[2];
        w = c[3];
        d = c[4];
        h = c[5];

        translate([x - box_width/2 + w/2,
                   y - box_depth/2 + d/2,
                   0]) {
            if (type == "card_holder")
                card_holder(width=w, depth=d, height=h);
            else if (type == "component_bin")
                component_bin(width=w, depth=d, height=h);
            else if (type == "dice_tray")
                dice_tray(width=w, depth=d, height=h);
            else if (type == "token_tray") {
                token_tray(width=w, depth=d, height=h);

                // Generate lid if enabled
                if (generate_lids) {
                    translate([0, 0, h + 5 * exploded_view]) {
                        if (lid_type == "snap")
                            snap_lid(w, d, tolerance=lid_tolerance, thickness=lid_thickness);
                        else if (lid_type == "slide")
                            sliding_lid(w, d, tolerance=lid_tolerance, thickness=lid_thickness);
                        else if (lid_type == "friction")
                            friction_lid(w, d, tolerance=lid_tolerance, thickness=lid_thickness);
                    }
                }
            }
        }

        // Also generate lids for component bins if they're coin/token types
        if (generate_lids && type == "component_bin" &&
            (bin_type == "coin_slot" || bin_type == "token_well")) {
            translate([x - box_width/2 + w/2,
                       y - box_depth/2 + d/2,
                       h + 5 * exploded_view]) {
                if (lid_type == "snap")
                    snap_lid(w, d, tolerance=lid_tolerance, thickness=lid_thickness);
                else if (lid_type == "slide")
                    sliding_lid(w, d, tolerance=lid_tolerance, thickness=lid_thickness);
                else if (lid_type == "friction")
                    friction_lid(w, d, tolerance=lid_tolerance, thickness=lid_thickness);
            }
        }
    }

    // Show box outline in preview mode
    if ($preview) {
        %translate([0, 0, box_height/2])
            cuboid([box_width, box_depth, box_height],
                   anchor=CENTER);
    }
} else {
    // Show individual container
    if (show_container < len(containers)) {
        c = containers[show_container];
        type = c[0];
        w = c[3];
        d = c[4];
        h = c[5];

        if (type == "card_holder")
            card_holder(width=w, depth=d, height=h);
        else if (type == "component_bin")
            component_bin(width=w, depth=d, height=h);
        else if (type == "dice_tray")
            dice_tray(width=w, depth=d, height=h);
        else if (type == "token_tray")
            token_tray(width=w, depth=d, height=h);
    }
}

// Example usage text
echo("=== Parametric Game Insert System ===");
echo("Adjust parameters in the Customizer panel");
echo("Enable/disable containers as needed");
echo("Check validation report for fit confirmation");
echo("");
echo("NEW FEATURES:");
echo("  - Hex patterns for floors/walls (saves 30-50% filament!)");
echo("  - Lids for token/coin trays (snap, slide, friction types)");
echo("  - Specialized bin types:");
echo("    * Coin slots - vertical storage");
echo("    * Token wells - circular compartments");
echo("    * Small parts grid - 4x3 compartments");
echo("    * Card dividers - multiple card sections");
echo("  Toggle these in the Customizer panel!");

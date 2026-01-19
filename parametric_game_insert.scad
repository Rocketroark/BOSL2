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

// Component bin width (mm)
bin_width = 90; // [40:5:200]

// Component bin depth (mm)
bin_depth = 90; // [40:5:200]

// Component bin height (mm)
bin_height = 40; // [20:5:150]

// Add divider to bin
bin_add_divider = true;

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
// CONTAINER MODULES
//====================================

/**
 * Basic container box with rounded corners and optional features
 */
module container_box(width, depth, height, finger_cutout=0, chamfer_top=true) {
    difference() {
        // Main body with rounding
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
    container_box(width, depth, height);

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
            else if (type == "token_tray")
                token_tray(width=w, depth=d, height=h);
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

/*
 * Game Insert Template
 *
 * Use this template as a starting point for creating a custom game insert.
 * Simply measure your game box and components, then adjust the parameters below.
 *
 * INSTRUCTIONS:
 * 1. Measure your game box internal dimensions (width, depth, height)
 * 2. Measure your game components (cards, tokens, pieces, etc.)
 * 3. Adjust the parameters in each section below
 * 4. Enable/disable containers as needed
 * 5. Preview and adjust layout positions
 * 6. Render and export for 3D printing
 */

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

/* [Box Dimensions] */
// Measure the INTERNAL dimensions of your game box
box_width = 280;   // Internal width in mm
box_depth = 280;   // Internal depth in mm
box_height = 70;   // Internal height in mm

/* [Container Options] */
wall_thickness = 2.0;      // Thicker walls = stronger but less space
floor_thickness = 1.5;     // Bottom thickness of containers
corner_radius = 2.0;       // Rounded corners (0 = sharp)
container_gap = 1.0;       // Space between containers for easier removal

/* [Container 1 - Card Holder] */
// For storing card decks vertically
enable_container_1 = true;
c1_width = 70;             // Card width + 4-6mm clearance
c1_depth = 95;             // Card height + 4-6mm clearance
c1_height = 60;            // Stack height needed
c1_finger_cutout = 25;     // Cutout diameter for finger access (0 = none)
c1_pos_x = 1;              // Position from left edge (mm)
c1_pos_y = 1;              // Position from front edge (mm)

/* [Container 2 - Component Bin] */
// General storage bin for tokens, meeples, etc.
enable_container_2 = true;
c2_width = 90;
c2_depth = 90;
c2_height = 40;
c2_add_divider = false;    // Add center divider?
c2_pos_x = 72;             // Position from left edge (mm)
c2_pos_y = 1;

/* [Container 3 - Multi-Compartment Tray] */
// Divided tray for organizing small pieces
enable_container_3 = true;
c3_width = 90;
c3_depth = 90;
c3_height = 30;
c3_compartments_x = 3;     // Number of columns
c3_compartments_y = 2;     // Number of rows
c3_pos_x = 163;
c3_pos_y = 1;

/* [Container 4 - Dice Tray] */
// Low tray for dice rolling or storage
enable_container_4 = true;
c4_width = 70;
c4_depth = 95;
c4_height = 25;
c4_felt_relief = 1.0;      // Depth to recess for felt/fabric (mm)
c4_pos_x = 1;
c4_pos_y = 97;

/* [Container 5 - Custom Storage] */
// Additional storage as needed
enable_container_5 = false;
c5_width = 60;
c5_depth = 60;
c5_height = 35;
c5_finger_cutout = 0;
c5_pos_x = 72;
c5_pos_y = 97;

$fn = $preview ? 48 : 64;

//====================================
// CONTAINER MODULES
//====================================

module container_box(width, depth, height, finger_cutout=0, felt_relief=0) {
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

        // Finger cutout
        if (finger_cutout > 0) {
            translate([0, depth/2 - wall_thickness, height - finger_cutout/2])
                rotate([90, 0, 0])
                    cyl(d=finger_cutout, h=wall_thickness*3, anchor=BOTTOM);
        }

        // Felt relief
        if (felt_relief > 0) {
            translate([0, 0, floor_thickness - felt_relief])
                cuboid([width - 2*wall_thickness - 2,
                        depth - 2*wall_thickness - 2,
                        felt_relief + 0.1],
                       rounding=max(0, corner_radius - 1),
                       anchor=BOTTOM);
        }
    }
}

module card_holder(width, depth, height, cutout) {
    container_box(width, depth, height, finger_cutout=cutout);
}

module component_bin(width, depth, height, add_divider=false) {
    container_box(width, depth, height);

    if (add_divider) {
        translate([0, 0, floor_thickness])
            cuboid([wall_thickness,
                    depth - 2*wall_thickness,
                    height - floor_thickness],
                   anchor=BOTTOM);
    }
}

module multi_compartment_tray(width, depth, height, comp_x, comp_y) {
    container_box(width, depth, height);

    int_width = width - 2*wall_thickness;
    int_depth = depth - 2*wall_thickness;

    // Vertical dividers
    if (comp_x > 1) {
        for (i = [1:comp_x-1]) {
            translate([int_width * i / comp_x - int_width/2, 0, floor_thickness])
                cuboid([wall_thickness, int_depth, height - floor_thickness],
                       anchor=BOTTOM);
        }
    }

    // Horizontal dividers
    if (comp_y > 1) {
        for (j = [1:comp_y-1]) {
            translate([0, int_depth * j / comp_y - int_depth/2, floor_thickness])
                cuboid([int_width, wall_thickness, height - floor_thickness],
                       anchor=BOTTOM);
        }
    }
}

module dice_tray(width, depth, height, felt_relief) {
    container_box(width, depth, height, felt_relief=felt_relief);
}

//====================================
// LAYOUT
//====================================

gap = container_gap;

// Container 1 - Card Holder
if (enable_container_1) {
    translate([c1_pos_x + c1_width/2 - box_width/2,
               c1_pos_y + c1_depth/2 - box_depth/2,
               0])
        card_holder(c1_width, c1_depth, c1_height, c1_finger_cutout);
}

// Container 2 - Component Bin
if (enable_container_2) {
    translate([c2_pos_x + c2_width/2 - box_width/2,
               c2_pos_y + c2_depth/2 - box_depth/2,
               0])
        component_bin(c2_width, c2_depth, c2_height, c2_add_divider);
}

// Container 3 - Multi-Compartment Tray
if (enable_container_3) {
    translate([c3_pos_x + c3_width/2 - box_width/2,
               c3_pos_y + c3_depth/2 - box_depth/2,
               0])
        multi_compartment_tray(c3_width, c3_depth, c3_height,
                              c3_compartments_x, c3_compartments_y);
}

// Container 4 - Dice Tray
if (enable_container_4) {
    translate([c4_pos_x + c4_width/2 - box_width/2,
               c4_pos_y + c4_depth/2 - box_depth/2,
               0])
        dice_tray(c4_width, c4_depth, c4_height, c4_felt_relief);
}

// Container 5 - Custom Storage
if (enable_container_5) {
    translate([c5_pos_x + c5_width/2 - box_width/2,
               c5_pos_y + c5_depth/2 - box_depth/2,
               0])
        container_box(c5_width, c5_depth, c5_height,
                     finger_cutout=c5_finger_cutout);
}

//====================================
// VALIDATION & HELPERS
//====================================

// Show box outline in preview
if ($preview) {
    %translate([0, 0, box_height/2])
        cuboid([box_width, box_depth, box_height], anchor=CENTER);
}

// Validation checks
module validate_container(name, pos_x, pos_y, width, depth, height, enabled) {
    if (enabled) {
        fits_x = pos_x + width <= box_width;
        fits_y = pos_y + depth <= box_depth;
        fits_z = height <= box_height;
        fits = fits_x && fits_y && fits_z;

        echo(str(name, ": ", fits ? "✓" : "✗ OVERFLOW",
                 " [", width, "x", depth, "x", height, "mm]",
                 " at [", pos_x, ",", pos_y, "]"));
    }
}

echo("=== Layout Validation ===");
echo(str("Box: ", box_width, "x", box_depth, "x", box_height, "mm"));

validate_container("Container 1", c1_pos_x, c1_pos_y, c1_width, c1_depth, c1_height, enable_container_1);
validate_container("Container 2", c2_pos_x, c2_pos_y, c2_width, c2_depth, c2_height, enable_container_2);
validate_container("Container 3", c3_pos_x, c3_pos_y, c3_width, c3_depth, c3_height, enable_container_3);
validate_container("Container 4", c4_pos_x, c4_pos_y, c4_width, c4_depth, c4_height, enable_container_4);
validate_container("Container 5", c5_pos_x, c5_pos_y, c5_width, c5_depth, c5_height, enable_container_5);

echo("======================");

/*
 * TIPS FOR CUSTOMIZATION:
 *
 * 1. MEASURING YOUR BOX:
 *    - Measure INTERNAL dimensions (inside the box)
 *    - Account for any lip or rim at the top
 *    - Leave 1-2mm clearance for lid closure
 *
 * 2. SIZING CONTAINERS:
 *    - Cards: Add 4-6mm to actual card dimensions for easy removal
 *    - Tokens: Measure stack height + 5-10mm clearance
 *    - Dice: Usually 20-30mm height is sufficient
 *
 * 3. POSITIONING:
 *    - Positions are from bottom-left corner (front-left of box)
 *    - Use gap variable for consistent spacing
 *    - Check validation output in console
 *
 * 4. PRINTING:
 *    - Print with 2-3 walls for strength
 *    - 10-15% infill is usually sufficient
 *    - Use supports only if needed for overhangs
 *    - Consider printing face-down for smoother interior
 *
 * 5. ADDING MORE CONTAINERS:
 *    - Copy any container block
 *    - Change the number (c6_, c7_, etc.)
 *    - Add new parameters section at top
 *    - Add validation call at bottom
 */

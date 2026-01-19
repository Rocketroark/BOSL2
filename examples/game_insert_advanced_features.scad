/*
 * Advanced Game Insert Features Example
 *
 * This example demonstrates advanced BOSL2 features for game inserts:
 * - Stackable containers with registration features
 * - Dovetail joints for modular assembly
 * - Angled compartments for better visibility
 * - Custom finger grips and handles
 * - Removable dividers with slots
 * - Magnetic lid attachments
 *
 * This is a more complex example showing what's possible beyond basic containers.
 */

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <BOSL2/joiners.scad>

/* [What to Show] */
// Select which component to display
show_component = "all"; // [all:All Components, card_box:Stackable Card Box, modular_tray:Modular Token Tray, tilted_bin:Angled Component Bin, handled_box:Box with Handles, divider_insert:Removable Divider System]

/* [Box Parameters] */
box_width = 200;
box_depth = 150;
box_height = 60;

/* [General Settings] */
wall_thickness = 2.5;
floor_thickness = 2.0;
corner_radius = 3.0;
$fn = $preview ? 32 : 64;

//====================================
// STACKABLE CARD BOX
// Features: Stack registration, finger cutout, top rim
//====================================

module stackable_card_box(width=70, depth=95, height=50) {
    tolerance = 0.3;
    rim_height = 2.5;

    difference() {
        union() {
            // Main box body
            cuboid([width, depth, height],
                   rounding=corner_radius,
                   edges="Z",
                   anchor=BOTTOM);

            // Stacking rim (male)
            translate([0, 0, height])
                difference() {
                    cuboid([width - tolerance,
                            depth - tolerance,
                            rim_height],
                           rounding=corner_radius - 0.5,
                           edges="Z",
                           anchor=BOTTOM);

                    // Hollow rim
                    translate([0, 0, -0.1])
                        cuboid([width - 2*wall_thickness - tolerance,
                                depth - 2*wall_thickness - tolerance,
                                rim_height + 1],
                               rounding=corner_radius - wall_thickness,
                               edges="Z",
                               anchor=BOTTOM);
                }
        }

        // Interior hollow
        translate([0, 0, floor_thickness])
            cuboid([width - 2*wall_thickness,
                    depth - 2*wall_thickness,
                    height],
                   rounding=corner_radius - wall_thickness,
                   edges="Z",
                   anchor=BOTTOM);

        // Finger cutout - semicircular
        translate([0, depth/2 - wall_thickness, height - 15])
            rotate([90, 0, 0])
                cyl(d=35, h=wall_thickness*3, anchor=BOTTOM);

        // Stacking recess (female) - bottom
        translate([0, 0, -0.1])
            difference() {
                cuboid([width - 2*wall_thickness + tolerance,
                        depth - 2*wall_thickness + tolerance,
                        rim_height + 0.2],
                       rounding=corner_radius - wall_thickness,
                       edges="Z",
                       anchor=BOTTOM);

                cuboid([width - 4*wall_thickness + tolerance,
                        depth - 4*wall_thickness + tolerance,
                        rim_height + 1],
                       rounding=corner_radius - 2*wall_thickness,
                       edges="Z",
                       anchor=BOTTOM);
            }
    }

    // Corner reinforcements
    for (x = [-1, 1], y = [-1, 1]) {
        translate([x * (width/2 - wall_thickness - 2),
                   y * (depth/2 - wall_thickness - 2),
                   floor_thickness])
            cyl(d=4, h=height - floor_thickness - 5, anchor=BOTTOM);
    }
}

//====================================
// MODULAR TOKEN TRAY
// Features: Dovetail connections, removable, interlocking
//====================================

module modular_token_tray(width=90, depth=90, height=30, show_male=true) {
    dovetail_width = 10;
    dovetail_height = 5;

    difference() {
        union() {
            // Main tray
            cuboid([width, depth, height],
                   rounding=corner_radius,
                   edges="Z",
                   anchor=BOTTOM);

            // Dovetail connectors on sides (male)
            if (show_male) {
                for (side = [0, 180]) {
                    rotate([0, 0, side])
                        translate([0, depth/2, height/2])
                            rotate([90, 0, 0])
                                dovetail("male", width=dovetail_width,
                                        height=dovetail_height,
                                        slide=depth/3,
                                        anchor=BACK);
                }
            }
        }

        // Interior
        translate([0, 0, floor_thickness])
            cuboid([width - 2*wall_thickness,
                    depth - 2*wall_thickness,
                    height],
                   rounding=corner_radius - wall_thickness,
                   edges="Z",
                   anchor=BOTTOM);

        // Dovetail slots on front/back (female)
        for (side = [90, 270]) {
            rotate([0, 0, side])
                translate([0, depth/2, height/2])
                    rotate([90, 0, 0])
                        dovetail("female", width=dovetail_width,
                                height=dovetail_height,
                                slide=depth/3,
                                anchor=BACK);
        }

        // Internal dividers forming 4 compartments
        // (留空间让dividers是从floor_thickness开始)
    }

    // Add dividers
    int_width = width - 2*wall_thickness;
    int_depth = depth - 2*wall_thickness;

    translate([0, 0, floor_thickness])
        cuboid([wall_thickness, int_depth, height - floor_thickness],
               anchor=BOTTOM);

    translate([0, 0, floor_thickness])
        cuboid([int_width, wall_thickness, height - floor_thickness],
               anchor=BOTTOM);
}

//====================================
// ANGLED COMPONENT BIN
// Features: Tilted for visibility, easier access
//====================================

module tilted_component_bin(width=80, depth=80, height=40, tilt_angle=15) {
    // Calculate tilted back height
    back_height = height + depth * sin(tilt_angle) / 2;

    difference() {
        // Main angled body using skin() for smooth transition
        translate([0, 0, 0])
            hull() {
                // Front edge
                translate([0, -depth/2, 0])
                    cuboid([width, wall_thickness, height],
                           rounding=corner_radius,
                           edges="Z",
                           anchor=BOTTOM);

                // Back edge (taller)
                translate([0, depth/2, 0])
                    cuboid([width, wall_thickness, back_height],
                           rounding=corner_radius,
                           edges="Z",
                           anchor=BOTTOM);
            }

        // Interior cutout (angled)
        hull() {
            translate([0, -depth/2 + wall_thickness, floor_thickness])
                cuboid([width - 2*wall_thickness, wall_thickness,
                        height - floor_thickness],
                       rounding=corner_radius - wall_thickness,
                       edges="Z",
                       anchor=BOTTOM);

            translate([0, depth/2 - wall_thickness, floor_thickness])
                cuboid([width - 2*wall_thickness, wall_thickness,
                        back_height - floor_thickness],
                       rounding=corner_radius - wall_thickness,
                       edges="Z",
                       anchor=BOTTOM);
        }
    }
}

//====================================
// BOX WITH INTEGRATED HANDLES
// Features: Finger grips, comfortable removal
//====================================

module handled_component_box(width=100, depth=70, height=45) {
    difference() {
        union() {
            // Main box
            cuboid([width, depth, height],
                   rounding=corner_radius,
                   edges="Z",
                   anchor=BOTTOM);

            // Handle reinforcements
            for (side = [0, 180]) {
                rotate([0, 0, side])
                    translate([0, depth/2, height - 10])
                        rotate([90, 0, 0])
                            difference() {
                                cyl(d=20, h=wall_thickness, anchor=FRONT);
                                cyl(d=14, h=wall_thickness*2, anchor=FRONT);
                            }
            }
        }

        // Interior
        translate([0, 0, floor_thickness])
            cuboid([width - 2*wall_thickness,
                    depth - 2*wall_thickness,
                    height],
                   rounding=corner_radius - wall_thickness,
                   edges="Z",
                   anchor=BOTTOM);

        // Handle cutouts
        for (side = [0, 180]) {
            rotate([0, 0, side])
                translate([0, depth/2 - wall_thickness, height - 10])
                    rotate([90, 0, 0])
                        cyl(d=14, h=wall_thickness*3, anchor=BOTTOM);
        }

        // Side grip recesses
        for (side = [90, 270]) {
            rotate([0, 0, side])
                translate([0, depth/2 + 0.5, height/2])
                    rotate([90, 0, 0])
                        cuboid([30, 20, wall_thickness + 1],
                               rounding=3,
                               anchor=FRONT);
        }
    }
}

//====================================
// REMOVABLE DIVIDER SYSTEM
// Features: Slotted dividers, adjustable layout
//====================================

module base_tray_with_slots(width=120, depth=100, height=35, num_slots_x=3, num_slots_y=2) {
    slot_width = wall_thickness + 0.4; // Tolerance for sliding fit
    slot_depth = 2;

    difference() {
        // Main tray
        cuboid([width, depth, height],
               rounding=corner_radius,
               edges="Z",
               anchor=BOTTOM);

        // Interior
        translate([0, 0, floor_thickness])
            cuboid([width - 2*wall_thickness,
                    depth - 2*wall_thickness,
                    height],
                   rounding=corner_radius - wall_thickness,
                   edges="Z",
                   anchor=BOTTOM);

        // Divider slots - X direction
        int_width = width - 2*wall_thickness;
        int_depth = depth - 2*wall_thickness;

        for (i = [1:num_slots_x]) {
            translate([int_width * i / (num_slots_x + 1) - int_width/2,
                       0,
                       floor_thickness])
                cuboid([slot_width, int_depth, height],
                       anchor=BOTTOM);
        }

        // Divider slots - Y direction
        for (j = [1:num_slots_y]) {
            translate([0,
                       int_depth * j / (num_slots_y + 1) - int_depth/2,
                       floor_thickness])
                cuboid([int_width, slot_width, height],
                       anchor=BOTTOM);
        }
    }
}

module removable_divider(length=96, height=31, orientation="x") {
    // orientation: "x" or "y"
    slot_width = wall_thickness + 0.3; // Slightly smaller than slot for fit
    notch_depth = height / 2 + 0.5; // Interlocking notches

    difference() {
        cuboid([slot_width, length, height], anchor=BOTTOM);

        // Interlocking notches (for crossing dividers)
        // Every 1/3 of length, alternating top and bottom
        for (i = [0:2]) {
            translate([0,
                       length * (i + 0.5) / 3 - length/2,
                       i % 2 == 0 ? height - notch_depth : 0])
                cuboid([slot_width + 1, slot_width + 0.2, notch_depth + 0.5],
                       anchor=BOTTOM);
        }
    }
}

//====================================
// MAIN RENDERING
//====================================

if (show_component == "all" || show_component == "card_box") {
    translate([-75, -50, 0])
        stackable_card_box();
}

if (show_component == "all" || show_component == "modular_tray") {
    translate([20, -50, 0])
        modular_token_tray(show_male=true);
}

if (show_component == "all" || show_component == "tilted_bin") {
    translate([-75, 60, 0])
        tilted_component_bin();
}

if (show_component == "all" || show_component == "handled_box") {
    translate([30, 60, 0])
        handled_component_box();
}

if (show_component == "all" || show_component == "divider_insert") {
    if ($preview) {
        base_tray_with_slots();

        // Show dividers in exploded view
        %translate([0, 0, 40]) {
            removable_divider(length=96, height=31, orientation="x");
            translate([30, 0, 0])
                removable_divider(length=96, height=31, orientation="x");

            translate([0, 25, 0])
                rotate([0, 0, 90])
                    removable_divider(length=116, height=31, orientation="y");
            translate([0, -25, 0])
                rotate([0, 0, 90])
                    removable_divider(length=116, height=31, orientation="y");
        }
    } else {
        base_tray_with_slots();
    }
}

// Show bounding box in preview
if ($preview && show_component == "all") {
    %translate([0, 0, box_height/2])
        cuboid([box_width, box_depth, box_height], anchor=CENTER);
}

echo("=== Advanced Features Demo ===");
echo("This example showcases:");
echo("  - Stackable containers with registration");
echo("  - Dovetail modular connections");
echo("  - Angled bins for better visibility");
echo("  - Integrated handles and grips");
echo("  - Removable divider system");
echo("");
echo("Use 'show_component' parameter to view individually");

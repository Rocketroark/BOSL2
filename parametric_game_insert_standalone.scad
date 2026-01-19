/*
 * Parametric Game Insert System v1.2.1 - STANDALONE VERSION
 *
 * This version works without BOSL2 dependencies
 * Compatible with MakerWorld and online OpenSCAD environments
 *
 * FEATURES:
 * - 8 container slots with full customization
 * - Per-container lids, hex floors, finger grips, stackable
 * - Multiple bin types: coin slots, token wells, small parts, card dividers
 * - Works in any OpenSCAD environment
 */

/* [Box Dimensions] */
box_width = 300; // [100:10:500]
box_depth = 200; // [100:10:500]
box_height = 75; // [30:5:200]

/* [Container Options] */
wall_thickness = 2.0; // [1.0:0.5:5.0]
floor_thickness = 1.5; // [0.8:0.1:4.0]
corner_radius = 2.0; // [0:0.5:10]
container_gap = 0.5; // [0:0.1:3.0]

/* [Global Hex Pattern Defaults] */
default_hex_floor = false;
default_hex_floor_size = 8; // [4:1:15]
default_hex_floor_wall = 0.8; // [0.4:0.1:2.0]

/* [Global Lid Defaults] */
default_lid_type = "snap"; // [snap:Snap-fit, friction:Friction-fit]
default_lid_tolerance = 0.3; // [0.1:0.05:0.8]
default_lid_thickness = 2.0; // [1.0:0.5:4.0]

/* [Container Slot 1] */
c1_enable = true;
c1_type = "token_tray"; // [card_holder, component_bin, dice_tray, token_tray]
c1_width = 70; // [30:5:200]
c1_depth = 70; // [30:5:200]
c1_height = 30; // [15:5:150]
c1_pos_x = 1; // [0:1:500]
c1_pos_y = 1; // [0:1:500]
c1_bin_type = "general"; // [general, coin_slot, token_well, small_parts, card_divider]
c1_comp_x = 2; // [1:1:12]
c1_comp_y = 2; // [1:1:12]
c1_divider = false;
c1_cutout = 25; // [0:5:60]
c1_lid = false;
c1_hex_floor = false;
c1_finger_grips = false;
c1_stackable = false;

/* [Container Slot 2] */
c2_enable = false;
c2_type = "component_bin"; // [card_holder, component_bin, dice_tray, token_tray]
c2_width = 90; // [30:5:200]
c2_depth = 90; // [30:5:200]
c2_height = 40; // [15:5:150]
c2_pos_x = 75; // [0:1:500]
c2_pos_y = 1; // [0:1:500]
c2_bin_type = "coin_slot"; // [general, coin_slot, token_well, small_parts, card_divider]
c2_comp_x = 6; // [1:1:12]
c2_comp_y = 2; // [1:1:12]
c2_divider = false;
c2_cutout = 0; // [0:5:60]
c2_lid = false;
c2_hex_floor = false;
c2_finger_grips = false;
c2_stackable = false;

/* [Container Slot 3] */
c3_enable = false;
c3_type = "token_tray"; // [card_holder, component_bin, dice_tray, token_tray]
c3_width = 70; // [30:5:200]
c3_depth = 70; // [30:5:200]
c3_height = 30; // [15:5:150]
c3_pos_x = 170; // [0:1:500]
c3_pos_y = 1; // [0:1:500]
c3_bin_type = "token_well"; // [general, coin_slot, token_well, small_parts, card_divider]
c3_comp_x = 3; // [1:1:12]
c3_comp_y = 3; // [1:1:12]
c3_divider = false;
c3_cutout = 0; // [0:5:60]
c3_lid = true;
c3_hex_floor = true;
c3_finger_grips = false;
c3_stackable = false;

/* [Container Slot 4] */
c4_enable = false;
c4_type = "card_holder"; // [card_holder, component_bin, dice_tray, token_tray]
c4_width = 70; // [30:5:200]
c4_depth = 95; // [30:5:200]
c4_height = 65; // [15:5:150]
c4_pos_x = 1; // [0:1:500]
c4_pos_y = 75; // [0:1:500]
c4_bin_type = "general"; // [general, coin_slot, token_well, small_parts, card_divider]
c4_comp_x = 1; // [1:1:12]
c4_comp_y = 1; // [1:1:12]
c4_divider = false;
c4_cutout = 30; // [0:5:60]
c4_lid = false;
c4_hex_floor = false;
c4_finger_grips = false;
c4_stackable = false;

/* [Container Slot 5] */
c5_enable = false;
c5_type = "component_bin"; // [card_holder, component_bin, dice_tray, token_tray]
c5_width = 90; // [30:5:200]
c5_depth = 70; // [30:5:200]
c5_height = 35; // [15:5:150]
c5_pos_x = 1; // [0:1:500]
c5_pos_y = 130; // [0:1:500]
c5_bin_type = "general"; // [general, coin_slot, token_well, small_parts, card_divider]
c5_comp_x = 3; // [1:1:12]
c5_comp_y = 2; // [1:1:12]
c5_divider = true;
c5_cutout = 0; // [0:5:60]
c5_lid = false;
c5_hex_floor = true;
c5_finger_grips = true;
c5_stackable = false;

/* [Container Slot 6] */
c6_enable = false;
c6_type = "dice_tray"; // [card_holder, component_bin, dice_tray, token_tray]
c6_width = 70; // [30:5:200]
c6_depth = 70; // [30:5:200]
c6_height = 25; // [15:5:150]
c6_pos_x = 95; // [0:1:500]
c6_pos_y = 130; // [0:1:500]
c6_bin_type = "general"; // [general, coin_slot, token_well, small_parts, card_divider]
c6_comp_x = 1; // [1:1:12]
c6_comp_y = 1; // [1:1:12]
c6_divider = false;
c6_cutout = 0; // [0:5:60]
c6_lid = true;
c6_hex_floor = true;
c6_finger_grips = false;
c6_stackable = false;

/* [Container Slot 7] */
c7_enable = false;
c7_type = "component_bin"; // [card_holder, component_bin, dice_tray, token_tray]
c7_width = 90; // [30:5:200]
c7_depth = 90; // [30:5:200]
c7_height = 30; // [15:5:150]
c7_pos_x = 170; // [0:1:500]
c7_pos_y = 75; // [0:1:500]
c7_bin_type = "small_parts"; // [general, coin_slot, token_well, small_parts, card_divider]
c7_comp_x = 4; // [1:1:12]
c7_comp_y = 3; // [1:1:12]
c7_divider = false;
c7_cutout = 0; // [0:5:60]
c7_lid = true;
c7_hex_floor = true;
c7_finger_grips = false;
c7_stackable = true;

/* [Container Slot 8] */
c8_enable = false;
c8_type = "token_tray"; // [card_holder, component_bin, dice_tray, token_tray]
c8_width = 65; // [30:5:200]
c8_depth = 65; // [30:5:200]
c8_height = 35; // [15:5:150]
c8_pos_x = 75; // [0:1:500]
c8_pos_y = 75; // [0:1:500]
c8_bin_type = "general"; // [general, coin_slot, token_well, small_parts, card_divider]
c8_comp_x = 4; // [1:1:12]
c8_comp_y = 4; // [1:1:12]
c8_divider = false;
c8_cutout = 0; // [0:5:60]
c8_lid = false;
c8_hex_floor = true;
c8_finger_grips = false;
c8_stackable = false;

/* [Display Options] */
show_validation = true;
exploded_view = 1.0; // [1.0:0.5:3.0]

/* [Advanced Global] */
top_chamfer = 0.5; // [0:0.1:2.0]
stack_tolerance = 0.3; // [0.1:0.1:1.0]

$fn = $preview ? 32 : 64;

//====================================
// STANDALONE HELPER MODULES
//====================================

// Rounded cube using minkowski (works everywhere)
module rcube(size, r=0) {
    if (r == 0) {
        cube(size, center=true);
    } else {
        minkowski() {
            cube([size[0]-2*r, size[1]-2*r, size[2]-2*r], center=true);
            cylinder(r=r, h=0.01, $fn=16);
        }
    }
}

// Simple cylinder
module simple_cyl(d, h) {
    cylinder(d=d, h=h, center=false);
}

// Hexagon pattern floor - standalone version
module hex_floor_standalone(width, depth, hex_size, wall_thick) {
    hex_spacing = hex_size * 1.732;

    difference() {
        // Solid base
        translate([0, 0, floor_thickness/2])
            cube([width, depth, floor_thickness], center=true);

        // Cut hexagons
        for (x = [-width/2 : hex_spacing : width/2]) {
            for (y = [-depth/2 : hex_spacing : depth/2]) {
                offset_y = (floor(x / hex_spacing) % 2 == 0) ? 0 : hex_spacing / 2;
                translate([x, y + offset_y, 0])
                    linear_extrude(height=floor_thickness + 1, center=true)
                        circle(r=hex_size - wall_thick, $fn=6);
            }
        }
    }
}

// Snap lid - standalone (solid top cover)
module snap_lid_standalone(width, depth, tolerance, thickness) {
    wall_height = 10; // Walls extend down 10mm to fully contain items
    clip_thick = 1.2;

    difference() {
        union() {
            // SOLID TOP SURFACE - covers entire container opening
            translate([0, 0, thickness/2])
                rcube([width + 0.5, depth + 0.5, thickness], r=corner_radius);

            // Interior containment walls that extend down inside container rim
            translate([0, 0, -wall_height/2])
                difference() {
                    // Outer wall boundary
                    rcube([width - 2*wall_thickness - tolerance,
                           depth - 2*wall_thickness - tolerance,
                           wall_height], r=max(0.5, corner_radius - wall_thickness));

                    // Hollow interior to create walls
                    rcube([width - 2*wall_thickness - tolerance - 2*clip_thick,
                           depth - 2*wall_thickness - tolerance - 2*clip_thick,
                           wall_height + 1], r=max(0.5, corner_radius - wall_thickness - clip_thick));
                }

            // Snap clips on two opposite sides for secure attachment
            for (side = [0, 180]) {
                rotate([0, 0, side])
                    translate([0, (depth - 2*wall_thickness - tolerance) / 2 - clip_thick/2, -wall_height/2])
                        difference() {
                            cube([25, clip_thick + 0.4, wall_height], center=true);
                            // Small undercut for flexible snap action
                            translate([0, -clip_thick/2 - 0.2, -wall_height/2 + 1.5])
                                cube([15, 0.4, 3], center=true);
                        }
            }
        }

        // Finger grip cutout on top for easy removal
        translate([0, 0, thickness/2])
            rcube([35, 15, thickness + 1], r=4);
    }
}

// Friction lid - standalone (solid top cover)
module friction_lid_standalone(width, depth, tolerance, thickness) {
    wall_height = 10; // Walls extend down 10mm to fully contain items
    wall_thick = 1.5;

    difference() {
        union() {
            // SOLID TOP SURFACE - covers entire container opening
            translate([0, 0, thickness/2])
                rcube([width + 0.5, depth + 0.5, thickness], r=corner_radius);

            // Interior containment walls with tight friction fit
            translate([0, 0, -wall_height/2])
                difference() {
                    // Outer wall boundary (slightly tighter fit than snap lid)
                    rcube([width - 2*wall_thickness - tolerance/2,
                           depth - 2*wall_thickness - tolerance/2,
                           wall_height], r=max(0.5, corner_radius - wall_thickness));

                    // Hollow interior to create walls
                    rcube([width - 2*wall_thickness - tolerance/2 - 2*wall_thick,
                           depth - 2*wall_thickness - tolerance/2 - 2*wall_thick,
                           wall_height + 1], r=max(0.5, corner_radius - wall_thickness - wall_thick));
                }
        }

        // Finger grip cutout on top for easy removal
        translate([0, 0, thickness/2])
            rcube([35, 15, thickness + 1], r=4);
    }
}

// Main container box - standalone
module container_box_standalone(width, depth, height, finger_cutout, use_hex_floor, use_finger_grips, use_stackable) {
    difference() {
        // Outer box (walls + floor)
        translate([0, 0, height/2])
            rcube([width, depth, height], r=corner_radius);

        // Interior cavity - cut from top of floor to top of container
        translate([0, 0, floor_thickness + (height - floor_thickness)/2 + 0.01])
            rcube([width - 2*wall_thickness,
                   depth - 2*wall_thickness,
                   height - floor_thickness], r=max(0.5, corner_radius - wall_thickness));

        // Top chamfer
        if (top_chamfer > 0) {
            translate([0, 0, height - top_chamfer/2])
                rcube([width - 2*wall_thickness + 2*top_chamfer,
                       depth - 2*wall_thickness + 2*top_chamfer,
                       top_chamfer], r=top_chamfer/2);
        }

        // Finger cutout
        if (finger_cutout > 0) {
            translate([0, depth/2 - wall_thickness, height - finger_cutout/2])
                rotate([90, 0, 0])
                    cylinder(d=finger_cutout, h=wall_thickness*3);
        }

        // Cut hex pattern holes into floor if enabled
        if (use_hex_floor) {
            hex_spacing = default_hex_floor_size * 1.732;
            for (x = [-(width - 2*wall_thickness)/2 : hex_spacing : (width - 2*wall_thickness)/2]) {
                for (y = [-(depth - 2*wall_thickness)/2 : hex_spacing : (depth - 2*wall_thickness)/2]) {
                    offset_y = (floor(x / hex_spacing) % 2 == 0) ? 0 : hex_spacing / 2;
                    translate([x, y + offset_y, -0.5])
                        linear_extrude(height=floor_thickness + 1)
                            circle(r=default_hex_floor_size - default_hex_floor_wall, $fn=6);
                }
            }
        }
    }

    // Stackable rim
    if (use_stackable) {
        translate([0, 0, height + 1])
            difference() {
                rcube([width - stack_tolerance, depth - stack_tolerance, 2], r=corner_radius);
                rcube([width - 2*wall_thickness - stack_tolerance,
                       depth - 2*wall_thickness - stack_tolerance, 3],
                       r=max(0.5, corner_radius - wall_thickness));
            }
    }

    // Finger grips
    if (use_finger_grips) {
        for (side = [0, 180]) {
            rotate([0, 0, side])
                translate([0, depth/2, height/2])
                    rotate([90, 0, 0])
                        difference() {
                            cylinder(d=15, h=wall_thickness);
                            cylinder(d=12, h=wall_thickness*2, center=true);
                        }
        }
    }
}

// Card holder
module card_holder_standalone(w, d, h, cutout, hex_floor, grips, stackable) {
    container_box_standalone(w, d, h, cutout, hex_floor, grips, stackable);
}

// Token tray with dividers
module token_tray_standalone(w, d, h, comp_x, comp_y, hex_floor, grips, stackable) {
    container_box_standalone(w, d, h, 0, hex_floor, grips, stackable);

    int_width = w - 2*wall_thickness;
    int_depth = d - 2*wall_thickness;

    // Vertical dividers
    if (comp_x > 1) {
        for (i = [1:comp_x-1]) {
            translate([int_width * i / comp_x - int_width/2, 0, floor_thickness + (h - floor_thickness)/2])
                cube([wall_thickness, int_depth, h - floor_thickness], center=true);
        }
    }

    // Horizontal dividers
    if (comp_y > 1) {
        for (j = [1:comp_y-1]) {
            translate([0, int_depth * j / comp_y - int_depth/2, floor_thickness + (h - floor_thickness)/2])
                cube([int_width, wall_thickness, h - floor_thickness], center=true);
        }
    }
}

// Component bin with types
module component_bin_standalone(w, d, h, bin_type, num_slots, divider, hex_floor, grips, stackable) {
    container_box_standalone(w, d, h, 0, hex_floor, grips, stackable);

    int_width = w - 2*wall_thickness;
    int_depth = d - 2*wall_thickness;

    if (bin_type == "coin_slot") {
        // Vertical coin slots
        for (i = [1:num_slots-1]) {
            translate([int_width * i / num_slots - int_width/2, 0, floor_thickness + (h - floor_thickness)/2])
                cube([wall_thickness, int_depth, h - floor_thickness], center=true);
        }
    } else if (bin_type == "token_well") {
        // Circular token wells
        wells_per_row = ceil(sqrt(num_slots));
        well_diameter = min((w - 2*wall_thickness) / wells_per_row - 2,
                           (d - 2*wall_thickness) / wells_per_row - 2);

        for (i = [0:num_slots-1]) {
            x_pos = (i % wells_per_row) - (wells_per_row - 1) / 2;
            y_pos = floor(i / wells_per_row) - (ceil(num_slots / wells_per_row) - 1) / 2;

            translate([x_pos * (int_width / wells_per_row),
                       y_pos * (int_depth / ceil(num_slots / wells_per_row)),
                       floor_thickness])
                cylinder(d=well_diameter, h=h);
        }
    } else if (bin_type == "small_parts") {
        // 4x3 grid
        for (i = [1:3]) {
            translate([int_width * i / 4 - int_width/2, 0, floor_thickness + (h - floor_thickness)/2])
                cube([wall_thickness, int_depth, h - floor_thickness], center=true);
        }
        for (j = [1:2]) {
            translate([0, int_depth * j / 3 - int_depth/2, floor_thickness + (h - floor_thickness)/2])
                cube([int_width, wall_thickness, h - floor_thickness], center=true);
        }
    } else if (bin_type == "card_divider") {
        // Card dividers
        for (i = [1:num_slots-1]) {
            translate([int_width * i / num_slots - int_width/2, 0, floor_thickness + (h - floor_thickness)/2])
                cube([wall_thickness, int_depth, h - floor_thickness], center=true);
        }
    } else if (divider) {
        // Single center divider
        translate([0, 0, floor_thickness + (h - floor_thickness)/2])
            cube([wall_thickness, int_depth, h - floor_thickness], center=true);
    }
}

// Dice tray
module dice_tray_standalone(w, d, h, hex_floor, grips, stackable) {
    container_box_standalone(w, d, h, 0, hex_floor, grips, stackable);
}

//====================================
// LAYOUT & RENDERING
//====================================

function multi_layout() =
    let (
        containers = [
            if (c1_enable)
                [c1_type, c1_pos_x, c1_pos_y, c1_width, c1_depth, c1_height,
                 c1_comp_x, c1_comp_y, c1_bin_type, c1_divider, c1_cutout, c1_lid,
                 c1_hex_floor, c1_finger_grips, c1_stackable],
            if (c2_enable)
                [c2_type, c2_pos_x, c2_pos_y, c2_width, c2_depth, c2_height,
                 c2_comp_x, c2_comp_y, c2_bin_type, c2_divider, c2_cutout, c2_lid,
                 c2_hex_floor, c2_finger_grips, c2_stackable],
            if (c3_enable)
                [c3_type, c3_pos_x, c3_pos_y, c3_width, c3_depth, c3_height,
                 c3_comp_x, c3_comp_y, c3_bin_type, c3_divider, c3_cutout, c3_lid,
                 c3_hex_floor, c3_finger_grips, c3_stackable],
            if (c4_enable)
                [c4_type, c4_pos_x, c4_pos_y, c4_width, c4_depth, c4_height,
                 c4_comp_x, c4_comp_y, c4_bin_type, c4_divider, c4_cutout, c4_lid,
                 c4_hex_floor, c4_finger_grips, c4_stackable],
            if (c5_enable)
                [c5_type, c5_pos_x, c5_pos_y, c5_width, c5_depth, c5_height,
                 c5_comp_x, c5_comp_y, c5_bin_type, c5_divider, c5_cutout, c5_lid,
                 c5_hex_floor, c5_finger_grips, c5_stackable],
            if (c6_enable)
                [c6_type, c6_pos_x, c6_pos_y, c6_width, c6_depth, c6_height,
                 c6_comp_x, c6_comp_y, c6_bin_type, c6_divider, c6_cutout, c6_lid,
                 c6_hex_floor, c6_finger_grips, c6_stackable],
            if (c7_enable)
                [c7_type, c7_pos_x, c7_pos_y, c7_width, c7_depth, c7_height,
                 c7_comp_x, c7_comp_y, c7_bin_type, c7_divider, c7_cutout, c7_lid,
                 c7_hex_floor, c7_finger_grips, c7_stackable],
            if (c8_enable)
                [c8_type, c8_pos_x, c8_pos_y, c8_width, c8_depth, c8_height,
                 c8_comp_x, c8_comp_y, c8_bin_type, c8_divider, c8_cutout, c8_lid,
                 c8_hex_floor, c8_finger_grips, c8_stackable],
        ]
    )
    containers;

containers = multi_layout();

// Only render if there are containers
if (len(containers) > 0) {
    for (i = [0:len(containers)-1]) {
        c = containers[i];
        type = c[0];
        x = c[1];
        y = c[2];
        w = c[3];
        d = c[4];
        h = c[5];
        comp_x = c[6];
        comp_y = c[7];
        bin_type = c[8];
        divider = c[9];
        cutout = c[10];
        has_lid = c[11];
        hex_floor = c[12];
        grips = c[13];
        stackable = c[14];

        translate([x - box_width/2 + w/2, y - box_depth/2 + d/2, 0]) {
            if (type == "card_holder")
                card_holder_standalone(w, d, h, cutout, hex_floor, grips, stackable);
            else if (type == "component_bin")
                component_bin_standalone(w, d, h, bin_type, comp_x, divider, hex_floor, grips, stackable);
            else if (type == "dice_tray")
                dice_tray_standalone(w, d, h, hex_floor, grips, stackable);
            else if (type == "token_tray")
                token_tray_standalone(w, d, h, comp_x, comp_y, hex_floor, grips, stackable);

            // Lid
            if (has_lid) {
                translate([0, 0, h]) {
                    if (default_lid_type == "snap")
                        snap_lid_standalone(w, d, default_lid_tolerance, default_lid_thickness);
                    else
                        friction_lid_standalone(w, d, default_lid_tolerance, default_lid_thickness);
                }
            }
        }
    }

    // Box outline in preview
    if ($preview) {
        %translate([0, 0, box_height/2])
            cube([box_width, box_depth, box_height], center=true);
    }
} else {
    // Show message when no containers enabled
    echo("=== NO CONTAINERS ENABLED ===");
    echo("Enable at least one container slot (c1_enable, c2_enable, etc.)");

    // Show box outline
    if ($preview) {
        %translate([0, 0, box_height/2])
            cube([box_width, box_depth, box_height], center=true);
    }
}

echo("=== Parametric Game Insert v1.2.1 STANDALONE ===");
echo(str("Active containers: ", len(containers)));
if (len(containers) == 0) {
    echo("TIP: Enable container slots in the Customizer!");
}

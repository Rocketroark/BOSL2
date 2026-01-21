/*
 * Parametric Stamp - Quick Start Template
 * Version: 1.2.0
 *
 * Simplified template for quick stamp creation
 * Upload your image and adjust basic settings
 * Features recessed face to prevent ink overflow
 * Socket mount system for separate handle printing
 *
 * For advanced options, use parametric_stamp.scad
 */

include <BOSL2/std.scad>

/* [Quick Settings] */

// Upload your image file (SVG, PNG, or STL)
image_file = "default.svg"; // file

// Stamp width (mm)
width = 40; // [20:1:100]

// Stamp height (mm)
height = 30; // [20:1:100]

// Handle style
handle = "cylindrical"; // [cylindrical, knob, ergonomic, rectangular, none]

// Handle mount type
handle_mount = "socket"; // [integrated, socket]

/* [Optional Text] */

// Add text to stamp
add_text = false;

// Your text
stamp_text = "APPROVED"; // text

// Text size (mm)
text_size = 6; // [3:0.5:15]

// Text Y offset (fine-tune position, mm)
text_offset_y = 0; // [-20:0.5:20]

/* [Advanced] */

// What to render
render_part = "both"; // [both, stamp_only, handle_only]

// Stamp depth (mm)
depth = 5; // [3:0.5:10]

// Image relief depth (mm)
relief = 1.5; // [0.5:0.1:5]

// Handle height (mm)
handle_height = 25; // [10:1:50]

// Enable recessed face (prevents ink overflow)
enable_recess = true;

// Face recess depth (mm)
recess_depth = 1.0; // [0.3:0.1:3]

// Border width (mm)
border = 3; // [1:0.5:10]

// Socket diameter (for separate handle, mm)
socket_diameter = 12; // [8:0.5:20]

// Socket depth (for separate handle, mm)
socket_depth = 8; // [5:0.5:15]

// ===========================
// Main Model
// ===========================

$fn = 100;

if (render_part == "both") {
    if (handle_mount == "integrated") {
        // Traditional: stamp and handle together
        union() {
            stamp_body();
            if (handle != "none") {
                translate([0, 0, depth/2])
                    create_handle();
            }
        }
    } else {
        // Socket mount: show stamp with socket
        stamp_body();
    }
} else if (render_part == "stamp_only") {
    stamp_body();
} else if (render_part == "handle_only") {
    if (handle != "none") {
        handle_with_peg();
    }
}

// ===========================
// Modules
// ===========================

module stamp_body() {
    difference() {
        stamp_with_elements();

        // Add socket hole if using socket mount
        if (handle != "none" && handle_mount == "socket") {
            translate([0, 0, depth])
                cyl(d=socket_diameter + 0.2, h=socket_depth, anchor=TOP);
        }
    }
}

module stamp_with_elements() {
    // Stamp base with recessed face
    if (enable_recess) {
        union() {
            // Body with recessed center
            difference() {
                cuboid([width, height, depth], rounding=2, edges="Z", anchor=BOTTOM);
                // Create recess
                translate([0, 0, recess_depth])
                    cuboid([width - border*2, height - border*2, depth],
                           rounding=1, edges="Z", anchor=BOTTOM);
            }

            // Add raised image
            translate([0, 0, recess_depth + relief/2])
                mirror([1, 0, 0])
                    load_image();

            // Add raised text
            if (add_text && stamp_text != "") {
                base_y = -height/2 + text_size/2 + 2;
                translate([0, base_y + text_offset_y, recess_depth + 0.4])
                    mirror([1, 0, 0])
                        linear_extrude(height=0.8, center=true)
                            text(stamp_text, size=text_size,
                                 font="Liberation Sans:style=Bold",
                                 halign="center", valign="center");
            }
        }
    } else {
        // Traditional stamp (no recess)
        difference() {
            cuboid([width, height, depth], rounding=2, edges="Z", anchor=BOTTOM);

            translate([0, 0, -depth/2 + relief/2])
                mirror([1, 0, 0])
                    load_image();

            if (add_text && stamp_text != "") {
                base_y = -height/2 + text_size/2 + 2;
                translate([0, base_y + text_offset_y, -depth/2 + 0.4])
                    mirror([1, 0, 0])
                        linear_extrude(height=0.8, center=true)
                            text(stamp_text, size=text_size,
                                 font="Liberation Sans:style=Bold",
                                 halign="center", valign="center");
            }
        }
    }
}

module handle_with_peg() {
    union() {
        create_handle();

        // Add mounting peg if using socket mount
        if (handle_mount == "socket") {
            translate([0, 0, -socket_depth/2])
                cyl(d=socket_diameter, h=socket_depth, anchor=TOP, chamfer2=0.5);
        }
    }
}

module load_image() {
    if (image_file != "default.svg" && image_file != "default.png" && image_file != "default.stl") {
        // Determine file type from extension
        ext = search(".svg", image_file);
        if (ext != []) {
            resize([width*0.9, height*0.9, relief], auto=true)
                linear_extrude(height=relief, center=true, convexity=10)
                    import(file=image_file, center=true);
        } else {
            resize([width*0.9, height*0.9, relief], auto=true)
                import(file=image_file, center=true);
        }
    } else {
        // Placeholder
        cube([width*0.7, height*0.7, relief], center=true);
    }
}

module create_handle() {
    handle_size = min(width, height) * 0.6;

    if (handle == "cylindrical") {
        difference() {
            union() {
                cyl(d=handle_size, h=handle_height, anchor=BOTTOM);
                translate([0, 0, handle_height])
                    sphere(d=handle_size);
            }
        }
    }
    else if (handle == "knob") {
        hull() {
            cyl(d=handle_size*0.7, h=2, anchor=BOTTOM);
            translate([0, 0, handle_height*0.6])
                sphere(d=handle_size);
        }
    }
    else if (handle == "ergonomic") {
        union() {
            hull() {
                cyl(d=handle_size*0.8, h=1, anchor=BOTTOM);
                translate([0, 0, handle_height*0.6])
                    cyl(d=handle_size, h=1, anchor=BOTTOM);
            }
            translate([0, 0, handle_height*0.6])
                sphere(d=handle_size);
        }
    }
    else if (handle == "rectangular") {
        union() {
            cuboid([handle_size, handle_size, handle_height],
                   rounding=2, edges="Z", anchor=BOTTOM);
            translate([0, 0, handle_height])
                cuboid([handle_size, handle_size, handle_size/2],
                       rounding=handle_size/4, anchor=BOTTOM);
        }
    }
}

echo("========================================");
echo("Parametric Stamp - Quick Start Template v1.2.0");
echo("========================================");
echo("1. Upload your image file");
echo("2. Adjust width and height");
echo("3. Choose handle style and mount type");
echo("4. Optional: Add text");
echo("5. Select what to render (stamp/handle/both)");
echo("6. Export STL for 3D printing");
echo("========================================");
echo(str("Rendering: ", render_part));
echo(str("Stamp size: ", width, "mm x ", height, "mm"));
if (enable_recess) {
    echo(str("Recessed face: ", recess_depth, "mm with ", border, "mm border"));
}
if (handle != "none") {
    echo(str("Handle: ", handle, " (", handle_mount, " mount)"));
    if (handle_mount == "socket") {
        echo(str("Socket: ", socket_diameter, "mm dia x ", socket_depth, "mm deep"));
    }
}
if (add_text) {
    echo(str("Text: ", stamp_text, " (offset: ", text_offset_y, "mm)"));
}
echo("========================================");

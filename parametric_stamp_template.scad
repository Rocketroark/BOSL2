/*
 * Parametric Stamp - Quick Start Template
 * Version: 1.0.0
 *
 * Simplified template for quick stamp creation
 * Upload your image and adjust basic settings
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

/* [Optional Text] */

// Add text to stamp
add_text = false;

// Your text
stamp_text = "APPROVED"; // text

// Text size (mm)
text_size = 6; // [3:0.5:15]

/* [Advanced] */

// Stamp depth (mm)
depth = 5; // [3:0.5:10]

// Image relief depth (mm)
relief = 1.5; // [0.5:0.1:5]

// Handle height (mm)
handle_height = 25; // [10:1:50]

// ===========================
// Main Model
// ===========================

$fn = 100;

union() {
    // Stamp base
    difference() {
        // Base shape
        cuboid([width, height, depth], rounding=2, edges="Z", anchor=BOTTOM);

        // Image
        translate([0, 0, -depth/2 + relief/2])
            mirror([1, 0, 0])
                load_image();

        // Text
        if (add_text && stamp_text != "") {
            translate([0, -height/2 + text_size/2 + 2, -depth/2 + 0.4])
                mirror([1, 0, 0])
                    linear_extrude(height=0.8, center=true)
                        text(stamp_text, size=text_size,
                             font="Liberation Sans:style=Bold",
                             halign="center", valign="center");
        }
    }

    // Handle
    if (handle != "none") {
        translate([0, 0, depth/2])
            create_handle();
    }
}

// ===========================
// Modules
// ===========================

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
echo("Parametric Stamp - Quick Start Template");
echo("========================================");
echo("1. Upload your image file");
echo("2. Adjust width and height");
echo("3. Choose a handle style");
echo("4. Optional: Add text");
echo("5. Export STL for 3D printing");
echo("========================================");
echo(str("Current size: ", width, "mm x ", height, "mm"));
echo(str("Handle: ", handle));
if (add_text) {
    echo(str("Text: ", stamp_text));
}
echo("========================================");

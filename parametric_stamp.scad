/*
 * Parametric Stamp Generator
 * Version: 1.0.0
 *
 * A customizable 3D printable stamp with:
 * - Variable stamp size (width, height, depth)
 * - Custom image upload (SVG, PNG, STL)
 * - Multiple handle styles
 * - Text/script engraving options
 * - Multiple stamp shapes
 *
 * Based on BOSL2 library examples
 * Author: Claude Code
 * License: CC-BY-4.0
 */

// Include BOSL2 library for advanced geometry functions
include <BOSL2/std.scad>

/* [Basic Stamp Parameters] */

// Stamp shape
stamp_shape = "rectangle"; // [rectangle, circle, oval, square]

// Stamp width (mm)
stamp_width = 40; // [20:1:100]

// Stamp height (mm)
stamp_height = 30; // [20:1:100]

// Stamp depth/thickness (mm)
stamp_depth = 5; // [3:0.5:10]

// Corner radius for rounded shapes (mm)
corner_radius = 2; // [0:0.5:10]

/* [Image Settings] */

// Image type to use
image_type = "svg"; // [none, svg, png, stl]

// SVG image file (click to upload)
svg_file = "default.svg"; // file

// PNG image file (click to upload)
png_file = "default.png"; // file

// STL image file (click to upload)
stl_file = "default.stl"; // file

// Image width (mm)
image_width = 35; // [10:1:90]

// Image height (mm)
image_height = 25; // [10:1:90]

// Image relief depth (mm)
image_depth = 1.5; // [0.5:0.1:5]

// Image mode
image_mode = "deboss"; // [emboss, deboss]

// Center image on stamp
center_image = true;

// Image X offset (when not centered)
image_offset_x = 0; // [-50:1:50]

// Image Y offset (when not centered)
image_offset_y = 0; // [-50:1:50]

// Flip image horizontally (mirror for stamping)
mirror_image = true;

/* [Handle Settings] */

// Enable handle
enable_handle = true;

// Handle style
handle_style = "cylindrical"; // [cylindrical, rectangular, knob, ergonomic, none]

// Handle height (mm)
handle_height = 25; // [10:1:50]

// Handle diameter/width (mm)
handle_diameter = 25; // [15:1:40]

// Handle grip style
grip_style = "smooth"; // [smooth, ridged, knurled]

// Number of grip ridges (for ridged style)
grip_ridges = 8; // [4:1:20]

// Ridge depth (mm)
ridge_depth = 0.5; // [0.2:0.1:2]

/* [Text/Script Options] */

// Enable text
enable_text = false;

// Text content
text_content = "CUSTOM"; // text

// Text font
text_font = "Liberation Sans:style=Bold"; // text

// Text size (mm)
text_size = 6; // [3:0.5:20]

// Text depth (mm)
text_depth = 0.8; // [0.3:0.1:3]

// Text position
text_position = "bottom"; // [top, bottom, center, custom]

// Text X offset (for custom position)
text_offset_x = 0; // [-50:1:50]

// Text Y offset (for custom position)
text_offset_y = -10; // [-50:1:50]

// Text mode
text_mode = "deboss"; // [emboss, deboss]

/* [Advanced Options] */

// Circle quality (higher = smoother but slower)
circle_quality = 100; // [20:10:200]

// Show stamp preview
show_stamp = true;

// Show handle preview
show_handle = true;

// Render quality
render_quality = "medium"; // [low, medium, high]

// ===========================
// Main Assembly
// ===========================

$fn = circle_quality;

if (show_stamp || show_handle) {
    complete_stamp();
}

// ===========================
// Modules
// ===========================

module complete_stamp() {
    union() {
        // Stamp base
        if (show_stamp) {
            stamp_base();
        }

        // Handle
        if (show_handle && enable_handle && handle_style != "none") {
            translate([0, 0, stamp_depth/2])
                stamp_handle();
        }
    }
}

module stamp_base() {
    difference() {
        // Create the base stamp shape
        stamp_body();

        // Apply image
        if (image_type != "none") {
            apply_image();
        }

        // Apply text
        if (enable_text && text_content != "") {
            apply_text();
        }
    }
}

module stamp_body() {
    if (stamp_shape == "rectangle") {
        cuboid([stamp_width, stamp_height, stamp_depth],
               rounding=corner_radius,
               edges="Z",
               anchor=BOTTOM);
    }
    else if (stamp_shape == "square") {
        size = max(stamp_width, stamp_height);
        cuboid([size, size, stamp_depth],
               rounding=corner_radius,
               edges="Z",
               anchor=BOTTOM);
    }
    else if (stamp_shape == "circle") {
        diameter = max(stamp_width, stamp_height);
        cyl(d=diameter, h=stamp_depth,
            rounding2=corner_radius,
            anchor=BOTTOM);
    }
    else if (stamp_shape == "oval") {
        linear_extrude(height=stamp_depth, center=false, convexity=10)
            round2d(r=corner_radius)
                scale([stamp_width/stamp_height, 1])
                    circle(d=stamp_height);
    }
}

module apply_image() {
    // Calculate position
    x_pos = center_image ? 0 : image_offset_x;
    y_pos = center_image ? 0 : image_offset_y;

    // Position for deboss/emboss
    z_pos = (image_mode == "deboss") ? -stamp_depth/2 + image_depth/2 : stamp_depth/2 + image_depth/2;

    translate([x_pos, y_pos, z_pos]) {
        if (mirror_image) {
            mirror([1, 0, 0])
                image_loader(image_type, svg_file, png_file, stl_file,
                           image_width, image_height, image_depth);
        } else {
            image_loader(image_type, svg_file, png_file, stl_file,
                       image_width, image_height, image_depth);
        }
    }
}

module image_loader(fileType, svgFile, pngFile, stlFile, imgWidth, imgHeight, imgDepth) {
    if(fileType == "svg") {
        if (svgFile != "default.svg") {
            resize([imgWidth, imgHeight, imgDepth], auto=true)
                linear_extrude(height = imgDepth, center = true, convexity=10)
                    import(file = svgFile, center = true);
        } else {
            // Default placeholder
            cube([imgWidth, imgHeight, imgDepth], center=true);
        }
    }
    else if(fileType == "png") {
        if (pngFile != "default.png") {
            resize([imgWidth, imgHeight, imgDepth], auto=true)
                linear_extrude(height = imgDepth, center = true, convexity=10)
                    surface(file = pngFile, center = true, invert = true);
        } else {
            cube([imgWidth, imgHeight, imgDepth], center=true);
        }
    }
    else if(fileType == "stl") {
        if (stlFile != "default.stl") {
            resize([imgWidth, imgHeight, imgDepth], auto=true)
                import(file = stlFile, center = true);
        } else {
            cube([imgWidth, imgHeight, imgDepth], center=true);
        }
    }
}

module apply_text() {
    // Calculate text position
    x_pos = (text_position == "custom") ? text_offset_x : 0;

    y_pos = 0;
    if (text_position == "top") {
        y_pos = stamp_height/2 - text_size/2 - 2;
    } else if (text_position == "bottom") {
        y_pos = -stamp_height/2 + text_size/2 + 2;
    } else if (text_position == "center") {
        y_pos = 0;
    } else {
        y_pos = text_offset_y;
    }

    z_pos = (text_mode == "deboss") ? -stamp_depth/2 + text_depth/2 : stamp_depth/2 + text_depth/2;

    translate([x_pos, y_pos, z_pos])
        mirror([1, 0, 0])  // Mirror text for proper stamping
            linear_extrude(height=text_depth, center=true, convexity=10)
                text(text_content, size=text_size, font=text_font,
                     halign="center", valign="center");
}

module stamp_handle() {
    if (handle_style == "cylindrical") {
        cylindrical_handle();
    }
    else if (handle_style == "rectangular") {
        rectangular_handle();
    }
    else if (handle_style == "knob") {
        knob_handle();
    }
    else if (handle_style == "ergonomic") {
        ergonomic_handle();
    }
}

module cylindrical_handle() {
    difference() {
        union() {
            // Main cylinder
            cyl(d=handle_diameter, h=handle_height, anchor=BOTTOM);

            // Top dome for comfort
            translate([0, 0, handle_height])
                sphere(d=handle_diameter, $fn=circle_quality);
        }

        // Apply grip pattern
        if (grip_style == "ridged") {
            ridged_grip_cutout();
        } else if (grip_style == "knurled") {
            knurled_grip_cutout();
        }
    }
}

module rectangular_handle() {
    difference() {
        union() {
            // Main rectangular body
            cuboid([handle_diameter, handle_diameter, handle_height],
                   rounding=2, edges="Z", anchor=BOTTOM);

            // Top rounded cap
            translate([0, 0, handle_height])
                cuboid([handle_diameter, handle_diameter, handle_diameter/2],
                       rounding=handle_diameter/4, anchor=BOTTOM);
        }

        // Apply grip pattern
        if (grip_style == "ridged") {
            ridged_grip_cutout();
        }
    }
}

module knob_handle() {
    // Simple knob style
    hull() {
        // Bottom connection
        cyl(d=handle_diameter*0.7, h=2, anchor=BOTTOM);

        // Top knob
        translate([0, 0, handle_height*0.6])
            sphere(d=handle_diameter, $fn=circle_quality);
    }
}

module ergonomic_handle() {
    // Ergonomic tapered handle
    difference() {
        union() {
            // Tapered body
            hull() {
                cyl(d=handle_diameter*0.8, h=1, anchor=BOTTOM);
                translate([0, 0, handle_height*0.6])
                    cyl(d=handle_diameter, h=1, anchor=BOTTOM);
            }

            // Top sphere
            translate([0, 0, handle_height*0.6])
                sphere(d=handle_diameter, $fn=circle_quality);
        }

        // Finger grooves
        if (grip_style == "ridged") {
            for (i = [0:2]) {
                translate([0, 0, handle_height*0.2 + i*handle_height*0.15])
                    rotate_extrude(angle=360, convexity=10)
                        translate([handle_diameter/2, 0, 0])
                            circle(r=ridge_depth*2, $fn=30);
            }
        }
    }
}

module ridged_grip_cutout() {
    for (i = [0:grip_ridges-1]) {
        rotate([0, 0, i*(360/grip_ridges)])
            translate([handle_diameter/2 - ridge_depth/2, 0, handle_height/2])
                cube([ridge_depth*2, 1, handle_height*0.8], center=true);
    }
}

module knurled_grip_cutout() {
    // Diamond knurl pattern
    for (i = [0:grip_ridges*2-1]) {
        for (j = [0:floor(handle_height/3)]) {
            rotate([0, 0, i*(360/(grip_ridges*2)) + (j%2)*10])
                translate([handle_diameter/2 - ridge_depth/2, 0, j*3])
                    cube([ridge_depth*2, 0.8, 2], center=true);
        }
    }
}

// ===========================
// Helper Functions
// ===========================

// Preview message
echo("=================================");
echo("Parametric Stamp Generator v1.0.0");
echo("=================================");
echo(str("Stamp shape: ", stamp_shape));
echo(str("Stamp size: ", stamp_width, "mm x ", stamp_height, "mm x ", stamp_depth, "mm"));
echo(str("Handle: ", handle_style, " (", enable_handle ? "enabled" : "disabled", ")"));
echo(str("Image type: ", image_type));
echo(str("Text: ", enable_text ? text_content : "none"));
echo("=================================");

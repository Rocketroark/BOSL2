/*
 * Parametric Stamp Generator
 * Version: 1.3.0
 *
 * A customizable 3D printable stamp with:
 * - Variable stamp size (width, height, depth)
 * - Custom image upload (SVG, PNG, STL)
 * - Multiple handle styles
 * - Multiline text with customizable spacing and alignment
 * - Decorative border/stroke options
 * - Multiple stamp shapes
 * - Recessed face with raised border (prevents ink overflow)
 * - Separate handle printing with socket mount system
 *
 * Based on BOSL2 library examples
 * Author: Claude Code
 * License: CC-BY-4.0
 */

// Include BOSL2 library for advanced geometry functions
include <BOSL2/std.scad>
include <BOSL2/beziers.scad>

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

/* [Face Recess Settings] */

// Enable recessed stamp face (prevents ink overflow)
enable_face_recess = true;

// Face recess depth (how far to lower center, mm)
face_recess_depth = 1.0; // [0.3:0.1:3]

// Border width (raised edge around stamp, mm)
border_width = 3; // [1:0.5:10]

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

// Handle mounting type
handle_mount = "socket"; // [integrated, socket]

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

// Socket depth (for separate handle, mm)
socket_depth = 8; // [2:0.5:15]

// Socket diameter (for separate handle, mm)
socket_diameter = 12; // [8:0.5:20]

// Socket clearance (extra space for fit, mm)
socket_clearance = 0.2; // [0:0.05:0.5]

/* [Text/Script Options] */

// Enable text
enable_text = false;

// Text content (use "/" for line breaks)
text_content = "CUSTOM"; // text

// Text font
text_font = "Liberation Sans:style=Bold"; // text

// Text size (mm)
text_size = 6; // [3:0.5:20]

// Text depth (mm)
text_depth = 0.8; // [0.3:0.1:3]

// Line spacing (for multiline text)
line_spacing = 1.2; // [0.8:0.1:2]

// Text alignment (for multiline)
text_halign = "center"; // [left, center, right]

// Text position
text_position = "bottom"; // [top, bottom, center, custom]

// Text X offset (for custom position)
text_offset_x = 0; // [-50:1:50]

// Text Y offset (for custom position)
text_offset_y = -10; // [-50:1:50]

// Text mode
text_mode = "deboss"; // [emboss, deboss]

/* [Border/Stroke Options] */

// Enable decorative border
enable_border = false;

// Border width (mm)
border_stroke_width = 1.0; // [0.5:0.1:3]

// Border inset from edge (mm)
border_inset = 2; // [1:0.5:10]

// Border depth (mm)
border_depth = 0.8; // [0.3:0.1:3]

/* [Advanced Options] */

// What to render
render_part = "both"; // [both, stamp_only, handle_only]

// Circle quality (higher = smoother but slower)
circle_quality = 100; // [20:10:200]

// Render quality
render_quality = "medium"; // [low, medium, high]

// ===========================
// Main Assembly
// ===========================

$fn = circle_quality;

if (render_part == "both") {
    complete_stamp();
} else if (render_part == "stamp_only") {
    stamp_assembly();
} else if (render_part == "handle_only") {
    if (enable_handle && handle_style != "none") {
        separate_handle();
    }
}

// ===========================
// Modules
// ===========================

module complete_stamp() {
    if (handle_mount == "integrated") {
        // Traditional: stamp and handle printed together
        union() {
            stamp_assembly();

            if (enable_handle && handle_style != "none") {
                translate([0, 0, stamp_depth/2])
                    stamp_handle();
            }
        }
    } else {
        // Socket mount: show stamp with socket, handle separate
        stamp_assembly();
    }
}

module stamp_assembly() {
    difference() {
        // Stamp with raised elements
        stamp_base();

        // Add socket hole if using socket mount
        if (enable_handle && handle_style != "none" && handle_mount == "socket") {
            translate([0, 0, stamp_depth])
                cyl(d=socket_diameter + socket_clearance,
                    h=socket_depth,
                    anchor=TOP);
        }
    }
}

module stamp_base() {
    if (enable_face_recess) {
        // With recessed face: add raised image/text elements
        union() {
            stamp_body();

            // Add raised image elements
            if (image_type != "none") {
                apply_image_raised();
            }

            // Add raised text elements
            if (enable_text && text_content != "") {
                apply_text_raised();
            }

            // Add raised border
            if (enable_border) {
                apply_border_raised();
            }
        }
    } else {
        // Without recess: use traditional subtract method
        difference() {
            stamp_body();

            // Subtract image
            if (image_type != "none") {
                apply_image();
            }

            // Subtract text
            if (enable_text && text_content != "") {
                apply_text();
            }

            // Subtract border
            if (enable_border) {
                apply_border();
            }
        }
    }
}

module stamp_body() {
    difference() {
        // Main stamp body
        create_stamp_shape(stamp_width, stamp_height, stamp_depth);

        // Create recessed face if enabled
        if (enable_face_recess) {
            // Calculate inset dimensions
            inset_amount = border_width * 2;
            inset_width = stamp_width - inset_amount;
            inset_height = stamp_height - inset_amount;

            // Only create recess if there's room for it
            if (inset_width > 0 && inset_height > 0) {
                translate([0, 0, face_recess_depth])
                    create_stamp_shape(inset_width, inset_height, stamp_depth);
            }
        }
    }
}

module create_stamp_shape(width, height, depth) {
    if (stamp_shape == "rectangle") {
        cuboid([width, height, depth],
               rounding=corner_radius,
               edges="Z",
               anchor=BOTTOM);
    }
    else if (stamp_shape == "square") {
        size = max(width, height);
        cuboid([size, size, depth],
               rounding=corner_radius,
               edges="Z",
               anchor=BOTTOM);
    }
    else if (stamp_shape == "circle") {
        diameter = max(width, height);
        cyl(d=diameter, h=depth,
            rounding2=corner_radius,
            anchor=BOTTOM);
    }
    else if (stamp_shape == "oval") {
        linear_extrude(height=depth, center=false, convexity=10)
            round2d(r=corner_radius)
                scale([width/height, 1])
                    circle(d=height);
    }
}

module apply_image() {
    // Calculate position
    x_pos = center_image ? 0 : image_offset_x;
    y_pos = center_image ? 0 : image_offset_y;

    // Position for deboss/emboss (traditional mode without recess)
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

module apply_image_raised() {
    // Calculate position
    x_pos = center_image ? 0 : image_offset_x;
    y_pos = center_image ? 0 : image_offset_y;

    // Position raised from recessed face
    // Image sits on the recessed face and extends upward
    z_pos = face_recess_depth + image_depth/2;

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
    // Split text into lines
    lines = split_text(text_content);
    line_height = text_size * line_spacing;
    total_height = len(lines) * line_height;

    // Calculate base text position
    base_y = 0;
    if (text_position == "top") {
        base_y = stamp_height/2 - total_height/2 - 2;
    } else if (text_position == "bottom") {
        base_y = -stamp_height/2 + total_height/2 + 2;
    } else if (text_position == "center") {
        base_y = 0;
    } else {
        // Custom position - use offset directly as position
        base_y = 0;
    }

    // Apply offsets (always applied for fine-tuning)
    x_pos = text_offset_x;
    y_pos = base_y + text_offset_y;

    // Traditional positioning (without recess)
    z_pos = (text_mode == "deboss") ? -stamp_depth/2 + text_depth/2 : stamp_depth/2 + text_depth/2;

    translate([x_pos, y_pos, z_pos])
        mirror([1, 0, 0])  // Mirror text for proper stamping
            linear_extrude(height=text_depth, center=true, convexity=10)
                render_text_lines(lines, text_size, line_height, text_font, text_halign);
}

module apply_text_raised() {
    // Split text into lines
    lines = split_text(text_content);
    line_height = text_size * line_spacing;
    total_height = len(lines) * line_height;

    // Calculate base text position
    base_y = 0;
    if (text_position == "top") {
        base_y = stamp_height/2 - total_height/2 - 2;
    } else if (text_position == "bottom") {
        base_y = -stamp_height/2 + total_height/2 + 2;
    } else if (text_position == "center") {
        base_y = 0;
    } else {
        // Custom position - use offset directly as position
        base_y = 0;
    }

    // Apply offsets (always applied for fine-tuning)
    x_pos = text_offset_x;
    y_pos = base_y + text_offset_y;

    // Position raised from recessed face
    z_pos = face_recess_depth + text_depth/2;

    translate([x_pos, y_pos, z_pos])
        mirror([1, 0, 0])  // Mirror text for proper stamping
            linear_extrude(height=text_depth, center=true, convexity=10)
                render_text_lines(lines, text_size, line_height, text_font, text_halign);
}

module apply_border() {
    // Position for deboss/emboss
    z_pos = (text_mode == "deboss") ? -stamp_depth/2 + border_depth/2 : stamp_depth/2 + border_depth/2;

    translate([0, 0, z_pos])
        linear_extrude(height=border_depth, center=true, convexity=10)
            create_border_shape(stamp_width, stamp_height, stamp_shape, corner_radius, border_inset, border_stroke_width);
}

module apply_border_raised() {
    // Position raised from recessed face
    z_pos = face_recess_depth + border_depth/2;

    translate([0, 0, z_pos])
        linear_extrude(height=border_depth, center=true, convexity=10)
            create_border_shape(stamp_width, stamp_height, stamp_shape, corner_radius, border_inset, border_stroke_width);
}

// Create border shape for different stamp shapes
module create_border_shape(width, height, shape, radius, inset, stroke_width) {
    w = width - inset * 2;
    h = height - inset * 2;

    if (shape == "rectangle" || shape == "square") {
        difference() {
            offset(r=stroke_width/2)
                rect([w, h], rounding=max(0, radius - inset));
            offset(r=-stroke_width/2)
                rect([w, h], rounding=max(0, radius - inset));
        }
    } else if (shape == "circle") {
        difference() {
            circle(d=max(w, h) + stroke_width);
            circle(d=max(w, h) - stroke_width);
        }
    } else if (shape == "oval") {
        difference() {
            scale([w/h, 1]) circle(d=h + stroke_width);
            scale([w/h, 1]) circle(d=h - stroke_width);
        }
    } else {
        // fallback rectangle
        difference() {
            offset(r=stroke_width/2) rect([w, h]);
            offset(r=-stroke_width/2) rect([w, h]);
        }
    }
}

module separate_handle() {
    // Render handle with mounting peg for socket mount
    union() {
        // Main handle body
        stamp_handle();

        // Add mounting peg if using socket mount
        if (handle_mount == "socket") {
            translate([0, 0, -socket_depth/2])
                cyl(d=socket_diameter,
                    h=socket_depth,
                    anchor=TOP,
                    chamfer2=0.5);
        }
    }
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

// Split text by "/" into lines
function split_text(txt) =
    search("/", txt) == [] ? [txt] : str_split(txt, "/");

// Render multiple lines of text
module render_text_lines(lines, size, line_height, font, halign) {
    total_lines = len(lines);
    start_y = (total_lines - 1) * line_height / 2;

    for (i = [0:total_lines-1]) {
        translate([0, start_y - i * line_height, 0])
            text(lines[i], size=size, font=font,
                 halign=halign, valign="center");
    }
}

// Preview message
echo("=================================");
echo("Parametric Stamp Generator v1.3.0");
echo("=================================");
echo(str("Rendering: ", render_part));
echo(str("Stamp shape: ", stamp_shape));
echo(str("Stamp size: ", stamp_width, "mm x ", stamp_height, "mm x ", stamp_depth, "mm"));
if (enable_face_recess) {
    echo(str("Face recess: ", face_recess_depth, "mm with ", border_width, "mm border"));
}
if (enable_handle && handle_style != "none") {
    echo(str("Handle: ", handle_style, " (", handle_mount, " mount)"));
    if (handle_mount == "socket") {
        echo(str("Socket: ", socket_diameter, "mm dia x ", socket_depth, "mm deep"));
    }
}
echo(str("Image type: ", image_type));
if (enable_text) {
    text_lines = split_text(text_content);
    echo(str("Text: ", len(text_lines), " line(s) - ", text_halign, " aligned"));
}
if (enable_border) {
    echo(str("Border: ", border_stroke_width, "mm width, ", border_inset, "mm inset"));
}
echo("=================================");

/*
 * Parametric Cake Topper Generator
 * Version: 1.0.0
 *
 * A customizable 3D printable cake topper with:
 * - Custom text with multiple fonts and sizes
 * - Multiline text support (use "/" for line breaks)
 * - Multiple topper styles (script, block, heart, banner, oval)
 * - Various attachment methods (sticks, stakes, posts, base, clip)
 * - Decorative elements and borders
 *
 * Based on BOSL2 library
 * Author: Claude Code
 * License: CC-BY-4.0
 */

// Include BOSL2 library for advanced geometry functions
include <BOSL2/std.scad>

/* [Text Settings] */

// Main text content (use "/" for line breaks)
text_content = "Happy Birthday"; // text

// Text font (use OpenSCAD font format)
text_font = "Liberation Sans:style=Bold"; // text

// Text size (mm)
text_size = 12; // [5:0.5:40]

// Text thickness/depth (mm)
text_thickness = 3; // [1:0.5:10]

// Line spacing multiplier (for multiline text)
line_spacing = 1.3; // [0.8:0.1:2.5]

// Text alignment
text_alignment = "center"; // [left, center, right]

// Letter spacing adjustment
letter_spacing = 1.0; // [0.5:0.05:2]

/* [Topper Style] */

// Topper style
topper_style = "script"; // [script, block, heart, banner, oval, rectangular]

// Enable backing plate (for block styles)
enable_backing = false;

// Backing plate margin around text (mm)
backing_margin = 5; // [2:0.5:20]

// Backing plate thickness (mm)
backing_thickness = 2; // [1:0.5:5]

// Backing plate corner radius (mm)
backing_corner_radius = 3; // [0:0.5:15]

// Heart/oval width (mm, for shaped styles)
shape_width = 80; // [30:1:200]

// Heart/oval height (mm, for shaped styles)
shape_height = 60; // [30:1:150]

/* [Decorative Options] */

// Enable decorative border
enable_border = false;

// Border style
border_style = "simple"; // [simple, double, dotted, wavy]

// Border width (mm)
border_width = 1.5; // [0.5:0.1:5]

// Border offset from edge (mm)
border_offset = 2; // [1:0.5:10]

// Enable decorative elements
enable_decorations = false;

// Decoration type
decoration_type = "hearts"; // [hearts, stars, dots, none]

// Number of decorations
decoration_count = 5; // [2:1:20]

// Decoration size (mm)
decoration_size = 4; // [2:0.5:15]

/* [Attachment Settings] */

// Attachment type
attachment_type = "sticks"; // [sticks, stake, single_post, flat_base, clip, none]

// Number of sticks/stakes
stick_count = 2; // [1:1:5]

// Stick/stake length (mm)
stick_length = 80; // [30:5:150]

// Stick/stake diameter (mm)
stick_diameter = 3; // [2:0.5:8]

// Stick spacing (mm, for multiple sticks)
stick_spacing = 40; // [10:5:100]

// Stick taper (pointed end)
stick_taper = true;

// Taper length (mm)
taper_length = 15; // [5:1:30]

// Post/stake base plate diameter (mm)
base_diameter = 20; // [10:1:50]

// Base plate thickness (mm)
base_thickness = 3; // [1:0.5:8]

// Clip opening width (mm)
clip_opening = 8; // [3:0.5:20]

// Clip depth (mm)
clip_depth = 15; // [5:1:30]

/* [Advanced Options] */

// What to render
render_part = "complete"; // [complete, topper_only, attachment_only]

// Horizontal offset for text on topper (mm)
text_offset_x = 0; // [-50:1:50]

// Vertical offset for text on topper (mm)
text_offset_y = 0; // [-50:1:50]

// Rotate topper (degrees)
topper_rotation = 0; // [-45:5:45]

// Circle/curve quality (higher = smoother)
circle_quality = 80; // [20:10:200]

// Enable preview colors
enable_colors = true;

// ===========================
// Main Assembly
// ===========================

$fn = circle_quality;

// Main render logic
if (render_part == "complete") {
    complete_topper();
} else if (render_part == "topper_only") {
    topper_assembly();
} else if (render_part == "attachment_only") {
    attachment_assembly();
}

// ===========================
// Core Modules
// ===========================

module complete_topper() {
    union() {
        // Main topper with text
        topper_assembly();

        // Attachment mechanism
        if (attachment_type != "none") {
            attachment_assembly();
        }
    }
}

module topper_assembly() {
    rotate([0, 0, topper_rotation]) {
        if (topper_style == "script") {
            script_topper();
        } else if (topper_style == "block") {
            block_topper();
        } else if (topper_style == "heart") {
            heart_topper();
        } else if (topper_style == "banner") {
            banner_topper();
        } else if (topper_style == "oval") {
            oval_topper();
        } else if (topper_style == "rectangular") {
            rectangular_topper();
        }
    }
}

module attachment_assembly() {
    if (attachment_type == "sticks") {
        stick_attachment();
    } else if (attachment_type == "stake") {
        stake_attachment();
    } else if (attachment_type == "single_post") {
        single_post_attachment();
    } else if (attachment_type == "flat_base") {
        flat_base_attachment();
    } else if (attachment_type == "clip") {
        clip_attachment();
    }
}

// ===========================
// Topper Style Modules
// ===========================

module script_topper() {
    // Pure text topper - text stands alone
    color_part("topper") {
        translate([text_offset_x, text_offset_y, 0])
            linear_extrude(height=text_thickness, convexity=10)
                render_multiline_text();
    }
}

module block_topper() {
    // Text with optional backing plate
    union() {
        // Backing plate if enabled
        if (enable_backing) {
            color_part("backing") {
                backing_plate();
            }
        }

        // Raised text on top of backing
        color_part("topper") {
            translate([text_offset_x, text_offset_y, enable_backing ? backing_thickness : 0])
                linear_extrude(height=text_thickness, convexity=10)
                    render_multiline_text();
        }

        // Optional border
        if (enable_border && enable_backing) {
            color_part("decoration") {
                translate([0, 0, backing_thickness])
                    decorative_border();
            }
        }

        // Optional decorations
        if (enable_decorations && enable_backing) {
            color_part("decoration") {
                translate([0, 0, backing_thickness])
                    apply_decorations();
            }
        }
    }
}

module heart_topper() {
    // Heart-shaped backing with text
    union() {
        // Heart backing
        color_part("backing") {
            linear_extrude(height=backing_thickness, convexity=10)
                heart_shape(shape_width, shape_height);
        }

        // Text on heart
        color_part("topper") {
            translate([text_offset_x, text_offset_y - shape_height * 0.1, backing_thickness])
                linear_extrude(height=text_thickness, convexity=10)
                    render_multiline_text();
        }

        // Border
        if (enable_border) {
            color_part("decoration") {
                translate([0, 0, backing_thickness])
                    linear_extrude(height=text_thickness * 0.5, convexity=10)
                        heart_border();
            }
        }
    }
}

module banner_topper() {
    // Ribbon/banner shaped backing with text
    union() {
        // Banner backing
        color_part("backing") {
            banner_shape();
        }

        // Text on banner
        color_part("topper") {
            translate([text_offset_x, text_offset_y, backing_thickness])
                linear_extrude(height=text_thickness, convexity=10)
                    render_multiline_text();
        }
    }
}

module oval_topper() {
    // Oval-shaped backing with text
    union() {
        // Oval backing
        color_part("backing") {
            linear_extrude(height=backing_thickness, convexity=10)
                scale([shape_width/shape_height, 1])
                    circle(d=shape_height);
        }

        // Text on oval
        color_part("topper") {
            translate([text_offset_x, text_offset_y, backing_thickness])
                linear_extrude(height=text_thickness, convexity=10)
                    render_multiline_text();
        }

        // Border
        if (enable_border) {
            color_part("decoration") {
                translate([0, 0, backing_thickness])
                    linear_extrude(height=text_thickness * 0.5, convexity=10)
                        difference() {
                            scale([shape_width/shape_height, 1])
                                circle(d=shape_height - border_offset);
                            scale([shape_width/shape_height, 1])
                                circle(d=shape_height - border_offset - border_width * 2);
                        }
            }
        }
    }
}

module rectangular_topper() {
    // Rectangular backing with rounded corners
    text_bounds = get_text_bounds();
    plate_width = text_bounds[0] + backing_margin * 2;
    plate_height = text_bounds[1] + backing_margin * 2;

    union() {
        // Rectangular backing
        color_part("backing") {
            linear_extrude(height=backing_thickness, convexity=10)
                rect([plate_width, plate_height], rounding=backing_corner_radius);
        }

        // Text
        color_part("topper") {
            translate([text_offset_x, text_offset_y, backing_thickness])
                linear_extrude(height=text_thickness, convexity=10)
                    render_multiline_text();
        }

        // Border
        if (enable_border) {
            color_part("decoration") {
                translate([0, 0, backing_thickness])
                    linear_extrude(height=text_thickness * 0.5, convexity=10)
                        difference() {
                            rect([plate_width - border_offset * 2, plate_height - border_offset * 2],
                                 rounding=max(0, backing_corner_radius - border_offset));
                            rect([plate_width - border_offset * 2 - border_width * 2,
                                  plate_height - border_offset * 2 - border_width * 2],
                                 rounding=max(0, backing_corner_radius - border_offset - border_width));
                        }
            }
        }

        // Decorations
        if (enable_decorations) {
            color_part("decoration") {
                translate([0, 0, backing_thickness])
                    apply_rectangular_decorations(plate_width, plate_height);
            }
        }
    }
}

// ===========================
// Attachment Modules
// ===========================

module stick_attachment() {
    // Multiple sticks for inserting into cake
    color_part("attachment") {
        for (i = [0:stick_count-1]) {
            x_offset = (i - (stick_count-1)/2) * stick_spacing;
            translate([x_offset, 0, -stick_length]) {
                if (stick_taper) {
                    tapered_stick();
                } else {
                    cyl(d=stick_diameter, h=stick_length, anchor=BOTTOM);
                }
            }
        }
    }
}

module tapered_stick() {
    // Stick with pointed end for easy insertion
    union() {
        // Main stick body
        cyl(d=stick_diameter, h=stick_length - taper_length, anchor=BOTTOM);

        // Tapered point
        translate([0, 0, 0])
            cyl(d1=0.5, d2=stick_diameter, h=taper_length, anchor=TOP);
    }
}

module stake_attachment() {
    // Wide stake-style attachment with base
    color_part("attachment") {
        // Base plate
        translate([0, 0, 0])
            cyl(d=base_diameter, h=base_thickness, anchor=TOP);

        // Stakes
        for (i = [0:stick_count-1]) {
            x_offset = (i - (stick_count-1)/2) * (base_diameter * 0.5);
            translate([x_offset, 0, -stick_length - base_thickness]) {
                if (stick_taper) {
                    tapered_stick();
                } else {
                    cyl(d=stick_diameter, h=stick_length, anchor=BOTTOM);
                }
            }
        }
    }
}

module single_post_attachment() {
    // Single central post
    color_part("attachment") {
        // Reinforced base
        hull() {
            translate([0, 0, 0])
                cyl(d=base_diameter, h=base_thickness, anchor=TOP);
            translate([0, 0, -base_thickness * 2])
                cyl(d=stick_diameter * 2, h=base_thickness, anchor=TOP);
        }

        // Main post
        translate([0, 0, -stick_length - base_thickness * 2]) {
            if (stick_taper) {
                union() {
                    cyl(d=stick_diameter * 1.5, h=stick_length - taper_length, anchor=BOTTOM);
                    translate([0, 0, 0])
                        cyl(d1=0.5, d2=stick_diameter * 1.5, h=taper_length, anchor=TOP);
                }
            } else {
                cyl(d=stick_diameter * 1.5, h=stick_length, anchor=BOTTOM);
            }
        }
    }
}

module flat_base_attachment() {
    // Flat base for sitting on top of cake (no insertion)
    text_bounds = get_text_bounds();
    base_width = max(text_bounds[0] + backing_margin * 4, base_diameter * 2);
    base_depth = base_diameter;

    color_part("attachment") {
        translate([0, -text_bounds[1]/2 - base_depth/2, 0]) {
            // Main base
            difference() {
                hull() {
                    translate([0, 0, -base_thickness/2])
                        cuboid([base_width, base_depth, base_thickness],
                               rounding=2, edges="Z", anchor=TOP);
                    translate([0, base_depth/4, 0])
                        cuboid([base_width * 0.8, base_depth/2, base_thickness/2],
                               rounding=1, anchor=TOP);
                }

                // Optional adhesive recess
                translate([0, 0, -base_thickness + 0.5])
                    cuboid([base_width * 0.6, base_depth * 0.6, 1], anchor=TOP);
            }
        }
    }
}

module clip_attachment() {
    // Clip for attaching to edge of cake
    text_bounds = get_text_bounds();
    clip_width = max(text_bounds[0] * 0.6, 30);
    wall_thickness = 2;

    color_part("attachment") {
        translate([0, -text_bounds[1]/2 - clip_depth/2 + wall_thickness, 0]) {
            difference() {
                // Outer clip body
                hull() {
                    translate([0, 0, 0])
                        cuboid([clip_width, wall_thickness * 2, base_thickness],
                               rounding=1, anchor=TOP);
                    translate([0, -clip_depth/2, -clip_opening - base_thickness])
                        cuboid([clip_width, clip_depth, wall_thickness],
                               rounding=1, anchor=TOP);
                }

                // Inner clip opening
                translate([0, -clip_depth/2 + wall_thickness, -base_thickness])
                    cuboid([clip_width - wall_thickness * 2, clip_depth, clip_opening + 1],
                           rounding=0.5, anchor=TOP);
            }

            // Grip ridges inside clip
            for (i = [0:2]) {
                translate([0, -wall_thickness - i * 3, -base_thickness - clip_opening/2])
                    rotate([0, 90, 0])
                        cyl(d=1, h=clip_width - wall_thickness * 4, $fn=20);
            }
        }
    }
}

// ===========================
// Shape Helper Modules
// ===========================

module heart_shape(w, h) {
    // Parametric heart shape
    scale([w/100, h/100]) {
        translate([0, -25, 0]) {
            union() {
                // Left lobe
                translate([-25, 35, 0])
                    circle(d=50, $fn=circle_quality);

                // Right lobe
                translate([25, 35, 0])
                    circle(d=50, $fn=circle_quality);

                // Bottom point
                polygon(points=[
                    [-50, 30],
                    [0, -40],
                    [50, 30]
                ]);
            }
        }
    }
}

module heart_border() {
    difference() {
        offset(r=-border_offset)
            heart_shape(shape_width, shape_height);
        offset(r=-border_offset - border_width)
            heart_shape(shape_width, shape_height);
    }
}

module banner_shape() {
    // Ribbon/banner shape
    text_bounds = get_text_bounds();
    banner_width = text_bounds[0] + backing_margin * 4;
    banner_height = text_bounds[1] + backing_margin * 2;
    ribbon_extend = banner_width * 0.15;
    ribbon_notch = banner_height * 0.3;

    linear_extrude(height=backing_thickness, convexity=10) {
        union() {
            // Main banner body
            rect([banner_width, banner_height], rounding=2);

            // Left ribbon tail
            translate([-banner_width/2 - ribbon_extend/2, 0, 0])
                polygon(points=[
                    [ribbon_extend/2, banner_height/2],
                    [-ribbon_extend/2, banner_height/2],
                    [-ribbon_extend/2, -banner_height/2],
                    [ribbon_extend/2, -banner_height/2],
                    [ribbon_extend/2 - ribbon_notch, 0]
                ]);

            // Right ribbon tail
            translate([banner_width/2 + ribbon_extend/2, 0, 0])
                polygon(points=[
                    [-ribbon_extend/2, banner_height/2],
                    [ribbon_extend/2, banner_height/2],
                    [ribbon_extend/2, -banner_height/2],
                    [-ribbon_extend/2, -banner_height/2],
                    [-ribbon_extend/2 + ribbon_notch, 0]
                ]);
        }
    }
}

module backing_plate() {
    // Generic backing plate sized to text
    text_bounds = get_text_bounds();
    plate_width = text_bounds[0] + backing_margin * 2;
    plate_height = text_bounds[1] + backing_margin * 2;

    linear_extrude(height=backing_thickness, convexity=10)
        rect([plate_width, plate_height], rounding=backing_corner_radius);
}

// ===========================
// Decoration Modules
// ===========================

module decorative_border() {
    text_bounds = get_text_bounds();
    plate_width = text_bounds[0] + backing_margin * 2;
    plate_height = text_bounds[1] + backing_margin * 2;

    if (border_style == "simple") {
        linear_extrude(height=text_thickness * 0.5, convexity=10)
            difference() {
                rect([plate_width - border_offset * 2, plate_height - border_offset * 2],
                     rounding=max(0, backing_corner_radius - border_offset));
                rect([plate_width - border_offset * 2 - border_width * 2,
                      plate_height - border_offset * 2 - border_width * 2],
                     rounding=max(0, backing_corner_radius - border_offset - border_width));
            }
    } else if (border_style == "double") {
        // Double line border
        for (offset_mult = [1, 2]) {
            linear_extrude(height=text_thickness * 0.5, convexity=10)
                difference() {
                    rect([plate_width - border_offset * 2 * offset_mult,
                          plate_height - border_offset * 2 * offset_mult],
                         rounding=max(0, backing_corner_radius - border_offset * offset_mult));
                    rect([plate_width - border_offset * 2 * offset_mult - border_width,
                          plate_height - border_offset * 2 * offset_mult - border_width],
                         rounding=max(0, backing_corner_radius - border_offset * offset_mult - border_width/2));
                }
        }
    } else if (border_style == "dotted") {
        // Dotted border
        dot_count = floor((plate_width + plate_height) * 2 / (border_width * 3));
        perimeter = (plate_width + plate_height) * 2;

        for (i = [0:dot_count-1]) {
            angle = i * 360 / dot_count;
            pos = get_rect_perimeter_point(plate_width - border_offset * 2,
                                           plate_height - border_offset * 2,
                                           i / dot_count);
            translate([pos[0], pos[1], 0])
                cyl(d=border_width, h=text_thickness * 0.5, anchor=BOTTOM);
        }
    }
}

module apply_decorations() {
    text_bounds = get_text_bounds();
    plate_width = text_bounds[0] + backing_margin * 2;

    // Place decorations along the top
    for (i = [0:decoration_count-1]) {
        x_pos = (i - (decoration_count-1)/2) * (plate_width / (decoration_count + 1));
        y_pos = text_bounds[1]/2 + backing_margin - decoration_size/2;

        translate([x_pos, y_pos, 0])
            decoration_element();
    }
}

module apply_rectangular_decorations(width, height) {
    // Corner decorations
    corners = [
        [width/2 - border_offset - decoration_size, height/2 - border_offset - decoration_size],
        [-width/2 + border_offset + decoration_size, height/2 - border_offset - decoration_size],
        [width/2 - border_offset - decoration_size, -height/2 + border_offset + decoration_size],
        [-width/2 + border_offset + decoration_size, -height/2 + border_offset + decoration_size]
    ];

    for (pos = corners) {
        translate([pos[0], pos[1], 0])
            decoration_element();
    }
}

module decoration_element() {
    if (decoration_type == "hearts") {
        linear_extrude(height=text_thickness * 0.6, convexity=10)
            heart_shape(decoration_size, decoration_size * 0.9);
    } else if (decoration_type == "stars") {
        linear_extrude(height=text_thickness * 0.6, convexity=10)
            star(n=5, r=decoration_size/2, ir=decoration_size/4);
    } else if (decoration_type == "dots") {
        cyl(d=decoration_size, h=text_thickness * 0.6, anchor=BOTTOM);
    }
}

// Simple star shape for decorations
module star(n, r, ir) {
    polygon([
        for (i = [0:2*n-1])
            let(angle = i * 180/n - 90,
                radius = i % 2 == 0 ? r : ir)
            [radius * cos(angle), radius * sin(angle)]
    ]);
}

// ===========================
// Text Rendering
// ===========================

module render_multiline_text() {
    lines = split_text(text_content);
    line_height = text_size * line_spacing;
    total_height = len(lines) * line_height;

    // Center the text block vertically
    start_y = (len(lines) - 1) * line_height / 2;

    for (i = [0:len(lines)-1]) {
        translate([0, start_y - i * line_height, 0])
            text(lines[i],
                 size=text_size,
                 font=text_font,
                 halign=text_alignment,
                 valign="center",
                 spacing=letter_spacing);
    }
}

// ===========================
// Helper Functions
// ===========================

// Split text by "/" into lines
function split_text(txt) =
    search("/", txt) == [] ? [txt] : str_split(txt, "/");

// Estimate text bounds (approximate)
function get_text_bounds() =
    let(
        lines = split_text(text_content),
        line_height = text_size * line_spacing,
        total_height = len(lines) * line_height,
        // Estimate width based on average character width (approximate)
        max_line_length = max([for (line = lines) len(line)]),
        estimated_width = max_line_length * text_size * 0.6 * letter_spacing
    )
    [estimated_width, total_height];

// Get point on rectangle perimeter (0-1 normalized position)
function get_rect_perimeter_point(w, h, t) =
    let(
        perimeter = 2 * (w + h),
        pos = t * perimeter,
        // Top edge
        top_end = w,
        // Right edge
        right_end = w + h,
        // Bottom edge
        bottom_end = 2 * w + h,
        // Left edge
        left_end = perimeter
    )
    pos < top_end ? [pos - w/2, h/2] :
    pos < right_end ? [w/2, h/2 - (pos - top_end)] :
    pos < bottom_end ? [w/2 - (pos - right_end), -h/2] :
    [-w/2, -h/2 + (pos - bottom_end)];

// Color helper for preview
module color_part(part_type) {
    if (enable_colors) {
        if (part_type == "topper") {
            color("Gold") children();
        } else if (part_type == "backing") {
            color("White") children();
        } else if (part_type == "attachment") {
            color("BurlyWood") children();
        } else if (part_type == "decoration") {
            color("Pink") children();
        } else {
            children();
        }
    } else {
        children();
    }
}

// ===========================
// Preview/Debug Information
// ===========================

echo("=====================================");
echo("Parametric Cake Topper Generator v1.0.0");
echo("=====================================");
echo(str("Rendering: ", render_part));
echo(str("Topper style: ", topper_style));
echo(str("Text: \"", text_content, "\""));
echo(str("Font: ", text_font));
echo(str("Text size: ", text_size, "mm"));
echo(str("Attachment: ", attachment_type));
if (attachment_type == "sticks" || attachment_type == "stake") {
    echo(str("  Sticks: ", stick_count, " x ", stick_diameter, "mm dia x ", stick_length, "mm long"));
    echo(str("  Spacing: ", stick_spacing, "mm"));
    echo(str("  Tapered: ", stick_taper));
}
if (enable_backing) {
    echo(str("Backing: ", backing_margin, "mm margin, ", backing_thickness, "mm thick"));
}
if (enable_border) {
    echo(str("Border: ", border_style, " style, ", border_width, "mm wide"));
}
if (enable_decorations) {
    echo(str("Decorations: ", decoration_count, " x ", decoration_type));
}
echo("=====================================");

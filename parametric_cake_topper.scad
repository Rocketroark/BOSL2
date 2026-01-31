/*
 * Parametric Cake Topper Generator
 * Version: 1.2.0
 *
 * A customizable 3D printable cake topper with:
 * - Custom text with multiple fonts and sizes
 * - Multiline text support (use "/" for line breaks)
 * - Multiple topper styles (script, block, heart, banner, oval)
 * - Simple attachment tabs (vertical or horizontal, 1-5mm)
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
border_style = "simple"; // [simple, double, dotted]

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

// Attachment orientation
attachment_type = "vertical"; // [vertical, horizontal, none]

// Number of tabs/extensions
tab_count = 2; // [1:1:5]

// Tab extension length (mm)
tab_length = 3; // [1:0.5:5]

/* [Advanced Options] */

// What to render
render_part = "complete"; // [complete, topper_only]

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
}

// ===========================
// Core Modules
// ===========================

module complete_topper() {
    // Topper with integrated attachment tabs
    topper_assembly();
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


// ===========================
// Topper Style Modules
// ===========================

module script_topper() {
    // Pure text topper with integrated attachment tabs
    text_bounds = get_text_bounds();

    color_part("topper") {
        translate([text_offset_x, text_offset_y, 0])
            linear_extrude(height=text_thickness, convexity=10) {
                union() {
                    // Main text
                    render_multiline_text();

                    // Integrated attachment tabs (same 2D shape, extruded together)
                    if (attachment_type == "vertical") {
                        for (i = [0:tab_count-1]) {
                            x_offset = (i - (tab_count-1)/2) * (text_bounds[0] / max(tab_count, 1));
                            // Tab extending down from bottom of text
                            translate([x_offset, -text_bounds[1]/2 - tab_length/2])
                                square([3, tab_length], center=true);
                        }
                    }
                }
            }

        // Horizontal tabs extend from the face (Z direction)
        if (attachment_type == "horizontal") {
            for (i = [0:tab_count-1]) {
                x_offset = (i - (tab_count-1)/2) * (text_bounds[0] / max(tab_count, 1));
                translate([x_offset, -text_bounds[1]/2 - 1.5, text_thickness])
                    cube([3, 3, tab_length]);
            }
        }
    }
}

module block_topper() {
    // Text with optional backing plate and integrated tabs
    text_bounds = get_text_bounds();

    union() {
        // Backing plate if enabled (with integrated tabs)
        if (enable_backing) {
            color_part("backing") {
                backing_plate_with_tabs();
            }
        }

        // Raised text on top of backing
        color_part("topper") {
            translate([text_offset_x, text_offset_y, enable_backing ? backing_thickness : 0])
                linear_extrude(height=text_thickness, convexity=10)
                    render_multiline_text();
        }

        // If no backing, add tabs directly to text
        if (!enable_backing && attachment_type != "none") {
            color_part("topper") {
                attachment_tabs(text_bounds);
            }
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
    // Heart-shaped backing with text and integrated tabs
    union() {
        // Heart backing with tabs
        color_part("backing") {
            linear_extrude(height=backing_thickness, convexity=10) {
                union() {
                    heart_shape(shape_width, shape_height);

                    // Vertical tabs at bottom of heart
                    if (attachment_type == "vertical") {
                        for (i = [0:tab_count-1]) {
                            x_offset = (i - (tab_count-1)/2) * (shape_width * 0.4 / max(tab_count, 1));
                            translate([x_offset, -shape_height * 0.65 - tab_length/2])
                                square([3, tab_length], center=true);
                        }
                    }
                }
            }

            // Horizontal tabs
            if (attachment_type == "horizontal") {
                for (i = [0:tab_count-1]) {
                    x_offset = (i - (tab_count-1)/2) * (shape_width * 0.4 / max(tab_count, 1));
                    translate([x_offset - 1.5, -shape_height * 0.65 - 1.5, backing_thickness])
                        cube([3, 3, tab_length]);
                }
            }
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
    // Ribbon/banner shaped backing with text and integrated tabs
    text_bounds = get_text_bounds();
    banner_height = text_bounds[1] + backing_margin * 2;

    union() {
        // Banner backing with tabs
        color_part("backing") {
            banner_shape_with_tabs();
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
    // Oval-shaped backing with text and integrated tabs
    union() {
        // Oval backing with tabs
        color_part("backing") {
            linear_extrude(height=backing_thickness, convexity=10) {
                union() {
                    scale([shape_width/shape_height, 1])
                        circle(d=shape_height);

                    // Vertical tabs
                    if (attachment_type == "vertical") {
                        for (i = [0:tab_count-1]) {
                            x_offset = (i - (tab_count-1)/2) * (shape_width * 0.5 / max(tab_count, 1));
                            translate([x_offset, -shape_height/2 - tab_length/2])
                                square([3, tab_length], center=true);
                        }
                    }
                }
            }

            // Horizontal tabs
            if (attachment_type == "horizontal") {
                for (i = [0:tab_count-1]) {
                    x_offset = (i - (tab_count-1)/2) * (shape_width * 0.5 / max(tab_count, 1));
                    translate([x_offset - 1.5, -shape_height/2 - 1.5, backing_thickness])
                        cube([3, 3, tab_length]);
                }
            }
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
    // Rectangular backing with rounded corners and integrated tabs
    text_bounds = get_text_bounds();
    plate_width = text_bounds[0] + backing_margin * 2;
    plate_height = text_bounds[1] + backing_margin * 2;

    union() {
        // Rectangular backing with tabs
        color_part("backing") {
            linear_extrude(height=backing_thickness, convexity=10) {
                union() {
                    rect([plate_width, plate_height], rounding=backing_corner_radius);

                    // Vertical tabs
                    if (attachment_type == "vertical") {
                        for (i = [0:tab_count-1]) {
                            x_offset = (i - (tab_count-1)/2) * (plate_width * 0.6 / max(tab_count, 1));
                            translate([x_offset, -plate_height/2 - tab_length/2])
                                square([3, tab_length], center=true);
                        }
                    }
                }
            }

            // Horizontal tabs
            if (attachment_type == "horizontal") {
                for (i = [0:tab_count-1]) {
                    x_offset = (i - (tab_count-1)/2) * (plate_width * 0.6 / max(tab_count, 1));
                    translate([x_offset - 1.5, -plate_height/2 - 1.5, backing_thickness])
                        cube([3, 3, tab_length]);
                }
            }
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
    // Ribbon/banner shape (2D)
    text_bounds = get_text_bounds();
    banner_width = text_bounds[0] + backing_margin * 4;
    banner_height = text_bounds[1] + backing_margin * 2;
    ribbon_extend = banner_width * 0.15;
    ribbon_notch = banner_height * 0.3;

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

module banner_shape_with_tabs() {
    // Ribbon/banner shape with integrated tabs
    text_bounds = get_text_bounds();
    banner_width = text_bounds[0] + backing_margin * 4;
    banner_height = text_bounds[1] + backing_margin * 2;

    linear_extrude(height=backing_thickness, convexity=10) {
        union() {
            banner_shape();

            // Vertical tabs
            if (attachment_type == "vertical") {
                for (i = [0:tab_count-1]) {
                    x_offset = (i - (tab_count-1)/2) * (banner_width * 0.5 / max(tab_count, 1));
                    translate([x_offset, -banner_height/2 - tab_length/2])
                        square([3, tab_length], center=true);
                }
            }
        }
    }

    // Horizontal tabs
    if (attachment_type == "horizontal") {
        for (i = [0:tab_count-1]) {
            x_offset = (i - (tab_count-1)/2) * (banner_width * 0.5 / max(tab_count, 1));
            translate([x_offset - 1.5, -banner_height/2 - 1.5, backing_thickness])
                cube([3, 3, tab_length]);
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

module backing_plate_with_tabs() {
    // Backing plate with integrated attachment tabs
    text_bounds = get_text_bounds();
    plate_width = text_bounds[0] + backing_margin * 2;
    plate_height = text_bounds[1] + backing_margin * 2;

    linear_extrude(height=backing_thickness, convexity=10) {
        union() {
            // Main plate
            rect([plate_width, plate_height], rounding=backing_corner_radius);

            // Vertical tabs
            if (attachment_type == "vertical") {
                for (i = [0:tab_count-1]) {
                    x_offset = (i - (tab_count-1)/2) * (plate_width * 0.6 / max(tab_count, 1));
                    translate([x_offset, -plate_height/2 - tab_length/2])
                        square([3, tab_length], center=true);
                }
            }
        }
    }

    // Horizontal tabs extend from face
    if (attachment_type == "horizontal") {
        for (i = [0:tab_count-1]) {
            x_offset = (i - (tab_count-1)/2) * (plate_width * 0.6 / max(tab_count, 1));
            translate([x_offset - 1.5, -plate_height/2 - 1.5, backing_thickness])
                cube([3, 3, tab_length]);
        }
    }
}

module attachment_tabs(bounds) {
    // Standalone attachment tabs for toppers without backing
    if (attachment_type == "vertical") {
        linear_extrude(height=text_thickness, convexity=10) {
            for (i = [0:tab_count-1]) {
                x_offset = (i - (tab_count-1)/2) * (bounds[0] * 0.6 / max(tab_count, 1));
                translate([x_offset, -bounds[1]/2 - tab_length/2])
                    square([3, tab_length], center=true);
            }
        }
    } else if (attachment_type == "horizontal") {
        for (i = [0:tab_count-1]) {
            x_offset = (i - (tab_count-1)/2) * (bounds[0] * 0.6 / max(tab_count, 1));
            translate([x_offset - 1.5, -bounds[1]/2 - 1.5, text_thickness])
                cube([3, 3, tab_length]);
        }
    }
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

        for (i = [0:dot_count-1]) {
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
        top_end = w,
        right_end = w + h,
        bottom_end = 2 * w + h
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
echo("Parametric Cake Topper Generator v1.2.0");
echo("=====================================");
echo(str("Rendering: ", render_part));
echo(str("Topper style: ", topper_style));
echo(str("Text: \"", text_content, "\""));
echo(str("Font: ", text_font));
echo(str("Text size: ", text_size, "mm"));
echo(str("Attachment: ", attachment_type));
if (attachment_type != "none") {
    echo(str("  Tabs: ", tab_count, " x ", tab_length, "mm long"));
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

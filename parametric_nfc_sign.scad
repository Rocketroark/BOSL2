/*
 * Parametric NFC Sign Generator
 *
 * Creates customizable signs with:
 * - 3D printed images (PNG/SVG support)
 * - Internal NFC tag housing
 * - Optional QR code integration
 * - Multiple shape options
 * - Configurable mounting options
 *
 * Version: 1.5.0
 * Author: Claude AI
 * Date: 2026-01-19
 * License: CC-BY-4.0
 */

include <BOSL2/std.scad>

/* [Basic Parameters] */
// Sign base color
sign_color = "#FFFFFF";  // color

// Shape of the sign
sign_shape = "rectangle"; // [rectangle, circle, oval, hexagon, octagon]

// Width of the sign in mm
sign_width = 80; // [30:5:200]

// Height of the sign in mm
sign_height = 80; // [30:5:200]

// Base thickness of sign (before NFC cavity)
sign_thickness = 3; // [2:0.5:10]

// Corner radius for rounded shapes
corner_radius = 3; // [0:0.5:15]

// For oval shape: width to height ratio
oval_ratio = 1.5; // [1:0.1:3]

/* [NFC Tag Housing] */
// Enable NFC tag cavity
enable_nfc = true;

// NFC tag diameter (NTAG216 standard is 25-26mm)
nfc_tag_diameter = 26; // [20:0.5:30]

// Depth of NFC tag recess
nfc_tag_depth = 1.25; // [0.5:0.1:3]

// Position NFC cavity on front or back
nfc_position = "back"; // [front, back, center]

// X offset of NFC tag from center
nfc_offset_x = 0; // [-50:1:50]

// Y offset of NFC tag from center
nfc_offset_y = 0; // [-50:1:50]

/* [Main Image - Front Side] */
// Image file type: svg (recommended), png, stl, or none
imageType = "svg"; // [none, svg, png, stl]

// SVG image file (click to upload)
svgFile = "default.svg"; // file

// PNG image file (click to upload)
pngFile = "default.png"; // file

// STL image file (click to upload)
stlFile = "default.stl"; // file

// Image raised height above surface (in mm)
imageThickness = 1; // [0.3:0.1:5]

// Image color (for multi-color printing)
imageColor = "#00FF00";  // color

// Image width (warps/scales the image)
imageWidth = 50; // [10:1:150]

// Image height (warps/scales the image)
imageHeight = 50; // [10:1:150]

// Image position
imageSide = "front"; // [front, back]

// Horizontal offset of image from center
imageOffsetX = 0; // [-100:1:100]

// Vertical offset of image from center
imageOffsetY = 0; // [-100:1:100]

// Image mode
imageMode = "emboss"; // [emboss, deboss]

/* [QR Code Settings] */
// Enable QR code
enableQRCode = false;

// QR code file type: svg or png
qrCodeType = "svg"; // [svg, png]

// SVG QR code file (click to upload)
qrCodeSvgFile = "default.svg"; // file

// PNG QR code file (click to upload)
qrCodePngFile = "default.png"; // file

// QR code raised height above surface (in mm)
qrCodeThickness = 0.8; // [0.3:0.1:3]

// QR code color
qrCodeColor = "#000000";  // color

// Size of QR code (square, in mm)
qrCodeSize = 25; // [10:1:80]

// QR code position on sign
qrCodeSide = "back"; // [front, back]

// QR code corner position (or center)
qrCodeCorner = "bottom_right"; // [center, top_left, top_right, bottom_left, bottom_right]

// Horizontal offset of QR code from position
qrCodeOffsetX = 0; // [-50:1:50]

// Vertical offset of QR code from position
qrCodeOffsetY = 0; // [-50:1:50]

// QR code mode
qrCodeMode = "emboss"; // [emboss, deboss]

/* [Mounting Options] */
// Mounting type
mounting_type = "none"; // [none, holes, slot, magnet, adhesive_cavity]

// Hole diameter for screw mounting
mounting_hole_diameter = 3.5; // [2:0.1:10]

// Number of mounting holes
mounting_hole_count = 2; // [1:1:4]

// Distance from edge to hole center
mounting_hole_edge_distance = 8; // [5:1:20]

// Slot width for keyhole mounting
slot_width = 6; // [3:0.5:15]

// Slot height
slot_height = 10; // [5:1:30]

// Magnet diameter (common 6mm or 8mm)
magnet_diameter = 6; // [4:0.5:15]

// Magnet depth
magnet_depth = 2; // [1:0.1:5]

// Number of magnets
magnet_count = 1; // [1:1:4]

/* [Border Options] */
// Add border/frame around sign
enable_border = false;

// Border width
border_width = 2; // [1:0.5:10]

// Border thickness (raised)
border_thickness = 0.5; // [0.2:0.1:3]

// Border color
border_color = "#0000FF";  // color

/* [Text Label] */
// Add text label
enable_text = false;

// Text to emboss
text_string = "SCAN ME";

// Font name (examples: "Liberation Sans", "Arial", "Times New Roman")
text_font = "Liberation Sans";

// Font style
text_style = "Bold"; // [Regular, Bold, Italic, Bold Italic]

// Text size
text_size = 6; // [3:0.5:20]

// Text thickness
text_thickness = 0.8; // [0.3:0.1:3]

// Text position preset
text_position = "bottom"; // [top, bottom, center, custom]

// Horizontal offset of text from center
text_offset_x = 0; // [-100:1:100]

// Vertical offset of text from center
text_offset_y = 0; // [-100:1:100]

// Text color
text_color = "#FF0000";  // color

/* [Auto Layout & Dividers] */
// Enable automatic element spacing
enable_auto_layout = false;

// Auto-layout side (which side to arrange)
auto_layout_side = "front"; // [front, back, both]

// Vertical spacing between elements (in mm)
element_spacing = 5; // [2:1:20]

// Add dividing lines between elements
enable_dividers = false;

// Divider line thickness (height)
divider_thickness = 0.5; // [0.2:0.1:2]

// Divider line width (length)
divider_width = 60; // [10:5:150]

// Divider style
divider_style = "line"; // [line, dashed, dotted]

// Divider mode
divider_mode = "emboss"; // [emboss, deboss]

// Divider color
divider_color = "#888888";  // color

/* [Advanced Options] */
// Quality of circles ($fn)
circle_quality = 64; // [16:4:128]

// What to render
render_part = "assembled"; // [assembled, sign_only, nfc_test_fit]

// ==================== MAIN EXECUTION ====================

$fn = circle_quality;

if (render_part == "assembled") {
    complete_sign();
} else if (render_part == "sign_only") {
    color(sign_color)
        sign_body();
} else if (render_part == "nfc_test_fit") {
    // Render a small test piece to verify NFC tag fit
    intersection() {
        complete_sign();
        translate([nfc_offset_x, nfc_offset_y, 0])
            cuboid([nfc_tag_diameter + 10, nfc_tag_diameter + 10, 20], anchor=CENTER);
    }
}

// ==================== MODULES ====================

module complete_sign() {
    // Main sign body
    color(sign_color)
        difference() {
            union() {
                // Base sign body
                sign_body();

                // Add border if enabled
                if (enable_border) {
                    border_frame();
                }
            }

            // Subtract NFC cavity
            if (enable_nfc) {
                nfc_cavity();
            }

            // Subtract debossed elements
            if (imageType != "none" && imageMode == "deboss") {
                emboss_image();
            }

            if (enableQRCode && qrCodeMode == "deboss") {
                emboss_qr_code();
            }

            // Subtract debossed dividers
            if (enable_dividers && enable_auto_layout && divider_mode == "deboss") {
                // Front side dividers
                if (auto_layout_side == "front" || auto_layout_side == "both") {
                    layout_front = calculate_auto_layout("front");
                    divider_positions_front = layout_front[3];

                    if (divider_positions_front[0] != undef) {
                        divider_line(divider_positions_front[0], "front");
                    }
                    if (divider_positions_front[1] != undef) {
                        divider_line(divider_positions_front[1], "front");
                    }
                }

                // Back side dividers
                if (auto_layout_side == "back" || auto_layout_side == "both") {
                    layout_back = calculate_auto_layout("back");
                    divider_positions_back = layout_back[3];

                    if (divider_positions_back[0] != undef) {
                        divider_line(divider_positions_back[0], "back");
                    }
                    if (divider_positions_back[1] != undef) {
                        divider_line(divider_positions_back[1], "back");
                    }
                }
            }

            // Subtract mounting features
            mounting_features();
        }

    // Add embossed elements (front)
    if (imageType != "none" && imageSide == "front" && imageMode == "emboss") {
        color(imageColor)
            emboss_image();
    }

    if (enableQRCode && qrCodeSide == "front" && qrCodeMode == "emboss") {
        color(qrCodeColor)
            emboss_qr_code();
    }

    // Add embossed elements (back)
    if (imageType != "none" && imageSide == "back" && imageMode == "emboss") {
        color(imageColor)
            emboss_image();
    }

    if (enableQRCode && qrCodeSide == "back" && qrCodeMode == "emboss") {
        color(qrCodeColor)
            emboss_qr_code();
    }

    // Add text if enabled
    if (enable_text) {
        color(text_color)
            emboss_text();
    }

    // Add dividers if enabled and auto-layout is active
    if (enable_dividers && enable_auto_layout) {
        // Front side dividers
        if (auto_layout_side == "front" || auto_layout_side == "both") {
            layout_front = calculate_auto_layout("front");
            divider_positions_front = layout_front[3];

            if (divider_mode == "emboss") {
                color(divider_color) {
                    if (divider_positions_front[0] != undef) {
                        divider_line(divider_positions_front[0], "front");
                    }
                    if (divider_positions_front[1] != undef) {
                        divider_line(divider_positions_front[1], "front");
                    }
                }
            }
        }

        // Back side dividers
        if (auto_layout_side == "back" || auto_layout_side == "both") {
            layout_back = calculate_auto_layout("back");
            divider_positions_back = layout_back[3];

            if (divider_mode == "emboss") {
                color(divider_color) {
                    if (divider_positions_back[0] != undef) {
                        divider_line(divider_positions_back[0], "back");
                    }
                    if (divider_positions_back[1] != undef) {
                        divider_line(divider_positions_back[1], "back");
                    }
                }
            }
        }
    }
}

module sign_body() {
    if (sign_shape == "rectangle") {
        cuboid([sign_width, sign_height, sign_thickness],
               rounding=corner_radius,
               edges="Z",
               anchor=CENTER);
    }
    else if (sign_shape == "circle") {
        cyl(d=sign_width, h=sign_thickness,
            rounding2=corner_radius,
            anchor=CENTER);
    }
    else if (sign_shape == "oval") {
        linear_extrude(height=sign_thickness, center=true, convexity=10)
            resize([sign_width, sign_height, 0])
                circle(d=sign_width);

        // Add rounded edge
        if (corner_radius > 0) {
            hull() {
                linear_extrude(height=0.01, center=true)
                    resize([sign_width, sign_height, 0])
                        offset(r=-corner_radius)
                            circle(d=sign_width);

                linear_extrude(height=sign_thickness - 2*corner_radius, center=true)
                    resize([sign_width, sign_height, 0])
                        circle(d=sign_width);
            }
        }
    }
    else if (sign_shape == "hexagon") {
        linear_extrude(height=sign_thickness, center=true, convexity=10)
            hexagon(d=sign_width);
    }
    else if (sign_shape == "octagon") {
        linear_extrude(height=sign_thickness, center=true, convexity=10)
            octagon(d=sign_width);
    }
}

module nfc_cavity() {
    // Calculate Z position based on nfc_position setting
    z_pos = (nfc_position == "front") ? sign_thickness/2 - nfc_tag_depth/2 :
            (nfc_position == "back") ? -sign_thickness/2 + nfc_tag_depth/2 :
            0; // center

    translate([nfc_offset_x, nfc_offset_y, z_pos])
        cyl(d=nfc_tag_diameter, h=nfc_tag_depth, anchor=CENTER);

    // Optional: Add chamfer to cavity entrance for easier tag insertion
    chamfer_depth = 0.3;
    entrance_z = (nfc_position == "front") ? sign_thickness/2 :
                 (nfc_position == "back") ? -sign_thickness/2 :
                 z_pos + nfc_tag_depth/2;

    translate([nfc_offset_x, nfc_offset_y, entrance_z])
        cyl(d1=nfc_tag_diameter, d2=nfc_tag_diameter + 2*chamfer_depth,
            h=chamfer_depth, anchor=(nfc_position == "back" ? TOP : BOTTOM));
}

module emboss_image() {
    if (imageType != "none") {
        // Check if auto-layout is enabled for this side
        use_auto_layout = enable_auto_layout &&
                          (auto_layout_side == imageSide || auto_layout_side == "both");

        // Get layout positions if auto-layout is enabled
        layout = use_auto_layout ? calculate_auto_layout(imageSide) : [0, 0, 0, []];
        auto_y = layout[0];

        // Calculate final Y position
        final_y = use_auto_layout ? auto_y : imageOffsetY;
        final_x = imageOffsetX;

        // Calculate Z position
        z_base = (imageSide == "front") ? sign_thickness/2 : -sign_thickness/2;
        z_offset = (imageSide == "front") ? imageThickness/2 : -imageThickness/2;

        translate([final_x, final_y, z_base + z_offset]) {
            image_loader(imageType, svgFile, pngFile, stlFile,
                         imageWidth, imageHeight, imageThickness);
        }
    }
}

module emboss_qr_code() {
    // Check if auto-layout is enabled for this side
    use_auto_layout = enable_auto_layout &&
                      (auto_layout_side == qrCodeSide || auto_layout_side == "both");

    // Get layout positions if auto-layout is enabled
    layout = use_auto_layout ? calculate_auto_layout(qrCodeSide) : [0, 0, 0, []];
    auto_y = layout[2];

    // Calculate final position
    if (use_auto_layout) {
        final_x = qrCodeOffsetX;
        final_y = auto_y;
    } else {
        qr_pos = get_qr_position(qrCodeCorner, sign_width, sign_height, qrCodeSize);
        final_x = qr_pos[0] + qrCodeOffsetX;
        final_y = qr_pos[1] + qrCodeOffsetY;
    }

    // Calculate Z position
    z_base = (qrCodeSide == "front") ? sign_thickness/2 : -sign_thickness/2;
    z_offset = (qrCodeSide == "front") ? qrCodeThickness/2 : -qrCodeThickness/2;

    translate([final_x, final_y, z_base + z_offset]) {
        image_loader(qrCodeType, qrCodeSvgFile, qrCodePngFile, "",
                     qrCodeSize, qrCodeSize, qrCodeThickness);
    }
}

module emboss_text() {
    // Text is always on front for now - could be parameterized
    text_side = "front";

    // Check if auto-layout is enabled
    use_auto_layout = enable_auto_layout &&
                      (auto_layout_side == text_side || auto_layout_side == "both");

    // Get layout positions if auto-layout is enabled
    layout = use_auto_layout ? calculate_auto_layout(text_side) : [0, 0, 0, []];
    auto_y = layout[1];

    // Calculate final position
    if (use_auto_layout) {
        final_x = text_offset_x;
        final_y = auto_y + text_offset_y;
    } else {
        // Calculate preset Y position
        preset_y = (text_position == "top") ? sign_height/2 - text_size - 3 :
                   (text_position == "bottom") ? -sign_height/2 + 3 :
                   (text_position == "center") ? 0 :
                   0; // custom uses only offsets

        // Apply offsets (for custom position or fine-tuning presets)
        final_x = (text_position == "custom") ? text_offset_x : text_offset_x;
        final_y = (text_position == "custom") ? text_offset_y : preset_y + text_offset_y;
    }

    // Build font string (format: "FontName:style=StyleName")
    font_string = str(text_font, ":style=", text_style);

    translate([final_x, final_y, sign_thickness/2 + text_thickness/2])
        linear_extrude(height=text_thickness, center=true)
            text(text_string, size=text_size, halign="center", valign="center",
                 font=font_string);
}

module border_frame() {
    difference() {
        // Outer border shape
        translate([0, 0, sign_thickness/2 + border_thickness/2])
            linear_extrude(height=border_thickness, center=true) {
                if (sign_shape == "rectangle") {
                    round2d(r=corner_radius)
                        square([sign_width, sign_height], center=true);
                } else if (sign_shape == "circle") {
                    circle(d=sign_width);
                } else if (sign_shape == "oval") {
                    resize([sign_width, sign_height, 0])
                        circle(d=sign_width);
                } else if (sign_shape == "hexagon") {
                    hexagon(d=sign_width);
                } else if (sign_shape == "octagon") {
                    octagon(d=sign_width);
                }
            }

        // Inner cutout
        translate([0, 0, sign_thickness/2 + border_thickness/2])
            linear_extrude(height=border_thickness + 1, center=true) {
                if (sign_shape == "rectangle") {
                    round2d(r=max(0, corner_radius - border_width))
                        square([sign_width - 2*border_width, sign_height - 2*border_width], center=true);
                } else if (sign_shape == "circle") {
                    circle(d=sign_width - 2*border_width);
                } else if (sign_shape == "oval") {
                    resize([sign_width - 2*border_width, sign_height - 2*border_width, 0])
                        circle(d=sign_width - 2*border_width);
                } else if (sign_shape == "hexagon") {
                    hexagon(d=sign_width - 2*border_width);
                } else if (sign_shape == "octagon") {
                    octagon(d=sign_width - 2*border_width);
                }
            }
    }
}

module mounting_features() {
    if (mounting_type == "holes") {
        mounting_holes();
    } else if (mounting_type == "slot") {
        keyhole_slot();
    } else if (mounting_type == "magnet") {
        magnet_cavities();
    } else if (mounting_type == "adhesive_cavity") {
        adhesive_recess();
    }
}

module mounting_holes() {
    for (i = [0:mounting_hole_count-1]) {
        angle = i * (360 / mounting_hole_count);
        x_pos = (sign_width/2 - mounting_hole_edge_distance) * cos(angle);
        y_pos = (sign_height/2 - mounting_hole_edge_distance) * sin(angle);

        translate([x_pos, y_pos, 0])
            cyl(d=mounting_hole_diameter, h=sign_thickness + 2, anchor=CENTER);
    }
}

module keyhole_slot() {
    translate([0, sign_height/2 - mounting_hole_edge_distance, 0]) {
        // Upper circle (keyhole entrance)
        cyl(d=slot_width, h=sign_thickness + 2, anchor=CENTER);

        // Lower slot (hanging channel)
        translate([0, -slot_height/2, 0])
            cuboid([slot_width * 0.6, slot_height, sign_thickness + 2], anchor=CENTER);
    }
}

module magnet_cavities() {
    back_z = -sign_thickness/2 + magnet_depth/2;

    if (magnet_count == 1) {
        translate([0, 0, back_z])
            cyl(d=magnet_diameter, h=magnet_depth, anchor=CENTER);
    } else {
        for (i = [0:magnet_count-1]) {
            angle = i * (360 / magnet_count);
            x_pos = (sign_width/3) * cos(angle);
            y_pos = (sign_height/3) * sin(angle);

            translate([x_pos, y_pos, back_z])
                cyl(d=magnet_diameter, h=magnet_depth, anchor=CENTER);
        }
    }
}

module adhesive_recess() {
    // Create shallow recess for adhesive pads (3M Command strips, etc.)
    recess_width = min(sign_width - 10, 40);
    recess_height = min(sign_height - 10, 20);
    recess_depth = 0.5;

    translate([0, 0, -sign_thickness/2 + recess_depth/2])
        cuboid([recess_width, recess_height, recess_depth],
               rounding=2, edges="Z", anchor=CENTER);
}

module divider_line(y_pos, side) {
    // Calculate Z position
    z_base = (side == "front") ? sign_thickness/2 : -sign_thickness/2;
    z_offset = (side == "front") ? divider_thickness/2 : -divider_thickness/2;

    actual_width = min(divider_width, sign_width - 10);

    if (divider_style == "line") {
        // Solid line
        translate([0, y_pos, z_base + z_offset])
            cuboid([actual_width, 0.5, divider_thickness], anchor=CENTER);
    }
    else if (divider_style == "dashed") {
        // Dashed line - 5 segments
        dash_length = actual_width / 11; // 5 dashes + 4 gaps
        gap_length = dash_length * 0.5;

        for (i = [0:4]) {
            x_offset = -actual_width/2 + dash_length/2 + i * (dash_length + gap_length);
            translate([x_offset, y_pos, z_base + z_offset])
                cuboid([dash_length, 0.5, divider_thickness], anchor=CENTER);
        }
    }
    else if (divider_style == "dotted") {
        // Dotted line - multiple small circles
        dot_count = floor(actual_width / 5);
        dot_spacing = actual_width / (dot_count - 1);

        for (i = [0:dot_count-1]) {
            x_offset = -actual_width/2 + i * dot_spacing;
            translate([x_offset, y_pos, z_base + z_offset])
                cyl(d=1.5, h=divider_thickness, anchor=CENTER);
        }
    }
}

// ==================== HELPER FUNCTIONS ====================

/*
 * Calculate QR code position based on corner setting
 */
function get_qr_position(corner, sign_w, sign_h, qr_size) =
    (corner == "center") ? [0, 0] :
    (corner == "top_left") ? [-sign_w/2 + qr_size/2 + 3, sign_h/2 - qr_size/2 - 3] :
    (corner == "top_right") ? [sign_w/2 - qr_size/2 - 3, sign_h/2 - qr_size/2 - 3] :
    (corner == "bottom_left") ? [-sign_w/2 + qr_size/2 + 3, -sign_h/2 + qr_size/2 + 3] :
    (corner == "bottom_right") ? [sign_w/2 - qr_size/2 - 3, -sign_h/2 + qr_size/2 + 3] :
    [0, 0];

/*
 * Calculate auto-layout positions for elements on a given side
 * Returns [image_y, text_y, qr_y, divider_positions]
 */
function calculate_auto_layout(side) =
    let(
        // Determine which elements are on this side
        has_image = (imageType != "none" && imageSide == side),
        has_text = (enable_text == true),
        has_qr = (enableQRCode && qrCodeSide == side),

        // Count elements
        element_count = (has_image ? 1 : 0) + (has_text ? 1 : 0) + (has_qr ? 1 : 0),

        // Calculate element heights
        image_h = has_image ? imageHeight : 0,
        text_h = has_text ? text_size : 0,
        qr_h = has_qr ? qrCodeSize : 0,

        // Total content height including spacing
        total_height = image_h + text_h + qr_h + (element_count - 1) * element_spacing,

        // Starting Y position (top of content area)
        start_y = total_height / 2,

        // Calculate positions for each element
        image_y = has_image ? start_y - image_h/2 : 0,
        text_y = has_text ? (has_image ? image_y - image_h/2 - element_spacing - text_h/2 : start_y - text_h/2) : 0,
        qr_y = has_qr ? (has_text ? text_y - text_h/2 - element_spacing - qr_h/2 :
                         has_image ? image_y - image_h/2 - element_spacing - qr_h/2 :
                         start_y - qr_h/2) : 0,

        // Calculate divider positions (between elements)
        div1_y = (has_image && has_text) ? image_y - image_h/2 - element_spacing/2 : undef,
        div2_y = (has_text && has_qr) ? text_y - text_h/2 - element_spacing/2 :
                 (has_image && has_qr && !has_text) ? image_y - image_h/2 - element_spacing/2 : undef
    )
    [image_y, text_y, qr_y, [div1_y, div2_y]];

/*
 * Generic image loader module that handles SVG, PNG, or STL files
 * Pattern based on nfc_tag_keychain.scad logo() module
 */
module image_loader(fileType, svgFile, pngFile, stlFile, imgWidth, imgHeight, imgThickness) {
    if(fileType == "svg") {
        if (svgFile != "default.svg") {
            resize([imgWidth, imgHeight, imgThickness], auto=true)
                linear_extrude(height = imgThickness, center = true)
                    import(file = svgFile, center = true);
        }
    } else if(fileType == "png") {
        if (pngFile != "default.png") {
            resize([imgWidth, imgHeight, imgThickness], auto=true)
                surface(file = pngFile, center = true);
        }
    } else if(fileType == "stl") {
        if (stlFile != "default.stl") {
            resize([imgWidth, imgHeight, imgThickness], auto=true)
                import(file = stlFile, center = true);
        }
    }
}

module octagon(d) {
    circle(d=d, $fn=8);
}

// ==================== END ====================

echo("==============================================");
echo("Parametric NFC Sign Generator v1.5.0");
echo("==============================================");
echo(str("Sign Shape: ", sign_shape));
echo(str("Sign Dimensions: ", sign_width, "mm x ", sign_height, "mm x ", sign_thickness, "mm"));
echo(str("NFC Tag Cavity: ", enable_nfc ? "YES" : "NO"));
if (enable_nfc) {
    echo(str("  - Diameter: ", nfc_tag_diameter, "mm, Depth: ", nfc_tag_depth, "mm"));
    echo(str("  - Position: ", nfc_position));
}
echo(str("Main Image: ", imageType));
if (imageType != "none") {
    echo(str("  - File: ", imageType == "svg" ? svgFile : imageType == "png" ? pngFile : stlFile));
    echo(str("  - Size: ", imageWidth, "mm x ", imageHeight, "mm"));
    echo(str("  - Side: ", imageSide, ", Mode: ", imageMode));
}
echo(str("QR Code: ", enableQRCode ? "YES" : "NO"));
if (enableQRCode) {
    echo(str("  - Size: ", qrCodeSize, "mm x ", qrCodeSize, "mm"));
    echo(str("  - Position: ", qrCodeCorner, " on ", qrCodeSide));
}
echo(str("Mounting: ", mounting_type));
echo("==============================================");

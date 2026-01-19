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
 * Version: 1.1.0
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
image_type = "svg"; // [none, svg, png, stl]

// SVG image file (place your .svg file in the same directory)
image_svg_file = "image.svg";

// PNG image file (used as heightmap)
image_png_file = "image.png";

// STL image file (3D model)
image_stl_file = "image.stl";

// Width of image in mm
image_width = 50; // [10:1:150]

// Height of image in mm
image_height = 50; // [10:1:150]

// Thickness/depth of embossed image
image_thickness = 1; // [0.3:0.1:5]

// Image position
image_side = "front"; // [front, back]

// X offset from center
image_offset_x = 0; // [-100:1:100]

// Y offset from center
image_offset_y = 0; // [-100:1:100]

// Image mode
image_mode = "emboss"; // [emboss, deboss]

// Image color (for multi-color printing)
image_color = "#00FF00";  // color

/* [QR Code Settings] */
// Enable QR code
enable_qr_code = false;

// Type of QR code file
qr_code_type = "svg"; // [svg, png]

// Path to QR code SVG file
qr_code_svg_file = "qrcode.svg";

// Path to QR code PNG file
qr_code_png_file = "qrcode.png";

// Size of QR code (square)
qr_code_size = 25; // [10:1:80]

// Thickness of QR code relief
qr_code_thickness = 0.8; // [0.3:0.1:3]

// QR code position
qr_code_side = "back"; // [front, back]

// QR code corner position (or center)
qr_code_corner = "bottom_right"; // [center, top_left, top_right, bottom_left, bottom_right]

// Fine X adjustment
qr_code_offset_x = 0; // [-50:1:50]

// Fine Y adjustment
qr_code_offset_y = 0; // [-50:1:50]

// QR code mode
qr_code_mode = "emboss"; // [emboss, deboss]

// QR code color
qr_code_color = "#000000";  // color

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

// Text size
text_size = 6; // [3:0.5:20]

// Text thickness
text_thickness = 0.8; // [0.3:0.1:3]

// Text position
text_position = "bottom"; // [top, bottom, center]

// Text color
text_color = "#FF0000";  // color

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
            if (image_type != "none" && image_mode == "deboss") {
                emboss_image();
            }

            if (enable_qr_code && qr_code_mode == "deboss") {
                emboss_qr_code();
            }

            // Subtract mounting features
            mounting_features();
        }

    // Add embossed elements (front)
    if (image_type != "none" && image_side == "front" && image_mode == "emboss") {
        color(image_color)
            emboss_image();
    }

    if (enable_qr_code && qr_code_side == "front" && qr_code_mode == "emboss") {
        color(qr_code_color)
            emboss_qr_code();
    }

    // Add embossed elements (back)
    if (image_type != "none" && image_side == "back" && image_mode == "emboss") {
        color(image_color)
            emboss_image();
    }

    if (enable_qr_code && qr_code_side == "back" && qr_code_mode == "emboss") {
        color(qr_code_color)
            emboss_qr_code();
    }

    // Add text if enabled
    if (enable_text) {
        color(text_color)
            emboss_text();
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
    if (image_type == "none") return;

    // Calculate Z position
    z_base = (image_side == "front") ? sign_thickness/2 : -sign_thickness/2;
    z_offset = (image_side == "front") ? image_thickness/2 : -image_thickness/2;

    translate([image_offset_x, image_offset_y, z_base + z_offset]) {
        image_loader(image_type, image_svg_file, image_png_file, image_stl_file,
                     image_width, image_height, image_thickness);
    }
}

module emboss_qr_code() {
    // Calculate corner position
    function get_qr_position() =
        (qr_code_corner == "center") ? [0, 0] :
        (qr_code_corner == "top_left") ? [-sign_width/2 + qr_code_size/2 + 3, sign_height/2 - qr_code_size/2 - 3] :
        (qr_code_corner == "top_right") ? [sign_width/2 - qr_code_size/2 - 3, sign_height/2 - qr_code_size/2 - 3] :
        (qr_code_corner == "bottom_left") ? [-sign_width/2 + qr_code_size/2 + 3, -sign_height/2 + qr_code_size/2 + 3] :
        (qr_code_corner == "bottom_right") ? [sign_width/2 - qr_code_size/2 - 3, -sign_height/2 + qr_code_size/2 + 3] :
        [0, 0];

    qr_pos = get_qr_position();

    // Calculate Z position
    z_base = (qr_code_side == "front") ? sign_thickness/2 : -sign_thickness/2;
    z_offset = (qr_code_side == "front") ? qr_code_thickness/2 : -qr_code_thickness/2;

    translate([qr_pos[0] + qr_code_offset_x, qr_pos[1] + qr_code_offset_y, z_base + z_offset]) {
        image_loader(qr_code_type, qr_code_svg_file, qr_code_png_file, "",
                     qr_code_size, qr_code_size, qr_code_thickness);
    }
}

module emboss_text() {
    text_y = (text_position == "top") ? sign_height/2 - text_size - 3 :
             (text_position == "bottom") ? -sign_height/2 + 3 :
             0;

    translate([0, text_y, sign_thickness/2 + text_thickness/2])
        linear_extrude(height=text_thickness, center=true)
            text(text_string, size=text_size, halign="center", valign="center",
                 font="Liberation Sans:style=Bold");
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

// ==================== HELPER FUNCTIONS ====================

/*
 * Generic image loader module that handles SVG, PNG, or STL files
 * Pattern based on nfc_tag_keychain.scad logo() module
 */
module image_loader(fileType, svgFile, pngFile, stlFile, imgWidth, imgHeight, imgThickness) {
    if(fileType == "svg") {
        if (svgFile != "image.svg" && svgFile != "qrcode.svg" && svgFile != "default.svg") {
            resize([imgWidth, imgHeight, imgThickness], auto=true)
                linear_extrude(height = imgThickness, center = true)
                    import(file = svgFile, center = true);
        }
    } else if(fileType == "png") {
        if (pngFile != "image.png" && pngFile != "qrcode.png" && pngFile != "default.png") {
            resize([imgWidth, imgHeight, imgThickness], auto=true)
                surface(file = pngFile, center = true);
        }
    } else if(fileType == "stl") {
        if (stlFile != "image.stl" && stlFile != "default.stl") {
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
echo("Parametric NFC Sign Generator v1.1.0");
echo("==============================================");
echo(str("Sign Shape: ", sign_shape));
echo(str("Sign Dimensions: ", sign_width, "mm x ", sign_height, "mm x ", sign_thickness, "mm"));
echo(str("NFC Tag Cavity: ", enable_nfc ? "YES" : "NO"));
if (enable_nfc) {
    echo(str("  - Diameter: ", nfc_tag_diameter, "mm, Depth: ", nfc_tag_depth, "mm"));
    echo(str("  - Position: ", nfc_position));
}
echo(str("Main Image: ", image_type));
if (image_type != "none") {
    echo(str("  - File: ", image_type == "svg" ? image_svg_file : image_type == "png" ? image_png_file : image_stl_file));
    echo(str("  - Size: ", image_width, "mm x ", image_height, "mm"));
    echo(str("  - Side: ", image_side, ", Mode: ", image_mode));
}
echo(str("QR Code: ", enable_qr_code ? "YES" : "NO"));
if (enable_qr_code) {
    echo(str("  - Size: ", qr_code_size, "mm x ", qr_code_size, "mm"));
    echo(str("  - Position: ", qr_code_corner, " on ", qr_code_side));
}
echo(str("Mounting: ", mounting_type));
echo("==============================================");

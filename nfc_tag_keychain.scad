/*
 * NFC Tag Keychain with Custom Logo - Parametric Design
 *
 * This OpenSCAD file creates a custom keychain designed to hold an NFC tag
 * with support for adding custom logos/images on one or both sides.
 *
 * AVAILABLE SHAPES:
 * - oval, square, circle, rectangle, hexagon, custom_svg
 * - body_rotation and body_scale for quick global transforms
 * - hanging hole, NFC recess, and logos each have independent placement controls
 *
 * To use your own photo/logo:
 * 1. Save your image file in the same directory as this .scad file
 * 2. Update the svgFile1, pngFile1, or stlFile1 parameter below with your filename
 * 3. Adjust logo1Width and logo1Height to resize as needed
 * 4. Set logo1Type to match your file type (svg, png, or stl)
 *
 * For best results with photos:
 * - Convert photos to SVG or PNG format
 * - Resize images to approximately 200-500px for faster rendering
 * - High contrast images work best for 3D printing
 */

/* [Basic Parameters] */
// Keychain base color
tag_color = "#FFFFFF";  // color

// Keychain shape style
keychain_shape = "oval"; // [oval, square, circle, rectangle, hexagon, custom_svg]

// Rotate the entire keychain body in the XY plane (degrees)
body_rotation = 0;

// Uniform scale for the keychain body (1 = default size)
body_scale = 1;

// Create a recessed hole for embedding NFC tag
nfc_tag_hole = true;

/* [Logo 1 Options - Front Side] */
// Logo file type: svg (recommended), png, or stl
logo1Type = "svg"; // [svg,png,stl]

// SVG logo file (click to upload)
svgFile1 = "default.svg"; // file

// PNG logo file (click to upload)
pngFile1 = "default.png"; // file

// STL logo file (click to upload)
stlFile1 = "default.stl"; // file

// Logo raised height above surface (in mm)
logo1Thickness = 0.5;

// Additional inset depth into the face (0 = flush; positive = deeper inlay)
logo1EmbedDepth = 0;

// Keep logo flush with keychain face so it can lie flat
logo1Flush = true;

// Logo color (for multi-color printing)
logo1Color = "#00FF00";  // color

// Logo width (warps/scales the image)
logo1Width = 22;

// Logo height (warps/scales the image)
logo1Height = 22;

// Horizontal offset of logo from center
logo1OffsetX = 0;

// Vertical offset of logo from center
logo1OffsetY = 0;

// Rotation of front logo in degrees
logo1Rotation = 0;

/* [Logo 2 Options - Back Side] */
// Enable second logo on back side
logo2Enabled = false;

// Logo file type for back side
logo2Type = "svg"; // [svg,png,stl]

// SVG logo file (click to upload)
svgFile2 = "default.svg"; // file

// PNG logo file (click to upload)
pngFile2 = "default.png"; // file

// STL logo file (click to upload)
stlFile2 = "default.stl"; // file

// Logo raised height above surface (in mm)
logo2Thickness = 0.5;

// Additional inset depth into the face (0 = flush; positive = deeper inlay)
logo2EmbedDepth = 0;

// Logo color for back side
logo2Color = "#00FF00";  // color

// Keep back logo flush with keychain face so it can lie flat
logo2Flush = true;

// Logo dimensions for back side
logo2Width = 22;
logo2Height = 22;
logo2OffsetX = 0;
logo2OffsetY = 0;

// Rotation of back logo in degrees
logo2Rotation = 0;

/* [Advanced Keychain Dimensions] */
// Angle for the tapered sides (in degrees)
angle = 30;

// Radius for the beveled (rounded) edges
bevel_radius = 1.5;

// Distance from center to hanging hole
distance_hole = 18.7;

// Diameter of the bottom (main) circle
diameter1 = 30;

// Diameter of the top (hanging) circle
diameter2 = 15;

// Distance between the centers of the two circles
distance_centers = 15;

// Base thickness of the keychain (before beveling)
keychain_thickness = 1;

// Diameter of the pill-shaped hanging hole
hole_diameter = 7;

// Length of the pill-shaped hanging hole
hole_length = 3;

/* [NFC Tag Specifications] */
// NFC tag diameter (NTAG216 is typically 25mm)
nfc_tag_diameter = 26;

// NFC tag recess depth
nfc_tag_height = 1.25;

/* [Square Shape Dimensions] */
// Width of square keychain body (only used if keychain_shape = "square")
square_width = 35;

// Height of square keychain body (only used if keychain_shape = "square")
square_height = 50;

// Corner radius for rounded corners (only used if keychain_shape = "square")
square_corner_radius = 3;

// Distance from bottom to center of hanging hole (only used if keychain_shape = "square")
square_hole_distance = 43;

/* [Additional Shape Dimensions] */
// Circle body diameter (only used if keychain_shape = "circle")
circle_diameter = 35;

// Rectangle body width (only used if keychain_shape = "rectangle")
rectangle_width = 35;

// Rectangle body height (only used if keychain_shape = "rectangle")
rectangle_height = 50;

// Rectangle corner radius (only used if keychain_shape = "rectangle")
rectangle_corner_radius = 4;

// Hexagon body diameter point-to-point (only used if keychain_shape = "hexagon")
hexagon_diameter = 38;

// Custom SVG body file (only used if keychain_shape = "custom_svg")
body_svg_file = "default_body.svg"; // file

// Width target for custom SVG body
body_svg_width = 40;

// Height target for custom SVG body
body_svg_height = 50;

/* [Hanging Hole Placement] */
// Enable the hanging hole
hanging_hole_enabled = true;

// X position of hanging hole center
hole_center_x = 0;

// Y position of hanging hole center
hole_center_y = 18.7;

// Rotation of the hanging hole (degrees)
hole_rotation = 0;

/* [NFC Recess Placement] */
// X position of NFC recess center
nfc_offset_x = 0;

// Y position of NFC recess center
nfc_offset_y = 0;


// ============================================================
// MODULES - Main Construction Code
// ============================================================

/*
 * Main keychain body with oval shape and rounded edges
 */
module keychain_oval_with_ends() {
    radius1 = diameter1 / 2;
    radius2 = diameter2 / 2;

    // Apply minkowski to create smooth, beveled edges
    minkowski() {
        difference() {
            // Main body union
            union() {
                // Bottom circular end (main body for NFC tag)
                translate([0, 0, 0])
                    cylinder(h = keychain_thickness, r = radius1, $fn=200);

                // Top circular end (hanging hole area)
                translate([0, distance_centers, 0])
                    cylinder(h = keychain_thickness, r = radius2, $fn=100);

                // Connecting walls between the two circles
                linear_extrude(height = keychain_thickness)
                    polygon(points=[
                        [radius1 * cos(angle), radius1 * sin(angle)],
                        [radius2 * cos(angle), distance_centers + radius2 * sin(angle)],
                        [-radius2 * cos(angle), distance_centers + radius2 * sin(angle)],
                        [-radius1 * cos(angle), radius1 * sin(angle)]
                    ]);
            }

            // Cut out the hanging hole
            hanging_hole();
        }

        // Sphere used for rounding/beveling all edges
        sphere(r = bevel_radius, $fn=50);
    }
}

/*
 * Main keychain body with square/rectangular shape and rounded corners
 */
module keychain_square() {
    // Apply minkowski to create smooth, beveled edges
    minkowski() {
        difference() {
            // Main square body with rounded corners
            translate([-square_width/2, 0, 0])
                hull() {
                    // Four corners with rounded edges
                    translate([square_corner_radius, square_corner_radius, 0])
                        cylinder(h = keychain_thickness, r = square_corner_radius, $fn=50);

                    translate([square_width - square_corner_radius, square_corner_radius, 0])
                        cylinder(h = keychain_thickness, r = square_corner_radius, $fn=50);

                    translate([square_corner_radius, square_height - square_corner_radius, 0])
                        cylinder(h = keychain_thickness, r = square_corner_radius, $fn=50);

                    translate([square_width - square_corner_radius, square_height - square_corner_radius, 0])
                        cylinder(h = keychain_thickness, r = square_corner_radius, $fn=50);
                }

            // Cut out the hanging hole at top
            hanging_hole();
        }

        // Sphere used for rounding/beveling all edges
        sphere(r = bevel_radius, $fn=50);
    }
}

module keychain_circle() {
    minkowski() {
        difference() {
            cylinder(h = keychain_thickness, r = circle_diameter / 2, $fn=180);
            hanging_hole();
        }
        sphere(r = bevel_radius, $fn=50);
    }
}

module rounded_rectangle_2d(w, h, r) {
    rr = min(r, min(w, h)/2 - 0.01);
    if (rr > 0) {
        hull() {
            translate([-w/2 + rr, -h/2 + rr]) circle(r = rr, $fn=40);
            translate([w/2 - rr, -h/2 + rr]) circle(r = rr, $fn=40);
            translate([-w/2 + rr, h/2 - rr]) circle(r = rr, $fn=40);
            translate([w/2 - rr, h/2 - rr]) circle(r = rr, $fn=40);
        }
    } else {
        square([w, h], center = true);
    }
}

module keychain_rectangle() {
    minkowski() {
        difference() {
            linear_extrude(height = keychain_thickness)
                rounded_rectangle_2d(rectangle_width, rectangle_height, rectangle_corner_radius);
            hanging_hole();
        }
        sphere(r = bevel_radius, $fn=50);
    }
}

module keychain_hexagon() {
    minkowski() {
        difference() {
            linear_extrude(height = keychain_thickness)
                circle(d = hexagon_diameter, $fn=6);
            hanging_hole();
        }
        sphere(r = bevel_radius, $fn=50);
    }
}

module keychain_custom_svg() {
    if (body_svg_file != "default_body.svg") {
        minkowski() {
            difference() {
                linear_extrude(height = keychain_thickness)
                    resize([body_svg_width, body_svg_height], auto = true)
                        import(file = body_svg_file, center = true);
                hanging_hole();
            }
            sphere(r = bevel_radius, $fn=50);
        }
    } else {
        echo("Set body_svg_file to a valid SVG when keychain_shape = custom_svg");
    }
}

/*
 * Creates a pill-shaped (obround) hole for hanging the keychain (oval version)
 */
module pill_hole() {
    translate([0, distance_hole, -0.1]) {
        union() {
            // Left rounded end
            translate([-hole_length / 2, 0, 0])
                cylinder(h = keychain_thickness + 3, r = hole_diameter / 2, $fn=50);

            // Right rounded end
            translate([hole_length / 2, 0, 0])
                cylinder(h = keychain_thickness + 3, r = hole_diameter / 2, $fn=50);

            // Connecting rectangle
            translate([-hole_length / 2, -hole_diameter / 2, 0])
                cube([hole_length, hole_diameter, keychain_thickness + 3]);
        }
    }
}

module hanging_hole() {
    if (hanging_hole_enabled) {
        translate([hole_center_x, hole_center_y, -0.1])
            rotate([0, 0, hole_rotation])
                union() {
                    translate([-hole_length / 2, 0, 0])
                        cylinder(h = keychain_thickness + 3, r = hole_diameter / 2, $fn=50);
                    translate([hole_length / 2, 0, 0])
                        cylinder(h = keychain_thickness + 3, r = hole_diameter / 2, $fn=50);
                    translate([-hole_length / 2, -hole_diameter / 2, 0])
                        cube([hole_length, hole_diameter, keychain_thickness + 3]);
                }
    }
}

/*
 * Creates a pill-shaped (obround) hole for hanging the keychain (square version)
 */
module pill_hole_square() {
    translate([0, square_hole_distance, -0.1]) {
        union() {
            // Left rounded end
            translate([-hole_length / 2, 0, 0])
                cylinder(h = keychain_thickness + 3, r = hole_diameter / 2, $fn=50);

            // Right rounded end
            translate([hole_length / 2, 0, 0])
                cylinder(h = keychain_thickness + 3, r = hole_diameter / 2, $fn=50);

            // Connecting rectangle
            translate([-hole_length / 2, -hole_diameter / 2, 0])
                cube([hole_length, hole_diameter, keychain_thickness + 3]);
        }
    }
}

/*
 * Generic logo module that handles SVG, PNG, or STL files
 */
module logo(logoType, logoOffsetX, logoOffsetY, logoRotation, logoWidth, logoHeight, logoThickness, svgFile, pngFile, stlFile) {
    if(logoType == "svg") {
        if (svgFile != "default.svg") {
            translate([logoOffsetX, logoOffsetY, 0])
                rotate([0, 0, logoRotation])
                resize([logoWidth, logoHeight, logoThickness], auto=true)
                    linear_extrude(height = logoThickness, center = true)
                        import(file = svgFile, center = true);
        }
    } else if(logoType == "png") {
        if (pngFile != "default.png") {
            translate([logoOffsetX, logoOffsetY, 0])
                rotate([0, 0, logoRotation])
                resize([logoWidth, logoHeight, logoThickness], auto=true)
                    surface(file = pngFile, center = true);
        }
    } else if(logoType == "stl") {
        if (stlFile != "default.stl") {
            translate([logoOffsetX, logoOffsetY, 0])
                rotate([0, 0, logoRotation])
                resize([logoWidth, logoHeight, logoThickness], auto=true)
                    import(file = stlFile, center = true);
        }
    }
}

// True when an actual logo file is selected (not placeholder default)
function logo_present(logoType, svgFile, pngFile, stlFile) =
    (logoType == "svg" && svgFile != "default.svg") ||
    (logoType == "png" && pngFile != "default.png") ||
    (logoType == "stl" && stlFile != "default.stl");

// SVG/STL imports are centered in Z; PNG surfaces are not
function logo_centered_z(logoType) = logoType != "png";

// Front logo recess used to make the logo inlay sit flush with the face
module logo1_recess() {
    if (logo1Flush && logo_present(logo1Type, svgFile1, pngFile1, stlFile1)) {
        recessThickness = logo1Thickness + logo1EmbedDepth + 0.02;
        recessZOffset = logo_centered_z(logo1Type)
            ? keychain_thickness + bevel_radius - logo1EmbedDepth - recessThickness/2
            : keychain_thickness + bevel_radius - logo1EmbedDepth - recessThickness;
        translate([0, 0, recessZOffset])
            logo(logo1Type, logo1OffsetX, logo1OffsetY, logo1Rotation, logo1Width, logo1Height,
                 recessThickness, svgFile1, pngFile1, stlFile1);
    }
}

// Back logo recess used to make the logo inlay sit flush with the face
module logo2_recess() {
    if (logo2Enabled && logo2Flush && logo_present(logo2Type, svgFile2, pngFile2, stlFile2)) {
        recessThickness = logo2Thickness + logo2EmbedDepth + 0.02;
        recessZOffset = logo_centered_z(logo2Type)
            ? -bevel_radius + logo2EmbedDepth + recessThickness/2
            : -bevel_radius + logo2EmbedDepth;
        translate([0, 0, recessZOffset])
            rotate([0, 180, 0])
                logo(logo2Type, logo2OffsetX, logo2OffsetY, logo2Rotation, logo2Width, logo2Height,
                     recessThickness, svgFile2, pngFile2, stlFile2);
    }
}

/*
 * Creates a recessed hole for embedding the NFC tag
 */
module nfc_hole() {
    if(nfc_tag_hole) {
        translate([nfc_offset_x, nfc_offset_y, 0])
            cylinder(h = nfc_tag_height, r = nfc_tag_diameter / 2, $fn=100);
    }
}

// ============================================================
// RENDERING - Final Assembly
// ============================================================

// Main keychain body with NFC tag recess
color(tag_color)
    rotate([0, 0, body_rotation])
        scale([body_scale, body_scale, 1])
            difference() {
                // Render selected shape
                if (keychain_shape == "oval") {
                    keychain_oval_with_ends();
                } else if (keychain_shape == "square") {
                    keychain_square();
                } else if (keychain_shape == "circle") {
                    keychain_circle();
                } else if (keychain_shape == "rectangle") {
                    keychain_rectangle();
                } else if (keychain_shape == "hexagon") {
                    keychain_hexagon();
                } else if (keychain_shape == "custom_svg") {
                    keychain_custom_svg();
                } else {
                    keychain_oval_with_ends();
                }
                nfc_hole();
                logo1_recess();
                logo2_recess();
            }

// Front side logo (Logo 1)
logo1ZOffset = logo_centered_z(logo1Type)
    ? keychain_thickness + bevel_radius - (logo1Flush ? (logo1EmbedDepth + logo1Thickness/2) : -logo1Thickness/2)
    : keychain_thickness + bevel_radius - (logo1Flush ? (logo1EmbedDepth + logo1Thickness) : 0);

color(logo1Color)
    translate([0, 0, logo1ZOffset])
        logo(logo1Type, logo1OffsetX, logo1OffsetY, logo1Rotation, logo1Width, logo1Height,
             logo1Thickness, svgFile1, pngFile1, stlFile1);

// Back side logo (Logo 2) - Optional
if(logo2Enabled) {
    logo2ZOffset = logo_centered_z(logo2Type)
        ? -bevel_radius + (logo2Flush ? (logo2EmbedDepth + logo2Thickness/2) : -logo2Thickness/2)
        : -bevel_radius + (logo2Flush ? logo2EmbedDepth : 0);

    color(logo2Color)
        translate([0, 0, logo2ZOffset])
            rotate([0, 180, 0])
                logo(logo2Type, logo2OffsetX, logo2OffsetY, logo2Rotation, logo2Width, logo2Height,
                     logo2Thickness, svgFile2, pngFile2, stlFile2);
}

// ============================================================
// USAGE NOTES
// ============================================================
/*
 * QUICK START GUIDE:
 *
 * SELECT YOUR SHAPE:
 *    keychain_shape = "oval" | "square" | "circle" | "rectangle" | "hexagon" | "custom_svg"
 *    nfc_tag_hole = true/false
 *    body_rotation = 0..360
 *    body_scale = 1.0 (uniform XY scale)
 *
 * 1. PREPARE YOUR IMAGE:
 *    - For photos: Convert to SVG using online tools like:
 *      * vectorizer.io
 *      * convertio.co/jpg-svg/
 *    - Or use PNG directly (may need post-processing)
 *
 * 2. ADD YOUR IMAGE:
 *    - Save image file in the same folder as this .scad file
 *    - Set logo1Type to match your file type
 *    - Update svgFile1 (or pngFile1) with your filename
 *
 * 3. ADJUST SIZE:
 *    - Modify logo1Width and logo1Height to fit
 *    - Oval: Default 22mm x 22mm fits well on 30mm diameter
 *    - Square: Default 22mm x 22mm fits well on 35mm width
 *
 * 4. PRINT SETTINGS:
 *    - Layer height: 0.1-0.2mm recommended
 *    - Enable supports if needed for hanging hole
 *    - Consider pause at layer for multi-color printing
 *    - Insert NFC tag into recess before final layers (if desired)
 *
 * NFC TAG COMPATIBILITY:
 *    - NTAG213/215/216 tags typically 25mm diameter, 0.5mm thick
 *    - Adjust nfc_tag_diameter and nfc_tag_height if needed
 */

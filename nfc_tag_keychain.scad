/*
 * NFC Tag Keychain - Simple Parametric Design
 *
 * Supports multiple body shapes, optional front/back logos, centered NFC recess,
 * and an automatically centered hanging hole at the top of the selected body.
 */

/* [Body] */
tag_color = "#FFFFFF"; // color

// [oval, square, circle, rectangle, hexagon, custom_svg]
keychain_shape = "oval";

// Rotate entire keychain body in XY (degrees)
body_rotation = 0;

// Uniform body scale in XY
body_scale = 1;

// Base thickness before edge rounding
keychain_thickness = 1;

// Edge rounding radius
bevel_radius = 1.5;

/* [Shape Sizes] */
// Oval shape parameters
oval_main_diameter = 30;
oval_top_diameter = 15;
oval_center_distance = 15;
oval_side_angle = 30;

// Square (teardrop-like rectangle) parameters
square_width = 35;
square_height = 50;
square_corner_radius = 3;

// Circle/rectangle/hexagon parameters
circle_diameter = 35;
rectangle_width = 35;
rectangle_height = 50;
rectangle_corner_radius = 4;
hexagon_diameter = 38;

// Custom SVG body (used when keychain_shape = "custom_svg")
body_svg_file = "default_body.svg"; // file
body_svg_width = 40;
body_svg_height = 50;

/* [Hanging Hole] */
hanging_hole_enabled = true;

// [top_center, manual]
hole_position_mode = "top_center";

// Keep top_center hole pinned to the visual top after body rotation
hole_top_uses_body_rotation = true;

// Hole diameter and obround length
hole_diameter = 7;
hole_length = 3;

// Distance from top edge to hole outer edge (top_center mode)
hole_margin_from_top = 2;

// Manual position (used only when hole_position_mode = "manual")
hole_center_x = 0;
hole_center_y = 18.7;

// Hole rotation (degrees)
hole_rotation = 0;

/* [NFC Recess] */
nfc_tag_hole = true;
nfc_tag_diameter = 26;
nfc_tag_height = 1.25;

// Keep NFC cutout centered on the keychain body
nfc_centered = true;

// Optional manual offsets if nfc_centered = false
nfc_offset_x = 0;
nfc_offset_y = 0;

/* [Logo 1 - Front] */
logo1Type = "svg"; // [svg,png,stl]
svgFile1 = "default.svg"; // file
pngFile1 = "default.png"; // file
stlFile1 = "default.stl"; // file
logo1Thickness = 0.5;
logo1EmbedDepth = 0;
logo1Flush = true;
logo1Color = "#00FF00"; // color
logo1Width = 22;
logo1Height = 22;
logo1OffsetX = 0;
logo1OffsetY = 0;
logo1Rotation = 0;

/* [Logo 2 - Back] */
logo2Enabled = false;
logo2Type = "svg"; // [svg,png,stl]
svgFile2 = "default.svg"; // file
pngFile2 = "default.png"; // file
stlFile2 = "default.stl"; // file
logo2Thickness = 0.5;
logo2EmbedDepth = 0;
logo2Flush = true;
logo2Color = "#00FF00"; // color
logo2Width = 22;
logo2Height = 22;
logo2OffsetX = 0;
logo2OffsetY = 0;
logo2Rotation = 0;


// ============================================================
// SHAPE HELPERS
// ============================================================


function degcos(a) = cos(a);
function degsin(a) = sin(a);

function body_half_width() =
    keychain_shape == "oval" ? max(oval_main_diameter/2, oval_top_diameter/2) + bevel_radius :
    keychain_shape == "square" ? square_width/2 + bevel_radius :
    keychain_shape == "circle" ? circle_diameter/2 + bevel_radius :
    keychain_shape == "rectangle" ? rectangle_width/2 + bevel_radius :
    keychain_shape == "hexagon" ? hexagon_diameter/2 + bevel_radius :
    keychain_shape == "custom_svg" ? body_svg_width/2 + bevel_radius :
    max(oval_main_diameter/2, oval_top_diameter/2) + bevel_radius;

function body_half_height() =
    keychain_shape == "oval" ? max(oval_main_diameter/2, oval_center_distance + oval_top_diameter/2) + bevel_radius :
    keychain_shape == "square" ? square_height/2 + bevel_radius :
    keychain_shape == "circle" ? circle_diameter/2 + bevel_radius :
    keychain_shape == "rectangle" ? rectangle_height/2 + bevel_radius :
    keychain_shape == "hexagon" ? hexagon_diameter/2 + bevel_radius :
    keychain_shape == "custom_svg" ? body_svg_height/2 + bevel_radius :
    max(oval_main_diameter/2, oval_center_distance + oval_top_diameter/2) + bevel_radius;

function rotated_body_top_y() =
    body_scale * (
        abs(degsin(body_rotation)) * body_half_width() +
        abs(degcos(body_rotation)) * body_half_height()
    );

function resolved_hole_x() = hole_position_mode == "top_center" ? 0 : hole_center_x;

function resolved_hole_y() =
    hole_position_mode == "top_center"
        ? ((hole_top_uses_body_rotation ? rotated_body_top_y() : body_scale * body_half_height()) - hole_margin_from_top - hole_diameter/2)
        : hole_center_y;

module rounded_rectangle_2d(w, h, r) {
    rr = min(r, min(w, h)/2 - 0.01);
    if (rr > 0) {
        hull() {
            translate([-w/2 + rr, -h/2 + rr]) circle(r = rr, $fn=40);
            translate([ w/2 - rr, -h/2 + rr]) circle(r = rr, $fn=40);
            translate([-w/2 + rr,  h/2 - rr]) circle(r = rr, $fn=40);
            translate([ w/2 - rr,  h/2 - rr]) circle(r = rr, $fn=40);
        }
    } else {
        square([w, h], center = true);
    }
}

module hanging_hole() {
    if (hanging_hole_enabled) {
        translate([resolved_hole_x(), resolved_hole_y(), -bevel_radius - 1])
            rotate([0, 0, hole_rotation])
                union() {
                    translate([-hole_length / 2, 0, 0])
                        cylinder(h = keychain_thickness + 2*bevel_radius + 2, r = hole_diameter / 2, $fn=50);
                    translate([ hole_length / 2, 0, 0])
                        cylinder(h = keychain_thickness + 2*bevel_radius + 2, r = hole_diameter / 2, $fn=50);
                    translate([-hole_length / 2, -hole_diameter / 2, 0])
                        cube([hole_length, hole_diameter, keychain_thickness + 2*bevel_radius + 2]);
                }
    }
}


// ============================================================
// BODY SHAPES
// ============================================================

module keychain_oval() {
    radius1 = oval_main_diameter / 2;
    radius2 = oval_top_diameter / 2;

    minkowski() {
        union() {
            cylinder(h = keychain_thickness, r = radius1, $fn=200);

            translate([0, oval_center_distance, 0])
                cylinder(h = keychain_thickness, r = radius2, $fn=100);

            linear_extrude(height = keychain_thickness)
                polygon(points=[
                    [ radius1 * cos(oval_side_angle), radius1 * sin(oval_side_angle)],
                    [ radius2 * cos(oval_side_angle), oval_center_distance + radius2 * sin(oval_side_angle)],
                    [-radius2 * cos(oval_side_angle), oval_center_distance + radius2 * sin(oval_side_angle)],
                    [-radius1 * cos(oval_side_angle), radius1 * sin(oval_side_angle)]
                ]);
        }
        sphere(r = bevel_radius, $fn=50);
    }
}

module keychain_square() {
    minkowski() {
        linear_extrude(height = keychain_thickness)
            rounded_rectangle_2d(square_width, square_height, square_corner_radius);
        sphere(r = bevel_radius, $fn=50);
    }
}

module keychain_circle() {
    minkowski() {
        cylinder(h = keychain_thickness, r = circle_diameter / 2, $fn=180);
        sphere(r = bevel_radius, $fn=50);
    }
}

module keychain_rectangle() {
    minkowski() {
        linear_extrude(height = keychain_thickness)
            rounded_rectangle_2d(rectangle_width, rectangle_height, rectangle_corner_radius);
        sphere(r = bevel_radius, $fn=50);
    }
}

module keychain_hexagon() {
    minkowski() {
        linear_extrude(height = keychain_thickness)
            circle(d = hexagon_diameter, $fn=6);
        sphere(r = bevel_radius, $fn=50);
    }
}

module keychain_custom_svg() {
    if (body_svg_file != "default_body.svg") {
        minkowski() {
            linear_extrude(height = keychain_thickness)
                resize([body_svg_width, body_svg_height], auto = true)
                    import(file = body_svg_file, center = true);
            sphere(r = bevel_radius, $fn=50);
        }
    } else {
        echo("Set body_svg_file to a valid SVG when keychain_shape = custom_svg");
    }
}


// ============================================================
// LOGO + NFC HELPERS
// ============================================================

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

function logo_present(logoType, svgFile, pngFile, stlFile) =
    (logoType == "svg" && svgFile != "default.svg") ||
    (logoType == "png" && pngFile != "default.png") ||
    (logoType == "stl" && stlFile != "default.stl");

function logo_centered_z(logoType) = logoType != "png";

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

module nfc_hole() {
    if(nfc_tag_hole) {
        translate([
            nfc_centered ? 0 : nfc_offset_x,
            nfc_centered ? 0 : nfc_offset_y,
            0
        ])
            cylinder(h = nfc_tag_height, r = nfc_tag_diameter / 2, $fn=100);
    }
}


// ============================================================
// FINAL ASSEMBLY
// ============================================================

module keychain_body() {
    if (keychain_shape == "oval") {
        keychain_oval();
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
        keychain_oval();
    }
}

color(tag_color)
    difference() {
        rotate([0, 0, body_rotation])
            scale([body_scale, body_scale, 1])
                difference() {
                    keychain_body();
                    nfc_hole();
                    logo1_recess();
                    logo2_recess();
                }
        hanging_hole();
    }
}

color(tag_color)
    rotate([0, 0, body_rotation])
        scale([body_scale, body_scale, 1])
            difference() {
                keychain_body();
                hanging_hole();
                nfc_hole();
                logo1_recess();
                logo2_recess();
            }

logo1ZOffset = logo_centered_z(logo1Type)
    ? keychain_thickness + bevel_radius - (logo1Flush ? (logo1EmbedDepth + logo1Thickness/2) : -logo1Thickness/2)
    : keychain_thickness + bevel_radius - (logo1Flush ? (logo1EmbedDepth + logo1Thickness) : 0);

color(logo1Color)
    translate([0, 0, logo1ZOffset])
        logo(logo1Type, logo1OffsetX, logo1OffsetY, logo1Rotation, logo1Width, logo1Height,
             logo1Thickness, svgFile1, pngFile1, stlFile1);

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

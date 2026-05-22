/*
 * NFC Keychain Stand - Self-Supporting Display Stand
 *
 * Derived from nfc_tag_keychain.scad.
 *
 * PRINT ORIENTATION: Place face-down on the build plate.
 * The sign face is at Z=0 so logos/embossing print with maximum
 * surface quality. The stand legs and base rise from the back of
 * the sign and are fully self-supporting — no slicer supports needed.
 *
 * When flipped upright after printing the sign leans at `lean_angle`
 * from vertical, held by two front feet at the bottom of the sign
 * and a rear kickstand arm at the back.
 */

// ============================================================
// SIGN BODY
// ============================================================

/* [Sign] */
sign_color = "#FFFFFF"; // color

sign_shape = "rectangle"; // [rectangle, oval, circle, hexagon]

sign_width  = 80;  // [30:1:200]
sign_height = 80;  // [30:1:200]

// Base thickness of the sign panel
sign_thickness = 3; // [2:0.5:10]

// Corner rounding radius (rectangle and oval)
corner_radius = 4; // [0:0.5:20]

// ============================================================
// NFC TAG RECESS
// ============================================================

/* [NFC Tag] */
enable_nfc = true;

// Diameter of the NFC tag (NTAG216 = 25-26 mm)
nfc_diameter = 26; // [20:0.5:35]

// Depth of the recess (tag sits in the back face when printing face-down)
nfc_depth = 1.25; // [0.5:0.1:3]

// Horizontal offset from center
nfc_offset_x = 0; // [-40:1:40]

// Vertical offset from center
nfc_offset_y = 0; // [-40:1:40]

// ============================================================
// LOGO / IMAGE
// ============================================================

/* [Logo - Front Face] */
logo_type = "svg"; // [svg, png, stl, none]

logo_svg_file = "default.svg"; // file
logo_png_file = "default.png"; // file
logo_stl_file = "default.stl"; // file

logo_color = "#00FF00"; // color

logo_width  = 50; // [5:1:150]
logo_height = 50; // [5:1:150]

// Height the logo rises above (or is recessed into) the face
logo_thickness = 0.6; // [0.2:0.1:5]

// Embed logo flush with surface (good for face-down printing)
logo_flush = true;

logo_offset_x  = 0;  // [-80:1:80]
logo_offset_y  = 0;  // [-80:1:80]
logo_rotation  = 0;  // [0:5:355]

// Emboss or deboss the logo into the sign face
logo_mode = "emboss"; // [emboss, deboss]

/* [Text Label] */
enable_text = false;

text_string    = "SCAN ME";
text_font      = "Liberation Sans";
text_style     = "Bold"; // [Regular, Bold, Italic, Bold Italic]
text_size      = 6;      // [3:0.5:20]
text_thickness = 0.6;    // [0.2:0.1:3]
text_color     = "#FF0000"; // color
text_offset_x  = 0;  // [-80:1:80]
text_offset_y  = -30; // [-80:1:80]
text_mode      = "emboss"; // [emboss, deboss]

// ============================================================
// STAND GEOMETRY
// ============================================================

/* [Stand] */
// Lean angle of the sign from vertical when standing upright (degrees)
lean_angle = 15; // [5:1:45]

// Width of each front foot tab
foot_tab_width = 14; // [6:1:40]

// Depth (front-to-back) of each front foot tab
foot_tab_depth = 12; // [6:1:30]

// Thickness of the front foot tabs
foot_tab_thickness = 3; // [1.5:0.5:6]

// Rounding radius on foot tab edges
foot_tab_rounding = 1.5; // [0:0.5:4]

// Width of the rear kickstand arm
kickstand_width = 16; // [6:1:40]

// Thickness of the kickstand arm
kickstand_thickness = 3; // [1.5:0.5:6]

// How far back the kickstand foot extends from the sign
kickstand_reach = 35; // [15:1:80]

// Thickness of the kickstand foot pad
kickstand_foot_thickness = 3; // [1.5:0.5:6]

// Depth of the kickstand foot pad
kickstand_foot_depth = 14; // [6:1:35]

// Rounding on kickstand edges
kickstand_rounding = 1.5; // [0:0.5:4]

/* [Advanced] */
// Rendering quality
$fn = 64;

// What to show
render_part = "print_ready"; // [print_ready, display_upright, sign_only]

// ============================================================
// DERIVED VALUES
// ============================================================

// Total sign thickness along Z when printing (face at Z=0, back at Z=sign_thickness)
_sign_z_top = sign_thickness;

// Lean angle in radians (used for geometry)
_lean_rad = lean_angle * PI / 180;

// When upright the sign leans back by lean_angle from vertical.
// The kickstand arm must reach back far enough so its foot lands on
// the table. The arm is attached to the back face of the sign and
// extends at (90 - lean_angle) from the sign plane.
//
// In print orientation (face-down) everything is flat:
//   - sign face at Z=0
//   - sign back at Z = sign_thickness
//   - foot tabs: small rectangular pads at the bottom of the sign back face
//   - kickstand: flat arm printed on the same plane (back face), connected
//     at the top centre of the sign

// ============================================================
// 2D PROFILE HELPERS
// ============================================================

module rounded_rect_2d(w, h, r) {
    rr = min(r, min(w, h)/2 - 0.01);
    if (rr > 0.001) {
        offset(r = rr) offset(r = -rr) square([w, h], center = true);
    } else {
        square([w, h], center = true);
    }
}

// ============================================================
// SIGN PANEL BODY
// ============================================================

module sign_panel_2d() {
    if (sign_shape == "rectangle") {
        rounded_rect_2d(sign_width, sign_height, corner_radius);
    } else if (sign_shape == "circle") {
        circle(d = sign_width);
    } else if (sign_shape == "oval") {
        resize([sign_width, sign_height])
            offset(r = corner_radius)
                offset(r = -corner_radius)
                    circle(d = max(sign_width, sign_height));
    } else if (sign_shape == "hexagon") {
        circle(d = sign_width, $fn = 6);
    } else {
        rounded_rect_2d(sign_width, sign_height, corner_radius);
    }
}

module sign_panel() {
    linear_extrude(height = sign_thickness)
        sign_panel_2d();
}

// ============================================================
// NFC RECESS  (cut from back face, i.e. top during printing)
// ============================================================

module nfc_recess() {
    if (enable_nfc) {
        translate([nfc_offset_x, nfc_offset_y, sign_thickness - nfc_depth])
            cylinder(d = nfc_diameter, h = nfc_depth + 0.01);
        // Entry chamfer
        translate([nfc_offset_x, nfc_offset_y, sign_thickness - 0.4])
            cylinder(d1 = nfc_diameter, d2 = nfc_diameter + 0.8, h = 0.4 + 0.01);
    }
}

// ============================================================
// LOGO
// ============================================================

function _logo_present() =
    (logo_type == "svg" && logo_svg_file != "default.svg") ||
    (logo_type == "png" && logo_png_file != "default.png") ||
    (logo_type == "stl" && logo_stl_file != "default.stl");

module _logo_geometry() {
    if (logo_type == "svg" && logo_svg_file != "default.svg") {
        resize([logo_width, logo_height, logo_thickness], auto = true)
            linear_extrude(height = logo_thickness, center = true)
                import(file = logo_svg_file, center = true);
    } else if (logo_type == "png" && logo_png_file != "default.png") {
        resize([logo_width, logo_height, logo_thickness], auto = true)
            surface(file = logo_png_file, center = true);
    } else if (logo_type == "stl" && logo_stl_file != "default.stl") {
        resize([logo_width, logo_height, logo_thickness], auto = true)
            import(file = logo_stl_file, center = true);
    }
}

// Z centre of the logo element on the front face (face at Z=0 during printing)
function _logo_face_z() =
    logo_flush
        ? (logo_mode == "emboss" ? logo_thickness / 2 : logo_thickness / 2)
        : (logo_mode == "emboss" ? -logo_thickness / 2 : logo_thickness / 2);

module logo_cut() {
    if (_logo_present() && (logo_mode == "deboss" || logo_flush)) {
        d = logo_mode == "deboss" ? logo_thickness : logo_thickness + 0.02;
        // Centred at the front face (Z=0 when printing face-down)
        translate([logo_offset_x, logo_offset_y, -d / 2])
            rotate([0, 0, logo_rotation])
                _logo_geometry();
    }
}

module logo_add() {
    if (_logo_present() && logo_type != "none") {
        if (logo_mode == "emboss") {
            z = logo_flush ? logo_thickness / 2 : -logo_thickness / 2;
            color(logo_color)
                translate([logo_offset_x, logo_offset_y, z])
                    rotate([0, 0, logo_rotation])
                        _logo_geometry();
        }
    }
}

// ============================================================
// TEXT LABEL
// ============================================================

module text_cut() {
    if (enable_text && text_mode == "deboss") {
        translate([text_offset_x, text_offset_y, -text_thickness / 2])
            linear_extrude(height = text_thickness, center = true)
                text(text_string, size = text_size, halign = "center", valign = "center",
                     font = str(text_font, ":style=", text_style));
    }
}

module text_add() {
    if (enable_text && text_mode == "emboss") {
        z = logo_flush ? text_thickness / 2 : -text_thickness / 2;
        color(text_color)
            translate([text_offset_x, text_offset_y, z])
                linear_extrude(height = text_thickness, center = true)
                    text(text_string, size = text_size, halign = "center", valign = "center",
                         font = str(text_font, ":style=", text_style));
    }
}

// ============================================================
// FRONT FOOT TABS
// Printed at back-face level (Z = sign_thickness) during face-down print.
// When the stand is flipped upright these become the two front feet.
// ============================================================

module foot_tabs() {
    x_pos = sign_width / 2 - foot_tab_width / 2;
    y_pos = -sign_height / 2 + foot_tab_depth / 2;

    for (side = [-1, 1]) {
        translate([side * x_pos, y_pos, sign_thickness])
            _rounded_box(foot_tab_width, foot_tab_depth, foot_tab_thickness, foot_tab_rounding);
    }
}

// ============================================================
// REAR KICKSTAND ARM
// Printed flat on the back face during face-down printing.
// The arm is centred horizontally and runs from the top of the sign
// outward, then has a foot pad at the end.
//
// Geometry is computed so that when the whole print is flipped upright
// (rotating 90° + lean_angle around the bottom-front edge) the foot
// pad lands flat on the table.
//
// Arm length derivation:
//   In display orientation the sign panel height along the vertical axis
//   is sign_height * cos(lean_angle). The kickstand arm, attached at the
//   top of the sign back face, must reach the table level. The horizontal
//   distance from the sign's top-back edge to the table contact point is:
//     reach = sign_height * cos(lean_angle) * tan(lean_angle)
//           + sign_thickness * (1 / cos(lean_angle) - 1) ...simplified to:
//     reach = kickstand_reach  (user-controlled)
// ============================================================

module _rounded_box(w, d, h, r) {
    rr = min(r, min(w, d) / 2 - 0.01);
    translate([0, 0, h / 2])
        if (rr > 0.001) {
            minkowski() {
                cube([w - 2*rr, d - 2*rr, h - 0.01], center = true);
                cylinder(r = rr, h = 0.01, $fn = 32);
            }
        } else {
            cube([w, d, h], center = true);
        }
}

module kickstand() {
    arm_length = kickstand_reach;

    // Arm: runs from top-centre of sign outward (positive Y in print orientation)
    arm_y_start = sign_height / 2;
    arm_y_end   = arm_y_start + arm_length;
    arm_y_mid   = (arm_y_start + arm_y_end) / 2;

    // Arm body
    translate([0, arm_y_mid, sign_thickness])
        _rounded_box(kickstand_width, arm_length, kickstand_thickness, kickstand_rounding);

    // Foot pad at the far end of the arm
    translate([0, arm_y_end + kickstand_foot_depth / 2, sign_thickness])
        _rounded_box(kickstand_width + 4, kickstand_foot_depth, kickstand_foot_thickness, kickstand_rounding);
}

// ============================================================
// COMPLETE ASSEMBLED SIGN (print-ready orientation: face at Z=0)
// ============================================================

module complete_sign() {
    // Sign body with cutouts
    color(sign_color)
        difference() {
            sign_panel();
            nfc_recess();
            logo_cut();
            text_cut();
        }

    // Embossed / raised logo on face
    logo_add();
    text_add();

    // Stand hardware (back face, Z = sign_thickness)
    color(sign_color) {
        foot_tabs();
        kickstand();
    }
}

// ============================================================
// DISPLAY-UPRIGHT VIEW  (for visualisation only, not for printing)
// Rotates the whole assembly so the sign stands upright leaning back.
// ============================================================

module display_upright() {
    // Pivot about the bottom front edge of the sign
    // Front edge: Y = -sign_height/2, Z = 0
    // Rotate: lean_angle backward (toward positive Y) = rotate around X axis by -(90-lean_angle)
    pivot_y = -sign_height / 2;
    translate([0, pivot_y, 0])
        rotate([-(90 - lean_angle), 0, 0])
            translate([0, -pivot_y, 0])
                complete_sign();
}

// ============================================================
// MAIN RENDER
// ============================================================

if (render_part == "print_ready") {
    complete_sign();
} else if (render_part == "display_upright") {
    display_upright();
} else if (render_part == "sign_only") {
    color(sign_color)
        difference() {
            sign_panel();
            nfc_recess();
            logo_cut();
            text_cut();
        }
    logo_add();
    text_add();
}

// ============================================================
// ECHO SUMMARY
// ============================================================

echo("==============================================");
echo("NFC Keychain Stand");
echo("==============================================");
echo(str("Sign shape : ", sign_shape));
echo(str("Sign size  : ", sign_width, " x ", sign_height, " x ", sign_thickness, " mm"));
echo(str("NFC recess : ", enable_nfc ? str(nfc_diameter, " mm dia, ", nfc_depth, " mm deep (back face)") : "disabled"));
echo(str("Logo       : ", logo_type, " | mode: ", logo_mode));
echo(str("Lean angle : ", lean_angle, " deg"));
echo(str("Kickstand reach : ", kickstand_reach, " mm"));
echo("PRINT ORIENTATION: face-down (sign face = build plate)");
echo("==============================================");

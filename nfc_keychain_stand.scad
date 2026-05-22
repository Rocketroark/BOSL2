/*
 * NFC Keychain Pedestal Stand
 *
 * A desk/table pedestal sign — the sign panel stands upright on a solid
 * L-shaped base that extends forward from the bottom, exactly like a
 * classic photo-frame or desk-nameplate stand.
 *
 * PRINT ORIENTATION: face-down on the build plate.
 *   - Sign face is at Z = 0 (on the plate) for best surface quality.
 *   - The base foot extends up from the back during printing.
 *   - Fully self-supporting; no slicer supports needed.
 *
 * After printing, flip the piece upright — the sign leans slightly back
 * and rests on the base foot.
 *
 * All components are independently adjustable via the Customizer.
 */

// ============================================================
// SIGN PANEL
// ============================================================

/* [Sign Panel] */
sign_color = "#FFFFFF"; // color

// Shape of the sign face
sign_shape = "rectangle"; // [rectangle, circle, oval, hexagon]

// Sign width (mm)
sign_width = 100; // [40:1:250]

// Sign height (mm)
sign_height = 120; // [40:1:300]

// Sign panel thickness (mm)
sign_thickness = 3; // [2:0.5:10]

// Corner rounding radius for rectangle / oval (mm)
corner_radius = 6; // [0:0.5:30]

// ============================================================
// BASE / FOOT
// ============================================================

/* [Base Foot] */
// How far the base foot extends forward from the sign face (mm)
base_depth = 40; // [15:1:100]

// Thickness of the base foot slab (mm)
base_thickness = 5; // [2:0.5:15]

// The base foot matches the sign width by default; set to 0 to use sign_width
base_width_override = 0; // [0:1:250]

// Fillet radius where the sign panel meets the base foot (mm)
fillet_radius = 6; // [0:0.5:20]

// Corner rounding on the base foot edges (mm)
base_corner_radius = 4; // [0:0.5:20]

// ============================================================
// NFC TAG RECESS
// ============================================================

/* [NFC Tag] */
enable_nfc = true;

// Diameter of the NFC tag (NTAG216 = 25-26 mm)
nfc_diameter = 26; // [20:0.5:35]

// Depth of the recess (cut into the back face of the sign)
nfc_depth = 1.25; // [0.5:0.1:3]

// Horizontal offset from centre
nfc_offset_x = 0; // [-60:1:60]

// Vertical offset from centre  (positive = up on the sign face)
nfc_offset_y = 0; // [-80:1:80]

// ============================================================
// LOGO / IMAGE  (front face of sign)
// ============================================================

/* [Logo] */
logo_type = "svg"; // [svg, png, stl, none]

logo_svg_file = "default.svg"; // file
logo_png_file = "default.png"; // file
logo_stl_file = "default.stl"; // file

logo_color = "#00FF00"; // color

// Logo width (mm)
logo_width = 60; // [5:1:200]

// Logo height (mm)
logo_height = 60; // [5:1:200]

// Logo element thickness (mm)
logo_thickness = 0.6; // [0.2:0.1:5]

// Sink logo flush with sign face (recommended for face-down printing)
logo_flush = true;

// Emboss (raise) or deboss (sink) the logo
logo_mode = "emboss"; // [emboss, deboss]

logo_offset_x = 0;  // [-100:1:100]
logo_offset_y = 10; // [-100:1:100]
logo_rotation = 0;  // [0:5:355]

// ============================================================
// TEXT LABEL
// ============================================================

/* [Text Label] */
enable_text = false;

text_string    = "SCAN ME";
text_font      = "Liberation Sans";
text_style     = "Bold"; // [Regular, Bold, Italic, Bold Italic]
text_size      = 8;      // [3:0.5:30]
text_thickness = 0.6;    // [0.2:0.1:3]
text_color     = "#333333"; // color

text_offset_x  = 0;   // [-100:1:100]
text_offset_y  = -40; // [-100:1:100]
text_rotation  = 0;   // [0:5:355]

// Emboss or deboss
text_mode = "emboss"; // [emboss, deboss]

// ============================================================
// RENDER CONTROL
// ============================================================

/* [Render] */
// print_ready  = face-down (sign face on build plate) — use this for slicing
// display_view = upright as it looks on a desk — for visual preview only
render_mode = "print_ready"; // [print_ready, display_view]

/* [Advanced] */
$fn = 64;

// ============================================================
// DERIVED VALUES  (do not edit)
// ============================================================

_base_w = (base_width_override > 0) ? base_width_override : sign_width;

// ============================================================
// 2D HELPERS
// ============================================================

module _rounded_rect_2d(w, h, r) {
    rr = min(r, min(w, h) / 2 - 0.01);
    if (rr > 0.001) {
        offset(r = rr) offset(r = -rr) square([w, h], center = true);
    } else {
        square([w, h], center = true);
    }
}

// ============================================================
// SIGN PANEL SHAPE
// ============================================================

module sign_face_2d() {
    if (sign_shape == "rectangle") {
        _rounded_rect_2d(sign_width, sign_height, corner_radius);
    } else if (sign_shape == "circle") {
        circle(d = sign_width);
    } else if (sign_shape == "oval") {
        resize([sign_width, sign_height])
            circle(d = max(sign_width, sign_height));
    } else if (sign_shape == "hexagon") {
        circle(d = sign_width, $fn = 6);
    } else {
        _rounded_rect_2d(sign_width, sign_height, corner_radius);
    }
}

module sign_panel_solid() {
    linear_extrude(height = sign_thickness)
        sign_face_2d();
}

// ============================================================
// BASE FOOT
// The foot is a flat slab.  When printing face-down:
//   - foot lies in the XY plane at Z = sign_thickness (back face level)
//   - foot extends in +Y (away from the viewer in print orientation)
//   - width matches _base_w, depth = base_depth
// When flipped upright the foot extends forward and down, balancing the sign.
// ============================================================

module base_foot_solid() {
    // Position: flush with back face of sign (Z = sign_thickness),
    // centred on X, extending from the sign bottom (Y = -sign_height/2) outward (+Y).
    translate([0, -sign_height / 2 + base_depth / 2, sign_thickness])
        _rounded_box(_base_w, base_depth, base_thickness, base_corner_radius);
}

// ============================================================
// FILLET  (smooth the inside corner between panel and foot)
// Runs along the full width of the joint.
// Built as a quarter-torus cross-section extruded across the width.
// ============================================================

module junction_fillet() {
    if (fillet_radius > 0.001) {
        // Quarter-circle fillet profile centred at the joint corner
        // Joint is at: Y = -sign_height/2, Z = sign_thickness
        fr = fillet_radius;
        translate([0, -sign_height / 2, sign_thickness])
            rotate([0, 90, 0])
                translate([0, 0, -_base_w / 2])
                    linear_extrude(height = _base_w) {
                        // Profile: fill the inside 90° corner
                        difference() {
                            translate([-fr, 0]) square([fr, fr]);
                            translate([-fr, 0]) circle(r = fr);
                        }
                    }
    }
}

// ============================================================
// NFC RECESS  (cut from the back face = top surface when printing)
// ============================================================

module nfc_recess() {
    if (enable_nfc) {
        translate([nfc_offset_x, nfc_offset_y, sign_thickness - nfc_depth])
            cylinder(d = nfc_diameter, h = nfc_depth + 0.01);
        // Entry chamfer
        translate([nfc_offset_x, nfc_offset_y, sign_thickness - 0.4])
            cylinder(d1 = nfc_diameter, d2 = nfc_diameter + 0.8, h = 0.41);
    }
}

// ============================================================
// LOGO
// ============================================================

function _logo_present() =
    (logo_type == "svg" && logo_svg_file != "default.svg") ||
    (logo_type == "png" && logo_png_file != "default.png") ||
    (logo_type == "stl" && logo_stl_file != "default.stl");

module _logo_geo() {
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

// Cut into front face (Z = 0 in print orientation)
module logo_cut() {
    if (_logo_present() && (logo_mode == "deboss" || logo_flush)) {
        d = logo_thickness + 0.02;
        translate([logo_offset_x, logo_offset_y, -d / 2])
            rotate([0, 0, logo_rotation])
                _logo_geo();
    }
}

// Add raised logo on front face
module logo_add() {
    if (_logo_present()) {
        z = logo_flush ? logo_thickness / 2 : -logo_thickness / 2;
        if (logo_mode == "emboss") {
            color(logo_color)
                translate([logo_offset_x, logo_offset_y, z])
                    rotate([0, 0, logo_rotation])
                        _logo_geo();
        }
    }
}

// ============================================================
// TEXT
// ============================================================

module text_cut() {
    if (enable_text && text_mode == "deboss") {
        translate([text_offset_x, text_offset_y, -text_thickness / 2])
            rotate([0, 0, text_rotation])
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
                rotate([0, 0, text_rotation])
                    linear_extrude(height = text_thickness, center = true)
                        text(text_string, size = text_size, halign = "center", valign = "center",
                             font = str(text_font, ":style=", text_style));
    }
}

// ============================================================
// BOX HELPER
// ============================================================

module _rounded_box(w, d, h, r) {
    rr = min(r, min(w, d) / 2 - 0.01);
    translate([0, 0, h / 2])
        if (rr > 0.001) {
            minkowski() {
                cube([max(w - 2*rr, 0.01), max(d - 2*rr, 0.01), max(h - 0.01, 0.01)], center = true);
                cylinder(r = rr, h = 0.01, $fn = 32);
            }
        } else {
            cube([w, d, h], center = true);
        }
}

// ============================================================
// COMPLETE ASSEMBLY  (print orientation: face at Z=0)
// ============================================================

module pedestal_sign() {
    color(sign_color) {
        difference() {
            union() {
                sign_panel_solid();
                base_foot_solid();
                junction_fillet();
            }
            nfc_recess();
            logo_cut();
            text_cut();
        }
    }

    logo_add();
    text_add();
}

// ============================================================
// MAIN RENDER
// ============================================================

if (render_mode == "print_ready") {
    // Face-down: sign face at Z=0, foot extends up and back
    pedestal_sign();
} else {
    // Display view: rotate 90° so the sign stands upright
    // Pivot about the front-bottom edge (Y = -sign_height/2, Z = 0)
    translate([0, -sign_height / 2, 0])
        rotate([-90, 0, 0])
            translate([0, sign_height / 2, 0])
                pedestal_sign();
}

// ============================================================
// SUMMARY
// ============================================================

echo("==============================================");
echo("NFC Keychain Pedestal Stand");
echo("==============================================");
echo(str("Sign  : ", sign_shape, "  ", sign_width, " x ", sign_height, " x ", sign_thickness, " mm"));
echo(str("Base  : ", _base_w, " x ", base_depth, " x ", base_thickness, " mm"));
echo(str("NFC   : ", enable_nfc ? str(nfc_diameter, " mm dia, ", nfc_depth, " mm deep") : "disabled"));
echo(str("Logo  : ", logo_type, "  mode=", logo_mode, "  flush=", logo_flush));
echo(str("Text  : ", enable_text ? text_string : "disabled"));
echo(str("Render: ", render_mode));
echo("PRINT TIP: use render_mode=print_ready, place face-down on build plate.");
echo("==============================================");

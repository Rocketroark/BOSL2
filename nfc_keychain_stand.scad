/*
 * NFC Pedestal Sign — Single-Piece L-Shape
 *
 * One solid extrusion: sign panel + foot in one piece.
 * Print face-down (sign face = build plate). No supports needed.
 *
 * Adjustable: foot depth, foot height, foot angle, fillet, NFC, logo, text.
 */

/* [Sign Panel] */
sign_color    = "#FFFFFF"; // color
sign_width    = 100; // [40:1:250]
sign_height   = 120; // [40:1:300]
sign_thickness = 3;  // [2:0.5:10]
corner_radius  = 6;  // [0:0.5:30]

/* [Foot] */
// Depth the foot extends forward from the sign face (mm)
foot_depth  = 45; // [10:1:180]

// Height of the foot slab (mm)
foot_height = 5;  // [1:0.5:40]

// Angle of foot relative to sign face — 90 = flat L, < 90 tilts sign back (degrees)
foot_angle  = 90; // [45:1:120]

// Fillet radius at the inside corner of the L (mm)
fillet_radius = 6; // [0:0.5:20]

/* [NFC Tag] */
enable_nfc   = true;
nfc_diameter = 26;   // [20:0.5:35]
nfc_depth    = 1.25; // [0.5:0.1:3]
nfc_offset_x = 0;    // [-60:1:60]
nfc_offset_y = 0;    // [-60:1:80]

/* [Logo] */
logo_type      = "svg";          // [svg, png, stl, none]
logo_svg_file  = "default.svg";  // file
logo_png_file  = "default.png";  // file
logo_stl_file  = "default.stl";  // file
logo_color     = "#00FF00";      // color
logo_width     = 60;  // [5:1:200]
logo_height    = 60;  // [5:1:200]
logo_thickness = 0.6; // [0.2:0.1:5]
logo_flush     = true;
logo_mode      = "emboss"; // [emboss, deboss]
logo_offset_x  = 0;  // [-100:1:100]
logo_offset_y  = 10; // [-100:1:100]
logo_rotation  = 0;  // [0:5:355]

/* [Text] */
enable_text    = false;
text_string    = "SCAN ME";
text_font      = "Liberation Sans";
text_style     = "Bold"; // [Regular, Bold, Italic, Bold Italic]
text_size      = 8;      // [3:0.5:30]
text_thickness = 0.6;    // [0.2:0.1:3]
text_color     = "#333333"; // color
text_offset_x  = 0;   // [-100:1:100]
text_offset_y  = -40; // [-100:1:100]
text_mode      = "emboss"; // [emboss, deboss]

/* [Render] */
// print_ready = face-down for slicing | display_view = upright preview
render_mode = "print_ready"; // [print_ready, display_view]

/* [Advanced] */
$fn = 64;

// ── L-profile in the YZ plane ────────────────────────────────
// In print orientation:  Z = up,  Y = depth axis
//   sign face at Z = 0
//   sign back  at Z = sign_thickness
//   foot runs from sign bottom in the +Y direction
//
// foot_angle: angle between foot surface and sign face plane.
//   90° → classic right-angle L
//  <90° → foot tilts so the sign leans back when stood upright

function _foot_dy() = max(0.01, foot_depth) * sin(foot_angle);   // Y extent of foot
function _foot_dz() = max(0.01, foot_depth) * cos(foot_angle);   // Z rise/drop of foot tip

module _L_profile_2d() {
    dy = _foot_dy();
    dz = _foot_dz();
    fr = min(fillet_radius, min(sign_height, foot_depth) / 2 - 0.01);

    // Outer boundary of the L (CCW)
    //   A = top of sign face       (y=0,  z=sign_height)
    //   B = top of sign back       (y=st, z=sign_height)
    //   C = inside corner back     (y=st, z=0)
    //   D = foot tip back          (y=st+dy, z=dz+foot_height)  adjusted for angle
    //   E = foot tip face          (y=st+dy, z=dz)
    //   F = sign bottom face       (y=0,  z=0)
    //
    // Y → horizontal (depth), Z → vertical (height)  [in 2D: X=Y, Y=Z]

    st = sign_thickness;
    fh = foot_height;

    pts = [
        [0,       sign_height],          // A  top-front
        [st,      sign_height],          // B  top-back
        [st,      fr],                   // C1 inside corner (above fillet)
        [st + fr, 0],                    // C2 inside corner (right of fillet)
        [st + dy, dz + fh],              // D  foot back tip top
        [st + dy, dz],                   // E  foot back tip bottom
        [fr,      0],                    // F1 sign bottom (right of fillet)
        [0,       fr],                   // F2 sign bottom (above fillet)
    ];

    if (fr > 0.001) {
        // Use offset trick for corner rounding at inside corner only;
        // the two fillet points make a simple arc manually.
        difference() {
            polygon(pts);
            // carve the inside fillet arc
            translate([st, 0]) circle(r = fr);
        }
        // fill the inside fillet
        translate([st, 0])
            intersection() {
                circle(r = fr);
                square([fr + 1, fr + 1]);
            }
    } else {
        polygon([
            [0,    sign_height],
            [st,   sign_height],
            [st,   0],
            [st + dy, dz + fh],
            [st + dy, dz],
            [0,    0],
        ]);
    }
}

// ── Extrude L-profile to full sign width ─────────────────────
module _L_solid() {
    rotate([90, 0, 90])
        linear_extrude(height = sign_width, center = true)
            _L_profile_2d();
}

// ── NFC recess (back face of sign = Z=sign_thickness top) ───
module _nfc_cut() {
    if (enable_nfc) {
        translate([nfc_offset_x, nfc_offset_y, sign_thickness - nfc_depth])
            cylinder(d = nfc_diameter, h = nfc_depth + 0.01);
        translate([nfc_offset_x, nfc_offset_y, sign_thickness - 0.4])
            cylinder(d1 = nfc_diameter, d2 = nfc_diameter + 0.8, h = 0.41);
    }
}

// ── Logo helpers ─────────────────────────────────────────────
function _logo_ok() =
    (logo_type == "svg" && logo_svg_file != "default.svg") ||
    (logo_type == "png" && logo_png_file != "default.png") ||
    (logo_type == "stl" && logo_stl_file != "default.stl");

module _logo_geo() {
    if (logo_type == "svg" && logo_svg_file != "default.svg")
        resize([logo_width, logo_height, logo_thickness], auto=true)
            linear_extrude(height=logo_thickness, center=true)
                import(file=logo_svg_file, center=true);
    else if (logo_type == "png" && logo_png_file != "default.png")
        resize([logo_width, logo_height, logo_thickness], auto=true)
            surface(file=logo_png_file, center=true);
    else if (logo_type == "stl" && logo_stl_file != "default.stl")
        resize([logo_width, logo_height, logo_thickness], auto=true)
            import(file=logo_stl_file, center=true);
}

module _logo_cut() {
    if (_logo_ok() && (logo_mode == "deboss" || logo_flush)) {
        d = logo_thickness + 0.02;
        translate([logo_offset_x, logo_offset_y, -d/2])
            rotate([0,0,logo_rotation]) _logo_geo();
    }
}

module _logo_add() {
    if (_logo_ok() && logo_mode == "emboss") {
        z = logo_flush ? logo_thickness/2 : -logo_thickness/2;
        color(logo_color)
            translate([logo_offset_x, logo_offset_y, z])
                rotate([0,0,logo_rotation]) _logo_geo();
    }
}

// ── Text helpers ──────────────────────────────────────────────
module _text_cut() {
    if (enable_text && text_mode == "deboss")
        translate([text_offset_x, text_offset_y, -text_thickness/2])
            linear_extrude(height=text_thickness, center=true)
                text(text_string, size=text_size, halign="center", valign="center",
                     font=str(text_font,":style=",text_style));
}

module _text_add() {
    if (enable_text && text_mode == "emboss") {
        z = logo_flush ? text_thickness/2 : -text_thickness/2;
        color(text_color)
            translate([text_offset_x, text_offset_y, z])
                linear_extrude(height=text_thickness, center=true)
                    text(text_string, size=text_size, halign="center", valign="center",
                         font=str(text_font,":style=",text_style));
    }
}

// ── Full assembly ─────────────────────────────────────────────
// Single-piece L-shaped body: sign plate + foot are one continuous solid
module pedestal() {
    color(sign_color)
        difference() {
            _L_solid();
            _nfc_cut();
            _logo_cut();
            _text_cut();
        }
    _logo_add();
    _text_add();
}

// ── Render ────────────────────────────────────────────────────
if (render_mode == "print_ready") {
    pedestal();
} else {
    // Rotate upright: pivot about the bottom-front edge
    translate([0, -sign_height/2, 0])
        rotate([-90, 0, 0])
            translate([0, sign_height/2, 0])
                pedestal();
}

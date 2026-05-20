/*
 * NFC Disc Golf Mini - Parametric Design
 *
 * A disc golf mini marker disc with a true disc-style profile (flight plate
 * with raised rim), a centered NFC tag recess on the underside, and optional
 * embossed/flush logos on the top and bottom faces.
 *
 * Defaults to a 100 mm PDGA-style mini. Drop the diameter to 60-80 mm for
 * a compact pocket mini.
 */

/* [Disc] */
disc_color = "#FFFFFF"; // color

// Outer diameter of the disc (PDGA mini is ~100mm; pocket minis ~60-80mm)
disc_diameter = 100;

// Height of the flight plate (the flat central area, where the logo lives).
// Needs to be at least underside_cup_depth + nfc_tag_height + ~0.8 so a printable
// cap remains above the NFC pocket.
flight_plate_thickness = 4;

// Extra height of the rim above the flight plate
rim_height = 2;

// Radial width of the rim (how thick the lip is, measured inward from the edge)
rim_width = 6;

// Outer edge bevel/rounding radius (gives the disc a softer flying-disc edge)
edge_radius = 1.2;

// Rounding radius at the inner top corner of the rim (where rim meets flight plate)
inner_rim_radius = 1.0;

// Resolution of the rotational extrude (higher = smoother disc, slower preview)
disc_facets = 200;

/* [Underside Cup] */
// Carve a shallow concave "cup" into the underside (typical of real minis).
// The cup makes room for the NFC tag and lightens the print.
underside_cup_enabled = true;

// Depth of the underside cup (measured up from the flat bottom)
underside_cup_depth = 1.4;

// Diameter of the underside cup (should be inside the rim footprint)
underside_cup_diameter = 0; // 0 = auto = disc_diameter - 2*rim_width - 4

// Rounding at the edge of the underside cup
underside_cup_corner_radius = 1.0;

/* [NFC Recess] */
nfc_tag_hole = true;
nfc_tag_diameter = 26;
nfc_tag_height = 1.25;

// Which face holds the NFC cavity: "bottom" is recommended (logo on top stays clean)
nfc_position = "bottom"; // [bottom, top]

// Keep NFC cutout centered on the disc
nfc_centered = true;

// Optional manual offsets if nfc_centered = false
nfc_offset_x = 0;
nfc_offset_y = 0;

/* [Center Marker] */
// Small raised dimple at the dead center of the top — useful for marking a lie precisely
center_marker_enabled = false;
center_marker_diameter = 3;
center_marker_height = 0.6;

/* [Logo 1 - Top] */
logo1Type = "svg"; // [svg,png,stl]
svgFile1 = "default.svg"; // file
pngFile1 = "default.png"; // file
stlFile1 = "default.stl"; // file
logo1Thickness = 0.6;
logo1EmbedDepth = 0;
logo1Flush = true;
logo1Color = "#00AA00"; // color
logo1Width = 60;
logo1Height = 60;
logo1OffsetX = 0;
logo1OffsetY = 0;
logo1Rotation = 0;

/* [Logo 2 - Bottom] */
logo2Enabled = false;
logo2Type = "svg"; // [svg,png,stl]
svgFile2 = "default.svg"; // file
pngFile2 = "default.png"; // file
stlFile2 = "default.stl"; // file
logo2Thickness = 0.5;
logo2EmbedDepth = 0;
logo2Flush = true;
logo2Color = "#00AA00"; // color
logo2Width = 40;
logo2Height = 40;
logo2OffsetX = 0;
logo2OffsetY = 0;
logo2Rotation = 0;


// ============================================================
// DERIVED VALUES
// ============================================================

function disc_radius() = disc_diameter / 2;
function total_thickness() = flight_plate_thickness + rim_height;
function flight_plate_radius() = disc_radius() - rim_width;
function resolved_cup_diameter() =
    underside_cup_diameter > 0
        ? underside_cup_diameter
        : max(disc_diameter - 2*rim_width - 4, disc_diameter * 0.5);


// ============================================================
// DISC BODY
// ============================================================

// 2D profile (r, z) revolved around the Z axis to form the disc.
// Center is at r=0. Bottom is at z=0. Top of rim is at z = total_thickness.
module disc_profile_2d() {
    R   = disc_radius();
    H   = total_thickness();
    fpH = flight_plate_thickness;
    rW  = rim_width;
    er  = max(min(edge_radius, min(rim_width, rim_height, fpH) / 2 - 0.01), 0);
    irr = max(min(inner_rim_radius, min(rim_width, rim_height) / 2 - 0.01), 0);

    // Build the offset profile, then expand it with offset(r=er) to round the
    // outer corners of the rim. The inner-rim transition is handled by an
    // inset+outset round on a separate sub-region.
    offset(r = er) offset(r = -er)
        polygon(points = [
            [0,            0],
            [R,            0],
            [R,            H],
            [R - rW + irr, H],
            // round the inner top corner of the rim
            [R - rW,       H - irr],
            [R - rW,       fpH],
            [0,            fpH],
        ]);
}

module disc_body_solid() {
    rotate_extrude($fn = disc_facets)
        // clip to positive-r half-plane to keep rotate_extrude happy
        intersection() {
            disc_profile_2d();
            translate([0, -1]) square([disc_radius() + 10, total_thickness() + 2]);
        }
}

module underside_cup_cut() {
    if (underside_cup_enabled) {
        cd = resolved_cup_diameter();
        cr = cd / 2;
        cd_h = underside_cup_depth;
        rr = max(min(underside_cup_corner_radius, min(cr, cd_h) - 0.01), 0);
        // Rounded-edge shallow disc cut starting at z=0 (bottom face) and
        // extending up by cd_h. Built as a rotate_extrude of a rounded rectangle.
        rotate_extrude($fn = disc_facets)
            offset(r = rr) offset(r = -rr)
                polygon(points = [
                    [0,   -0.01],
                    [cr,  -0.01],
                    [cr,  cd_h],
                    [0,   cd_h],
                ]);
    }
}


// ============================================================
// NFC + CENTER MARKER
// ============================================================

module nfc_hole() {
    if (nfc_tag_hole) {
        // Bottom: start above the cup floor so the tag sits in the cup with an
        // extra recess cut into the disc material above it. Top: cut down from
        // the rim peak.
        bottom_floor = underside_cup_enabled ? underside_cup_depth : 0;
        z_start = nfc_position == "top"
            ? total_thickness() - nfc_tag_height
            : bottom_floor;
        translate([
            nfc_centered ? 0 : nfc_offset_x,
            nfc_centered ? 0 : nfc_offset_y,
            z_start
        ])
            cylinder(h = nfc_tag_height + 0.01, r = nfc_tag_diameter / 2, $fn = 120);
    }
}

module center_marker() {
    if (center_marker_enabled) {
        translate([0, 0, flight_plate_thickness])
            cylinder(h = center_marker_height, r = center_marker_diameter / 2, $fn = 60);
    }
}


// ============================================================
// LOGO HELPERS (adapted from nfc_tag_keychain.scad)
// ============================================================

module logo(logoType, logoOffsetX, logoOffsetY, logoRotation, logoWidth, logoHeight, logoThickness, svgFile, pngFile, stlFile) {
    if (logoType == "svg") {
        if (svgFile != "default.svg") {
            translate([logoOffsetX, logoOffsetY, 0])
                rotate([0, 0, logoRotation])
                    resize([logoWidth, logoHeight, logoThickness], auto = true)
                        linear_extrude(height = logoThickness, center = true)
                            import(file = svgFile, center = true);
        }
    } else if (logoType == "png") {
        if (pngFile != "default.png") {
            translate([logoOffsetX, logoOffsetY, 0])
                rotate([0, 0, logoRotation])
                    resize([logoWidth, logoHeight, logoThickness], auto = true)
                        surface(file = pngFile, center = true);
        }
    } else if (logoType == "stl") {
        if (stlFile != "default.stl") {
            translate([logoOffsetX, logoOffsetY, 0])
                rotate([0, 0, logoRotation])
                    resize([logoWidth, logoHeight, logoThickness], auto = true)
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
        // Logo sits on the flight plate (top of plate at z = flight_plate_thickness),
        // not on the rim peak.
        top_z = flight_plate_thickness;
        recessZOffset = logo_centered_z(logo1Type)
            ? top_z - logo1EmbedDepth - recessThickness/2
            : top_z - logo1EmbedDepth - recessThickness;
        translate([0, 0, recessZOffset])
            logo(logo1Type, logo1OffsetX, logo1OffsetY, logo1Rotation, logo1Width, logo1Height,
                 recessThickness, svgFile1, pngFile1, stlFile1);
    }
}

module logo2_recess() {
    if (logo2Enabled && logo2Flush && logo_present(logo2Type, svgFile2, pngFile2, stlFile2)) {
        recessThickness = logo2Thickness + logo2EmbedDepth + 0.02;
        // Bottom face in the center is the cup floor when a cup is carved.
        bottom_z = underside_cup_enabled ? underside_cup_depth : 0;
        recessZOffset = logo_centered_z(logo2Type)
            ? bottom_z + logo2EmbedDepth + recessThickness/2
            : bottom_z + logo2EmbedDepth;
        translate([0, 0, recessZOffset])
            rotate([0, 180, 0])
                logo(logo2Type, logo2OffsetX, logo2OffsetY, logo2Rotation, logo2Width, logo2Height,
                     recessThickness, svgFile2, pngFile2, stlFile2);
    }
}


// ============================================================
// FINAL ASSEMBLY
// ============================================================

color(disc_color)
    difference() {
        union() {
            disc_body_solid();
            center_marker();
        }
        underside_cup_cut();
        nfc_hole();
        logo1_recess();
        logo2_recess();
    }

logo1ZOffset = logo_centered_z(logo1Type)
    ? flight_plate_thickness - (logo1Flush ? (logo1EmbedDepth + logo1Thickness/2) : -logo1Thickness/2)
    : flight_plate_thickness - (logo1Flush ? (logo1EmbedDepth + logo1Thickness) : 0);

color(logo1Color)
    translate([0, 0, logo1ZOffset])
        logo(logo1Type, logo1OffsetX, logo1OffsetY, logo1Rotation, logo1Width, logo1Height,
             logo1Thickness, svgFile1, pngFile1, stlFile1);

if (logo2Enabled) {
    bottom_z2 = underside_cup_enabled ? underside_cup_depth : 0;
    logo2ZOffset = logo_centered_z(logo2Type)
        ? bottom_z2 + (logo2Flush ? (logo2EmbedDepth + logo2Thickness/2) : -logo2Thickness/2)
        : bottom_z2 + (logo2Flush ? logo2EmbedDepth : 0);

    color(logo2Color)
        translate([0, 0, logo2ZOffset])
            rotate([0, 180, 0])
                logo(logo2Type, logo2OffsetX, logo2OffsetY, logo2Rotation, logo2Width, logo2Height,
                     logo2Thickness, svgFile2, pngFile2, stlFile2);
}

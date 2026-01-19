/*
 * Parametric NFC Sign - Quick Start Template
 *
 * This template provides a starting point for creating custom NFC signs.
 * Uncomment and modify the sections you need.
 *
 * Usage:
 * 1. Copy this file to your project folder
 * 2. Uncomment the sections you want to customize
 * 3. Modify the values
 * 4. Open in OpenSCAD and render (F5 for preview, F6 for full render)
 */

use <parametric_nfc_sign.scad>

// ============================================================
// BASIC CONFIGURATION
// ============================================================

// Sign dimensions
sign_width = 80;              // Width in mm
sign_height = 80;             // Height in mm
sign_thickness = 3;           // Thickness in mm
corner_radius = 3;            // Rounded corners

// Choose your shape: "rectangle", "circle", "oval", "hexagon", "octagon"
sign_shape = "rectangle";

// ============================================================
// NFC TAG HOUSING
// ============================================================

enable_nfc = true;            // Set to false to disable NFC cavity
nfc_tag_diameter = 26;        // Standard NTAG216 size
nfc_tag_depth = 1.25;         // Depth of cavity
nfc_position = "back";        // "front", "back", or "center"

// Fine-tune NFC position if needed
// nfc_offset_x = 0;
// nfc_offset_y = 0;

// ============================================================
// MAIN IMAGE (Logo, Photo, Icon)
// ============================================================

// Uncomment ONE of these sections:

// --- SVG Image (for logos, vector art) ---
image_type = "svg";
svg_file = "logo.svg";        // Path to your SVG file
image_width = 50;             // Size in mm
image_height = 50;
image_thickness = 1;          // How tall the embossed design is
image_side = "front";         // "front" or "back"

// --- PNG Image (for photos, heightmaps) ---
// image_type = "png";
// png_file = "image.png";    // Path to your PNG file
// image_width = 50;
// image_height = 50;
// image_thickness = 1;
// image_side = "front";

// --- STL File (for 3D models) ---
// image_type = "stl";
// stl_file = "model.stl";
// image_width = 50;
// image_height = 50;
// image_thickness = 1;
// image_side = "front";

// --- No image ---
// image_type = "none";

// Image position adjustments
// image_offset_x = 0;        // Move left/right
// image_offset_y = 0;        // Move up/down
// image_invert = false;      // Set to true for deboss (carved in) instead of emboss (raised)

// ============================================================
// QR CODE
// ============================================================

enable_qr_code = false;       // Set to true to add QR code

// Uncomment if using QR code:
// qr_code_type = "svg";      // "svg" or "png"
// qr_code_svg = "qrcode.svg"; // Path to QR code file
// qr_code_size = 25;          // Size in mm (square)
// qr_code_thickness = 0.8;    // Relief depth
// qr_code_side = "back";      // "front" or "back"
// qr_code_corner = "bottom_right"; // "center", "top_left", "top_right", "bottom_left", "bottom_right"

// Fine-tune QR position if needed:
// qr_code_offset_x = 0;
// qr_code_offset_y = 0;
// qr_code_invert = false;    // Set to true for deboss

// ============================================================
// MOUNTING OPTIONS
// ============================================================

// Choose ONE: "none", "holes", "slot", "magnet", "adhesive_cavity"
mounting_type = "none";

// --- Screw Holes ---
// mounting_type = "holes";
// mounting_hole_diameter = 3.5;    // For M3 screws
// mounting_hole_count = 2;         // Number of holes
// mounting_hole_edge_distance = 8; // Distance from edge

// --- Keyhole Slot (hang on nail) ---
// mounting_type = "slot";
// slot_width = 6;
// slot_height = 10;

// --- Magnet Mounting ---
// mounting_type = "magnet";
// magnet_diameter = 6;       // 6mm or 8mm common
// magnet_depth = 2;          // Thickness of magnet
// magnet_count = 1;          // 1-4 magnets

// --- Adhesive Cavity (for Command strips) ---
// mounting_type = "adhesive_cavity";

// ============================================================
// OPTIONAL: BORDER & TEXT
// ============================================================

// Border frame
enable_border = false;
// border_width = 2;
// border_thickness = 0.5;

// Text label
enable_text = false;
// text_string = "SCAN ME";
// text_size = 6;
// text_thickness = 0.8;
// text_position = "bottom";  // "top", "bottom", "center"

// ============================================================
// RENDER OPTIONS
// ============================================================

// What to render: "assembled", "sign_only", "nfc_test_fit"
render_part = "assembled";

// Print quality (higher = smoother circles, slower render)
circle_quality = 64;          // 16-128, default 64

// ============================================================
// RENDER THE SIGN
// ============================================================

$fn = circle_quality;

if (render_part == "assembled") {
    complete_sign();
} else if (render_part == "sign_only") {
    sign_body();
} else if (render_part == "nfc_test_fit") {
    intersection() {
        complete_sign();
        translate([nfc_offset_x, nfc_offset_y, 0])
            cube([nfc_tag_diameter + 10, nfc_tag_diameter + 10, 20], center=true);
    }
}

// ============================================================
// TIPS
// ============================================================

/*

GETTING STARTED:
1. Replace "logo.svg" with the path to your image file
2. Adjust sign_width and sign_height to your desired size
3. Set enable_nfc = true and nfc_position = "back"
4. Press F5 in OpenSCAD to preview

CREATING QR CODES:
1. Use online QR generator (qr-code-generator.com)
2. Export as SVG or PNG
3. Set qr_code_svg to the file path
4. Set enable_qr_code = true

FILE PATHS:
- Relative paths: "images/logo.svg" (in subfolder)
- Absolute paths: "/home/user/project/logo.svg"
- Use forward slashes, even on Windows

TESTING NFC FIT:
1. Set render_part = "nfc_test_fit"
2. Print just the small test piece
3. Test NFC tag fit
4. Adjust nfc_tag_diameter if needed (±0.5mm)
5. Set render_part = "assembled" for final print

EXPORTING:
1. Press F6 for full render (may take 30-60 seconds)
2. File > Export > Export as STL
3. Import STL into your slicer software

*/

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

// Sign base color
sign_color = "#FFFFFF";  // color

// Choose your shape
sign_shape = "rectangle"; // [rectangle, circle, oval, hexagon, octagon]

// Sign dimensions
sign_width = 80;              // Width in mm
sign_height = 80;             // Height in mm
sign_thickness = 3;           // Thickness in mm
corner_radius = 3;            // Rounded corners

// ============================================================
// NFC TAG HOUSING
// ============================================================

enable_nfc = true;            // Set to false to disable NFC cavity
nfc_tag_diameter = 26;        // Standard NTAG216 size
nfc_tag_depth = 1.25;         // Depth of cavity
nfc_position = "back";        // [front, back, center]

// Fine-tune NFC position if needed
// nfc_offset_x = 0;
// nfc_offset_y = 0;

// ============================================================
// MAIN IMAGE (Logo, Photo, Icon)
// ============================================================

// Choose image type - this will appear as a DROPDOWN in OpenSCAD Customizer
image_type = "svg"; // [none, svg, png, stl]

// Provide BOTH SVG and PNG file paths - OpenSCAD will use the correct one
image_svg_file = "logo.svg";        // Path to your SVG file
image_png_file = "image.png";       // Path to your PNG file (if using PNG)
image_stl_file = "model.stl";       // Path to your STL file (if using STL)

// Image settings
image_width = 50;             // Size in mm
image_height = 50;
image_thickness = 1;          // How tall the embossed design is
image_side = "front";         // [front, back]
image_mode = "emboss";        // [emboss, deboss] - dropdown in customizer
image_color = "#00FF00";      // color - for multi-color printing

// Image position adjustments
// image_offset_x = 0;        // Move left/right
// image_offset_y = 0;        // Move up/down

// ============================================================
// QR CODE
// ============================================================

enable_qr_code = false;       // Set to true to add QR code

// QR code settings (uncomment if using)
// qr_code_type = "svg";      // [svg, png] - dropdown in customizer
// qr_code_svg_file = "qrcode.svg"; // Path to QR code SVG
// qr_code_png_file = "qrcode.png"; // Path to QR code PNG
// qr_code_size = 25;          // Size in mm (square)
// qr_code_thickness = 0.8;    // Relief depth
// qr_code_side = "back";      // [front, back]
// qr_code_corner = "bottom_right"; // [center, top_left, top_right, bottom_left, bottom_right]
// qr_code_mode = "emboss";    // [emboss, deboss]
// qr_code_color = "#000000";  // color

// Fine-tune QR position if needed:
// qr_code_offset_x = 0;
// qr_code_offset_y = 0;

// ============================================================
// MOUNTING OPTIONS
// ============================================================

// Choose ONE - this will be a DROPDOWN in OpenSCAD Customizer
mounting_type = "none"; // [none, holes, slot, magnet, adhesive_cavity]

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
// border_color = "#0000FF";  // color

// Text label
enable_text = false;
// text_string = "SCAN ME";
// text_size = 6;
// text_thickness = 0.8;
// text_position = "bottom";  // [top, bottom, center]
// text_color = "#FF0000";    // color

// ============================================================
// RENDER OPTIONS
// ============================================================

// What to render - DROPDOWN in customizer
render_part = "assembled"; // [assembled, sign_only, nfc_test_fit]

// Print quality (higher = smoother circles, slower render)
circle_quality = 64;          // [16:4:128]

// ============================================================
// RENDER THE SIGN
// ============================================================

$fn = circle_quality;

if (render_part == "assembled") {
    complete_sign();
} else if (render_part == "sign_only") {
    color(sign_color)
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
1. Open this file in OpenSCAD
2. Go to Window > Customizer (or View > Show Customizer)
3. Use the dropdown menus and sliders to customize your sign
4. All the selections like shape, mounting type, etc. appear as DROPDOWNS
5. Press F5 to preview

DROPDOWN FEATURES:
- sign_shape: Select from rectangle, circle, oval, hexagon, octagon
- image_type: Choose svg, png, stl, or none
- image_mode: Toggle between emboss (raised) and deboss (carved)
- mounting_type: Pick your mounting method from dropdown
- render_part: Choose what to export

FILE UPLOADS:
- You can provide BOTH SVG and PNG file paths
- Just set image_type dropdown to choose which one to use
- No need to delete unused file paths
- Example: Keep both "logo.svg" and "logo.png" filled in

CREATING QR CODES:
1. Use online QR generator (qr-code-generator.com)
2. Export as SVG or PNG
3. Set qr_code_svg_file or qr_code_png_file to the file path
4. Set enable_qr_code = true
5. Use qr_code_type dropdown to select svg or png

FILE PATHS:
- Relative paths: "images/logo.svg" (in subfolder)
- Absolute paths: "/home/user/project/logo.svg"
- Use forward slashes, even on Windows

TESTING NFC FIT:
1. Use render_part dropdown, select "nfc_test_fit"
2. Print just the small test piece
3. Test NFC tag fit
4. Adjust nfc_tag_diameter if needed (±0.5mm)
5. Switch back to "assembled" for final print

EXPORTING:
1. Press F6 for full render (may take 30-60 seconds)
2. File > Export > Export as STL
3. Import STL into your slicer software

MULTI-COLOR PRINTING:
- Set image_color, qr_code_color, text_color, border_color
- Your slicer will show these as different colors
- Use filament change or multi-material system

*/

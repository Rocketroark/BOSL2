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
imageType = "svg"; // [none, svg, png, stl]

// Provide BOTH SVG and PNG file paths - OpenSCAD will use the correct one
// Example: "my_logo.svg" or "company_logo.svg"
svgFile = "default.svg";        // Path to your SVG file

// Example: "my_photo.png" or "logo.png"
pngFile = "default.png";        // Path to your PNG file (if using PNG)

// Example: "my_model.stl"
stlFile = "default.stl";        // Path to your STL file (if using STL)

// Image settings
imageWidth = 50;              // Image width in mm
imageHeight = 50;             // Image height in mm
imageThickness = 1;           // How tall the embossed design is
imageSide = "front";          // [front, back]
imageMode = "emboss";         // [emboss, deboss] - dropdown in customizer
imageColor = "#00FF00";       // color - for multi-color printing

// Image position adjustments
// imageOffsetX = 0;          // Move left/right
// imageOffsetY = 0;          // Move up/down

// ============================================================
// QR CODE
// ============================================================

enableQRCode = false;         // Set to true to add QR code

// QR code settings (uncomment if using)
// qrCodeType = "svg";        // [svg, png] - dropdown in customizer
// qrCodeSvgFile = "default.svg"; // Path to QR code SVG (Example: "qrcode.svg")
// qrCodePngFile = "default.png"; // Path to QR code PNG (Example: "qrcode.png")
// qrCodeSize = 25;            // Size in mm (square)
// qrCodeThickness = 0.8;      // Relief depth
// qrCodeSide = "back";        // [front, back]
// qrCodeCorner = "bottom_right"; // [center, top_left, top_right, bottom_left, bottom_right]
// qrCodeMode = "emboss";      // [emboss, deboss]
// qrCodeColor = "#000000";    // color

// Fine-tune QR position if needed:
// qrCodeOffsetX = 0;
// qrCodeOffsetY = 0;

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
- imageType: Choose svg, png, stl, or none
- imageMode: Toggle between emboss (raised) and deboss (carved)
- mounting_type: Pick your mounting method from dropdown
- render_part: Choose what to export

FILE UPLOADS:
- Files use the pattern from nfc_tag_keychain.scad
- Set svgFile = "my_logo.svg", pngFile = "my_logo.png", etc.
- Use the imageType dropdown to choose which file to use
- Default values ("default.svg", "default.png") are ignored
- No need to delete unused file paths

CREATING QR CODES:
1. Use online QR generator (qr-code-generator.com)
2. Export as SVG or PNG
3. Set qrCodeSvgFile or qrCodePngFile to the file path
4. Set enableQRCode = true
5. Use qrCodeType dropdown to select svg or png

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

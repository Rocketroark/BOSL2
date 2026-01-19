# Parametric NFC Sign Generator

A fully customizable 3D printable sign generator with integrated NFC tag housing, image embedding, and QR code support.

## Features

- **Multiple Shape Options**: Rectangle, Circle, Oval, Hexagon, Octagon
- **NFC Tag Housing**: Sized for standard NTAG216 tags (25-26mm diameter)
- **Image Support**: Import PNG, SVG, or STL files as embossed/debossed designs
- **QR Code Integration**: Add scannable QR codes to any corner or center
- **Mounting Options**: Screw holes, keyhole slots, magnet cavities, or adhesive recesses
- **Full Customization**: Size, thickness, border, text, and more

## Quick Start

### Basic Usage

1. Open `parametric_nfc_sign.scad` in OpenSCAD
2. Modify parameters in the Customizer panel (View > Show Customizer)
3. Press F5 to preview, F6 to render
4. Export as STL (File > Export > Export as STL)

### Minimal Example

```scad
// A simple 80x80mm rectangular sign with NFC housing
sign_width = 80;
sign_height = 80;
sign_thickness = 3;
sign_shape = "rectangle";
enable_nfc = true;
```

## Parameter Guide

### Sign Dimensions

| Parameter | Description | Range | Default |
|-----------|-------------|-------|---------|
| `sign_width` | Width in mm | 30-200 | 80 |
| `sign_height` | Height in mm | 30-200 | 80 |
| `sign_thickness` | Base thickness in mm | 2-10 | 3 |
| `corner_radius` | Rounded corner radius | 0-15 | 3 |

### Sign Shape

**Options**: `rectangle`, `circle`, `oval`, `hexagon`, `octagon`

- **Rectangle**: Classic rectangular sign with rounded corners
- **Circle**: Perfect circle (uses `sign_width` as diameter)
- **Oval**: Elliptical shape (set `sign_width` and `sign_height` differently)
- **Hexagon**: Six-sided polygon
- **Octagon**: Eight-sided polygon

### NFC Tag Housing

Based on standard NTAG216 specifications from `nfc_tag_keychain.scad`:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `enable_nfc` | Enable NFC cavity | true |
| `nfc_tag_diameter` | Tag diameter (mm) | 26 |
| `nfc_tag_depth` | Recess depth (mm) | 1.25 |
| `nfc_position` | front/back/center | back |
| `nfc_offset_x` | X position adjustment | 0 |
| `nfc_offset_y` | Y position adjustment | 0 |

**NFC Position Options**:
- `front`: Cavity accessible from front face
- `back`: Cavity accessible from back face (recommended)
- `center`: Cavity through the middle (requires thicker sign)

### Image Settings

Import and embed images as 3D reliefs:

| Parameter | Description |
|-----------|-------------|
| `image_type` | none/svg/png/stl |
| `svg_file` | Path to SVG file |
| `png_file` | Path to PNG file (used as heightmap) |
| `stl_file` | Path to STL file |
| `image_width` | Image width in mm |
| `image_height` | Image height in mm |
| `image_thickness` | Relief depth (0.3-5mm) |
| `image_side` | front/back |
| `image_offset_x` | X position offset |
| `image_offset_y` | Y position offset |
| `image_invert` | false=emboss, true=deboss |

**Image File Tips**:
- **SVG**: Vector files work best for logos and text (use `linear_extrude`)
- **PNG**: Grayscale images create heightmaps (lighter = higher)
- **STL**: Pre-made 3D models can be embedded directly

### QR Code Settings

Add scannable QR codes to your sign:

| Parameter | Description |
|-----------|-------------|
| `enable_qr_code` | Enable QR code | false |
| `qr_code_type` | svg/png |
| `qr_code_svg` | Path to QR SVG file |
| `qr_code_size` | QR code size (square) | 25mm |
| `qr_code_thickness` | Relief depth | 0.8mm |
| `qr_code_side` | front/back |
| `qr_code_corner` | center/top_left/top_right/bottom_left/bottom_right |
| `qr_code_invert` | false=emboss, true=deboss |

**Creating QR Codes**:
1. Generate QR code online (e.g., qr-code-generator.com)
2. Export as SVG or PNG
3. Set file path in `qr_code_svg` or `qr_code_png`

### Mounting Options

**Mounting Types**: `none`, `holes`, `slot`, `magnet`, `adhesive_cavity`

#### Screw Holes (`mounting_type = "holes"`)
| Parameter | Default |
|-----------|---------|
| `mounting_hole_diameter` | 3.5mm |
| `mounting_hole_count` | 2 |
| `mounting_hole_edge_distance` | 8mm |

#### Keyhole Slot (`mounting_type = "slot"`)
Hang on a screw or nail head
| Parameter | Default |
|-----------|---------|
| `slot_width` | 6mm |
| `slot_height` | 10mm |

#### Magnets (`mounting_type = "magnet"`)
Embed circular magnets in back
| Parameter | Default |
|-----------|---------|
| `magnet_diameter` | 6mm |
| `magnet_depth` | 2mm |
| `magnet_count` | 1 |

#### Adhesive Cavity (`mounting_type = "adhesive_cavity"`)
Shallow recess for 3M Command strips or double-sided tape

## Example Configurations

### Example 1: Business Card with NFC

```scad
// Business card sized sign (85x55mm)
sign_width = 85;
sign_height = 55;
sign_thickness = 3;
sign_shape = "rectangle";
corner_radius = 5;

// NFC on back
enable_nfc = true;
nfc_position = "back";

// Logo on front
image_type = "svg";
svg_file = "company_logo.svg";
image_width = 40;
image_height = 40;
image_side = "front";
image_offset_y = 10;

// QR code bottom right
enable_qr_code = true;
qr_code_type = "svg";
qr_code_svg = "website_qr.svg";
qr_code_size = 20;
qr_code_corner = "bottom_right";
qr_code_side = "front";

// Name text
enable_text = true;
text_string = "JOHN DOE";
text_position = "bottom";
text_size = 5;
```

### Example 2: Circular Museum Exhibit Sign

```scad
// 100mm diameter circle
sign_width = 100;
sign_height = 100;
sign_thickness = 4;
sign_shape = "circle";

// NFC centered in back
enable_nfc = true;
nfc_position = "back";
nfc_offset_x = 0;
nfc_offset_y = 0;

// Artifact image on front
image_type = "png";
png_file = "artifact_photo.png";
image_width = 70;
image_height = 70;
image_thickness = 1.5;
image_side = "front";

// Info QR code
enable_qr_code = true;
qr_code_svg = "exhibit_info.svg";
qr_code_size = 25;
qr_code_corner = "bottom_right";
qr_code_side = "back";

// Magnet mount
mounting_type = "magnet";
magnet_diameter = 8;
magnet_depth = 2.5;
magnet_count = 3;
```

### Example 3: Hexagonal Product Tag

```scad
// 60mm hexagon
sign_width = 60;
sign_height = 60;
sign_thickness = 2.5;
sign_shape = "hexagon";

// NFC in back
enable_nfc = true;
nfc_position = "back";

// Product logo debossed
image_type = "svg";
svg_file = "product_logo.svg";
image_width = 35;
image_height = 35;
image_thickness = 0.8;
image_side = "front";
image_invert = true; // Deboss instead of emboss

// Product URL QR code
enable_qr_code = true;
qr_code_svg = "product_url_qr.svg";
qr_code_size = 20;
qr_code_corner = "center";
qr_code_side = "back";

// Keyhole for hanging
mounting_type = "slot";
slot_width = 5;
slot_height = 12;
```

## Export Options

The `render_part` parameter controls what gets generated:

- **`assembled`** (default): Complete sign with all features
- **`sign_only`**: Just the base sign body (for testing)
- **`nfc_test_fit`**: Small cross-section to test NFC tag fit before printing full sign

## Printing Tips

### Recommended Print Settings

- **Layer Height**: 0.2mm (0.12mm for fine details)
- **Infill**: 15-20% (100% for maximum durability)
- **Supports**: Usually not needed
- **Orientation**: Print face-down for best surface quality

### NFC Tag Installation

1. Print with NFC cavity on build plate (face-up printing)
2. Insert NFC tag into cavity while warm (optional)
3. Seal with:
   - Clear epoxy resin (waterproof)
   - Thin adhesive label
   - Small piece of tape

### Multi-Material Printing

For multi-color designs:
1. Use filament change at layer height where images start
2. Or use multi-material printer (Prusa MMU, Bambu AMS, etc.)
3. Images print in different color automatically

### Post-Processing

- **Sanding**: Light sanding on back for smooth finish
- **Painting**: Use primer for better paint adhesion
- **Coating**: Clear coat for weather resistance (outdoor signs)

## File Organization

Recommended folder structure:
```
project/
├── parametric_nfc_sign.scad
├── images/
│   ├── logo.svg
│   ├── photo.png
│   └── icon.stl
├── qr_codes/
│   ├── website_qr.svg
│   └── contact_qr.svg
└── exports/
    └── final_sign.stl
```

## Troubleshooting

### "WARNING: Can't open input file"
- Check file paths are correct (relative to .scad file)
- Use forward slashes: `images/logo.svg` not `images\logo.svg`

### SVG imports as flat shape
- Make sure `linear_extrude` is working
- Some complex SVGs may need simplification

### PNG creates weird bumps
- PNG should be grayscale (not RGB)
- Ensure PNG is high contrast
- Try inverting the image in photo editor

### NFC tag doesn't fit
- Use `nfc_test_fit` render mode first
- Adjust `nfc_tag_diameter` ±0.5mm for better fit
- Print test piece before full sign

### QR code not scannable
- Minimum recommended size: 20mm
- Ensure sufficient relief depth (0.8mm+)
- High contrast helps (black on white)
- Test with emboss AND deboss to see which scans better

## Version History

### v1.0.0 (2026-01-19)
- Initial release
- Support for 5 shape types
- NFC tag housing based on NTAG216 specs
- PNG/SVG/STL image import
- QR code positioning system
- 4 mounting types
- Border and text options

## Credits

- Built with [BOSL2 library](https://github.com/BelfrySCAD/BOSL2)
- NFC specifications from `nfc_tag_keychain.scad`
- Inspired by parametric game insert designs

## License

CC-BY-4.0 - Free to use, modify, and distribute with attribution

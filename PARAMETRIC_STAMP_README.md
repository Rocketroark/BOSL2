# Parametric Stamp Generator

A fully customizable 3D printable stamp model for OpenSCAD using the BOSL2 library.

## Features

### ✨ Image Upload
- **Button-based file upload** in OpenSCAD Customizer
- Support for **SVG** (vector graphics), **PNG** (heightmap), and **STL** (3D models)
- Automatic image mirroring for proper stamping
- Adjustable image size and relief depth
- Emboss or deboss modes

### 📏 Variable Size
- Customizable stamp dimensions (width, height, depth)
- Multiple stamp shapes: rectangle, square, circle, oval
- Adjustable corner radius for rounded edges
- Size range: 20-100mm width/height

### 🛡️ Recessed Face (NEW in v1.1.0)
- **Prevents ink overflow** and blotchy stamps
- Recessed center with raised border
- Image and text elements extend above the recess as raised stamping surfaces
- Adjustable recess depth (0.3-3mm)
- Configurable border width (1-10mm)
- Can be disabled for traditional flat stamp design

### 🎯 Handle Options
Four distinct handle styles:
- **Cylindrical** - Classic round handle with optional dome top
- **Rectangular** - Square grip with rounded cap
- **Knob** - Compact ball-top style
- **Ergonomic** - Tapered design for comfortable grip

Handle customization:
- Adjustable height (10-50mm)
- Variable diameter (15-40mm)
- Grip patterns: smooth, ridged, knurled

### 📝 Text/Script Options
- Custom text engraving
- Multiple positioning: top, bottom, center, or custom
- Font selection support
- Adjustable text size (3-20mm)
- Emboss or deboss modes
- Automatic text mirroring for stamping

## Files

- **`parametric_stamp.scad`** - Full-featured model with all options
- **`parametric_stamp_template.scad`** - Simplified quick-start template

## Quick Start

### Using the Template (Easiest)

1. Open `parametric_stamp_template.scad` in OpenSCAD
2. Click **Window → Customizer** to show the parameter panel
3. Click the **file button** next to "image_file" to upload your image
4. Adjust width, height, and handle style
5. Optional: Enable text and enter your message
6. Press **F5** to preview, **F6** to render
7. Export STL for 3D printing

### Using the Full Model

1. Open `parametric_stamp.scad` in OpenSCAD
2. Enable the Customizer (Window → Customizer)
3. Configure parameters in organized sections:
   - **Basic Stamp Parameters** - Shape and dimensions
   - **Image Settings** - Upload and position your image
   - **Handle Settings** - Choose handle style and grip
   - **Text/Script Options** - Add custom text
   - **Advanced Options** - Fine-tune rendering
4. Preview and export

## Parameter Guide

### Stamp Shapes
- **Rectangle** - Traditional rectangular stamp
- **Square** - Equal sides, uses max(width, height)
- **Circle** - Round stamp, uses max(width, height) as diameter
- **Oval** - Elliptical shape based on width/height ratio

### Image Modes
- **Emboss** - Raised image (adds material)
- **Deboss** - Carved image (removes material) - **Default for stamps**

### Handle Styles

| Style | Description | Best For |
|-------|-------------|----------|
| Cylindrical | Classic round handle | General purpose |
| Rectangular | Square grip | Large stamps |
| Knob | Compact ball top | Small stamps |
| Ergonomic | Tapered comfort grip | Frequent use |

### Grip Patterns
- **Smooth** - Plain surface
- **Ridged** - Vertical grip lines
- **Knurled** - Diamond crosshatch pattern

### Recessed Face Feature

The recessed face is a critical feature for professional stamp quality:

**How it works:**
- The center of the stamp face is lowered by the recess depth
- A raised border remains at the original level
- Image and text elements are raised from the recessed face
- Only the raised elements (image/text) contact the paper when stamping

**Benefits:**
- **Prevents ink overflow** - Ink stays on raised elements only
- **Cleaner impressions** - No blotchy backgrounds
- **Professional results** - Like commercial rubber stamps
- **Better control** - Easier to apply even pressure

**Settings:**
- `enable_face_recess` - Turn feature on/off (default: **true**)
- `face_recess_depth` - How far to lower the center (default: 1.0mm)
- `border_width` - Width of raised edge (default: 3mm)

**Important Note:**
When recess is enabled, image_mode and text_mode are ignored - all elements are automatically raised from the recessed face for proper stamping function.

## Tips for Best Results

### Image Preparation
- **SVG files** work best for crisp, clean designs
- Images are **automatically mirrored** for proper stamping
- Keep image size 85-95% of stamp size for borders
- Use high contrast images for better detail

### Sizing Guidelines
- **Small stamps**: 20-30mm, use knob handle
- **Medium stamps**: 30-60mm, use cylindrical/ergonomic handle
- **Large stamps**: 60-100mm, use rectangular handle

### 3D Printing
- Print with stamp face **down** on build plate
- Use **0.2mm layer height** for good detail
- **100% infill** recommended for durability
- Support may be needed for complex handles
- Material: PLA or PETG work well

### Text Settings
- Text is automatically mirrored for stamping
- Use bold fonts for better ink retention
- Recommended text depth: 0.6-1.0mm
- Position text at bottom for traditional stamp look

## Examples

### Basic Logo Stamp
```
stamp_shape = "circle"
stamp_width = 40
stamp_height = 40
image_type = "svg"
svg_file = "logo.svg"
handle_style = "cylindrical"
```

### Address Stamp with Text
```
stamp_shape = "rectangle"
stamp_width = 60
stamp_height = 40
enable_text = true
text_content = "John Doe"
text_position = "bottom"
handle_style = "ergonomic"
grip_style = "ridged"
```

### Signature Stamp
```
stamp_shape = "oval"
stamp_width = 50
stamp_height = 30
image_type = "svg"
svg_file = "signature.svg"
handle_style = "knob"
image_depth = 1.2
```

## Technical Details

### Dependencies
- OpenSCAD 2021.01 or newer
- BOSL2 library (included in this repository)

### BOSL2 Functions Used
- `cuboid()` - Rounded rectangular prisms
- `cyl()` - Cylinders with edge rounding
- `round2d()` - 2D corner rounding
- `linear_extrude()` - 2D to 3D conversion
- Standard transformations (translate, rotate, mirror)

### File Format Support
- **SVG**: Vector graphics, best for logos and text
- **PNG**: Converted to heightmap, good for photos
- **STL**: 3D models, advanced users

## Troubleshooting

### Image not appearing?
- Ensure file is uploaded (not "default.svg")
- Check image size isn't larger than stamp
- Try increasing image_depth

### Handle too weak?
- Increase handle_diameter
- Use cylindrical or ergonomic style
- Check printer settings (100% infill)

### Text not readable?
- Increase text_size
- Use bold font
- Increase text_depth
- Check text_mode is "deboss"

### Slow rendering?
- Reduce circle_quality (try 50)
- Disable show_handle while editing
- Use F5 (preview) instead of F6 (render)

## Version History

- **v1.1.0** - Recessed Face Feature
  - Added recessed stamp face to prevent ink overflow
  - Configurable recess depth and border width
  - Image and text elements automatically raised from recessed surface
  - Improves stamp quality and professional appearance

- **v1.0.0** - Initial release
  - Multiple stamp shapes
  - Image upload support (SVG/PNG/STL)
  - Four handle styles with grip options
  - Text engraving
  - Full BOSL2 integration

## License

CC-BY-4.0 - Based on BOSL2 library examples

## Credits

Created using the BOSL2 library by Revar Desmera
Inspired by parametric_nfc_sign.scad and nfc_tag_keychain.scad

---

**Happy Stamping! 🖊️**

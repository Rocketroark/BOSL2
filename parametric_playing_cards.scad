/*
 * Parametric Playing Cards Generator
 *
 * This script generates customizable 3D-printable playing cards for OpenSCAD.
 * Supports both SVG (vector) and PNG (raster/heightmap) image formats.
 *
 * QUICK START:
 * 1. Open in OpenSCAD and open Customizer (Window > Customizer)
 * 2. Adjust card dimensions, select suit, and choose which cards to generate
 * 3. Render (F6) and export to STL
 *
 * TO USE CUSTOM IMAGES (EASIEST METHOD):
 * 1. Save your image files (SVG or PNG) in the SAME FOLDER as this .scad file
 * 2. In Customizer, set useCustomImageFiles = true
 * 3. Update filename parameters (e.g., aceImageFilename = "my_ace.svg")
 * 4. Any files left as "default" will use the standard folder structure
 *
 * See full usage instructions at the end of this file.
 */

/* [Card Selection] */
// Which suit to render (hearts, diamonds, spades, clubs)
cardSuit = "spades"; // [spades, hearts, diamonds, clubs]

// Starting card value (0=Joker, 1=Ace, 2-10=Number, 11=Jack, 12=Queen, 13=King)
startCardValue = 0; // [0:13]

// Number of cards to render (default 7 fits on 256x256mm build plate)
cardCount = 7; // [1:14]

// Number of cards per row in the layout
cardsPerRow = 4; // [1:10]

/* [Card Physical Dimensions (mm)] */
// Card width in millimeters (standard poker: 63.5mm / 2.5")
cardWidth = 63.5; // [40:0.5:100]

// Card height in millimeters (standard poker: 88.9mm / 3.5")
cardHeight = 88.9; // [60:0.5:150]

// Corner radius for rounded edges
cornerRadius = 3; // [0:0.5:10]

// Spacing between cards when printing multiple
cardSpacing = 0.4; // [0:0.1:5]

/* [Layer Thickness (mm)] */
// Thickness of the white front layer
frontThickness = 0.3; // [0.1:0.05:1]

// Thickness of the opaque blocker layer (prevents light bleed)
blockerThickness = 0.1; // [0:0.05:0.5]

// Thickness of the colored back layer
backThickness = 0.1; // [0.05:0.05:0.5]

/* [Design Element Sizes (mm)] */
// Height of corner ID letters/numbers (A, 2, K, etc.)
idHeight = 8.5; // [5:0.5:15]

// Height of small corner pip (suit symbol next to ID)
idPipHeight = 8.5; // [5:0.5:15]

// Height of pips on number cards (2-10)
pipHeight = 15; // [10:0.5:30]

// Height of ace center design (suggest 50 for ace of spades, 20 for others)
aceHeight = 50; // [15:1:80]

// Height of joker center design
jokerHeight = 60; // [20:1:100]

// Height of joker corner ID
jokerIdHeight = 20; // [10:1:40]

// Space between corner ID and corner pip
idPipSpacing = 1; // [0:0.5:5]

// Space between corner IDs and card edge
idBorderSpacing = 2; // [0:0.5:10]

// Horizontal offset for corner ID positioning
idXOffset = 0.5; // [-5:0.1:5]

// Height of the back pattern design
backPatternHeight = 82; // [40:1:120]

// Scale factor for royalty card artwork (Jack, Queen, King)
royaltyScale = 0.35; // [0.1:0.05:1]

/* [Card Orientation] */
// Right-handed players fan cards left-to-right, left-handed fan right-to-left
isRightHanded = true;

/* [Image Format] */
// Image format for card designs (SVG for vector graphics, PNG for raster images)
imageFormat = "svg"; // [svg, png]

// For PNG: Invert brightness (true = white areas raised, false = black areas raised)
pngInvert = false;

// For PNG: Convexity value for surface extrusion (increase if preview shows artifacts)
pngConvexity = 10; // [1:20]

/* [Image Files - Use Defaults or Specify Custom] */
// To use custom images: Save your image files in the same folder as this .scad file
// Then update the filename parameters below (just the filename, not full path)
// Leave as "default" to use the standard folder structure

// Use custom image files instead of folder structure
useCustomImageFiles = false;

// Pip/suit symbol image filename (e.g., "my_heart.svg")
pipImageFilename = "default";

// Ace center image filename (e.g., "custom_ace.png")
aceImageFilename = "default";

// Joker image filename (e.g., "my_joker.svg")
jokerImageFilename = "default";

// Card back pattern filename (e.g., "cool_back.png")
backImageFilename = "default";

// Card ID image filenames (A, 2-10, J, Q, K, joker)
idAFilename = "default";
id2Filename = "default";
id3Filename = "default";
id4Filename = "default";
id5Filename = "default";
id6Filename = "default";
id7Filename = "default";
id8Filename = "default";
id9Filename = "default";
id10Filename = "default";
idJFilename = "default";
idQFilename = "default";
idKFilename = "default";
idJokerFilename = "default";

// Jack color layer filenames
jackColor1ImageFilename = "default";
jackColor2ImageFilename = "default";
jackColor3ImageFilename = "default";
jackColor4ImageFilename = "default";

// Queen color layer filenames
queenColor1ImageFilename = "default";
queenColor2ImageFilename = "default";
queenColor3ImageFilename = "default";
queenColor4ImageFilename = "default";

// King color layer filenames
kingColor1ImageFilename = "default";
kingColor2ImageFilename = "default";
kingColor3ImageFilename = "default";
kingColor4ImageFilename = "default";

/* [Standard Image Paths] */
// These settings are only used when useCustomImageFiles = false
// Base directory for all image files (relative to this .scad file)
baseImageDirectory = "classic/";

// Subdirectory for card ID images (A, 2-10, J, Q, K)
idSubdirectory = "ids/";

// Subdirectory structure for suit images
suitsSubdirectory = "suits/";

// Filename for suit pip image (in each suit folder) - without extension
pipFilename = "pip";

// Filename for ace center image (in each suit folder) - without extension
aceFilename = "ace";

// Filename for joker image (in base directory) - without extension
jokerFilename = "joker";

// Filename for card back pattern image (in base directory) - without extension
backPatternFilename = "back";

/* [Royalty Card Image Files] */
// Filenames for Jack color layers (in suit folder) - without extension
jackColor1Filename = "jack_color_1";
jackColor2Filename = "jack_color_2";
jackColor3Filename = "jack_color_3";
jackColor4Filename = "jack_color_4";

// Filenames for Queen color layers (in suit folder) - without extension
queenColor1Filename = "queen_color_1";
queenColor2Filename = "queen_color_2";
queenColor3Filename = "queen_color_3";
queenColor4Filename = "queen_color_4";

// Filenames for King color layers (in suit folder) - without extension
kingColor1Filename = "king_color_1";
kingColor2Filename = "king_color_2";
kingColor3Filename = "king_color_3";
kingColor4Filename = "king_color_4";

/* [Royalty Color Alignment - Jack] */
// X/Y offsets for Jack color layers (adjust if SVG layers don't align)
jackColor1XOffset = 0; // [-10:0.1:10]
jackColor1YOffset = 0; // [-10:0.1:10]
jackColor2XOffset = 0; // [-10:0.1:10]
jackColor2YOffset = 0; // [-10:0.1:10]
jackColor3XOffset = 0; // [-10:0.1:10]
jackColor3YOffset = 0; // [-10:0.1:10]
jackColor4XOffset = 0; // [-10:0.1:10]
jackColor4YOffset = 0; // [-10:0.1:10]

/* [Royalty Color Alignment - Queen] */
// X/Y offsets for Queen color layers (adjust if SVG layers don't align)
queenColor1XOffset = 0; // [-10:0.1:10]
queenColor1YOffset = 0; // [-10:0.1:10]
queenColor2XOffset = 0; // [-10:0.1:10]
queenColor2YOffset = 0; // [-10:0.1:10]
queenColor3XOffset = 0; // [-10:0.1:10]
queenColor3YOffset = 0; // [-10:0.1:10]
queenColor4XOffset = 0; // [-10:0.1:10]
queenColor4YOffset = 0; // [-10:0.1:10]

/* [Royalty Color Alignment - King] */
// X/Y offsets for King color layers (adjust if SVG layers don't align)
kingColor1XOffset = 0; // [-10:0.1:10]
kingColor1YOffset = 0; // [-10:0.1:10]
kingColor2XOffset = 0; // [-10:0.1:10]
kingColor2YOffset = 0; // [-10:0.1:10]
kingColor3XOffset = 0; // [-10:0.1:10]
kingColor3YOffset = 0; // [-10:0.1:10]
kingColor4XOffset = 0; // [-10:0.1:10]
kingColor4YOffset = 0; // [-10:0.1:10]

/* [Colors - Preview Only] */
// These colors are for design-time visualization only
// Final print colors are set in your slicer software
pipColor = "black";
frontColor = "white";
blockerColor = "black";
backColor = "navy";
backPatternColor = "gold";
royaltyColor1 = "black";
royaltyColor2 = "red";
royaltyColor3 = "blue";
royaltyColor4 = "yellow";
jokerColor = "red";

/* [Hidden] */
// Derived Parameters (automatically calculated - do not modify)
fileExtension = str(".", imageFormat);
idDirectory = str(baseImageDirectory, idSubdirectory);
suitDirectory = str(baseImageDirectory, suitsSubdirectory, cardSuit, "/");

// Choose between custom filenames and standard folder structure
pipImageFile = useCustomImageFiles && pipImageFilename != "default"
    ? pipImageFilename
    : str(suitDirectory, pipFilename, fileExtension);

aceImageFile = useCustomImageFiles && aceImageFilename != "default"
    ? aceImageFilename
    : str(suitDirectory, aceFilename, fileExtension);

jokerImageFile = useCustomImageFiles && jokerImageFilename != "default"
    ? jokerImageFilename
    : str(baseImageDirectory, jokerFilename, fileExtension);

backPatternImageFile = useCustomImageFiles && backImageFilename != "default"
    ? backImageFilename
    : str(baseImageDirectory, backPatternFilename, fileExtension);

// Jack color layer files
jackColor1File = useCustomImageFiles && jackColor1ImageFilename != "default"
    ? jackColor1ImageFilename
    : str(suitDirectory, jackColor1Filename, fileExtension);

jackColor2File = useCustomImageFiles && jackColor2ImageFilename != "default"
    ? jackColor2ImageFilename
    : str(suitDirectory, jackColor2Filename, fileExtension);

jackColor3File = useCustomImageFiles && jackColor3ImageFilename != "default"
    ? jackColor3ImageFilename
    : str(suitDirectory, jackColor3Filename, fileExtension);

jackColor4File = useCustomImageFiles && jackColor4ImageFilename != "default"
    ? jackColor4ImageFilename
    : str(suitDirectory, jackColor4Filename, fileExtension);

// Queen color layer files
queenColor1File = useCustomImageFiles && queenColor1ImageFilename != "default"
    ? queenColor1ImageFilename
    : str(suitDirectory, queenColor1Filename, fileExtension);

queenColor2File = useCustomImageFiles && queenColor2ImageFilename != "default"
    ? queenColor2ImageFilename
    : str(suitDirectory, queenColor2Filename, fileExtension);

queenColor3File = useCustomImageFiles && queenColor3ImageFilename != "default"
    ? queenColor3ImageFilename
    : str(suitDirectory, queenColor3Filename, fileExtension);

queenColor4File = useCustomImageFiles && queenColor4ImageFilename != "default"
    ? queenColor4ImageFilename
    : str(suitDirectory, queenColor4Filename, fileExtension);

// King color layer files
kingColor1File = useCustomImageFiles && kingColor1ImageFilename != "default"
    ? kingColor1ImageFilename
    : str(suitDirectory, kingColor1Filename, fileExtension);

kingColor2File = useCustomImageFiles && kingColor2ImageFilename != "default"
    ? kingColor2ImageFilename
    : str(suitDirectory, kingColor2Filename, fileExtension);

kingColor3File = useCustomImageFiles && kingColor3ImageFilename != "default"
    ? kingColor3ImageFilename
    : str(suitDirectory, kingColor3Filename, fileExtension);

kingColor4File = useCustomImageFiles && kingColor4ImageFilename != "default"
    ? kingColor4ImageFilename
    : str(suitDirectory, kingColor4Filename, fileExtension);

handednessMultiplier = isRightHanded ? 1 : -1;

// Helper function to get custom ID filename by card value
function getCustomIdFilename(value) =
    value == "A" ? idAFilename :
    value == "2" ? id2Filename :
    value == "3" ? id3Filename :
    value == "4" ? id4Filename :
    value == "5" ? id5Filename :
    value == "6" ? id6Filename :
    value == "7" ? id7Filename :
    value == "8" ? id8Filename :
    value == "9" ? id9Filename :
    value == "10" ? id10Filename :
    value == "J" ? idJFilename :
    value == "Q" ? idQFilename :
    value == "K" ? idKFilename :
    value == "joker" ? idJokerFilename : "default";

// Helper function to get ID image file path
function getIdImageFile(value) =
    useCustomImageFiles && getCustomIdFilename(value) != "default"
        ? getCustomIdFilename(value)
        : str(idDirectory, value, fileExtension);

// Dynamic Card Positions and Values
cardPositions = [
    for (i = [0:cardCount-1])
        [ (i % cardsPerRow) * (cardWidth + cardSpacing),
          -(floor(i / cardsPerRow)) * (cardHeight + cardSpacing),
          0 ]
];

cardValues = [
    for (i = [0:cardCount-1])
        startCardValue + i == 0 ? "joker" :
        startCardValue + i == 1 ? "A" :
        startCardValue + i <= 10 ? str(startCardValue + i) :
        startCardValue + i == 11 ? "J" :
        startCardValue + i == 12 ? "Q" :
        startCardValue + i == 13 ? "K" : "INVALID"
];

currentValues = [
    for (i = [0:cardCount-1])
        startCardValue + i
];

// ============================================================================
// MAIN CARD GENERATION LOGIC
// ============================================================================
// Program Flow:
// The script generates all instances of each component type sequentially
// (e.g., all fronts, then all blockers, then all backs, etc.) rather than
// completing one card at a time. This sequential approach ensures similar
// components are grouped together in the export order, making it easier to
// assign colors to each component type in a slicer after exporting.

// All Fronts
for (i = [0:cardCount-1]) {
    translate(cardPositions[i]) front();
}

// All Blockers (opaque layer to reduce light bleed)
for (i = [0:cardCount-1]) {
    translate(cardPositions[i]) blocker();
}

// All Backs
for (i = [0:cardCount-1]) {
    translate(cardPositions[i]) back();
}

// All Back Patterns
for (i = [0:cardCount-1]) {
    translate(cardPositions[i]) back_pattern();
}

// All Corner IDs
for (i = [0:cardCount-1]) {
    idImageFile = getIdImageFile(cardValues[i]);
    if (currentValues[i] == 0) {
        translate(cardPositions[i]) ucard_id(idImageFile, jokerIdHeight);
        translate(cardPositions[i]) dcard_id(idImageFile, jokerIdHeight);
    } else {
        translate(cardPositions[i]) ucard_id(idImageFile, idHeight);
        translate(cardPositions[i]) dcard_id(idImageFile, idHeight);
    }
}

// All Corner Pips
for (i = [0:cardCount-1]) {
    if (currentValues[i] >= 1) { // for all cards other than joker (joker doesn't have a suit)
        translate(cardPositions[i]) ucard_id_pip();
        translate(cardPositions[i]) dcard_id_pip();
    }
}

// All non-royalty primary designs
for (i = [0:cardCount-1]) {
    position = cardPositions[i];

    if (currentValues[i] == 0) {
       translate(position) joker();
    }
    else if (currentValues[i] == 1) {
        translate(position) ace();
    }
    else if (currentValues[i] == 2) {
        translate(position) upip(0, cardHeight/3);
        translate(position) dpip(0, cardHeight/3);
    }
    else if (currentValues[i] == 3) {
        translate(position) upip(0, cardHeight/3);
        translate(position) dpip(0, cardHeight/3);
        translate(position) upip(0, 0);
    }
    else if (currentValues[i] == 4) {
        translate(position) upip(cardWidth/5, cardHeight/3);
        translate(position) dpip(cardWidth/5, cardHeight/3);
        translate(position) upip(-cardWidth/5, cardHeight/3);
        translate(position) dpip(-cardWidth/5, cardHeight/3);
    }
    else if (currentValues[i] == 5) {
        translate(position) upip(cardWidth/5, cardHeight/3);
        translate(position) dpip(cardWidth/5, cardHeight/3);
        translate(position) upip(-cardWidth/5, cardHeight/3);
        translate(position) dpip(-cardWidth/5, cardHeight/3);
        translate(position) upip(0, 0);
    }
    else if (currentValues[i] == 6) {
        translate(position) upip(cardWidth/5, cardHeight/3);
        translate(position) dpip(cardWidth/5, cardHeight/3);
        translate(position) upip(-cardWidth/5, cardHeight/3);
        translate(position) dpip(-cardWidth/5, cardHeight/3);
        translate(position) upip(cardWidth/5, 0);
        translate(position) upip(-cardWidth/5, 0);
    }
    else if (currentValues[i] == 7) {
        translate(position) upip(cardWidth/5, cardHeight/3);
        translate(position) dpip(cardWidth/5, cardHeight/3);
        translate(position) upip(-cardWidth/5, cardHeight/3);
        translate(position) dpip(-cardWidth/5, cardHeight/3);
        translate(position) upip(cardWidth/5, 0);
        translate(position) upip(-cardWidth/5, 0);
        translate(position) upip(0, cardHeight/6);
    }
    else if (currentValues[i] == 8) {
        translate(position) upip(cardWidth/5, cardHeight/3);
        translate(position) dpip(cardWidth/5, cardHeight/3);
        translate(position) upip(-cardWidth/5, cardHeight/3);
        translate(position) dpip(-cardWidth/5, cardHeight/3);
        translate(position) upip(cardWidth/5, 0);
        translate(position) upip(-cardWidth/5, 0);
        translate(position) upip(0, cardHeight/6);
        translate(position) dpip(0, cardHeight/6);
    }
    else if (currentValues[i] == 9) {
        translate(position) upip(cardWidth/5, cardHeight/3);
        translate(position) dpip(cardWidth/5, cardHeight/3);
        translate(position) upip(-cardWidth/5, cardHeight/3);
        translate(position) dpip(-cardWidth/5, cardHeight/3);
        translate(position) upip(cardWidth/5, cardHeight/9);
        translate(position) dpip(cardWidth/5, cardHeight/9);
        translate(position) upip(-cardWidth/5, cardHeight/9);
        translate(position) dpip(-cardWidth/5, cardHeight/9);
        translate(position) upip(0, 0);
    }
    else if (currentValues[i] == 10) {
        translate(position) upip(cardWidth/5, cardHeight/3);
        translate(position) dpip(cardWidth/5, cardHeight/3);
        translate(position) upip(-cardWidth/5, cardHeight/3);
        translate(position) dpip(-cardWidth/5, cardHeight/3);
        translate(position) upip(cardWidth/5, cardHeight/9);
        translate(position) dpip(cardWidth/5, cardHeight/9);
        translate(position) upip(-cardWidth/5, cardHeight/9);
        translate(position) dpip(-cardWidth/5, cardHeight/9);
        translate(position) upip(0, cardHeight/4.5);
        translate(position) dpip(0, cardHeight/4.5);
    }
}

// Royalty Color 1 (Jack, Queen, King)
for (i = [0:cardCount-1]) {
    position = cardPositions[i];
    if (currentValues[i] == 11) {
        translate(position) royalty_part(jackColor1File, royaltyColor1, jackColor1XOffset, jackColor1YOffset);
    }
    else if (currentValues[i] == 12) {
        translate(position) royalty_part(queenColor1File, royaltyColor1, queenColor1XOffset, queenColor1YOffset);
    }
    else if (currentValues[i] == 13) {
        translate(position) royalty_part(kingColor1File, royaltyColor1, kingColor1XOffset, kingColor1YOffset);
    }
}

// Royalty Color 2 (Jack, Queen, King)
for (i = [0:cardCount-1]) {
    position = cardPositions[i];
    if (currentValues[i] == 11) {
        translate(position) royalty_part(jackColor2File, royaltyColor2, jackColor2XOffset, jackColor2YOffset);
    }
    else if (currentValues[i] == 12) {
        translate(position) royalty_part(queenColor2File, royaltyColor2, queenColor2XOffset, queenColor2YOffset);
    }
    else if (currentValues[i] == 13) {
        translate(position) royalty_part(kingColor2File, royaltyColor2, kingColor2XOffset, kingColor2YOffset);
    }
}

// Royalty Color 3 (Jack, Queen, King)
for (i = [0:cardCount-1]) {
    position = cardPositions[i];
    if (currentValues[i] == 11) {
        translate(position) royalty_part(jackColor3File, royaltyColor3, jackColor3XOffset, jackColor3YOffset);
    }
    else if (currentValues[i] == 12) {
        translate(position) royalty_part(queenColor3File, royaltyColor3, queenColor3XOffset, queenColor3YOffset);
    }
    else if (currentValues[i] == 13) {
        translate(position) royalty_part(kingColor3File, royaltyColor3, kingColor3XOffset, kingColor3YOffset);
    }
}

// Royalty Color 4 (Jack, Queen, King)
for (i = [0:cardCount-1]) {
    position = cardPositions[i];
    if (currentValues[i] == 11) {
        translate(position) royalty_part(jackColor4File, royaltyColor4, jackColor4XOffset, jackColor4YOffset);
    }
    else if (currentValues[i] == 12) {
        translate(position) royalty_part(queenColor4File, royaltyColor4, queenColor4XOffset, queenColor4YOffset);
    }
    else if (currentValues[i] == 13) {
        translate(position) royalty_part(kingColor4File, royaltyColor4, kingColor4XOffset, kingColor4YOffset);
    }
}

// ============================================================================
// CARD COMPONENT MODULES
// ============================================================================

module front() {
    color(frontColor)
    round_rect_3D(cardWidth, cardHeight, cornerRadius, frontThickness);
}

module back() {
    zOffset = frontThickness/2 + blockerThickness + backThickness/2;
    color(backColor)
    translate([0, 0, zOffset])
    round_rect_3D(cardWidth, cardHeight, cornerRadius, backThickness);
}

module blocker() {
    zOffset = frontThickness/2 + blockerThickness/2;
    color(blockerColor)
    translate([0, 0, zOffset])
    round_rect_3D(cardWidth, cardHeight, cornerRadius, blockerThickness);
}

module back_pattern() {
    zOffset = frontThickness/2 + blockerThickness + backThickness/2;
    color(backPatternColor)
    translate([0, 0, zOffset])
    loadImage(backPatternImageFile, backPatternHeight, backThickness);
}

module dcard_id(imageFile, height=idHeight) {
    rotate([0, 0, 180])
    ucard_id(imageFile, height);
}

module ucard_id(imageFile, height=idHeight) {
    xOffset = (cardWidth/2 - height/2 - idBorderSpacing + idXOffset) * handednessMultiplier;
    yOffset = cardHeight/2 - height/2 - idBorderSpacing;
    color(pipColor)
    translate([xOffset, yOffset, 0])
    rotate([0, 180, 0])
    loadImage(imageFile, height, frontThickness);
}

module dcard_id_pip() {
    rotate([0, 0, 180])
    ucard_id_pip();
}

module ucard_id_pip() {
    xOffset = (cardWidth/2 - idPipHeight/2 - idBorderSpacing + idXOffset) * handednessMultiplier;
    yOffset = cardHeight/2 - idPipHeight/2 - idBorderSpacing - idHeight - idPipSpacing;
    color(pipColor)
    translate([xOffset, yOffset, 0])
    rotate([0, 180, 0])
    loadImage(pipImageFile, idPipHeight, frontThickness);
}

module dpip(xOffset, yOffset) {
    rotate([0, 0, 180])
    upip(xOffset, yOffset);
}

module upip(xOffset, yOffset) {
    color(pipColor)
    translate([xOffset, yOffset, 0])
    rotate([0, 180, 0])
    loadImage(pipImageFile, pipHeight, frontThickness);
}

module royalty_part(imageFile, partColor, xOffset=0, yOffset=0) {
    color(partColor)
    translate([xOffset, yOffset, 0])
    rotate([0, 180, 0])
    scale([royaltyScale, royaltyScale, 1])
    loadImageKeepXY(imageFile, frontThickness);
}

module ace() {
    color(pipColor)
    rotate([0, 180, 0])
    loadImage(aceImageFile, aceHeight, frontThickness);
}

module joker() {
    color(jokerColor)
    rotate([0, 180, 0])
    loadImage(jokerImageFile, jokerHeight, frontThickness);
}

// ============================================================================
// UTILITY MODULES
// ============================================================================

module round_rect_3D(width, height, radius, thickness) {
    hull() {
        for (x = [-1, 1])
        for (y = [-1, 1])
            translate([x * (width/2 - radius), y * (height/2 - radius)])
            cylinder(r=radius, h=thickness, center=true, $fn=64);
    }
}

// Flexible image loader - handles both SVG and PNG formats
module loadImage(imageFile, height, thickness) {
    if (imageFormat == "svg") {
        // SVG: Import as vector, resize by height, and extrude
        resize([0, height, 0], [true, false, false])
        linear_extrude(height=thickness, center=true)
        import(imageFile, center=true);
    } else if (imageFormat == "png") {
        // PNG: Create embossed/raised design from image brightness
        resize([0, height, 0], [true, false, false])
        scale([1, 1, thickness])
        translate([0, 0, -0.5])
        surface(file=imageFile, center=true, invert=pngInvert, convexity=pngConvexity);
    }
}

// Flexible image loader that preserves original X/Y dimensions
module loadImageKeepXY(imageFile, thickness) {
    if (imageFormat == "svg") {
        // SVG: Import as vector and extrude
        linear_extrude(height=thickness, center=true)
        import(imageFile, center=true);
    } else if (imageFormat == "png") {
        // PNG: Create embossed/raised design from image brightness
        scale([1, 1, thickness])
        translate([0, 0, -0.5])
        surface(file=imageFile, center=true, invert=pngInvert, convexity=pngConvexity);
    }
}

// ============================================================================
// USAGE INSTRUCTIONS
// ============================================================================
//
// QUICK START:
// 1. Open this file in OpenSCAD
// 2. Open the Customizer panel (Window > Customizer)
// 3. Adjust the parameters in each section as needed
// 4. Click "Render" (F6) to generate the final model
// 5. Export as STL (File > Export > Export as STL)
//
// COMMON CUSTOMIZATIONS:
//
// To print a different suit:
//   - Change "cardSuit" in [Card Selection]
//
// To print different cards in a suit:
//   - Change "startCardValue" (0=Joker, 1=Ace, 11=Jack, etc.)
//   - Adjust "cardCount" for how many cards to generate
//
// To resize cards:
//   - Adjust "cardWidth" and "cardHeight" in [Card Physical Dimensions]
//   - Scale other elements proportionally in [Design Element Sizes]
//
// To use custom images - METHOD 1 (Custom Files - Easiest):
//   1. Save your image files in the SAME FOLDER as this .scad file
//   2. Set "useCustomImageFiles" = true
//   3. Update the filename parameters (e.g., aceImageFilename = "my_ace.svg")
//   4. Leave as "default" for any images you want to use from the standard folder structure
//
// To use custom images - METHOD 2 (Folder Structure):
//   - Keep "useCustomImageFiles" = false
//   - Create a folder structure matching the pattern below
//   - Update "baseImageDirectory" in [Standard Image Paths] if needed
//
// IMAGE FORMAT NOTES:
// - SVG (vector): Crisp at any size, recommended for clean designs
// - PNG (raster): Creates embossed/raised effect based on brightness
//   - For PNG: White areas = raised (or set pngInvert=true to reverse)
//   - PNG files should be grayscale for best results
//   - Higher resolution PNGs = smoother surfaces but slower rendering
//
// PRINTING TIPS:
// - Generate cards in batches that fit your build plate
// - Default 7 cards fits on 256x256mm build plate
// - Use different filament colors for each component type
// - The sequential generation order helps assign colors in slicer
//
// FILE STRUCTURE FOR CUSTOM IMAGES:
// your_folder/
//   ├── ids/                    (A.svg/.png, 2.svg/.png, ..., J.svg/.png, Q.svg/.png, K.svg/.png, joker.svg/.png)
//   ├── suits/
//   │   ├── hearts/
//   │   │   ├── pip.svg/.png
//   │   │   ├── ace.svg/.png
//   │   │   ├── jack_color_1.svg/.png through jack_color_4.svg/.png
//   │   │   ├── queen_color_1.svg/.png through queen_color_4.svg/.png
//   │   │   └── king_color_1.svg/.png through king_color_4.svg/.png
//   │   ├── diamonds/ (same structure)
//   │   ├── spades/   (same structure)
//   │   └── clubs/    (same structure)
//   ├── joker.svg/.png
//   └── back.svg/.png
//
// CONVERTING IMAGES:
// - To convert PNG to SVG: Use tools like Inkscape (Path > Trace Bitmap)
// - To convert SVG to PNG: Use Inkscape or online converters
// - For best PNG results: Use high-contrast black & white images
//
// CUSTOM IMAGE EXAMPLES:
//
// Example 1 - Custom ace of spades only:
//   1. Save your image as "cool_ace.svg" in the same folder as this file
//   2. Set useCustomImageFiles = true
//   3. Set aceImageFilename = "cool_ace.svg"
//   4. All other cards will use the default folder structure
//
// Example 2 - Custom pip for one suit (e.g., hearts):
//   1. Save your heart image as "my_heart.png" in the same folder
//   2. Set useCustomImageFiles = true
//   3. Set pipImageFilename = "my_heart.png"
//   4. Set cardSuit = "hearts"
//   5. All hearts will now use your custom pip image
//
// Example 3 - Completely custom card ID numbers:
//   1. Save 14 images in the same folder (ace.svg, 2.svg, ..., king.svg, joker.svg)
//   2. Set useCustomImageFiles = true
//   3. Set each ID filename:
//      idAFilename = "ace.svg"
//      id2Filename = "2.svg"
//      ... and so on
//
// Example 4 - Mix custom and default images:
//   1. Save only the images you want to customize in the same folder
//   2. Set useCustomImageFiles = true
//   3. Set filenames only for the images you're customizing
//   4. Leave others as "default" to use the standard folder structure
//

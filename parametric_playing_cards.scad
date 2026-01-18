/*
 * Parametric Playing Cards Generator
 *
 * This script generates customizable 3D-printable playing cards for OpenSCAD.
 * Supports both SVG (vector) and PNG (raster/heightmap) image formats.
 *
 * QUICK START - Desktop OpenSCAD:
 * 1. Open in OpenSCAD and open Customizer (Window > Customizer)
 * 2. Adjust card dimensions, select suit, and choose which cards to generate
 * 3. Render (F6) and export to STL
 *
 * QUICK START - Web-Based OpenSCAD (Thingiverse Customizer, etc.):
 * 1. Each file parameter will have an "Upload" button next to it
 * 2. Click the upload button to select and upload your custom image
 * 3. The tool will automatically fill in the filename for you
 * 4. Leave as "default.svg" to use the standard card images
 *
 * TO USE CUSTOM IMAGES - Desktop Method:
 * 1. Save your image files (SVG or PNG) in the SAME FOLDER as this .scad file
 * 2. In Customizer, set useCustomImageFiles = true
 * 3. Type the filename in the parameter (e.g., aceImageFile = "my_ace.svg")
 * 4. Any files left empty will use the standard folder structure
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
// NOTE FOR WEB USERS: In web-based OpenSCAD tools (Thingiverse Customizer, etc.),
// you'll see an "Upload" button next to each file parameter below.
// Click the button to upload your image - the filename will be filled automatically!
//
// NOTE FOR DESKTOP USERS: Save your image files in the same folder as this .scad file,
// then type the filename in the parameters below (e.g., "my_ace.svg")
//
// Leave as "default.svg" to use the standard folder structure instead

// Use custom image files instead of folder structure
useCustomImageFiles = false;

// Pip/suit symbol image file (e.g., "my_heart.svg")
pipImageFile = "default.svg";

// Ace center image file (e.g., "custom_ace.png")
aceImageFile = "default.svg";

// Joker image file (e.g., "my_joker.svg")
jokerImageFile = "default.svg";

// Card back pattern file (e.g., "cool_back.png")
backImageFile = "default.svg";

// Card ID image files (A, 2-10, J, Q, K, joker)
idAFile = "default.svg";
id2File = "default.svg";
id3File = "default.svg";
id4File = "default.svg";
id5File = "default.svg";
id6File = "default.svg";
id7File = "default.svg";
id8File = "default.svg";
id9File = "default.svg";
id10File = "default.svg";
idJFile = "default.svg";
idQFile = "default.svg";
idKFile = "default.svg";
idJokerFile = "default.svg";

// Jack color layer files
jackColor1ImageFile = "default.svg";
jackColor2ImageFile = "default.svg";
jackColor3ImageFile = "default.svg";
jackColor4ImageFile = "default.svg";

// Queen color layer files
queenColor1ImageFile = "default.svg";
queenColor2ImageFile = "default.svg";
queenColor3ImageFile = "default.svg";
queenColor4ImageFile = "default.svg";

// King color layer files
kingColor1ImageFile = "default.svg";
kingColor2ImageFile = "default.svg";
kingColor3ImageFile = "default.svg";
kingColor4ImageFile = "default.svg";

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

// Choose between custom files and standard folder structure
pipImagePath = useCustomImageFiles && pipImageFile != "default.svg"
    ? pipImageFile
    : str(suitDirectory, pipFilename, fileExtension);

aceImagePath = useCustomImageFiles && aceImageFile != "default.svg"
    ? aceImageFile
    : str(suitDirectory, aceFilename, fileExtension);

jokerImagePath = useCustomImageFiles && jokerImageFile != "default.svg"
    ? jokerImageFile
    : str(baseImageDirectory, jokerFilename, fileExtension);

backPatternImagePath = useCustomImageFiles && backImageFile != "default.svg"
    ? backImageFile
    : str(baseImageDirectory, backPatternFilename, fileExtension);

// Jack color layer paths
jackColor1Path = useCustomImageFiles && jackColor1ImageFile != "default.svg"
    ? jackColor1ImageFile
    : str(suitDirectory, jackColor1Filename, fileExtension);

jackColor2Path = useCustomImageFiles && jackColor2ImageFile != "default.svg"
    ? jackColor2ImageFile
    : str(suitDirectory, jackColor2Filename, fileExtension);

jackColor3Path = useCustomImageFiles && jackColor3ImageFile != "default.svg"
    ? jackColor3ImageFile
    : str(suitDirectory, jackColor3Filename, fileExtension);

jackColor4Path = useCustomImageFiles && jackColor4ImageFile != "default.svg"
    ? jackColor4ImageFile
    : str(suitDirectory, jackColor4Filename, fileExtension);

// Queen color layer paths
queenColor1Path = useCustomImageFiles && queenColor1ImageFile != "default.svg"
    ? queenColor1ImageFile
    : str(suitDirectory, queenColor1Filename, fileExtension);

queenColor2Path = useCustomImageFiles && queenColor2ImageFile != "default.svg"
    ? queenColor2ImageFile
    : str(suitDirectory, queenColor2Filename, fileExtension);

queenColor3Path = useCustomImageFiles && queenColor3ImageFile != "default.svg"
    ? queenColor3ImageFile
    : str(suitDirectory, queenColor3Filename, fileExtension);

queenColor4Path = useCustomImageFiles && queenColor4ImageFile != "default.svg"
    ? queenColor4ImageFile
    : str(suitDirectory, queenColor4Filename, fileExtension);

// King color layer paths
kingColor1Path = useCustomImageFiles && kingColor1ImageFile != "default.svg"
    ? kingColor1ImageFile
    : str(suitDirectory, kingColor1Filename, fileExtension);

kingColor2Path = useCustomImageFiles && kingColor2ImageFile != "default.svg"
    ? kingColor2ImageFile
    : str(suitDirectory, kingColor2Filename, fileExtension);

kingColor3Path = useCustomImageFiles && kingColor3ImageFile != "default.svg"
    ? kingColor3ImageFile
    : str(suitDirectory, kingColor3Filename, fileExtension);

kingColor4Path = useCustomImageFiles && kingColor4ImageFile != "default.svg"
    ? kingColor4ImageFile
    : str(suitDirectory, kingColor4Filename, fileExtension);

handednessMultiplier = isRightHanded ? 1 : -1;

// Helper function to get custom ID file by card value
function getCustomIdFile(value) =
    value == "A" ? idAFile :
    value == "2" ? id2File :
    value == "3" ? id3File :
    value == "4" ? id4File :
    value == "5" ? id5File :
    value == "6" ? id6File :
    value == "7" ? id7File :
    value == "8" ? id8File :
    value == "9" ? id9File :
    value == "10" ? id10File :
    value == "J" ? idJFile :
    value == "Q" ? idQFile :
    value == "K" ? idKFile :
    value == "joker" ? idJokerFile : "";

// Helper function to get ID image path
function getIdImagePath(value) =
    useCustomImageFiles && getCustomIdFile(value) != "default.svg"
        ? getCustomIdFile(value)
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
    idImageFile = getIdImagePath(cardValues[i]);
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
        translate(position) royalty_part(jackColor1Path, royaltyColor1, jackColor1XOffset, jackColor1YOffset);
    }
    else if (currentValues[i] == 12) {
        translate(position) royalty_part(queenColor1Path, royaltyColor1, queenColor1XOffset, queenColor1YOffset);
    }
    else if (currentValues[i] == 13) {
        translate(position) royalty_part(kingColor1Path, royaltyColor1, kingColor1XOffset, kingColor1YOffset);
    }
}

// Royalty Color 2 (Jack, Queen, King)
for (i = [0:cardCount-1]) {
    position = cardPositions[i];
    if (currentValues[i] == 11) {
        translate(position) royalty_part(jackColor2Path, royaltyColor2, jackColor2XOffset, jackColor2YOffset);
    }
    else if (currentValues[i] == 12) {
        translate(position) royalty_part(queenColor2Path, royaltyColor2, queenColor2XOffset, queenColor2YOffset);
    }
    else if (currentValues[i] == 13) {
        translate(position) royalty_part(kingColor2Path, royaltyColor2, kingColor2XOffset, kingColor2YOffset);
    }
}

// Royalty Color 3 (Jack, Queen, King)
for (i = [0:cardCount-1]) {
    position = cardPositions[i];
    if (currentValues[i] == 11) {
        translate(position) royalty_part(jackColor3Path, royaltyColor3, jackColor3XOffset, jackColor3YOffset);
    }
    else if (currentValues[i] == 12) {
        translate(position) royalty_part(queenColor3Path, royaltyColor3, queenColor3XOffset, queenColor3YOffset);
    }
    else if (currentValues[i] == 13) {
        translate(position) royalty_part(kingColor3Path, royaltyColor3, kingColor3XOffset, kingColor3YOffset);
    }
}

// Royalty Color 4 (Jack, Queen, King)
for (i = [0:cardCount-1]) {
    position = cardPositions[i];
    if (currentValues[i] == 11) {
        translate(position) royalty_part(jackColor4Path, royaltyColor4, jackColor4XOffset, jackColor4YOffset);
    }
    else if (currentValues[i] == 12) {
        translate(position) royalty_part(queenColor4Path, royaltyColor4, queenColor4XOffset, queenColor4YOffset);
    }
    else if (currentValues[i] == 13) {
        translate(position) royalty_part(kingColor4Path, royaltyColor4, kingColor4XOffset, kingColor4YOffset);
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
    loadImage(backPatternImagePath, backPatternHeight, backThickness);
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
    loadImage(pipImagePath, idPipHeight, frontThickness);
}

module dpip(xOffset, yOffset) {
    rotate([0, 0, 180])
    upip(xOffset, yOffset);
}

module upip(xOffset, yOffset) {
    color(pipColor)
    translate([xOffset, yOffset, 0])
    rotate([0, 180, 0])
    loadImage(pipImagePath, pipHeight, frontThickness);
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
    loadImage(aceImagePath, aceHeight, frontThickness);
}

module joker() {
    color(jokerColor)
    rotate([0, 180, 0])
    loadImage(jokerImagePath, jokerHeight, frontThickness);
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
// To use custom images - METHOD 1 (Web-Based Tools - Easiest):
//   Web tools like Thingiverse Customizer automatically add upload buttons!
//   1. Set "useCustomImageFiles" = true
//   2. Click the "Upload" button next to any filename parameter
//   3. Select your image file - the filename will be filled automatically
//   4. Leave as "default.svg" for images you want to use from the standard folder
//   5. Render and download your customized cards!
//
// To use custom images - METHOD 2 (Desktop OpenSCAD):
//   1. Save your image files in the SAME FOLDER as this .scad file
//   2. Set "useCustomImageFiles" = true
//   3. Type the filename in the parameter (e.g., aceImageFile = "my_ace.svg")
//   4. Leave as "default.svg" for any images you want to use from the standard folder structure
//
// To use custom images - METHOD 3 (Folder Structure):
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
// Example 1 - Using web-based upload (Thingiverse Customizer, etc.):
//   1. Open this file in a web-based OpenSCAD tool
//   2. Set useCustomImageFiles = true
//   3. Find the aceImageFile parameter
//   4. Click the "Upload" button next to it
//   5. Select your custom ace image (SVG or PNG)
//   6. The tool automatically uploads and sets the filename
//   7. Render and download!
//
// Example 2 - Custom ace of spades only (Desktop):
//   1. Save your image as "cool_ace.svg" in the same folder as this file
//   2. Set useCustomImageFiles = true
//   3. Set aceImageFile = "cool_ace.svg"
//   4. All other cards will use the default folder structure
//
// Example 3 - Custom pip for one suit (e.g., hearts):
//   1. Save your heart image as "my_heart.png" in the same folder
//      (or upload via button in web tools)
//   2. Set useCustomImageFiles = true
//   3. Set pipImageFile = "my_heart.png"
//   4. Set cardSuit = "hearts"
//   5. All hearts will now use your custom pip image
//
// Example 4 - Completely custom card ID numbers:
//   1. Save 14 images in the same folder (ace.svg, 2.svg, ..., king.svg, joker.svg)
//      (or upload each via buttons in web tools)
//   2. Set useCustomImageFiles = true
//   3. Set each ID filename:
//      idAFile = "ace.svg"
//      id2File = "2.svg"
//      ... and so on
//
// Example 5 - Mix custom and default images:
//   1. Save/upload only the images you want to customize
//   2. Set useCustomImageFiles = true
//   3. Set filenames only for the images you're customizing
//   4. Leave others as "default.svg" to use the standard folder structure
//
// NOTE: Web-based tools handle all the file management for you - just click
// upload buttons and the tool handles saving files and setting filenames!
//

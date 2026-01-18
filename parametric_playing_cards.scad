// Parametric Playing Cards Generator
// This script generates customizable 3D-printable playing cards for OpenSCAD
// Use the Customizer panel (Window > Customizer) to easily modify parameters

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

/* [Image Paths] */
// Base directory for all SVG files (relative to this .scad file)
baseSvgDirectory = "classic/";

// Subdirectory for card ID images (A, 2-10, J, Q, K)
idSubdirectory = "ids/";

// Subdirectory structure for suit images
suitsSubdirectory = "suits/";

// Filename for suit pip SVG (in each suit folder)
pipFilename = "pip.svg";

// Filename for ace center SVG (in each suit folder)
aceFilename = "ace.svg";

// Filename for joker SVG (in base directory)
jokerFilename = "joker.svg";

// Filename for card back pattern SVG (in base directory)
backPatternFilename = "back.svg";

/* [Royalty Card Image Files] */
// Filenames for Jack color layers (in suit folder)
jackColor1Filename = "jack_color_1.svg";
jackColor2Filename = "jack_color_2.svg";
jackColor3Filename = "jack_color_3.svg";
jackColor4Filename = "jack_color_4.svg";

// Filenames for Queen color layers (in suit folder)
queenColor1Filename = "queen_color_1.svg";
queenColor2Filename = "queen_color_2.svg";
queenColor3Filename = "queen_color_3.svg";
queenColor4Filename = "queen_color_4.svg";

// Filenames for King color layers (in suit folder)
kingColor1Filename = "king_color_1.svg";
kingColor2Filename = "king_color_2.svg";
kingColor3Filename = "king_color_3.svg";
kingColor4Filename = "king_color_4.svg";

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
idDirectory = str(baseSvgDirectory, idSubdirectory);
suitDirectory = str(baseSvgDirectory, suitsSubdirectory, cardSuit, "/");
pipSvgFile = str(suitDirectory, pipFilename);
aceSvgFile = str(suitDirectory, aceFilename);
jokerSvgFile = str(baseSvgDirectory, jokerFilename);
backPatternSvgFile = str(baseSvgDirectory, backPatternFilename);
handednessMultiplier = isRightHanded ? 1 : -1;

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
    idSvgFile = str(idDirectory, cardValues[i], ".svg");
    if (currentValues[i] == 0) {
        translate(cardPositions[i]) ucard_id(idSvgFile, jokerIdHeight);
        translate(cardPositions[i]) dcard_id(idSvgFile, jokerIdHeight);
    } else {
        translate(cardPositions[i]) ucard_id(idSvgFile, idHeight);
        translate(cardPositions[i]) dcard_id(idSvgFile, idHeight);
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
        translate(position) royalty_part(str(suitDirectory, jackColor1Filename), royaltyColor1, jackColor1XOffset, jackColor1YOffset);
    }
    else if (currentValues[i] == 12) {
        translate(position) royalty_part(str(suitDirectory, queenColor1Filename), royaltyColor1, queenColor1XOffset, queenColor1YOffset);
    }
    else if (currentValues[i] == 13) {
        translate(position) royalty_part(str(suitDirectory, kingColor1Filename), royaltyColor1, kingColor1XOffset, kingColor1YOffset);
    }
}

// Royalty Color 2 (Jack, Queen, King)
for (i = [0:cardCount-1]) {
    position = cardPositions[i];
    if (currentValues[i] == 11) {
        translate(position) royalty_part(str(suitDirectory, jackColor2Filename), royaltyColor2, jackColor2XOffset, jackColor2YOffset);
    }
    else if (currentValues[i] == 12) {
        translate(position) royalty_part(str(suitDirectory, queenColor2Filename), royaltyColor2, queenColor2XOffset, queenColor2YOffset);
    }
    else if (currentValues[i] == 13) {
        translate(position) royalty_part(str(suitDirectory, kingColor2Filename), royaltyColor2, kingColor2XOffset, kingColor2YOffset);
    }
}

// Royalty Color 3 (Jack, Queen, King)
for (i = [0:cardCount-1]) {
    position = cardPositions[i];
    if (currentValues[i] == 11) {
        translate(position) royalty_part(str(suitDirectory, jackColor3Filename), royaltyColor3, jackColor3XOffset, jackColor3YOffset);
    }
    else if (currentValues[i] == 12) {
        translate(position) royalty_part(str(suitDirectory, queenColor3Filename), royaltyColor3, queenColor3XOffset, queenColor3YOffset);
    }
    else if (currentValues[i] == 13) {
        translate(position) royalty_part(str(suitDirectory, kingColor3Filename), royaltyColor3, kingColor3XOffset, kingColor3YOffset);
    }
}

// Royalty Color 4 (Jack, Queen, King)
for (i = [0:cardCount-1]) {
    position = cardPositions[i];
    if (currentValues[i] == 11) {
        translate(position) royalty_part(str(suitDirectory, jackColor4Filename), royaltyColor4, jackColor4XOffset, jackColor4YOffset);
    }
    else if (currentValues[i] == 12) {
        translate(position) royalty_part(str(suitDirectory, queenColor4Filename), royaltyColor4, queenColor4XOffset, queenColor4YOffset);
    }
    else if (currentValues[i] == 13) {
        translate(position) royalty_part(str(suitDirectory, kingColor4Filename), royaltyColor4, kingColor4XOffset, kingColor4YOffset);
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
    loadSvg(backPatternSvgFile, backPatternHeight, backThickness);
}

module dcard_id(svgFile, height=idHeight) {
    rotate([0, 0, 180])
    ucard_id(svgFile, height);
}

module ucard_id(svgFile, height=idHeight) {
    xOffset = (cardWidth/2 - height/2 - idBorderSpacing + idXOffset) * handednessMultiplier;
    yOffset = cardHeight/2 - height/2 - idBorderSpacing;
    color(pipColor)
    translate([xOffset, yOffset, 0])
    rotate([0, 180, 0])
    loadSvg(svgFile, height, frontThickness);
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
    loadSvg(pipSvgFile, idPipHeight, frontThickness);
}

module dpip(xOffset, yOffset) {
    rotate([0, 0, 180])
    upip(xOffset, yOffset);
}

module upip(xOffset, yOffset) {
    color(pipColor)
    translate([xOffset, yOffset, 0])
    rotate([0, 180, 0])
    loadSvg(pipSvgFile, pipHeight, frontThickness);
}

module royalty_part(svgFile, partColor, xOffset=0, yOffset=0) {
    color(partColor)
    translate([xOffset, yOffset, 0])
    rotate([0, 180, 0])
    scale([royaltyScale, royaltyScale, 1])
    loadSvgKeepXY(svgFile, frontThickness);
}

module ace() {
    color(pipColor)
    rotate([0, 180, 0])
    loadSvg(aceSvgFile, aceHeight, frontThickness);
}

module joker() {
    color(jokerColor)
    rotate([0, 180, 0])
    loadSvg(jokerSvgFile, jokerHeight, frontThickness);
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

module loadSvgKeepXY(svgFile, thickness) {
    linear_extrude(height=thickness, center=true)
    import(svgFile, center=true);
}

module loadSvg(svgFile, height, thickness) {
    resize([0, height, 0], [true, false, false])
    linear_extrude(height=thickness, center=true)
    import(svgFile, center=true);
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
// To use custom images:
//   - Create a new folder structure matching: basedir/suits/suitname/
//   - Place your SVG files following the naming convention
//   - Update "baseSvgDirectory" and filenames in [Image Paths]
//
// PRINTING TIPS:
// - Generate cards in batches that fit your build plate
// - Default 7 cards fits on 256x256mm build plate
// - Use different filament colors for each component type
// - The sequential generation order helps assign colors in slicer
//
// FILE STRUCTURE FOR CUSTOM IMAGES:
// your_folder/
//   ├── ids/                    (A.svg, 2.svg, 3.svg, ..., J.svg, Q.svg, K.svg, joker.svg)
//   ├── suits/
//   │   ├── hearts/
//   │   │   ├── pip.svg
//   │   │   ├── ace.svg
//   │   │   ├── jack_color_1.svg through jack_color_4.svg
//   │   │   ├── queen_color_1.svg through queen_color_4.svg
//   │   │   └── king_color_1.svg through king_color_4.svg
//   │   ├── diamonds/ (same structure)
//   │   ├── spades/   (same structure)
//   │   └── clubs/    (same structure)
//   ├── joker.svg
//   └── back.svg
//

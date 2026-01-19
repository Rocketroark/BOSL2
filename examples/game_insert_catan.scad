/*
 * Settlers of Catan - Game Insert Example
 *
 * This example shows how to configure the parametric game insert system
 * for the popular board game Settlers of Catan.
 *
 * Catan box dimensions (standard edition): ~300x215x75mm
 *
 * Components to organize:
 * - Resource cards (2 decks)
 * - Development cards (1 deck)
 * - Hexagonal terrain tiles
 * - Number tokens
 * - Robber piece
 * - Dice (2)
 * - Roads, settlements, cities (5 colors)
 */

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

/* [Box Dimensions - Catan Standard] */
box_width = 295;
box_depth = 210;
box_height = 72;

/* [Container Options] */
wall_thickness = 2.0;
floor_thickness = 1.5;
corner_radius = 2.0;
container_gap = 1.0;

/* [Card Holders] */
// Resource cards holder (larger deck)
enable_resource_cards = true;
resource_card_width = 64;
resource_card_depth = 92;
resource_card_height = 55;
resource_finger_cutout = 25;

// Development cards holder (smaller deck)
enable_dev_cards = true;
dev_card_width = 64;
dev_card_depth = 92;
dev_card_height = 35;
dev_finger_cutout = 25;

/* [Terrain Tiles Storage] */
// Large open compartment for hexagonal tiles
enable_terrain_storage = true;
terrain_width = 145;
terrain_depth = 125;
terrain_height = 40;

/* [Player Pieces] */
// 5 compartments for player colors (roads, settlements, cities)
enable_player_pieces = true;
player_pieces_width = 145;
player_pieces_depth = 80;
player_pieces_height = 30;
player_compartments = 5; // One per player color

/* [Tokens and Accessories] */
// Number tokens and dice
enable_token_tray = true;
token_tray_width = 64;
token_tray_depth = 80;
token_tray_height = 25;
token_compartments_x = 2;
token_compartments_y = 3;

$fn = $preview ? 32 : 64;

//====================================
// CONTAINER MODULES
//====================================

module container_box(width, depth, height, finger_cutout=0) {
    difference() {
        cuboid([width, depth, height],
               rounding=corner_radius,
               edges="Z",
               anchor=BOTTOM);

        translate([0, 0, floor_thickness])
            cuboid([width - 2*wall_thickness,
                    depth - 2*wall_thickness,
                    height - floor_thickness + 0.1],
                   rounding=max(0, corner_radius - wall_thickness),
                   edges="Z",
                   anchor=BOTTOM);

        if (finger_cutout > 0) {
            translate([0, depth/2 - wall_thickness, height - finger_cutout/2])
                rotate([90, 0, 0])
                    cyl(d=finger_cutout, h=wall_thickness*3, anchor=BOTTOM);
        }
    }
}

module card_holder(width, depth, height, cutout) {
    container_box(width, depth, height, finger_cutout=cutout);
}

module storage_bin(width, depth, height) {
    container_box(width, depth, height);
}

module multi_compartment_tray(width, depth, height, compartments_x, compartments_y) {
    container_box(width, depth, height);

    int_width = width - 2*wall_thickness;
    int_depth = depth - 2*wall_thickness;

    if (compartments_x > 1) {
        for (i = [1:compartments_x-1]) {
            translate([int_width * i / compartments_x - int_width/2, 0, floor_thickness])
                cuboid([wall_thickness, int_depth, height - floor_thickness], anchor=BOTTOM);
        }
    }

    if (compartments_y > 1) {
        for (j = [1:compartments_y-1]) {
            translate([0, int_depth * j / compartments_y - int_depth/2, floor_thickness])
                cuboid([int_width, wall_thickness, height - floor_thickness], anchor=BOTTOM);
        }
    }
}

//====================================
// CATAN LAYOUT
//====================================

gap = container_gap;

// Layout: Left column (cards), center (terrain/pieces), right (tokens)
// Calculate positions relative to box origin (bottom-left corner)

// Resource cards - Left side, bottom
if (enable_resource_cards) {
    translate([gap + resource_card_width/2 - box_width/2,
               gap + resource_card_depth/2 - box_depth/2,
               0])
        card_holder(resource_card_width, resource_card_depth,
                   resource_card_height, resource_finger_cutout);
}

// Development cards - Left side, top
if (enable_dev_cards) {
    translate([gap + dev_card_width/2 - box_width/2,
               gap + resource_card_depth + gap + dev_card_depth/2 - box_depth/2,
               0])
        card_holder(dev_card_width, dev_card_depth,
                   dev_card_height, dev_finger_cutout);
}

// Terrain tiles - Center, bottom
if (enable_terrain_storage) {
    translate([gap + resource_card_width + gap + terrain_width/2 - box_width/2,
               gap + terrain_depth/2 - box_depth/2,
               0])
        storage_bin(terrain_width, terrain_depth, terrain_height);
}

// Player pieces - Center, top
if (enable_player_pieces) {
    translate([gap + resource_card_width + gap + player_pieces_width/2 - box_width/2,
               gap + terrain_depth + gap + player_pieces_depth/2 - box_depth/2,
               0])
        multi_compartment_tray(player_pieces_width, player_pieces_depth,
                              player_pieces_height, player_compartments, 1);
}

// Token and dice tray - Right side
if (enable_token_tray) {
    translate([gap + resource_card_width + gap + terrain_width + gap + token_tray_width/2 - box_width/2,
               gap + token_tray_depth/2 - box_depth/2,
               0])
        multi_compartment_tray(token_tray_width, token_tray_depth, token_tray_height,
                              token_compartments_x, token_compartments_y);
}

// Show box outline in preview
if ($preview) {
    %translate([0, 0, box_height/2])
        cuboid([box_width, box_depth, box_height], anchor=CENTER);
}

echo("=== Settlers of Catan Insert ===");
echo(str("Box: ", box_width, "x", box_depth, "x", box_height, "mm"));
echo("Components:");
echo("  - Resource cards holder (55mm high)");
echo("  - Development cards holder (35mm high)");
echo("  - Terrain tiles storage (145x125mm)");
echo("  - 5-compartment player pieces tray");
echo("  - 6-compartment token and dice tray");

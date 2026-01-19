/*
 * Ticket to Ride - Game Insert Example
 *
 * This example demonstrates a game insert configuration for Ticket to Ride,
 * showing how to organize train cards, destination tickets, train pieces,
 * and stations for multiple players.
 *
 * Ticket to Ride box dimensions (standard): ~300x230x75mm
 *
 * Components to organize:
 * - Train car cards (multiple colors)
 * - Destination ticket cards
 * - Train pieces (5 player colors, 45 pieces each)
 * - Station markers
 * - Scoring markers
 * - Game board (stores on top)
 */

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

/* [Box Dimensions - Ticket to Ride] */
box_width = 295;
box_depth = 225;
box_height = 70;

/* [Container Options] */
wall_thickness = 2.0;
floor_thickness = 1.5;
corner_radius = 2.5;
container_gap = 1.0;

/* [Train Card Storage] */
// Main card holder for train car cards
enable_train_cards = true;
train_card_width = 70;
train_card_depth = 100;
train_card_height = 65;
train_finger_cutout = 30;

/* [Destination Tickets] */
// Smaller holder for destination tickets
enable_destination_cards = true;
dest_card_width = 70;
dest_card_depth = 50;
dest_card_height = 35;
dest_finger_cutout = 20;

/* [Train Pieces Storage] */
// 5 compartments for player train pieces
enable_train_pieces = true;
train_pieces_width = 145;
train_pieces_depth = 100;
train_pieces_height = 30;

/* [Station and Marker Storage] */
// Multi-compartment for stations and scoring markers
enable_markers = true;
marker_width = 70;
marker_depth = 65;
marker_height = 25;
marker_compartments_x = 2;
marker_compartments_y = 2;

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

module train_piece_organizer(width, depth, height) {
    // Container with 5 angled compartments for easy access
    container_box(width, depth, height);

    // 5 vertical dividers for player colors
    int_width = width - 2*wall_thickness;
    int_depth = depth - 2*wall_thickness;

    for (i = [1:4]) {
        translate([int_width * i / 5 - int_width/2, 0, floor_thickness])
            cuboid([wall_thickness, int_depth, height - floor_thickness],
                   anchor=BOTTOM);
    }
}

module multi_compartment_tray(width, depth, height, comp_x, comp_y) {
    container_box(width, depth, height);

    int_width = width - 2*wall_thickness;
    int_depth = depth - 2*wall_thickness;

    if (comp_x > 1) {
        for (i = [1:comp_x-1]) {
            translate([int_width * i / comp_x - int_width/2, 0, floor_thickness])
                cuboid([wall_thickness, int_depth, height - floor_thickness],
                       anchor=BOTTOM);
        }
    }

    if (comp_y > 1) {
        for (j = [1:comp_y-1]) {
            translate([0, int_depth * j / comp_y - int_depth/2, floor_thickness])
                cuboid([int_width, wall_thickness, height - floor_thickness],
                       anchor=BOTTOM);
        }
    }
}

//====================================
// TICKET TO RIDE LAYOUT
//====================================

gap = container_gap;

// Layout strategy: Cards on left, train pieces center, markers right

// Train car cards - Left side
if (enable_train_cards) {
    translate([gap + train_card_width/2 - box_width/2,
               gap + train_card_depth/2 - box_depth/2,
               0])
        card_holder(train_card_width, train_card_depth,
                   train_card_height, train_finger_cutout);
}

// Destination ticket cards - Left side, back
if (enable_destination_cards) {
    translate([gap + dest_card_width/2 - box_width/2,
               gap + train_card_depth + gap + dest_card_depth/2 - box_depth/2,
               0])
        card_holder(dest_card_width, dest_card_depth,
                   dest_card_height, dest_finger_cutout);
}

// Train pieces organizer - Center
if (enable_train_pieces) {
    translate([gap + train_card_width + gap + train_pieces_width/2 - box_width/2,
               gap + train_pieces_depth/2 - box_depth/2,
               0])
        train_piece_organizer(train_pieces_width, train_pieces_depth,
                            train_pieces_height);
}

// Marker compartments - Right side
if (enable_markers) {
    translate([gap + train_card_width + gap + train_pieces_width + gap + marker_width/2 - box_width/2,
               gap + marker_depth/2 - box_depth/2,
               0])
        multi_compartment_tray(marker_width, marker_depth, marker_height,
                              marker_compartments_x, marker_compartments_y);
}

// Additional small tray for stations (right side, back)
translate([gap + train_card_width + gap + train_pieces_width + gap + marker_width/2 - box_width/2,
           gap + marker_depth + gap + 35 - box_depth/2,
           0])
    multi_compartment_tray(marker_width, 65, 20, 5, 1);

// Show box outline in preview
if ($preview) {
    %translate([0, 0, box_height/2])
        cuboid([box_width, box_depth, box_height], anchor=CENTER);
}

echo("=== Ticket to Ride Insert ===");
echo(str("Box: ", box_width, "x", box_depth, "x", box_height, "mm"));
echo("Components:");
echo("  - Train car cards (main deck)");
echo("  - Destination tickets");
echo("  - 5-compartment train pieces organizer");
echo("  - 4-compartment marker tray");
echo("  - 5-compartment station tray");
echo("All pieces fit with game board on top");

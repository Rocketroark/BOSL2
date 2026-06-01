// --- Seamless L-Shaped Sign with Smart NFC Pocket ---

/* [Main Sign Dimensions] */
sign_width = 100;      
sign_length = 60;      
sign_thickness = 4;    

/* [Foot Dimensions] */
foot_length = 40;      
foot_thickness = 4;    
foot_angle = 90;       

/* [Rounding] */
rounding_radius = 1.5;

/* [NFC Recess] */
enable_nfc_recess = true;
// 0 = Embedded Z-Center, 1 = Surface Pocket, 2 = Side-Loading Slot
nfc_style = 0;         
nfc_tag_diameter = 26;
nfc_tag_height = 1.25;
nfc_tolerance = 0.4;   // Adds clearance so the tag actually fits

nfc_centered = true;
nfc_offset_x = 0;
nfc_offset_y = 0;

/* [Advanced] */
$fn = 40;              

module nfc_recess(plate_center_y) {
    if (enable_nfc_recess) {
        // Calculate final dimensions including real-world printer tolerance
        d = nfc_tag_diameter + nfc_tolerance;
        h = nfc_tag_height + nfc_tolerance;
        
        x_pos = nfc_centered ? sign_width / 2 : sign_width / 2 + nfc_offset_x;
        y_pos = nfc_centered ? plate_center_y : plate_center_y + nfc_offset_y;
        
        // The '#' symbol forces OpenSCAD to render the subtraction in red
        #union() {
            if (nfc_style == 0) {
                // 0: Embedded in the exact center of the Z-axis
                translate([x_pos, y_pos, (sign_thickness - h) / 2])
                    cylinder(h = h, d = d, $fn = 100);
                    
            } else if (nfc_style == 1) {
                // 1: Open pocket flush with the top face
                translate([x_pos, y_pos, sign_thickness - h + 0.01])
                    cylinder(h = h, d = d, $fn = 100);
                    
            } else if (nfc_style == 2) {
                // 2: Internal Z-centered pocket with a slide-in channel from the left edge
                translate([x_pos, y_pos, (sign_thickness - h) / 2])
                    cylinder(h = h, d = d, $fn = 100);
                translate([-1, y_pos - d/2, (sign_thickness - h) / 2])
                    cube([x_pos + 1, d, h]);
            }
        }
    }
}

module seamless_l_sign() {
    A = max(5, min(175, foot_angle));

    Px = foot_length * cos(A) - foot_thickness * sin(A);
    Py = sign_thickness + foot_length * sin(A) + foot_thickness * cos(A);

    X_bottom_outer = Px - (Py / sin(A)) * cos(A);
    shift_x = -X_bottom_outer;

    profile_points = [
        [ shift_x + X_bottom_outer, 0 ],               
        [ shift_x + sign_length, 0 ],                  
        [ shift_x + sign_length, sign_thickness ],     
        [ shift_x + 0, sign_thickness ],               
        [ shift_x + foot_length * cos(A), sign_thickness + foot_length * sin(A) ], 
        [ shift_x + Px, Py ]                           
    ];

    r = min(rounding_radius, sign_thickness/2 - 0.01, foot_thickness/2 - 0.01);

    difference() {
        multmatrix(m = [
            [0, 0, 1, 0],
            [1, 0, 0, 0],
            [0, 1, 0, 0],
            [0, 0, 0, 1]
        ])
        if (r > 0) {
            translate([0, 0, r])
            minkowski() {
                linear_extrude(height = sign_width - 2*r)
                offset(r = -r)
                polygon(profile_points);
                sphere(r = r);
            }
        } else {
            linear_extrude(height = sign_width)
            polygon(profile_points);
        }

        translate([-100, -100, -100])
        cube([sign_width + 200, sign_length + foot_length + 200, 100]);

        // Triggers the NFC cutout
        nfc_recess(shift_x + sign_length / 2);
    }
}

seamless_l_sign();

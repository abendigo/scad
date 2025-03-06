use <MCAD/triangles.scad>

import("./GRIPS - STL for other slicers.stl");

drawer_depth = 70;
drawer_clearance = 5;

// STL is centered in the middle grid
gridfinity = 42;
bin_depth = 45.5;

left_thickness = 0.75;
left_lip_thickness = 0.75;

right_thickness = 0.75;
right_lip_thickness = 0.75;

top_thickness = 1.5;
top_lip_thickness = 1.5;

bottom_thickness = 1.5;
bottom_lip_thickness = 1.5;

height = bin_depth + 0;

// How far the parts are exploded
offset = 10;

// Grid is 5x7, centerd around the center grid
left = (gridfinity/2) - (gridfinity*3);
right = (gridfinity/2) + offset + (gridfinity*2);
top = (gridfinity/2) + offset + (gridfinity*3);
bottom = (gridfinity/2) - (gridfinity*4);


topLeft_leftLip_length = 40;
topLeft_topLip_length = 50;

topRight_rightLip_length = 35;
topRight_topLip_length = 25;

bottomLeft_bottomLip_length = 50;
bottomLeft_leftLip_length = 40;

bottomRight_rightLip_length = 35;
bottomRight_bottomLip_length = 25;

lip_height_overlap = 10;
lip_height = drawer_depth - height - drawer_clearance;

triangle_leg = 25;

// Tolereance for joining pieces
fudge = .25;
fudge_height = 10;

module topRight_rightLip() {
    rotate([180, 270, 0])
        triangle(triangle_leg, lip_height, right_lip_thickness);
    cube([right_lip_thickness, topRight_rightLip_length + top_thickness, lip_height]);
}

module topLeft_leftLip() {
    rotate([180, 270, 0])
        triangle(triangle_leg, lip_height, left_lip_thickness);
    cube([left_lip_thickness, topLeft_leftLip_length + top_thickness, lip_height]);
}

module bottomRight_rightLip() {
    translate([right_lip_thickness, 0, 0])
        rotate([0, 270, 0])
            triangle(triangle_leg, lip_height, right_lip_thickness);
    translate([0, -(bottomRight_rightLip_length + bottom_thickness), 0])
        cube([right_lip_thickness, bottomRight_rightLip_length + bottom_thickness, lip_height]);
}

module bottomLeft_leftLip() {
    translate([left_lip_thickness, 0, 0])
        rotate([0, 270, 0])
            triangle(triangle_leg, lip_height, left_lip_thickness);
    translate([0, -(bottomLeft_leftLip_length + bottom_thickness), 0])
        cube([left_lip_thickness, bottomLeft_leftLip_length + bottom_thickness, lip_height]);
}

module topRight() {
    grids_x = 2;
    grids_y = 4;

    // Top
    translate([right - gridfinity*grids_x, top, 0]) {
        translate([fudge, 0, 0])
            cube([gridfinity*grids_x - fudge, top_thickness, fudge_height]);
        translate([0, 0, fudge_height])
            cube([gridfinity*grids_x, top_thickness, height - fudge_height]);

        // Outside slope
        translate([0, top_thickness, height]) {
            rotate(a=[0, 90, 0]) 
                triangle(top_lip_thickness, lip_height_overlap, gridfinity*grids_x + right_thickness);
        }

        // Lip
        translate([gridfinity*grids_x - topRight_topLip_length, top_thickness, height]) {
            translate([0, 0, 0])
                cube([topRight_topLip_length + right_thickness, top_lip_thickness, lip_height]);
            translate([0, top_lip_thickness, 0])
                rotate([90, 270, 0])
                    triangle(triangle_leg, lip_height, top_lip_thickness);
        }

    }

    // Right
    translate([right, top - gridfinity*grids_y, 0]) {
        translate([0, fudge, 0])
            cube([right_thickness, gridfinity*grids_y - fudge, fudge_height]);
        translate([0, 0, fudge_height])
            cube([right_thickness, gridfinity*grids_y, height - fudge_height]);

        // Lip
        translate([0, gridfinity*grids_y - topRight_rightLip_length, height]) topRight_rightLip();
    }

    // Corner
    translate([right, top, 0]) cube([right_thickness, top_thickness, height]);
}

module topLeft() {
    grids_x = 3;
    grids_y = 3;

    // Top
    translate([left, top, 0]) {
        translate([0, 0, 0])
            cube([gridfinity*grids_x - fudge, top_thickness, fudge_height]);
        translate([0, 0, fudge_height])
            cube([gridfinity*grids_x, top_thickness, height - fudge_height]);

        // Outside slope
        translate([-left_thickness, top_thickness, height]) {
            rotate(a=[0, 90, 0]) 
                triangle(top_lip_thickness, lip_height_overlap, gridfinity*grids_x + left_thickness);
        }

        // Lip
        translate([-left_thickness, top_thickness, height]) {
            translate([0, 0, 0])
                cube([topLeft_topLip_length + left_thickness, top_lip_thickness, lip_height]);
            translate([topLeft_topLip_length + left_thickness, 0, 0])
                rotate([270, 270, 0])
                    triangle(triangle_leg, lip_height, top_lip_thickness);
        }
    }

    // Left
    translate([left - left_thickness, top, 0]) {
        translate([0, -gridfinity*grids_y, 0]) {
            translate([0, fudge, 0])
                cube([left_thickness, gridfinity*grids_y - fudge, fudge_height]);
            translate([0, 0, fudge_height])
                cube([left_thickness, gridfinity*grids_y, height - fudge_height]);
        }

        // Lip
        translate([0, -topLeft_leftLip_length, height]) topLeft_leftLip();
    }

    // Corner
    translate([left - left_thickness, top, 0]) cube([left_thickness, top_thickness, height]);
}

module bottomLeft() {
    grids_x = 3;
    grids_y = 4;

    // Bottom
    translate([left, bottom - bottom_thickness, 0]) {
        translate([0, 0, 0])
            cube([gridfinity*grids_x - fudge, bottom_thickness, fudge_height]);
        translate([0, 0, fudge_height])
            cube([gridfinity*grids_x, bottom_thickness, height - fudge_height]);

        // Outside slope
        translate([gridfinity*grids_x, 0, height])
            rotate(a=[180,90,0]) 
                triangle(bottom_lip_thickness, lip_height_overlap, gridfinity*grids_x + left_thickness);

        // Lip
        translate([-left_thickness, -bottom_lip_thickness, height])  {
            translate([0, 0, 0])
                cube([bottomLeft_bottomLip_length + left_thickness, bottom_lip_thickness, lip_height]);
            translate([bottomLeft_bottomLip_length + left_thickness, 0, 0])
                rotate([270, 270, 0])
                    triangle(triangle_leg, lip_height, bottom_lip_thickness);
        }
    }

    // Left
    translate([left - left_thickness, bottom, 0]) {
        translate([0, 0, 0])
            cube([left_thickness, gridfinity*grids_y - fudge, fudge_height]);
        translate([0, 0, fudge_height])
            cube([left_thickness, gridfinity*grids_y, height - fudge_height]);

        // Lip
        translate([0, bottomLeft_leftLip_length, height]) bottomLeft_leftLip();
    }

    // Corner
    translate([left - left_thickness, bottom - bottom_thickness , 0]) cube([left_thickness, bottom_thickness, height]);

    // translate([left, bottom - (bottom_thickness + bottom_lip_thickness), height])  {
    //     cube([gridfinity*grids_x, bottom_lip_thickness, lip_height]);
    //     translate([gridfinity*grids_x, bottom_lip_thickness, 0])
    //         rotate(a=[180,90,0]) 
    //             triangle(top_lip_thickness, lip_height_overlap, gridfinity*3);
    // }

    // translate([left - left_thickness, bottom, height]) 
    //     cube([left_lip_thickness, gridfinity*grids_y, lip_height]);
}

module bottomRight() {
    grids_x = 2;
    grids_y = 3;

    // Bottom
    translate([right - gridfinity*grids_x, bottom - bottom_thickness, 0]) {
        translate([fudge, 0, 0])
            cube([gridfinity*grids_x - fudge, bottom_thickness, fudge_height]);
        translate([0, 0, fudge_height])
            cube([gridfinity*grids_x, bottom_thickness, height - fudge_height]);

        // Outside Slope
        translate([gridfinity*grids_x + right_thickness, 0, height]) {
            rotate(a=[180,90,0]) 
                triangle(top_lip_thickness, lip_height_overlap, gridfinity*grids_x + right_thickness);
        }

        // Lip
        translate([gridfinity*grids_x - bottomRight_bottomLip_length, -bottom_thickness, height]) {
            translate([0, 0, 0])
                cube([topRight_topLip_length + right_thickness, top_lip_thickness, lip_height]);
            translate([0, top_lip_thickness, 0])
                rotate([90, 270, 0])
                    triangle(triangle_leg, lip_height, top_lip_thickness);
        }

    }

    // Right
    translate([right, bottom, 0]) {
        translate([0, 0, 0])
            cube([right_thickness, gridfinity*grids_y - fudge, fudge_height]);
        translate([0, 0, fudge_height])
            cube([right_thickness, gridfinity*grids_y, height - fudge_height]);

        // Lip
        translate([0, topRight_rightLip_length, height]) bottomRight_rightLip();
    }

    // Corner
    translate([right, bottom - bottom_thickness, 0]) cube([right_thickness, bottom_thickness, height]);
}



//////////////////////////////////////////////////////////////////////////////

difference() {
    topRight();
    translate([right, top - topRight_rightLip_length, 0]) scale([1, 1.1, 1.1]) topRight_rightLip();
}

difference() {
    topLeft();
    translate([left - left_thickness, top - topLeft_leftLip_length, 0]) scale([1, 1.1, 1.1]) topLeft_leftLip();
}

difference() {
    bottomLeft();
    translate([left - left_thickness, bottom + bottomLeft_leftLip_length, 0]) scale([1, 1.1, 1.1]) bottomLeft_leftLip();
}

difference() {
    bottomRight();
    translate([right, bottom + topRight_rightLip_length, 0]) scale([1, 1.1, 1.1]) bottomRight_rightLip();
}

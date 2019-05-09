$fn = 50;

// Dimensions
//width = 87;
//length = 130;
depth = 13.5;

width = 174;
length = 130;

thickness = 2;

radius=20;

rows = 2;
cols = 3;

lip = 10;
hindge = 4;
hindgeCore = 1.8;

//base();
color("green") translate([0, hindge-thickness, lip-hindge]) rotate([0, 0, 0]) lid();

/*
color("blue") {
    translate([0, 0, 0]) tray(130, 87);
    translate([0, width/2, 0]) tray(130, 87);
}
*/

tabs = 5;
tabLength = (length)/tabs;

handle=length/2;

module lid() {
    difference() {
        union() {
            translate([0, thickness-2*hindgeCore + thickness, -hindge]) {
                linear_extrude(height=thickness) {
                    square([length, width-thickness]);
                }
                
                linear_extrude(height=thickness) {
                    translate([(length - handle)/2,width - thickness,0])
                        square([handle, thickness*3]);
                }
            }
            
            translate([0, 0, 0]) {
                rotate([0, 90, 0]) {
                    difference() {
                        cylinder(r=hindge, h=length);
                        cylinder(r=hindgeCore, h=length);
                    }
                }
            }
        }
        
        translate([0, -thickness, -hindge-thickness])
            tabCutout(1);
    }
}

module tabCutout(_offset) {
    translate([0, 0, lip-hindge*2])
    for(x = [_offset:2:tabs-1]) {
        translate([x*tabLength,-thickness, 0]) {
            linear_extrude(height=hindge*2)
                square([tabLength, hindge*2]);
        }
    }
}

module base() {
    difference() {
        union() {
            difference() {
                translate([-thickness, -thickness, -depth - thickness])
                    cube([length + thickness*2, width + 2*thickness, (depth + thickness) + lip]);

                translate([0, 0, -depth])
                    cube([length, width, depth + lip]);
                
                translate([-thickness, -thickness, lip-hindge])
                    cube([length+thickness*2, hindge, hindge,]);
            }

            difference() {
                translate([-thickness, hindge-thickness, lip-hindge])
                    rotate([0, 90, 0])
                        cylinder(r=hindge, h=length + thickness*2);
            }
        }

        translate([-thickness, (hindge-thickness), lip-hindge])
                    rotate([0, 90, 0])
                        cylinder(r=hindgeCore, h=length + thickness*2);
        
        tabCutout(0);
        
        
        translate([(length - handle)/2, width,thickness])
            cube([handle, thickness, lip-thickness]);
    }
}

module tray(length, width) {
    xOffset = (length - (cols*radius*2))/(cols+1);
    yOffset = (width - (rows*radius*2))/(rows+1);
    zOffset = radius - depth;

    difference() {
        intersection() {
            translate([0, 0, -depth])
                cube([length, width, depth]);
            
            union() {
                translate([radius, radius, -thickness])
                    linear_extrude(height=thickness)
                        offset(r=radius)
                            square([length-2*radius,width-2*radius]);
                
                translate([radius+xOffset, radius+yOffset, zOffset]) {
                    for(x = [0:cols-1]) {
                        for(y = [0:rows-1]) {
                            translate([x * (xOffset + 2*radius), y * (yOffset + 2*radius), 0]) {
                                sphere(radius);
                            }
                        }
                    }
                }
            }
        }

        translate([radius+xOffset, radius+yOffset, zOffset]) {
            for(x = [0:cols-1]) {
                for(y = [0:rows-1]) {
                    translate([x * (xOffset + 2*radius), y * (yOffset + 2*radius), 0]) {
                        sphere(radius-thickness/2);
                    }
                }
            }
        }
    }
}
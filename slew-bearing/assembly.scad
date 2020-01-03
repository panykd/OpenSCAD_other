//$fn = 100;

include <slew-bearing.scad>;

baseBearing();

module baseBearing() {
    holes = 10;
    holeDiameter = 8;

    thickness = 20;

    difference() {
        slewBearing(130, 70, thickness, 8);
        
        // Outer Ring Holes
        for(i = [0:holes]) {
            rotate([0, 0, i*(360/holes)]) {
                translate([115, 0, -thickness/2]) {
                    cylinder(d=holeDiameter, h = 20);
                }
            }
        }
        
        // InnerRing Holes
        for(i = [0:holes]) {
            rotate([0, 0, i*(360/holes)]) {
                translate([85, 0, -thickness/2]) {
                    cylinder(d=holeDiameter, h = 20);
                }
            }
        }
    }
}
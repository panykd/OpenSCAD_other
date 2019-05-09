
$fn=20;

difference() {
    union() {
        translate([15,0,0]) {
            rotate([0, -90, 0]) {
                ports = 6;
                difference()
                {
                    union() {
                        sphere(d=20);
                        difference() {
                            cylinder(d=20, h=35);
                            cylinder(d=10, h=35);
                        }
                    }
                    
                    for(i=[0:ports]) {
                        translate([0, 0, 30]) {
                            rotate([180-15,0,360/ports * i]) {
                                cylinder(d=6, h=40);
                            }
                        }    
                    }
                }
            }
        }

        rotate([0, 0, 90]) {
            translate([-20, -20, 0]) {
                size = 40;
                thickness = 5;
                intersection() {
                    translate([size/2, size/2, 0]) {
                        cube([size, size, size], center=true);
                    }

                    rotate_extrude() {
                        translate([size/2, 0, 0]) {
                            difference() {
                                circle(d=size);
                                circle(d=size-thickness*2);
                            }
                        }
                    }
                }
            }
        }
    }
    
    rotate([0, -90, 0]) {
        cylinder(d=10, h=25);
    }
}




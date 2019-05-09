$fn = 20;

size = 6.5;
nominalLength = 80;

hookProfile();
%slideProfile();

module slideProfile() {
    rotate([0, 0, 180]) {
        union() {
            //circle(d=size, center=true);
            translate([-size/2, 20, 0]) {
                square([size, 40]);
            }
        }
    }
}

module assembly() {
    
    // Properties
    bedAngle = 45;
    bedSize = 10;
    bedPitch = 100/13;
    travel = 25;
    

    // Needle Positions
    frontNeedle =   [00, 00, 00, 00, 00, 00, 00, 00, 00, 00];
    backNeedle =    [00, 00, 00, 00, 00, 00, 00, 00, 00, 00];

    // Setup the beds
    for(i = [0:bedSize-1]) {
        // Lay bed(s) out on a different axis
        rotate([90, 0, 90]) {
            translate([0, 0, bedPitch * i]) {
                
                // Front            
                rotate([0, 0, -45]) {
                    translate([0, -travel + frontNeedle[i], 0]) {
                        hook();
                    }
                }
                
                // Back
                rotate([0, 0, 45]) {
                    translate([0, -travel + backNeedle[i], 0]) {
                        hook();
                    }
                }
            }
        }
    }

}







module hook() {
    color("gold") {        
        linear_extrude(height = 2, center = true) {
            hookProfile();
        }
    }
}

module hookProfile() {
    rotate([0, 0, 180]) {
        union() {
            circle(d=size, center=true);
            translate([-size/2, 0, 0]) {
                square([size, nominalLength]);
            }
        }
    }
}
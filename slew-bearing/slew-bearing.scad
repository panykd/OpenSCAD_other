// Input Parameters

//chaseProfile();

//slewBearing(130, 70, 20, 8);

module slewBearing(outerRadius, innerRadius, thickness, rollerSize, opening = 2) {
    
    // Calculated variables
    nominalRadius = (innerRadius + outerRadius) / 2;
    rollerDiameter = rollerSize;
    
    // Calculated Variables
    rollerCount = slewBearingRollerCount(rollerSize, nominalRadius);
    rollerRadius = slewBearingRollerRadius(rollerSize, rollerCount);
    
    // Inner Ring Lower
    innerRingHalf(innerRadius, rollerRadius, rollerSize, thickness, opening);
    
    // Outer Ring
    outerRing(outerRadius, rollerRadius, rollerSize, thickness, opening);
    
    // Rollers
    for(i = [0:rollerCount]) {
        rotate([0,0,i*(360/rollerCount)]) {
            translate([rollerRadius, 0, 0]) {
                if(i%2==0)
                {
                    rotate([0, -45, 0]) {
                        slewBearingRoller(rollerDiameter);
                    }
                }
                else
                {
                    rotate([0,45,0]) {
                        slewBearingRoller(rollerDiameter);
                    }
                }
            }
        }
    }
    
    // Top Inner
    mirror([0, 0, 1]) {
        innerRingHalf(innerRadius, rollerRadius, rollerSize, thickness, opening);
    }
}

function slewBearingRollerCount(size, r, gap = 0.3) = floor(360 / (2 * asin((size + gap) / (2 * r))));
function slewBearingRollerRadius(size, n, gap = 0.3) = (size + gap) / (2 * sin((360/n) / 2));

module outerRing(outerRadius, rollerRadius, size, thickness, opening) {
    
    t = thickness/2;
    
    w = outerRadius - rollerRadius;
    
    rotate_extrude(angle=360) {
        translate([rollerRadius, 0, 0]) {
            difference() {
                translate([0,-t/2,0]) {
                    square([w,t]);
                }
                slewBearingChaseProfile(size, opening);
            }
        }
    }
}

module innerRingHalf(innerRadius, rollerRadius, size, thickness, opening) {
    
    t = thickness/2;
    
    w =  rollerRadius - innerRadius;
    
    rotate_extrude(angle=360) {
        translate([rollerRadius, 0, 0]) {
            difference() {
                translate([-w,-t/2,0])
                square([w,t/2]);
                mirror([1,0,0])
                slewBearingChaseProfile(size, opening);
            }
        }
    }
}

module slewBearingChaseProfile(size, opening, gap = 0.3) {
    
    
    // Controls fit
    r = (size+gap)*cos(45);
    
    // Controls opening
    o = (opening/2)/cos(45);
    
    polygon(points=[
        [0, r],
        [o, r],
        [o, r-o],
        [r, 0],
        [o, -r+o],
        [o, -r],
        [0, -r]
    ]);
}


module slewBearingRoller(size, hole = 3, bevel = 1) {
    translate([0, 0, -size/2]) {
        rotate_extrude(angle=360) {
            polygon(points=[
                [hole/2, 0],
                [size / 2 - bevel, 0],
                [size / 2, bevel],
                [size / 2, size - bevel],
                [size / 2 - bevel, size],
                [hole / 2, size]
            ]);
        }
    }
}
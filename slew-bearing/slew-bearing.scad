$fn = 200;

effectiveRollerRadius = 100;
rollerDiameter = 8;
rollerHole = 3;
rollerBevel = 1;

rollerGap = 0.3;
chaseGap = 0.5;

chaseOffset = 1;
bearingThickness = 20;
bearingOuter = 130;
bearingInner = 70;

innerHoles = 10;
innerHoleDiameter = 8;
innerHoleRadius = 85;

outerHoles = 10;
outerHoleDiameter = 8;
outerHoleRadius = 115;

//chaseProfile();

//roller();
layoutRollers();

innerRingHalf();
mirror([0, 0, 1]) {
    innerRingHalf();
}
outerRing();

function rollerCount() = floor(360 / (2 * asin((rollerDiameter + rollerGap) / (2 * effectiveRollerRadius))));
function rollerRadius(n) = (rollerDiameter + rollerGap) / (2 * sin((360/n) / 2));



module outerRing() {
    
    t = bearingThickness/2;
    
    rc = rollerCount();
    rr = rollerRadius(rc);
    
    w = bearingOuter - rr;
    
    difference() {
        rotate_extrude(angle=360) {
            translate([rr, 0, 0]) {
                difference() {
                    translate([0,-t/2,0]) {
                        square([w,t]);
                    }
                    chaseProfile();
                }
            }
        }
        for(i = [0:outerHoles]) {
            rotate([0, 0, i*(360/outerHoles)]) {
                translate([outerHoleRadius, 0, -t]) {
                    cylinder(h=bearingThickness, d=outerHoleDiameter);
                }
            }
        }
    }
}

module innerRingHalf() {
    
    t = bearingThickness/2;
    
    rc = rollerCount();
    rr = rollerRadius(rc);
    
    w =  rr - bearingInner;
    
    difference() {
        rotate_extrude(angle=360) {
            translate([rr, 0, 0]) {
                difference() {
                    translate([-w,-t/2,0])
                    square([w,t/2]);
                    mirror([1,0,0])
                    chaseProfile();
                }
            }
        }
        for(i = [0:outerHoles]) {
            rotate([0, 0, i*(360/outerHoles)]) {
                translate([innerHoleRadius, 0, -t]) {
                    cylinder(h=t, d=innerHoleDiameter);
                }
            }
        }
    }
}

module chaseProfile() {
    
    
    d = rollerDiameter;
    r = (d+chaseGap)*cos(45);
    
    o = chaseOffset/cos(45);
    
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

module layoutRollers() {

    n = rollerCount();
    r = rollerRadius(n);

    // Layout Rollers
    for(i = [0:n]) {
        rotate([0,0,i*(360/n)]) {
            translate([r, 0, 0]) {
                if(i%2==0)
                {
                    rotate([0, -45, 0]) {
                        roller(rollerDiameter);
                    }
                }
                else
                {
                    rotate([0,45,0]) {
                        roller(rollerDiameter);
                    }
                }
            }
        }
    }
}
module roller() {
    translate([0, 0, -rollerDiameter/2]) {
        rotate_extrude(angle=360) {
            polygon(points=[
                [rollerHole/2, 0],
                [rollerDiameter / 2 - rollerBevel, 0],
                [rollerDiameter / 2, rollerBevel],
                [rollerDiameter / 2, rollerDiameter - rollerBevel],
                [rollerDiameter / 2 - rollerBevel, rollerDiameter],
                [rollerHole / 2, rollerDiameter]
            ]);
        }
    }
}
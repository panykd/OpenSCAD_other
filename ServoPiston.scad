link = 40;
linkWidth = 8;
linkHole = 4;

// Disk Properties
hornRadius = 15;

minAngle = -55;
maxAngle = 85;

module bottomHorn() {
    color("Yellow")
    union() {
        translate([0,0,-2])
            cylinder(r = hornRadius + linkHole/2  + 2, h = 2);

        translate([0, 0, -6]) {
            difference() {
                cylinder (h=4, d=10);
                cylinder(h=4, d=6);
            }
        }
            

        translate([-hornRadius, 0, 0])
            cylinder(d=linkHole, h=4);

        translate([hornRadius, 0, 0])
            cylinder(d=linkHole, h=4);
    }
}

module link() {
    color("Blue")
    difference() {
        union () {
            cylinder(h=2, d=linkWidth);
            translate([0, link, 0])
                cylinder(h=2, d=linkWidth);
            translate([-linkWidth/2, 0, 0])
                cube([linkWidth, link, 2]);
        };
        cylinder(h=2, d=linkHole);
        translate([0, link, 0])
            cylinder(h=2, d=linkHole);
    }
}



module rod() {
    color("Red")
    union() {
        translate([0, 0, -2]) {
            cylinder(d = linkHole, h=2 + 5);
            
            translate([-linkHole/2, 0, 0])
                cube([linkHole, link, 2]);
        }
    }
}


module topHorn() {
    color("White")
    difference() {
    cylinder(r = hornRadius + linkHole/2 + 2, h = 2);
    
        translate([-hornRadius, 0, 0])
            cylinder(d=linkHole, h=4);

        translate([hornRadius, 0, 0])
            cylinder(d=linkHole, h=4);
    }
}


module piston(angle) {
    // Assembly
    hornAngle = angle;

    rotate([0, 0, hornAngle]) {
        translate([0, 0, 2]) {
            //topHorn();
        }
        bottomHorn();
    }

    // Link 1
    link1X = hornRadius * cos(hornAngle);
    link1Y = hornRadius * sin(hornAngle);

    link1Angle = asin(hornRadius * cos(hornAngle) / link);

    translate([link1X, link1Y, 0])
        rotate([0, 0, link1Angle])
            link();

    // Link 2
    link2X = -hornRadius * cos(hornAngle);
    link2Y = -hornRadius * sin(hornAngle);

    link2Angle = asin(hornRadius * cos(-hornAngle) / link);

    translate([link2X, link2Y, 0])
        rotate([0, 0, 180 + link2Angle])
            link();
    // Rods
    //rodOffset = hornRadius*cos(90-hornAngle) + sqrt(pow(link, 2) - pow(hornRadius, 2) * pow(sin(90-hornAngle), 2));
    rodOffset = rodOffset(angle);

    // Rod 1
    translate([0, rodOffset, 0])
        rod();
        
    // Rod 2
    translate([0, -rodOffset, 0])
        rotate([0, 0, 180])
            rod();
}

function rodOffset(a) = hornRadius*cos(90-a) + sqrt(pow(link, 2) - pow(hornRadius, 2) * pow(sin(90-a), 2));

module servo() {
    a = 40;
    b = 20;
    c = 36;
    union() {
        color("White")
        cylinder(d=6, h=5);
        
        color("Black")
        translate([-10, -b/2, 0]) {
            difference() {
                union() {
                translate([0,0,-c])
                    cube([a, b, c]);
                
                translate([-7.5, 0, -(6 + 2.5)])
                    cube([a + 7.5 * 2, b, 2.5]);
                };
                
                translate([-4, 10, -(6 + 2.5)]) {
                    translate([0,5,0])
                        cylinder(d=4.5, h = 2.5);
                    
                    translate([0,-5,0])
                        cylinder(d=4.5, h = 2.5);
                }
                
                translate([a + 7.5 - 3.5, 10, -(6 + 2.5)]) {
                    translate([0,5,0])
                        cylinder(d=4.5, h = 2.5);
                    
                    translate([0,-5,0])
                        cylinder(d=4.5, h = 2.5);
                }
            }        
        }
    }
}


// Assembly

piston(80);

color("green")

translate([0, 0, -10])
{
    slotLength = rodOffset(maxAngle) - rodOffset(minAngle);
    difference() {
        translate([-(linkHole + 4)/2,rodOffset(minAngle) - linkHole / 2,0]) {
            cube([linkHole + 4, slotLength + linkHole * 2, 2 + 2]);
        }
        
        translate([-linkHole / 2, rodOffset(minAngle) - linkHole / 2, 2])
        cube([linkHole, slotLength + linkHole * 2, 2]);
    }
    
    difference() {
        translate([-25, -25, 0]) {
            cube([50, 50, 2]);
        }
    
        cylinder(d=10, h=2);
    }
}
    
    


translate([0,0,-7]) {
    rotate([0,0,90]) {
        //servo();
    }
}

spacing = 11;
depth = 25;
teeth = 8;

breadth = 60;
thickness = 6;

{
    
    toothLength = (spacing/2)+depth;
    
    totalWidth = (teeth)*2*spacing;
    
    centerlineOffset = toothLength + (breadth-toothLength)/2;

    difference() {
            
        union() {
            difference() {
                comb(toothLength, totalWidth);
                
                // Label Plate
                translate([totalWidth/2, centerlineOffset, thickness-3]) {
                    linear_extrude(3) {
                        square([totalWidth/2, (breadth-toothLength)/3*2], center=true);
                    }
                }

                         
            }
        
            // Label
            translate([0,0,thickness-3]) {
                linear_extrude(3) {
                    translate([totalWidth/2, centerlineOffset, thickness]) {
                        text(text = str(spacing, "mm"), valign="center", halign="center");
                    }
                }
            }
            
            for(i = [1:2:3]) {
                translate([totalWidth/4*i, centerlineOffset, 0]) {
                    cylinder(d=15, h=thickness);
                }   
            }
        }
            
        // Holes
        for(i = [1:2:3]) {
            translate([totalWidth/4*i, centerlineOffset, 0]) {
                cylinder(d=10, h=thickness);
            }
        }
    }
}

module comb(toothLength, totalWidth) {

    linear_extrude(thickness) {

         intersection() {
            
            square([totalWidth, breadth]);
            
            union() {
                translate([0, toothLength,0]) {
                    square([totalWidth, breadth-toothLength]);
                }

                translate([spacing*2, spacing/2, 0]) {
                    for(i=[-1:1:teeth-1]) {
                        translate([i*2*spacing, 0, 0]) {
                            union() {
                                circle(d=spacing);
                                translate([-spacing/2, 0, 0]) {
                                    square([spacing,depth]);
                                }
                            }
                        }
                    }
                }
            }
        }
    }

}

module relay() {
    color("blue")
        cube([15, 19, 15.5]);
}

module relayConnector() {
    color("blue")
        cube([15, 7.5, 10]);
}

module header(pins = 1, rows = 1) {

    // pin
    diameter = 1;
    heightAbove = 6;
    heightBelow = 3;
    spacing = 2.54;
    
    // base
    width = 2.5;
    height = 2.54;
    
    for(col = [0: pins - 1]) {
        for(row = [0:rows - 1]) {
            translate([col * spacing, row * spacing, 0]){
                color("silver")
                        translate([0, 0, -heightBelow])
                        cylinder(d = 1, h = heightBelow + height + heightAbove);
                
                translate([-spacing/2, -width/2, 0]) {
                    color("black")
                        cube([spacing, width, height]);
                    
                }
            }
        }
    }
}

module headerSocket(pins = 1, rows = 1) {

    // pin
    diameter = 1;
    heightAbove = 6;
    heightBelow = 3.15;
    spacing = 2.54;
    
    // base
    width = 2.5;
    height = 8.5;
    
    translate([0,0,-(height-heightAbove)]) {
        
        for(col = [0: pins - 1]) {
            for(row = [0:rows - 1]) {
                translate([col * spacing, row * spacing, 0]){
                    difference() {
                        union() {
                            color("silver")
                                    translate([0, 0, -heightBelow])
                                    cylinder(d = 1, h = heightBelow + (height-heightAbove));
                            
                            translate([-spacing/2, -width/2, 0]) {
                                color("black")
                                    cube([spacing, width, height]);
                                
                            }
                        }
                        translate([0,0,height-heightAbove])
                        cylinder(d=diameter, h = heightAbove);
                    }
                }
            }
        }
    }
}

module relayBoard() {
    // hole size - 4mm diameter
    // 9mm from top, 4mm from side, 6.5mm from bottom
    
    width = 78;
    height = 55;
    thickness = 1.5;
    
    union() {
        color("red")
        difference() {
            cube([width, height, 1.5]);
            
            translate([0, 6.5, 0]) {    // Offset bottom holes
                translate([4, 0, 0])
                    cylinder(d = 4, h = thickness);
            
                translate([width - 4, 0, 0])
                    cylinder(d = 4, h = 1.5);
            }
            
            translate([0, height - 9, 0]) { // Offset top holes
                translate([4, 0, 0])
                    cylinder(d = 4, h = 1.5);
            
                translate([width - 4, 0, 0])
                    cylinder(d = 4, h = 1.5);
            }
        }
        
        // Place things on top of the board
        translate([0,0, thickness]) {
        
            // Relays
            relayCount = 4;
            footprintWidth = 15;
            totalWidth = width - 2*7.5;
            space = (totalWidth - 4*footprintWidth) / 3;
            
            for(i = [0:relayCount - 1]) {        
                
                // Relays are 7.5 from sides, 21.5 from bottom
                translate([7.5 + i*(footprintWidth + space), 21.5, 0]) {
                    relay();
                }
                
                // Relays are 7.5 from sides, 5.5 from top
                translate([7.5 + i*(footprintWidth + space), height - 13, 0]) {
                    relayConnector();
                }
            }
            
            // Header Strip
            translate([21.5, 5.5, 0]) {
                header(8, 1);
            }
        }
    }
}


// Assembly

translate([21.5, 5.5, 10.5])
rotate([180,0,0])
headerSocket(8,1);

relayBoard();



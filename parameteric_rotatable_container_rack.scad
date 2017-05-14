// Caddy / Wheel Dimensions
caddyDiameter = 60;
caddyThickness = 7.5;

// When leaning adjacent wheels away from each other against internal stops
// the required distance between them is GAP
gap = 10;

// Height of the dividing walls between slots
slotHeight = caddyDiameter / 4;

// Wall Thickness
wallThickness = 2;

// Tray Dimensions 
trayLength = 100;

color("White")
    tray(caddyDiameter, caddyThickness, gap, slotHeight, 2, wallThickness, trayLength, caddyDiameter / 2);

module tray(wheelDiameter, wheelThickness, gap, slotHeight, wheelTolerance, wallThickness, trayLength, trayHeight) {
    
    // Gap per side is 
    gapPerSide = (gap - wallThickness) / 2;
    
    // lean angle to get gap is arcsign(gapPerSide/height of wheel)
    angle = asin(gapPerSide / wheelDiameter);
    
    // Width is the sum of the missing sides of the triangle, based on the height of the slot, and the thickness of the wheel
    slotWidth = ceil((wheelThickness * cos(angle) + slotHeight * sin(angle))*10)/10;

    slots = floor((trayLength - wallThickness) / (slotWidth + wallThickness));
    
    // Display the parameters
    echo (slotWidth=slotWidth, slotHeight=slotHeight, slots=slots);
    
    // Tray Width needs to be wheelDiameter + tolerance + wallThickness
    widthWithTolerance = wheelDiameter + wheelTolerance;
    trayWidth = (wheelDiameter + wheelTolerance) + 2*wallThickness;
    
    // Create the tray
    difference () {
        translate([-wallThickness, -trayWidth / 2, -wallThickness]) {
            cube([trayLength, trayWidth, trayHeight + wheelTolerance]);
        }
        
        // Remove the the top portion        
        translate([0, -(widthWithTolerance/2), slotHeight])
        cube([trayLength - 2*wallThickness, widthWithTolerance, 40]);
        
        // Cut the slots
        for(i=[0:slots - 1]) {
            translate([i*(slotWidth + wallThickness), -widthWithTolerance/2], 0)
                cube([slotWidth, widthWithTolerance, wheelDiameter]);
        }
    }
}


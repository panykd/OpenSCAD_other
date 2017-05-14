// Shank

INCH = 25.4;

overallLength = 2.25*INCH;
shank = 0.125*INCH;
bit = 0.25*INCH;
bitLength = 0.75*INCH;

target = 0.5 * INCH;

offset = (bit - shank) / 2;
minWidth = 150;
slotDepth = 100;
slots = floor((minWidth-2*offset)/target);
slotWidth = target - 2*offset;

panelWidth = target*(slots+1);
panelHeight = slotDepth+2*offset;
panelThickness = 3;

module frame() {
    color("blue")
    translate([-panelThickness, -panelThickness, -panelThickness])
    {
        difference() {
            union() {
                // Main Plate
                linear_extrude(height=panelThickness)
                square([panelWidth+2*panelThickness, panelHeight+2*panelThickness]);
                
                // Pattern Plate Holder
                linear_extrude(height=2*panelThickness)
                square([panelThickness, panelHeight+2*panelThickness]);
                
                linear_extrude(height=2*panelThickness)
                square([panelWidth+2*panelThickness, panelThickness]);
                
                translate([panelThickness+panelWidth, 0, 0])
                linear_extrude(height=2*panelThickness)
                square([panelThickness, panelHeight+2*panelThickness]);
                
                translate([0, panelThickness+panelHeight, 0])
                linear_extrude(height=2*panelThickness)
                square([panelWidth+2*panelThickness, panelThickness]);
            }
            
            // 
            translate([panelThickness+offset, panelThickness+offset, -1])
            linear_extrude(height=panelThickness+1)
            square([panelWidth-2*offset, panelHeight-2*offset]);
        }
    }
}

module bit() {
    translate([bit/2, bit/2, -1*INCH])
    {
        union() {
            cylinder(h=overallLength, d=shank);
            cylinder(h=bitLength, d=bit);
        }
    }
}

module panel() {
    
    linear_extrude(height=panelThickness) {
        difference() {
            square([panelWidth,panelHeight]);

            for(i =[1:slots])
            {
                translate([(2*(i-1)*target) + offset, offset, 0])
                {
                    square([slotWidth, slotDepth]);
                }
            }
        }
    }
}

//bit();
panel();
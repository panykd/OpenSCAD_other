$fn=100;

// Parameters
overallThickness = 2.8;
outsideDiameter = 13.5;
tireThickness = 1;

hubOuter = 5;
hubInner = 4;

backInlayDepth = 0.6;
frontInlayDepth = 0.6;

wheelSpokes = 5;
spokeWidth = 2;

// Useful measures

beeWheel();

module beeWheel() {
    
    tireInnerDiameter = outsideDiameter - 2*tireThickness;
    frontProfileLayer = overallThickness - backInlayDepth;
    
    difference() {
        union() {
            difference() {
                // Outer profile
                linear_extrude(height=overallThickness) {
                    circle(d=outsideDiameter);
                }
                
                // Back Cutout
                linear_extrude(height=backInlayDepth) {
                    circle(d=tireInnerDiameter);
                }
                
                // front Cutout
                translate([0, 0, frontProfileLayer]) {
                    linear_extrude(height=frontInlayDepth) {
                        circle(d=tireInnerDiameter);
                    }
                }
            }
            
            // Face Ridge
            linear_extrude(height=overallThickness) {
                circle(d=6);
            }
            
            // Decor on front inlay
            translate([0, 0, frontProfileLayer]) {
                linear_extrude(height=frontInlayDepth) {
                    
                    // Workout the parameters for the spoke pattern
                    innerEdge = hubOuter / 2;
                    outerEdge = tireInnerDiameter / 2;
                    middle = innerEdge + (outerEdge-innerEdge)/2;
                    narrowOffset = spokeWidth/4;
                    wideOffset = spokeWidth / 2;
                    
                    // Create 1 for each spoke
                    for(i=[0:wheelSpokes-1]) {
                        rotate([0,0,i * 360/wheelSpokes]) {
                            // Create the spoke
                            polygon(points=[
                                [innerEdge, -narrowOffset],
                                [middle, -wideOffset],
                                [outerEdge, -narrowOffset],
                                [outerEdge, narrowOffset],
                                [middle, wideOffset],
                                [innerEdge, narrowOffset]
                            ]);
                        }
                    }
                }
            }
        }
        
        // Front Clip Well
        translate([0, 0, frontProfileLayer]) {
            linear_extrude(height=frontInlayDepth) {
                circle(d=hubOuter);
            }
        }
        
        // Center hole
        linear_extrude(height=overallThickness) {
            circle(d=hubInner);
        }
    }
}
_bottleDepth = 20;
_bottleWidth = 32;

_bottleTolerance = 1;
_bottlePadding = 1;

_bottleWall = 10;

_thickness = 2;

// Depth
overallDepth = 200;

insideWidth = _bottleWidth + 2 * _bottleTolerance;
insideDepth = _bottleDepth + 2 * _bottleTolerance;

outsideWidth = insideWidth + 2 * _bottleTolerance;
outsideDepth = insideDepth + 2 * _bottlePadding;

bottleWell();

//assembly();

module assembly() {
    angle = 60;

    xOffset = (outsideWidth - _bottlePadding / 2) * cos(angle);
    yOffset = (outsideDepth - _bottlePadding / 2) * sin(angle);

    rows = floor(overallDepth / yOffset) - 1;
    echo(rows=rows);

    usedDepth = ((rows) * yOffset) + (outsideDepth);
    echo(overallDepth=overallDepth, usedDepth = usedDepth);

    centeringOffset = (overallDepth - usedDepth) / 2;
    echo(centeringOffset=centeringOffset);

    intersection() 
    {
        cube([outsideWidth * 1/2, overallDepth, _bottleWall]);  // Half
        
        //cube([outsideWidth, overallDepth, _bottleWall]);  // Full
        
        union() {
            cube([outsideWidth, overallDepth, _thickness]);
            
            //translate([0, centeringOffset, 0]) {    //center
            //translate([-outsideWidth, centeringOffset, 0]) {  // Left
            translate([outsideWidth * 1/2, centeringOffset, 0]) { // Right
                union() {
                    union() {
                        for(r = [1:2:rows]) {
                            translate([xOffset, r * yOffset, 0]) {
                                bottleWell();
                            }

                            translate([-xOffset, r * yOffset, 0]) {
                                bottleWell();
                            }
                        }
                    }
                    
                    union() {
                        for(r = [0:2:rows]) {
                            translate([0, r * yOffset, 0]) {
                                bottleWell();
                            }
                        }
                    }
                }
            }
        }
    }
}



module bottleWell() {
    //cutoutWidth = _bottleWidth - (2 * _thickness + 2 * _bottleTolerance);
    //cutoutDepth = _bottleDepth - (2 * _thickness + 2 * _bottleTolerance);

    translate([outsideWidth / 2, outsideDepth / 2, 0]) {
        difference() {
            oval(outsideWidth, outsideDepth, _bottleWall);
        
            translate([0, 0, _thickness]) {                        
                oval(insideWidth, insideDepth, _bottleWall);
            }
            
            //oval(cutoutWidth, cutoutDepth, );
        }
    }
    
    module oval(x,y,h) {
        scale([x/y,1,1]) 
            cylinder(h, d=y);
    }
}

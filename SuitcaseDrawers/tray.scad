_bottleDepth = 20;
_bottleWidth = 32;

_bottleTolerance = 1;
_bottlePadding = 2;

_bottleWall = 30;

_thickness = 2;

// Outside
//overallDepth = 200;
//overallWidth = 320;

overallDepth = 120;
overallWidth = 180;


insideWidth = _bottleWidth + 2 * _bottleTolerance;
insideDepth = _bottleDepth + 2 * _bottleTolerance;

outsideWidth = insideWidth + 2 * _bottleTolerance;
outsideDepth = insideDepth + 2 * _bottlePadding;

echo(outsideWidth=outsideWidth, outsideDepth=outsideDepth);

//bottleWell();

tray();

module tray() {
    angle = 60;

    xOffset = (outsideWidth - _bottlePadding / 2) * cos(angle);
    yOffset = (outsideDepth - _bottlePadding / 2) * sin(angle);

    oddCols = floor(overallWidth / outsideWidth);
    evenCols = floor((overallWidth -xOffset) / outsideWidth);
    
    
    rows = floor(overallDepth / yOffset) - 1;
    echo(rows=rows);

    oddRows = floor(rows / 2) + 1;
    evenRows = floor((1+rows) / 2);
    totalWells = oddRows * oddCols + evenRows * evenCols;
    echo(oddRows = oddRows, evenRows=evenRows, totalWells=totalWells);

    usedDepth = ((rows) * yOffset) + (outsideDepth);
    echo(overallDepth=overallDepth, usedDepth = usedDepth);

    usedWidth = max(outsideWidth * oddCols, (outsideWidth * evenCols) + xOffset);
    centeringXOffset = (overallWidth - usedWidth) / 2;
    
    centeringYOffset = (overallDepth - usedDepth) / 2;
    echo(centeringXOffset=centeringXOffset, centeringYOffset=centeringYOffset);

    union() {
        difference() {
            cube([overallWidth, overallDepth, _thickness]);
            translate([10, 2*centeringYOffset - outsideDepth / 2, 0]) {
                for(r = [1:rows+1]) {
                    translate([0, r*yOffset, 0]) {
                        cylinder(_thickness+2, d = 5);
                    }
                }
            }
            
            translate([overallWidth - 10, 2*centeringYOffset - outsideDepth / 2, 0]) {
                for(r = [1:rows+1]) {
                    translate([0, r*yOffset, 0]) {
                        cylinder(_thickness, d = 5);
                    }
                }
            }
        }
        
        translate([centeringXOffset, centeringYOffset, 0]) {
            difference() {
                union() {
                    for(c = [0:evenCols-1]) {
                        
                        translate([c * outsideWidth,0,0]) {
                            union() {
                                
                                for(r = [1:2:rows]) {
                                    translate([xOffset, r * yOffset, 0]) {
                                        bottleWell();
                                    }
                                }
                            }
                        }
                    }
                    
                    for(c = [0:oddCols-1]) {
                        translate([c * outsideWidth,0,0]) {
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
    }
}

module bottleWell() {
    translate([outsideWidth / 2, outsideDepth / 2, 0]) {
        difference() {
            oval(outsideWidth, outsideDepth, _bottleWall);
        
            translate([0, 0, _thickness]) {                        
                oval(insideWidth, insideDepth, _bottleWall);
            }
        }
    }
    
    module oval(x,y,h) {
        scale([x/y,1,1]) 
            cylinder(h, d=y);
    }
}
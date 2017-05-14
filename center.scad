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

angle = 60;

xOffset = outsideWidth * cos(angle);
yOffset = outsideDepth * sin(angle);

rows = floor(overallDepth / yOffset) - 1;
echo(rows=rows);

usedDepth = ((rows) * yOffset) + (outsideDepth);
echo(overallDepth=overallDepth, usedDepth = usedDepth);

centeringOffset = (overallDepth - usedDepth) / 2;
echo(centeringOffset=centeringOffset);

//intersection() 
{
    //cube([outsideWidth, overallDepth, _bottleWall]);
    
    union() {
        //cube([outsideWidth, overallDepth, _thickness]);
        
        translate([0, centeringOffset, 0]) {
            for(r = [1:2:rows]) {
                translate([xOffset, r * yOffset, 0]) {
                    bottleWell();
                }

                translate([-xOffset, r * yOffset, 0]) {
                    bottleWell();
                }
            }
            
            for(r = [0:2:rows]) {
                translate([0, r * yOffset, 0]) {
                    //bottleWell();
                }
            }
        }
    }
}




module bottleWell() {
    cutoutWidth = _bottleWidth - (2 * _thickness + 2 * _bottleTolerance);
    cutoutDepth = _bottleDepth - (2 * _thickness + 2 * _bottleTolerance);

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
        scale([x/y,1,0]) 
            cylinder(h = h, d=y);
    }
}

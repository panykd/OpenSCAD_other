// Bag Base
overallWidth=370;
//overallWidth=350;
overallDepth=250;
overallHeight = 85;

// Tray Width
//trayWidth = (overallWidth - 11)/2;
trayWidth = overallWidth;
trayDepth = overallDepth;

//baseProfile();
bottleWidth = 32;
bottleDepth = 20;

bottleTolerance = 1;
thickness = 2;
baseThickness = 5;

//dovetail(90);
translate([0, -thickness, baseThickness]) {
difference() {
    intersection() {
        translate([0, 0, baseThickness])
        drawer();
        cube([135, overallDepth/2, overallHeight]);
    }

    translate([135-3, thickness, 0])
    rotate([-90, 0, 0])
    dovetail(overallDepth/2);
}
}

translate([0, -thickness, baseThickness]) {
    //inlay();
    //drawer();
}

module drawer() {
    union() {
        translate([0,0,-baseThickness])
        linear_extrude(height=baseThickness)
        baseProfile();

        linear_extrude(height=overallHeight-baseThickness) {
            difference() {
                baseProfile();
                offset(-thickness) {
                    baseProfile();
                }
            }
        }
    }
}

module inlay() {
    difference() {
        linear_extrude(height=30)
        intersection() {
            baseProfile();
            wells();
        }
        drawer();
    }
}


module wells() {

    insideWidth = bottleWidth + 2 * bottleTolerance;
    insideDepth = bottleDepth + 2 * bottleTolerance;

    outsideWidth = insideWidth + 2 * thickness;
    outsideDepth = insideDepth + 2 * thickness;

    angle = 60;

    offsetX = (insideWidth + thickness) * cos(angle);
    offsetY = (insideDepth + thickness) * sin(angle);

    xCount = (trayWidth - outsideWidth) / (offsetX);
    yCount = (trayDepth - outsideDepth) / (offsetY);

    
    evenRows = (floor((xCount)/2)+1);
    evenCols = (floor((yCount)/2)+1);
    
    echo(evenRows, " "  ,evenCols);
    
    oddRows = (floor((xCount)/2));
    oddCols = (floor((yCount)/2));
    
    evenUsedWidth = evenRows*(insideWidth) + (evenRows+1)*thickness;
    usedWidth = max(evenUsedWidth);

    count = evenRows * evenCols + oddRows * oddCols;
    echo("Total Wells = ", count);
    union() {
        translate([outsideWidth/2 + (overallWidth - usedWidth)/2, outsideDepth/2, 0]) {
            for(x = [0:2:xCount]) {
                for(y = [0:2:yCount]) {
                    translate([offsetX * x, offsetY * y, 0]) well();
                }
            }

            for(x = [1:2:xCount]) {
                for(y = [1:2:yCount]) {
                    translate([offsetX * x, offsetY * y, 0]) well();            
                }
            }
        }
    }
    
    module well(){
        difference() {
            oval(outsideWidth, outsideDepth);
            oval(insideWidth, insideDepth);
        }
    }
}
module baseProfile() {
    
    
    handleSpacing = 170;
    handleWidth = 30;
    handleDepth = 30;

    difference() {
            square([overallWidth,overallDepth]);
    
        translate([overallWidth/2-(handleSpacing/2+handleWidth/2), overallDepth-handleDepth, 0])
            square([handleWidth, handleDepth + 2]);
        
        translate([(overallWidth/2 + handleSpacing/2-handleWidth/2), overallDepth-handleDepth, 0]) 
            square([handleWidth, handleDepth + 2]);
    }
}


module oval(x, y) {
    scale([1, y/x]) circle(d=x);
}
module dovetail(length) {
    linear_extrude(height=length)
    polygon(points=[
        [0, -1.5],
        [0, -3.5],
        [3, -3],
        [3, -2]
    ]);
}
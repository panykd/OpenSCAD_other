// Outside Dimensions
_width = 320;
_depth = 220;
_height = 320;

_drawerHeight = 100;

// Unusable space at top
_topLip = 35;
//
// Assembly
_braceWidth = 15;
_braceDepth = 30;
_sliderYOffset = 40;
_slugHeight = 30;

// Slider Parameters
_sliderHeight = 17;
_sliderDepth = 10;
_sliderTolerance = 1;
_sliderLength = 185;
_sliderInnerLength = 183;
_sliderLoss = 76;

// Bottle Parameters
_bottleWidth = 32;
_bottleLength = 20;
_bottleHeight = 34;

_lidDiameter1 = 15;
_lidDiameter2 = 12;
_lidHeight = 47;

_bottlePadding = 1;    // Space around each bottle
_bottleTolerance = 1;  // Tolerance on bottle fits
_bottleDivisionHeight = 20;


// Globals
_thickness = 2;
_drawBottles = false;
//$t = 0;
//__position = (_sliderInnerLength - _sliderLoss) * $t;
__position = 700;

assembly();

verticalSupport(_drawerHeight, _braceWidth, _braceDepth);

//bottleDrawer(_width - 2 * (_braceWidth + _sliderTolerance + _thickness + _sliderTolerance + _thickness));

module assembly() {
  
    extension = max(0, min(_sliderLength-_sliderLoss, __position));

    drawerXOffset = _braceWidth + _sliderTolerance + _thickness + _sliderTolerance + _thickness;
    drawerZOffset = _thickness + _sliderDepth;
    width = _width - 2*(drawerXOffset);
    
    // Drawer
    translate([drawerXOffset, -2*extension, drawerZOffset]) {
        bottleDrawer(width);
    }
    
    // Left Side
    translate([0, _depth - _sliderLength, 0]) {
        verticalSupport(_drawerHeight, _braceWidth, _braceDepth);

        translate([_braceWidth + _sliderTolerance, 0, 0])
        {
            translate([-_sliderDepth , 0, _sliderYOffset]) {
                drawerSlide(extension);
            }
        
            translate([0, -extension, 0]) {
                sliderTray();
                
                translate([_sliderHeight + _thickness + _sliderTolerance, 0, _thickness])
                rotate([0,-90,0])
                drawerSlide(extension);
            }
        }
    }
    
    translate([0, _depth - _braceDepth, 0]) {
        verticalSupport(_drawerHeight, _braceWidth, _braceDepth);
        
        translate([_braceWidth + _sliderTolerance, -extension, 0]) {
                sliderTray();
        }
    }
    
    // Right Side
    translate([_width, _depth - _sliderLength, 0]) {
        translate([0,2 * _braceWidth, 0]) rotate([0,0,180])
            verticalSupport(_drawerHeight, _braceWidth, _braceDepth);
        
        translate([-(_braceWidth-_sliderDepth+_sliderTolerance), 0, _sliderYOffset]) {
                translate([0, 0, _sliderHeight]) rotate([0, 180, 0])
                drawerSlide(extension);
            }
            
            translate([0, -extension, 0]) {
                translate([-(_braceWidth + _sliderTolerance), 2 * _braceWidth, 0]) rotate([0, 0, 180])
                sliderTray();
                
                translate([-(_sliderHeight + _thickness + _sliderTolerance), 0, _thickness])
                rotate([0,-90,0])
                drawerSlide(extension);
            }
    }
        
    translate([_width, _depth - _braceDepth, 0]) {
        translate([0, 2*_braceWidth, 0]) rotate([0,0,180])
        verticalSupport(_drawerHeight, _braceWidth, _braceDepth);
        
        translate([-(_braceWidth + _sliderTolerance), -extension, 0]) {
            translate([0, 2*_braceWidth, 0]) rotate([0, 0, 180])
                sliderTray();
        }
    }
}

module bottleDrawer(width) {
    
    // Layout Setup
    angle = 60;

    bw = _bottleWidth + 2*_bottleTolerance+2*_bottlePadding;
    bl = _bottleLength + 2*_bottleTolerance+2*_bottlePadding;

    xOffset = bw * cos(angle);
    yOffset = bl * sin(angle);

    evenRowCount=floor(width/bw);
    altRowCount=floor((width - xOffset) / bw);

    evenRows = floor((_depth) / (yOffset));
    altRows = floor((_depth - yOffset) / yOffset);

    total = (evenRowCount * evenRows + altRowCount * altRows);
    echo(total=total);

    usedDepth = max(evenRows * yOffset, (altRows * yOffset) + bl);
    usedWidth = max(evenRowCount * bw, (altRowCount * bw) + xOffset);
    
    union() {
        cube([width,_depth,_thickness]);
        // Draw the grid
        translate([(width-usedWidth)/2, (_depth - usedDepth) / 2, _thickness]) {
            // Even Rows
            for(r = [1 : 2 : evenRows]) {
                for(i = [1 : evenRowCount]) {
                    translate([(i-1) * bw, (r-1) * (yOffset), 0]) {
                        linear_extrude(height = _bottleDivisionHeight) {
                            difference() {
                                oval(bw,bl);
                                translate([_bottlePadding, _bottlePadding, 0]) {
                                    oval(bw-2*_bottlePadding, bl-2*_bottlePadding);
                                }
                            }
                        }                        
                    }
                }
            }

            // Odd Row
            for(r = [1 : 2: altRows]) {
                for(i = [1 : altRowCount]) {
                    translate([(i-1) * bw + xOffset, r * yOffset, 0]) {
                      linear_extrude(height = _bottleDivisionHeight) {
                        difference() {
                                oval(bw,bl);
                                translate([_bottlePadding, _bottlePadding, 0]) {
                                    oval(bw-2*_bottlePadding, bl-2*_bottlePadding);
                                }
                            }
                      }
                  }
                }
            }
        }
    }
}


module oval(x,y) {
    translate([x/2, y/2, 0])
    scale([x/y,1,0]) circle(d=y);
}

module bottle() {    
    union() {
        // Jar
        color("lightBlue")
            linear_extrude(height = _bottleHeight) {
                oval(_bottleWidth, _bottleLength);
            }   
        // Lid
        color("silver")
        translate([_bottleWidth / 2, _bottleLength / 2, _bottleHeight]) {
            cylinder(d1 = _lidDiameter1, d2 = _lidDiameter2, h = _lidHeight);
            }
    }
}

module sliderTray() {
        height = _sliderYOffset + _sliderHeight;
        width = _thickness + _sliderTolerance + _sliderHeight + _sliderTolerance;
        
        union() {
            cube([_thickness, _braceDepth, height]);
            cube([width, _braceDepth, _thickness]);
        }
    }
module drawerSlide(position) {
    translate([0, 0, 0]) {
        color("grey") {
            difference() {
                
                cube([_sliderDepth, _sliderLength, _sliderHeight]);            
                translate([_thickness, 0, 1.0 * _thickness / 2]) {
                    cube([_sliderDepth - 1.0*_thickness, _sliderLength, _sliderHeight - 1.0*_thickness]);
                }
            }
        }
        
        translate([1.5*_thickness, -position, 1.5 * _thickness / 2]) {
                color("silver") {
                    cube([_sliderDepth - 1.5 * _thickness, _sliderInnerLength, _sliderHeight - 1.5 * _thickness]);
                }
            }
    }
}



module verticalSupport(height, width, depth) {
    // Cutout for the slides
    color("white") {
        difference() {
            union() {
                difference() {
                    cube([width, depth, _slugHeight]);
                    slug(width, depth, _slugHeight);
                }

                translate([0, 0, _slugHeight]) {
                    cube([width, depth, height - _slugHeight]);
                }

                translate([0, 0, height]) {
                    intersection() {
                        cube([width, depth, _slugHeight]);
                        slug(width, depth, _slugHeight);
                    }
                }
            }
            
            translate([width - _sliderDepth + _sliderTolerance, 0, _sliderYOffset - _sliderTolerance/2]) {
                cube([_sliderDepth - _sliderTolerance, depth, 17 + _sliderTolerance]);
            }
        }
    }
     
    module slug(width, depth, height) {
        translate([_thickness, _thickness, 0]) {
            cube([width - 2 * _thickness, depth - 2 * _thickness, height]);
            }
    }
}
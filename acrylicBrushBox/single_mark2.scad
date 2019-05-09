//******************* Adjustable Parameters ***********
model = -1;

// Brush Parameters
barrelLength = 25;
barrelDiameter = 8.5;
bevelLength = 30;
bevelDiameter = 8;
handleLength = 117.5;
maxHandleDiameter = 12.5;

// Support Sizings
_supportHeight = 10;
_supportWidth = 15;
_supportInsertHeight = 5;
_supportInsertWidth = 10;
_tabSize = 10;
_tabScrewDiameter=3;

//Wall Thickness
_thickness = 2;

// Misc
_singleFingerDepth = 12;


//******************* Tunable Parameters ***********

_handleStart = barrelLength + bevelLength;

_overallBrushLength = _handleStart + handleLength;

// Clip Location and Sizings
_frontClipDiameter = bevelDiameter;
_frontClipOffset = _handleStart;

_backClipDiameter = 10;
_backClipOffset = _overallBrushLength - 15;


//******************* Derived / Calculated Parameters ***********

// Box Sizings
internalBoxHeight = max(
    _thickness * 2 + barrelDiameter, 
    _thickness * 2 + bevelDiameter,
    _thickness * 2 + maxHandleDiameter
)/2 + _supportHeight + _supportInsertHeight;

internalBoxLength = _overallBrushLength;

internalBoxWidth = max(
    _thickness * 2 + barrelDiameter, 
    _thickness * 2 + bevelDiameter,
    _thickness * 2 + maxHandleDiameter,
    _supportWidth,
    _thickness * 2 + _supportInsertHeight,
    _singleFingerDepth * 2 + maxHandleDiameter,     // One finger on each side of the widest part of the handle
    _tabSize
);

overallWidth = internalBoxWidth + 2*_thickness;
overallLength = internalBoxLength + 2*_thickness;
overallHeight = internalBoxHeight + _thickness;

lidOffset = internalBoxHeight - (_supportHeight + _supportInsertHeight);

lidWidth = overallWidth - _thickness;
lidLength = overallLength - _thickness;


lidAngle = 45;

// Output the final size of the box;
echo(overallWidth=overallWidth, overallLength=overallLength, overallHeight=overallHeight);

//******************* Assembly ***********
if(model < 0 || model ==0) color("orange") brush();

if(model < 0 || model ==1) color("yellow") translate([0, _frontClipOffset, 0]) clip(_frontClipDiameter);
if(model < 0 || model ==2) color("blue") translate([0, _backClipOffset, 0]) clip(_backClipDiameter);

if(model < 0 || model ==3) color("white") box();
if(model < 0 || model ==4) color("gray") lid();

//******************* Modules ***********
module clipMount() {
    
    width = max(_supportWidth, _supportInsertWidth + 2*_thickness, _tabSize);
    
    translate([0,0,- (_supportHeight + _supportInsertHeight)]) {
        
        linear_extrude(height=_supportInsertHeight)
        difference() {
            
            translate([-(width) / 2,-_tabSize,0])
            square([width, _tabSize + _thickness]);
            
            translate([-_supportInsertWidth/2,-_thickness,0]) {
                square([_supportInsertWidth, _thickness]);
            }
            
            translate([0, -_tabSize/2, 0]) {
                circle(d=_tabScrewDiameter-1, $fn=100);
            }
            
        }
    }
}
module clip(diameter) {
    
    _gap = 5;
    
    _topEdge = (diameter+_thickness)/2;
    _bottomEdge = -(diameter+_thickness)/2;
    _leftEdge = -(diameter+_thickness)/2;
    _rightEdge = (diameter+_thickness)/2;
    
    
    
    rotate([90,0,0]) 
    {
        union() {
            linear_extrude(height=_thickness) {
                union() {
                    difference() {
                        offset(radius=0.5, $fn=100)
                        polygon(points=[
                            // Top Edge
                            [_leftEdge, _topEdge],
                        
                            // Notch
                            [-_gap/2, _topEdge],
                            [-_gap/2, 0],
                            [_gap/2, 0],
                            [_gap/2, _topEdge],
                        
                            [_rightEdge, _topEdge],
                        
                            // Bottom Right
                            [_rightEdge, _bottomEdge],
                            
                            // Bottom Left
                            [_leftEdge, _bottomEdge]
                        ]);
                        
                        // Cutout for brush
                        circle(diameter/2, $fn=100);
                    }
                    
                    // Support + Insert
                    polygon(points=[
                        // Bottom Right
                        [_rightEdge, _bottomEdge],
                    
                        // Support Structure bottom left
                        [_supportWidth/2, -_supportHeight],
                        
                        // Support Insert
                        [_supportInsertWidth/2, -_supportHeight],
                        [_supportInsertWidth/2, -_supportHeight-_supportInsertHeight],
                        [-_supportInsertWidth/2, -_supportHeight-_supportInsertHeight],
                        [-_supportInsertWidth/2, -_supportHeight],
                        
                        // Support Structure bottom Right
                        [-_supportWidth/2, -_supportHeight],
                        
                        // Bottom Left
                        [_leftEdge, _bottomEdge]
                    ]);
                }
                
            }
            // Tab and Brace
            translate([-_tabSize/2, -_supportHeight, 0]) {
                difference() {
                    cube([_tabSize,_thickness,_tabSize]);
                    
                    translate([_tabSize/2, _tabSize/2 - _thickness, _tabSize/2]) {
                        rotate([90,0,0]) cylinder(h=_thickness*2, d=_tabScrewDiameter, $fn=100);
                    }
                }
            }
        }
    }    
}

module brush() {
    //Handle Profile
    rotate([-90, 0, 0])
    rotate_extrude(angle=360)
    polygon(points = [
        [0, 0],
        [barrelDiameter/2, 0],
        [barrelDiameter/2, barrelLength],
        [bevelDiameter/2, barrelLength],
        [bevelDiameter/2, barrelLength + bevelLength],
        [12.5/2, _handleStart + 5],
        [9.5/2, _handleStart + 29],
        [9.5/2, _handleStart + 48],
        [11/2, _handleStart + 67],
        [8/2, _overallBrushLength],
        [0, _overallBrushLength]
    ]);
}
module box() {
    union() {
        difference() {
            
            translate([-(overallWidth)/2, -_thickness, -(_supportHeight + _supportInsertHeight + _thickness)])
            cube([overallWidth, overallLength, overallHeight]);
            
            translate([-internalBoxWidth/2, 0, -(_supportHeight + _supportInsertHeight) ])
            cube([internalBoxWidth, internalBoxLength, internalBoxHeight+2*_thickness]);
        }
        translate([0, _frontClipOffset, 0]) clipMount();
        translate([0, _backClipOffset, 0]) clipMount();
        translate([-overallWidth / 2, -_thickness, lidOffset])
        linear_extrude(height=_thickness) {
            difference() {
                square([overallWidth, overallLength]);
                translate([_thickness/2, _thickness / 2, 0]) 
                    square([overallWidth - _thickness, overallLength - _thickness]);
                
                translate([lidWidth + _thickness / 2, lidLength/2 - lidWidth, 0]) {
                    square([_thickness, lidWidth*2+_thickness]);
                }
            }
        }
    }
}
module lid() {
    
    translate([-lidWidth/2,-_thickness/2,lidOffset]) {
        rotate([0,-(90-lidAngle),0])
        linear_extrude(height=_thickness) {
            union() {
                square([lidWidth, lidLength]);
                
                translate([lidWidth-_thickness/2, lidLength/2 - lidWidth, 0]) {
                    square([_thickness, lidWidth*2]);
                }
            }
        } 
    }
}

module hinge(angle = 0) {
    
    // Width
    width = 15;
    depth = 25;
    thickness = 0.5;

    barrel = 3;
    
    plate(width, depth, thickness);

    translate([0, depth/2, barrel/2]) {
        rotate([0, 90, 0]) cylinder(d=barrel, h=width);
        
        rotate([-(180-angle), 0, 0])
        translate([0,-depth/2,barrel/2-thickness])
        plate(width, depth, thickness);
        
    }
    
    module plate(width, depth, thickness) {
        holeoffset = 6.5;
        holeSpacing = 12;
        holeSize = 1.5;
        
        _plateDepth = (depth-1)/2;
        
        _cutoutTab = 10;
        _cutoutDiameter = (width - _cutoutTab);
        
        linear_extrude(height=thickness)
        difference() {
            square([width, _plateDepth]);
            
            // Front Cutouts
            circle(d=_cutoutDiameter);
            translate([width, 0, 0]) {
                circle(d=_cutoutDiameter);
            }
            
            // Holes
            translate([(3+holeSize/2), 5.5+holeSize/2,0]) circle(d=holeSize);
            translate([width-(3+holeSize/2), 5.5+holeSize/2,0]) circle(d=holeSize);
        }
    }
}


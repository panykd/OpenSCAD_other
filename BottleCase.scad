//400

volumeWidth = 360;
volumeDepth = 250;
drawHeight = 100;

partitionHeight = 40;    

thickness = 2;  // Thickness of structural Walls

// Slider parameters
sliderLength = 250;
sliderHeight = 37.2;
sliderWidth = 12.7;
sliderTravel = 228;

// Bottle Parameters
jarWidth = 32;
jarLength = 20;
jarHeight = 34;
lidDiameter1 = 15;
lidDiameter2 = 12;
lidHeight = 47;

jarPadding = 1;    // Space around each bottle
jarTolerance = 1;  // Tolerance on bottle fits

// Animation
__position = 0; // Position of the drawer slider(s)
__drawBottles = false;

assembly();

//jarTray(38, 26);
//translate([0,0, thickness])
//bottle();


// Modules
module assembly() {
    _position = min(__position, sliderTravel);

    _drawWidth = volumeWidth - 2 * sliderWidth;
    _drawDepth = min(sliderTravel, volumeDepth);

    // Sliders
    slide(_position);

    translate([_drawWidth, 0 ,0])
        rotate([0,180,0])     
            slide(_position);    

    translate([0,-_position, -partitionHeight/2])
        bottleDraw(_drawWidth, _drawDepth, 20, 32, 34, 47, 15);    // Oval Bottles

    module slide(position) {
        
        color("gray") {
            // Fixed Slider
            difference() {
                translate([-sliderWidth * 3/3, 0, -sliderHeight * 3/6])
                    cube([sliderWidth * 3/3, sliderLength, sliderHeight * 3/3]);
            
                translate([-sliderWidth * 2/3, 0, -sliderHeight * 2/6])    
                    cube([sliderWidth, sliderLength + thickness, sliderHeight * 2/3]);
            }
            
            // Middle Slider
            translate([0, -position * 1 / 2, 0])
            {
                difference() {
                    translate([-sliderWidth * 2/3, 0, -sliderHeight * 2/6])
                        cube([sliderWidth * 2/3, sliderLength, sliderHeight * 2/3]);
                
                    translate([-sliderWidth * 1/3, 0, -sliderHeight * 1/ 6])    
                        cube([sliderWidth, sliderLength + thickness, sliderHeight * 1/3]);    
                }
            }
            
            // Inner Slider
            translate([-sliderWidth * 1/3, -position, -sliderHeight * 1/ 6]) 
                cube([sliderWidth/3, sliderLength + thickness, sliderHeight/3]);    
        }
    }
}


module bottleDraw(drawWidth, drawDepth) {
    _supportHeight = jarHeight * 2/3;

    // Size of each bottle area
    _jL = min(jarWidth, jarLength);
    _jW = max(jarWidth, jarLength);

    _sW = _jW + 2 * jarTolerance + 2 * jarPadding;
    _sL = _jL + 2 * jarTolerance + 2 * jarPadding;
    
    echo(_sW = _sW, _sL = _sL);
    
    // Work out how many rows and columns can fit
    _columns = floor(drawDepth / _sL); 
    _rows = floor(drawWidth / _sW);

    echo(_drawWidth = drawWidth, drawDepth = drawDepth);
    echo(_rows = _rows, _columns=_columns);
    
    // Offsets
    x = (drawWidth - (_sW * _rows)) / 2;
    y = (drawDepth - (_sL * _columns));

   
    union() {
        color("green") {
            // Front panel
            translate([-sliderWidth,-2*thickness, -thickness])
                cube([volumeWidth, thickness, drawHeight]);
            
            // Side Panels    
            translate([0, -thickness, -thickness]) {
                cube([thickness, drawDepth + thickness, partitionHeight]);
            }    
         
            translate([drawWidth-thickness, -thickness, -thickness]) {
                cube([thickness, drawDepth + thickness, partitionHeight]);
            }
            
            // Rear Panel
            translate([0,drawDepth, -thickness])
            cube([drawWidth, thickness, partitionHeight]);

            // Upper tray supports
            translate([thickness, drawDepth, _supportHeight - 4 * thickness])
            rotate([90, 0, 0])
            upperTraySupport(drawDepth + thickness);
            
            translate([drawWidth - thickness, drawDepth, _supportHeight - 4 * thickness])
            rotate([90, 0, -90])
            upperTraySupport(drawWidth - 2 * thickness);
            
            translate([drawWidth - thickness, -thickness, _supportHeight - 4 * thickness])
            rotate([90, 0, 180])
            upperTraySupport(drawDepth + thickness);
            
            // Braces
            leftBrace = (floor(_columns * 1 / 3) * _sW) + x - thickness / 2;
            translate([leftBrace, -thickness, 0])
                cube([thickness, drawDepth, _supportHeight]);
            
            rightBrace = (ceil(_columns * 2 / 3) * _sW) + x - thickness / 2;
            translate([rightBrace, -thickness, 0])
                cube([thickness, drawDepth, _supportHeight]);
                
            frontBrace = (floor(_rows * 1 / 3) * _sL) - thickness / 2;
            translate([thickness, frontBrace, 0])
                cube([drawWidth - 2 * thickness, thickness, _supportHeight]);
            
            backBrace = (ceil(_rows * 2 / 3) * _sL) - thickness / 2;
            translate([thickness, backBrace, 0])
                cube([drawWidth - 2 * thickness, thickness, _supportHeight]);
            
            
            // Tray Level Spaces
            translate([0, 0, -thickness]) {
                union() {
                    cube([x, drawDepth, thickness]);
                
                    translate([drawWidth - x, 0, 0])
                        cube([x, drawDepth, thickness]);
                    
                    translate([0,_sL * _columns, 0])
                        cube([drawWidth, y, thickness]);
                        
                    translate([0, -thickness, 0])   
                        cube([drawWidth, thickness, thickness]);
                        
                    for(r=[0:_rows - 1]) {
                        for(c=[0:_columns - 1]) {
                            translate([(x + _sW / 2) + r * _sW, (_sL / 2) + c * _sL, 0]) {
                                jarTray(_sW, _sL);
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    *translate([0, 0, _supportHeight]) 
            {
                upperTray(x, y, _sL, _sW, _columns, _rows, drawWidth, drawDepth);
            }



    if(__drawBottles) {            
        // Display the bottles
        for(r=[0:_rows - 1]) {
            for(c=[0:_columns - 1]) {
                translate([x + _sW / 2 + r * _sW, _sL / 2 + c * _sL, 0]) {
                    translate([0, 0, thickness])
                    bottle();
                }
            }
        }
    }
}
module upperTraySupport(length) {
    linear_extrude(height = length)
        polygon([[0,0], [0, 4*thickness], [2*thickness, 4 * thickness]]);
}

module upperTray(xOffset, yOffset, sL, sW, columns, rows, drawWidth, drawDepth) {
    color("blue") {
        // Support Level
        translate([thickness, 0, 0])
        cube([xOffset - thickness, drawDepth, thickness]);

        translate([drawWidth - xOffset, 0, 0])
            cube([xOffset - thickness, drawDepth, thickness]);
        
        translate([thickness, sL * columns, 0])
            cube([drawWidth - 2*thickness, yOffset, thickness]);
            
        translate([0, -thickness, 0])   
            cube([drawWidth, thickness, thickness]);
        
        for(r=[0:rows - 1]) 
        {
            for(c=[0:columns - 1]) 
            {
                translate([(xOffset + sW / 2) + r * sW, (sL / 2) + c * sL, 0]) {
                    jarSupport(sW, sL);
                }
            }
        }
    }
}

module jarFootprint(height, x = 0) {
    w = jarWidth + 2*jarTolerance + x;
    l = jarLength + 2*jarTolerance + x;
    
    _w = max(l, w);
    _l = min(l, w);
    
    linear_extrude(height = height) {
        scale([_w/_l, 1, 1]) {
            circle(d = _l);
        }
    }
}

module bottle() {    
    union() {
        // Jar
        color("lightBlue")
        
            jarFootprint(jarHeight);
        
        
        // Lid
        color("silver")
        translate([0, 0, jarHeight]) {
            cylinder(d1 = lidDiameter1, d2 = lidDiameter2, h = lidHeight);
            }
    }
}

module jarTray(width, length) {
    difference() {
        union() {
            translate([-width/2, -length/2, 0])
                cube([width, length, thickness], center = false);
           
            translate([0, 0, thickness])
                jarFootprint(thickness, 2 * jarTolerance);
        }
        
        union() {
            translate([0, 0, thickness])
                jarFootprint(2*thickness, jarTolerance);
        
            translate([0, 0, -thickness])
                jarFootprint(3*thickness, - 4*thickness);
        }
    }
}

module jarSupport(width, length) {
    difference() {
        //
        translate([-width/2, -length/2, 0])
        cube([width, length, thickness], center = false);
        
        translate([0, 0, -thickness / 2])
        jarFootprint(2*thickness);        
    }
}
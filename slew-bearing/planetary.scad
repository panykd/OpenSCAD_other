include <involute_gears.scad>
include <C:\Program Files\OpenSCAD\libraries\MCAD\bearing.scad>
include <C:\Program Files\OpenSCAD\libraries\MCAD\stepper.scad>

// Parameters

// ring
ringTeeth = 128;
ringDiameter = 200;
ringThickness = 5;

caseThickness = 5;
ringCaseThickness = 5;


// planet
planetTeeth = 53;
planets = 3;
planetThickness=5;

sunTeeth=24;
sunThickness=5;

driveTeeth = 20;
driveThickness = 5;

motorGap = 2;

sunDriveTeeth=30;

// Calculations
circular_pitch = ringDiameter / ringTeeth * 180;

sunDiameter = pitch_diameter(sunTeeth, circular_pitch);
planetDiameter = pitch_diameter(planetTeeth, circular_pitch);

sunDriveThickness=driveThickness+motorGap;

// Motor
model = Nema17;
xOffset = (pitch_diameter(sunDriveTeeth, circular_pitch) + pitch_diameter(driveTeeth, circular_pitch)) / 2;
yOffset = motorGap + lookup(NemaFrontAxleLength, model) - lookup(NemaRoundExtrusionHeight, model);
    

// Calculate Pitch Radius for Ring
//pitch_diameter = number_of_teeth * circular_pitch / 180;
// circular_pitch = pitch_diameter / number_of_teeth * 180;

function pitch_diameter(t, p) = t * p / 180;

planets();
sun();
ring();

//drive();
//chassis();

module chassis() {
    translate([0, 0, -yOffset]) {
        // Main housing
        %linear_extrude(height=caseThickness) {
            difference() {
                circle(d=ringDiameter+2*ringCaseThickness);
                
                translate([xOffset, 0, 0]) {
                    // Placeholder
                    //square([100, 100], center = true);
                    
                    // Cutout
                    circle(d = lookup(NemaRoundExtrusionDiameter, model));
                    
                    // Mounting Holes
                    holeOffset = lookup(NemaDistanceBetweenMountingHoles, model)/2;
                    holeDiameter = lookup(NemaMountingHoleDiameter ,model);
                    
                    translate([+holeOffset, +holeOffset, 0]) circle(d=holeDiameter);
                    translate([+holeOffset, -holeOffset, 0]) circle(d=holeDiameter);
                    translate([-holeOffset, +holeOffset, 0]) circle(d=holeDiameter);
                    translate([-holeOffset, -holeOffset, 0]) circle(d=holeDiameter);
                }
            }
        }
        
        %difference() {
            cylinder(h=yOffset, d=ringDiameter+2*ringCaseThickness);
            cylinder(h=yOffset, d=ringDiameter);
        }
        
    }
    ring();
}


//




module drivePlate() {
    
}

module drive() {

    translate([xOffset, 0, -motorGap]) {
        driveGear();
        
        translate([0,0,motorGap-yOffset]) {
            rotate([0, 180, 0]) {
                motor(model = model);
            }
        }
    }
}

module driveGear() {
    translate([0, 0, -driveThickness]) {
        difference() {
            axel = lookup(NemaAxleDiameter, model);
            //key = lookup(NemaAxleFlatLengthFront, model);
            key = 10;
            union() {
                gear(number_of_teeth=driveTeeth, circular_pitch=circular_pitch, hub_thickness=driveThickness, rim_thickness=driveThickness, bore_diameter=0);
                translate([0, 0, -key]) {
                    cylinder(h = key, d = axel*2);
                }
            }
            linear_extrude(height=driveThickness) {
                circle(d=axel);
            }
        }       
    }
}


// ring
module ring() {
    difference() {
        cylinder(h = ringThickness, d = ringDiameter + 2*ringCaseThickness);
        linear_extrude(height = ringThickness) {
            gear(number_of_teeth = ringTeeth, circular_pitch=circular_pitch, flat=true, bore_diameter=0);
        }
    }
}

// planet
module planets() {
    planetOffset = (planetDiameter+sunDiameter)/2;


    for(i = [0 : planets]) {
        rotate([0, 0, i*(360/planets)]) {
            translate([planetOffset, 0, 0]) {
                gear(number_of_teeth=planetTeeth, circular_pitch=circular_pitch, hub_thickness=planetThickness, rim_thickness=planetThickness);
            }
        }
    }
}

// sun
module sun() {
    union() {
    gear(number_of_teeth=sunTeeth, circular_pitch=circular_pitch, hub_thickness=sunThickness, rim_thickness=sunThickness);

    translate([0, 0, -sunDriveThickness]) {
        gear(number_of_teeth=sunDriveTeeth, circular_pitch=circular_pitch, hub_thickness=sunDriveThickness, rim_thickness=sunDriveThickness);
    }
}
}
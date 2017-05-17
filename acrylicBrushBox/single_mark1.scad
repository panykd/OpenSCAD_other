// Constants
length = 106;   // Brush Length
width = 40;
height = 40;

lidBoxRatio = .5;

thickness=3;

_boxDepth = height * lidBoxRatio;
_lidDepth = height * (1-lidBoxRatio);

// Assembly
brushProfile();
*box();


//Animation
{
angle = -180*sin($t*180);    


color("blue") 
*box();

translate([0, 0, _boxDepth])
rotate([0,angle,0])
color("red") 
*lid();
}

// Modules
module brushProfile()
{
    rotate([-90, 0, 0])
    rotate_extrude(angle=360) {
        polygon(points=[
            // Backbone
            [0, 0],
            [0, 100],
        
            // Brush Tip
            [15, 100],
            [15, 70],
            [7.5, 70],
            [7.5, 67],
        
            
            // Handle Profile
            [10, 67],
            [10, 0]
        ]);
    }
}
module box() {
    difference() {
        // Main structure
        cube([width, length, _boxDepth]);
        
        // Brush Cutout
        translate([width / 2, thickness, height / 2]) {
            brushProfile();
        }
    }
}

module lid() {
    cube([width, length, _lidDepth]);
}
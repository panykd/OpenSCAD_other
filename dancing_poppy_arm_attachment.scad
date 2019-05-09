

$fn = 50;

thickness = 2;

opening = 10;
angle = 45;
support = 10;

catch = 2; 
insert = 5;

arm();

module arm() {
color("pink") {
    
    x = (opening) * sin(angle)  ;
    
    union() {
        intersection() {
            translate([-opening/2, 0, 0])
            cube([opening, opening + 2*x, opening ]);
            
            translate([0,x*sin(angle)/2,-x*sin(angle)/2])
            rotate([-angle,0,0]) {
                linear_extrude(height=support+support/sin(angle))
                scale([1, sin(angle)])
                {
                    difference() {
                        circle(d=opening);
                        
                        offset(delta=-thickness)
                            circle(d=opening);
                    }
                }
            }
        }
        
        translate([0, opening/2, -(insert+catch)])
        {
            difference() {
                union() {
                    cylinder(d=opening, h=(insert+catch));
                    cylinder(d1=opening, d2=(opening+catch),h=catch);
                }
                
                union() {
                    cylinder(d=opening-thickness, h=(insert+catch));
                    
                    translate([0, 0, (insert+catch)/2]) {
                        cube([opening-3*thickness, opening + catch, (insert+catch)], center = true);
                    }
                    
                    translate([0, 0, (insert+catch)/2]) {
                        cube([opening + catch, opening-3*thickness, (insert+catch)], center = true);
                    }
                }
            }
        }
    }
}
}
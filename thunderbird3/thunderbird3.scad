
radiator();

module radiator() {
    rounding = 2;
    
    oh = 35;
    
    difference() {
        translate([0, 0, rounding])
        union() {
            rotate_extrude(angle=360) 
            {
                polygon(points=[
                    [10, oh],
                    [20, 5],
                    [10, 0],
                    [0,0],
                    [0,oh]
                ]);
            }

            // Fins
            for(i = [0:15:360])
            {
                rotate([90, 0, i])
                {
                    linear_extrude(height=1, center=true) {
                        offset(r=rounding, $fn=25) {
                            polygon(points=[
                                [9, oh-rounding],
                                [20, 5],
                                [9, 0],
                                [0,0],
                                [0,oh-rounding]
                            ]);
                        }
                    }
                }
            }
        }
        translate([0, 0, -1]) cylinder(h=oh + 2 * rounding, d=10);
    }
}
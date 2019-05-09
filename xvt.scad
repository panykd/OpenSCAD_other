$fn = 50;

_size = 30;

union() {
    union()
    {
        //cube([15,15,15], center=true);

        sphere(d = _size);

        rotate([90, 0, 0]) 
        {
            translate([0,0,-_size/2]) 
            {
                linear_extrude(_size)
                x();
            }
        }

        rotate([90, 0, 90]) 
        {
            translate([0,0,-_size/2]) 
            {
                linear_extrude(_size)
                v();
            }
        }

        rotate([0, 0, 0]) 
        {
            translate([0,0,-_size/2]) 
            {
                linear_extrude(_size)
                t();
            }
        }
    }
    
    //cube([10, 10, 10], center=true);

}


module x() {
    difference() {
        //square([10,10], center=true);
        text("X", halign="center", valign="center", size=_size*2/3 );
    }
}

module v() {
    difference() {
        //square([10,10], center=true);
        text("V", halign="center", valign="center", size=_size*2/3 );
    }
}

module t() {
    difference() {
        //square([10,10], center=true);
        text("T", halign="center", valign="center", size=_size*2/3);
    }
}
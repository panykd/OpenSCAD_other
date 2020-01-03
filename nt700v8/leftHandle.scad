handleDiameter = 12;

combinationLower();

//leftCluster();

//combinationCombined();

module combinationCombined() {
    color("red") combinationLower();

    //color("blue") combinationUpper();
}


module combinationLower(width=50) {
    
    diameter=80;
        rotate([-90, 0, 0]) {
            rotate_extrude(angle=180) {            
                    square([diameter/2, width]);
        }
    }
}

module combinationUpper() {
}



module leftCluster() {
    handle();
    grip();
}

module handle() { 
    color("silver")
    translate([-50,0,0])
    rotate([0,90,0]) {
        cylinder(h=100, d=handleDiameter);
    }
}
module grip(length=100) {
    
    color("grey")
    rotate([0,90,0])
    difference() {
        union() {
            cylinder(h=length, d = 20);
            cylinder(h=5, d = 25);
        }
        
        cylinder(h=length, d=12);
    }
}


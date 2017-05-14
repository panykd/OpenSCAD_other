use <Bag.scad>;
use <shelf.scad>;
//use <trayv2.scad>;


//bag();

//trayAssembly();

translate([0,0,000]) rack();
//translate([0,0,100]) rack();
//translate([0,0,200]) rack();
//translate([0,0,300]) rack();
//translate([0,0,400]) rack();
//translate([0,0,500]) rack();

module rack() {
    // Left Side
    rowSide();

    // Right Side
    translate([2*30 + 2*170, 0]) {
        mirror([1, 0, 0]) {
            rowSide();
        }
    }



    // Front Row
    translate([30,0,13.25]) {
        translate([-8, 0, 0]) {
            color("blue") cube([340 + 2*8, 240, 4]);
        }
        
        translate([0, 0, 15]) {
            row();

            // Back Row
            translate([0,120,0])
            {
                row();
            }
        }
    }
}

module rowSide() {
    rail();
    translate([0, 150, 0]) {
        rail();
    }
}

module row () {

    translate([0, 0, 0]) {
        color("orange") import("tray.stl");
    }

    translate([170, 0, 0]) {
        color("orange") import("tray.stl");
    }
}





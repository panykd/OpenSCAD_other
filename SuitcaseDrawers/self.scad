use <bag.scad>;



rail();

module rail() {
    difference() {
        cube([30,300,30]);

        translate([20, 0, 10]) {
            cube([10, 300, 10]);
        }
    }
}
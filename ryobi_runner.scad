
runner();

module runner(length = 100) {
    color("lime") {
        rotate([90,0,0])
        translate([0,1.3,0]) {
            linear_extrude(height = length)
            union() {
            square([18.6, 2.6], center = true);
            translate([0, 2.6, 0])
                square([16.5, 3.1], center = true);
            }
        }
    }
}
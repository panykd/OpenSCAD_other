vacuumInner = 31;
sanderOuter = 63;

barrel = 20;

thickness = 2;


difference() {
    cylinder(h=barrel, d=sanderOuter+2*thickness);
    cylinder(h=barrel, d=sanderOuter);
}

translate([0, 0, barrel])
difference() {
    cylinder(h=barrel, d1=sanderOuter+2*thickness, d2=vacuumInner);
    cylinder(h=barrel, d1=sanderOuter, d2=vacuumInner-2*thickness);
}

translate([0, 0, 2*barrel])
difference() {
    cylinder(h=barrel, d=vacuumInner);
    cylinder(h=barrel, d=vacuumInner-2*thickness);
}
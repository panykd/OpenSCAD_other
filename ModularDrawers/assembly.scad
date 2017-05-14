
translate([0, 0, 0]) import("half-left.stl");

units = floor((320 - 36)/36);
echo(units=units);

for(i = [0:units]) {
    
    translate([18 + i * 36, 0,0]) import("center.stl");
}

translate([18 + ((units + 1) * 36), 0, 0]) import("half-right.stl");
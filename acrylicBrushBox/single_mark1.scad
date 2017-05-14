// Constants
length = 150;
width = 40;
height = 40;

lidBoxRatio = .6;

_boxDepth = height * lidBoxRatio;
_lidDepth = height * (1-lidBoxRatio);

// Assembly
color("blue") box();

translate([0, 0, _boxDepth])
color("red") lid();

// Modules

module box() {
    cube([width, length, _boxDepth]);
}

module lid() {
    cube([width, length, _lidDepth]);
}
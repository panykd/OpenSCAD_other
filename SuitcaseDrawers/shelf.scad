_width = 30;
_height = 30;
_depth = 150;

_sWidth = 10;
_sHeight = 5;

_pSize = 8;
_pLength = 50;

_bolt = 5;

__mode = 0;

if(__mode = 0) {
    rail();
}
else if (__mode = 1) {
    joiner();
}
else {
    rail();
}

//rail();

//joinerCutout();

joiner();

module joinerCutout() {
    translate([_pSize*1.5, 0, _pSize/2 + (_height - _pSize) / 2]) {
        union() {
            cube([_pSize, _pLength, _pSize], center = true);

            translate([0,_pLength / 4,0]) {
                pin(true);
            }

            translate([0,-_pLength / 4,0]) {
                pin(true);
            }
        }
    }
}

module joiner() {
    translate([_pSize*1.5, 0, _pSize/2 + (_height - _pSize) / 2]) {
        difference() {
            cube([_pSize, _pLength, _pSize], center = true);

            translate([0,_pLength / 4,0]) {
                pin(true);
            }

            translate([0,-_pLength / 4,0]) {
                pin(true);
            }
        }
    }
}

module pin(center = false) {
    cylinder(h=_height, d = 5, center = center);
}

module rail() {
    difference() {
        // Main Support
        cube([_width,_depth,_height]);

        // Slide cut-out
        translate([_width - _sWidth, 0, (_height - _sHeight) / 2]) {
            cube([_sWidth, 300, _sHeight]);
        }

        // Front joiner cutouts
        translate([0, 0, 0]) {
            joinerCutout();
        }
        
        translate([0, _depth, 0]) {
            joinerCutout();
        }
    }
}
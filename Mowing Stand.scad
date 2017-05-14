// Lawn Mower
lm_width = 1000;
lm_height = 600;
lm_length = 600;

lm_spacing = 50;

color("red")
translate([-lm_width/2, 0, 0]) {
    cube([lm_width, lm_length, lm_height]);
}

// Whipper Snipper
ws_width = 230;
ws_height = 1700;
ws_length = 230;
ws_spacing = 50;
ws_pu_height = 350; // Complete guess

color("red")
translate([-(ws_width/2), lm_length + lm_spacing + p_width, ws_pu_height + ws_spacing]) {
    //cube([ws_width, ws_length, ws_height]);
}
    
// Pine Dimensions
p_width = 35;
p_depth = 70;

// Shelf
sh_thickness = 8;
sh_width = 4*p_width + 2*lm_spacing + lm_width;
sh_length = lm_length + lm_spacing + p_width;

// Lengths
tallUpright = ws_spacing + ws_height;
shortUpright = lm_height + lm_spacing;
shortBrace = 4*p_width + 2*lm_spacing + lm_width;
longBrace = lm_length+lm_spacing;

// Peg Board
pb_thickness = 4.8;
pb_offset = sh_thickness + shortUpright;
pb_depth = lm_length + lm_spacing;
pb_length = tallUpright - pb_offset-p_depth;
pb_width = 2 * p_depth + lm_width;

// Uprights
color("yellow") {
    translate([-(lm_width/2 + lm_spacing), 0, 0]) {
        rotate([90, 0, 180])
        cube([p_width, tallUpright, p_depth]);
        echo(TallUpright=tallUpright);
    }

    translate([(lm_width/2 + lm_spacing + p_width), 0, 0]) {
        rotate([90, 0, 180])
        cube([p_width, tallUpright, p_depth]);
        echo(TallUpright=tallUpright);
    }
    
    translate([-(lm_width/2 + lm_spacing), lm_length - p_depth + lm_spacing, 0]) {
        rotate([90, 0, 180])
        cube([p_width, tallUpright, p_depth]);
        echo(TallUpright=tallUpright);
    }
    translate([(lm_width/2 + lm_spacing + p_width), lm_length - p_depth + lm_spacing, 0]) {
        rotate([90, 0, 180])
        cube([p_width, tallUpright, p_depth]);
        echo(tallUpright=tallUpright);
    }
}
// Right Side Braces
translate([(lm_width/2 + lm_spacing + p_width), 0, 0]) {
    translate([0, 0, 0]) {
        cube([p_width, longBrace, p_depth]);
        echo(LongBrace=longBrace);
    }

    translate([0, 0, shortUpright - p_depth]) {
        cube([p_width, longBrace, p_depth]);
        echo(LongBrace=longBrace);
    }
    
    translate([0, 0, tallUpright - p_depth]) {
        cube([p_width, longBrace, p_depth]);
        echo(LongBrace=longBrace);
    }
}
// Left Side Braces
translate([-(lm_width/2 + lm_spacing + 2*p_width), 0, 0]) {
    // Bottom
    translate([0, 0, 0]) {
        cube([p_width, longBrace, p_depth]);
        echo(LongBrace=longBrace);
    }

    // Middle
    translate([0, 0, shortUpright - p_depth]) {
        cube([p_width, longBrace, p_depth]);
        echo(LongBrace=longBrace);
    }
    
    // Top
    translate([0, 0, tallUpright - p_depth]) {
        cube([p_width, longBrace, p_depth]);
        echo(LongBrace=longBrace);
    }
}

// Back Braces
color("blue")
translate([(lm_width/2 + lm_spacing + 2*p_width), lm_length + lm_spacing, 0]) {
    // Bottom
    translate([0, 0, 0]) {
        rotate([0, 0, 90]) {
            cube([p_width, shortBrace, p_depth]);
            echo(ShortBrace=shortBrace);
        }
    }
    
    // Middle
    translate([0, 0, shortUpright - p_depth]) {
        rotate([0, 0, 90]) {
            cube([p_width, shortBrace, p_depth]);
            echo(ShortBrace=shortBrace);
        }
    }
    
    // Top
    translate([0, 0, tallUpright-p_depth]) {
        rotate([0, 0, 90]) {
            cube([p_width, shortBrace, p_depth]);
            echo(ShortBrace=shortBrace);
        }
    }
}

// Shelf
color("green")
translate([-(2*p_width + lm_spacing + lm_width/2), 0, shortUpright]) {
    difference() {
        cube([sh_width, sh_length, sh_thickness]);
        
        translate([0, 0, -1]) {
            cube([2*p_width, p_depth, sh_thickness + 2]);
        }
        
        /*
        translate([2*p_width + 2*lm_spacing + lm_width, 0, -1]) {
            cube([2*p_width, p_depth, sh_thickness + 2]);
        }
        */
        
        translate([0, lm_length + lm_spacing - p_depth, -1]) {
            cube([2*p_width, p_depth + p_width, sh_thickness + 2]);
        }
        
        translate([2*p_width + 2*lm_spacing + lm_width, lm_length + lm_spacing - p_depth, -1]) {
            cube([2*p_width, p_depth + p_width, sh_thickness + 2]);
        }
    }
    echo(Shelf_Width=sh_width,Shelf_Length=sh_length);
}
//Peg Board
color("brown")
translate([0, 0, pb_offset]) {
    
    // Left Panel
    translate([-(lm_width/2 + lm_spacing + p_width), 0, 0]) {
        cube([pb_thickness, pb_depth, pb_length]);
        echo(PegBoard_Depth=pb_depth,PegBoard_Length=pb_length);
    }
    
    // Right Panel
    translate([(lm_width/2 + lm_spacing + p_width), 0, 0]) {
        cube([pb_thickness, pb_depth, pb_length]);
        echo(PegBoard_Depth=pb_depth,PegBoard_Length=pb_length);
    }
    
    // Back Panel
    translate([-(lm_width/2 + lm_spacing), lm_length +lm_spacing, 0]) {
        cube([pb_width, pb_thickness, pb_length]);
        echo(PegBoard_Width=pb_width,PegBoard_Length=pb_length);
    }
}

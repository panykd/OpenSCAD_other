// sides 2@7"x19.5"
// bottom 1@7"x13.5"
// top1 1@7"x14"
// top2 1@7.5"x15"
// door 2@6.25"x20"
// shelf 1@7"x12"
// shelfOffset 4"

$fn = 20;

// Parameters
depth = 200; // 7in
width = 350; //13.5in
height = 500; //19.5in

thickness = 19; // 0.75in
doorThickness = 13; // 0.5in

shelfOffset = 100; // 4in
topOverhang = 5; //0.25in

angle = 135;
assembly();

dowel = 19;    // 0.75in
dowelOffset = 300; // 12in

//door();

module assembly() {
    bottom();

    translate([0,0,thickness]) {
        color("pink")
        side();
        
        translate([width-thickness,0,0])
        color("pink")
        side();
    }
    
    translate([0, -doorThickness, thickness/2]) {
        translate([thickness,0,0]) {
            rotate([0,0,-angle])
            door();
        }
        
        translate([(width-thickness), 0, 0]) {
            
            mirror([1,0,0])
            rotate([0,0,-angle])
            door();
        }
    }
    
    translate([0, depth/2, thickness + dowelOffset]) {
        rotate([0,90,0])
        dowel();
    }
    
    translate([thickness,0,(height+thickness-shelfOffset-thickness)]) {
        shelf();
    }
    
    translate([-topOverhang, 0, thickness+height]) {
        top1();
    }
    
    translate([-2*topOverhang, -topOverhang, thickness+height+thickness]) {
        top2();
    }
    translate([0,depth, 0]) {
        back();
    }
}

module bottom() {
    w = width;
    d = depth;
    t = thickness;
    
    echo("Bottom: ", w, d, t);
    
    color("orange")
    cube([w,d, t]);
}

module side() {
    w = thickness;
    d = depth;
    t = height;
    
    echo("Side: ", t, d, w);
    
    color("pink")
    difference() {
        cube([w, d, t]);
        translate([0, depth/2, dowelOffset]) {
            rotate([0, 90, 0])
            cylinder(d=dowel, h=thickness);
        }
    }
}

module top1() {
    w = width+2*topOverhang;
    d = depth;
    t = thickness;
    
    echo("Top1: ", w, d, t);
    
    color("lightBlue")
    cube([w, d, t]);
}

module top2() {
    w = width+4*topOverhang;
    d = depth + 2*topOverhang;
    t = thickness;
    
    echo("Top2: ", w, d, t);
    
    color("blue")
    cube([w, d, t]);
}
module door() {
    doorWidth = width/2 - thickness;
    
    w = width/2 - thickness;
    d = doorThickness;
    t = height + thickness;
    
    echo("Door: ", t, w, d);
    
    color("green")
    cube([w, d, t]);
}
module shelf() {
    w = width - 2*thickness;
    d = depth;
    t = thickness;
    
    echo("Shelf: ", w, d, t);
    
    color("yellow");
    cube([w, d, t]);
}
module dowel() {
    d=dowel;
    l=width;
    
    echo("Dowel: ", l, d);
    
    color("brown")
    cylinder(d=d, h=l);
}
module back() {
    w = width;
    h = height + 2 * thickness;
    t = 3;
    
    echo("back: ", w, h, t);
    
    color("gray")
    cube([w, t, h]);
}
    
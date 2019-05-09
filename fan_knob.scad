$fn=50;

bottomDiameter = 24;
upperDiameter = 21;
height = 13;

_t = 2;


shaftDiameter=6;
shaftLength=8;
notch=1;


difference() {
    knob();
    shaft();
}

module shaft() {
    difference() {
        cylinder(h=shaftLength,d=shaftDiameter);

        translate([-shaftDiameter/2,-(shaftDiameter/2)-_t+notch,0]) {
            cube([shaftDiameter,_t,height]);
        }
    }
}

module knob() {
    
    for(x=[0:90:360]) {
        rotate([90,0,x])
        linear_extrude(height=_t/2, center=true)
        polygon(points=[
            [(shaftDiameter)/2, 0],
            [(bottomDiameter)/2, 0],
            [(upperDiameter)/2, height-_t],
            [(shaftDiameter)/2, height-_t]
        ]);
    }
    
    difference() {
        cylinder(h=height,d1=bottomDiameter,d2=upperDiameter);
        cylinder(h=height-_t,d1=bottomDiameter-_t,d2=upperDiameter-_t);
    }
    
    

    difference() {
        cylinder(h=13,d=7.5);    
    }
}
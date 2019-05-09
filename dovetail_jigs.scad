// Parameters
width = 110;
thickness = 11;
profileWidth = 30;

// Calculations
count = round((width-profileWidth)/profileWidth) - (round((width)/profileWidth))%2;

usedWidth = profileWidth * count;
xOffset = (width - usedWidth) / 2;

echo(count, usedWidth, xOffset);

square([width, thickness]);

for(x = [0:2:count]) {
    translate([xOffset + profileWidth * x, 0, 0])
    #profile(profileWidth, thickness);
}

module profile(w, h) {
    
    
    
    polygon(points=[
        [0, 0],
        [w, 0],
        [w, h],
        [0, h]
    ]);
    
    //square([w, h]);
}
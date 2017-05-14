ad = 20;
aw = 32;
tolerance = 1;

padding = 1;

d = ad + 2 * tolerance + 2*padding;
w = aw + 2 * tolerance + 2*padding;

stacks = 3;

width = 330;
depth = 240;
//width = 278;
//depth = 218;

box();
oval();

angle = 60;

xOffset = w * cos(angle);
yOffset = d * sin(angle);

evenRowCount=floor(width/w);
altRowCount=floor((width - xOffset) / w);

evenRows = floor((depth) / (yOffset));
altRows = floor((depth - yOffset) / yOffset);

total = (evenRowCount * evenRows + altRowCount * altRows);

usedDepth = max(evenRows * yOffset, (altRows * yOffset) + d);
usedWidth = max(evenRowCount * w, (altRowCount * w) + xOffset);

echo(total=total, all=total*stacks);
echo(total=total);

translate([(width-usedWidth)/2, (depth - usedDepth) / 2, 0]) {
    // Even Rows
    for(r = [1 : 2 : evenRows]) {
        for(i = [1 : evenRowCount]) {
            translate([(i-1) * w, (r-1) * (yOffset), 0])
                oval(aw,ad);
        }
    }

    // Odd Row
    for(r = [1 : 2: altRows]) {
        for(i = [1 : altRowCount]) {
        color("yellow")
            translate([(i-1) * w + xOffset, r * yOffset, 0])
                oval(aw, ad);
        }
    }
}

module oval(x,y) {
    translate([x/2, y/2, 0])
    scale([x/y,1,0]) circle(d=y);
}    

module box() {
    color("blue")
    translate([0, 0, -1])
    square([width, depth]);
}
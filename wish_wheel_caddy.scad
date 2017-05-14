/* Small Wish Wheel tray */

// Overall length of the tray.
length = 150;

// Size of the to store
caddy_diameter = 40;
caddy_thickness = 10;

// Way up the caddy to have walls
caddy_held = 0.4;


// Spacing around the caddies
caddy_padding = 1;
wall_thickness = 2;

// Calculate the size of the slots
slot_diameter = caddy_diameter + caddy_padding;
slot_thickness = caddy_thickness + 2 * caddy_padding;

// Work out the number of slots based on the length
total_slots = (length - wall_thickness) / (slot_thickness + wall_thickness);

slots = floor(total_slots);

overall_width = slot_diameter * caddy_held + wall_thickness;

echo("Size:  ", length, overall_width);
echo("Slots: ", slots);



// Reference Caddys
color("White")
    for(i=[0:slots-1])
        translate([i * (slot_thickness + wall_thickness) + caddy_padding,0,0,])
            rotate([0, 90, 0])
                cylinder(h=caddy_thickness, d=caddy_diameter);
    
// Tray
difference() {
    
    // The base of the tray
    translate(
        [-wall_thickness, 
        -(slot_diameter / 2 + wall_thickness), 
        -(slot_diameter / 2 + wall_thickness)])
            cube([
                length, 
                slot_diameter + wall_thickness * 2, 
                overall_width]);
    
    // Slots for the 'wheels'
    for(i=[0:slots-1])
        translate([i * (slot_thickness + wall_thickness),0,0])
            rotate([0, 90, 0])
                cylinder(h=slot_thickness, d=slot_diameter);
}
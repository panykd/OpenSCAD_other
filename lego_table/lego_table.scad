overallWidth = 800;
overallLength =  1200;
overallHeight = 700;

legWidth = 89;
legThickness = 19;

tableHeight = 89;
tableEdge = 19;

tableSurfaceThickness = 12;

tableDadoDepth = 4;
tableSurfaceOffset = 60;

slideCurrentExtension = 500;
slideMaxExtension = 300;
slideGap = 3;
slideLength = 300;
slideWidth = 45;
slideThickness = 25;


wellDepth = 150;
wellThickness = 19;

shelfThickness = 12;
shelfDepth = 42;
shelfSupportThickness = 19;

includeBottomShelf = false;

assembly();

module assembly() {
    addHeader();
    
    translate([0,0,overallHeight - tableHeight]) {
        table();
    }
    
    // Well
    wellOffset = overallHeight - tableHeight - wellDepth + tableSurfaceOffset - slideGap;
    
    translate([tableEdge, tableEdge + slideThickness, wellOffset]) {
        well();
    }
    
    // Front Left
    translate([tableEdge+wellThickness,tableEdge + slideThickness+wellThickness,0]) {
        mirror([0,0,0]) {
            rotate([0,0,0]) {
                leg();
            }
        }
    }
    
    // Front Right
    translate([overallLength-(tableEdge+wellThickness),tableEdge + slideThickness+wellThickness,0]) {
        mirror([1,0,0]){
            rotate([0,0,0]) {
                leg();
            }
        }
    }
    
    // Rear Left
    translate([tableEdge+wellThickness,overallWidth-(tableEdge + slideThickness+wellThickness),0]) {
        mirror([1,0,0]) {
            rotate([0,0,180]) {
                leg();
            }
        }
    }
    
    // Rear Right
    translate([overallLength-(tableEdge+wellThickness),overallWidth-(tableEdge + slideThickness+wellThickness),0]) {
        mirror([0,0,0]){
            rotate([0,0,180]) {
                leg();
            }
        }
    }
    
    // Common offset for shelf placement
    translate([tableEdge + wellThickness+legThickness, tableEdge + slideThickness + wellThickness + legThickness, 0]) {
        if(includeBottomShelf) {
            // Bottom Shelf
            shelf();
            
            // middle Shelf
            shelfOffset = (wellOffset -  shelfDepth) / 2;
            translate([0,0,wellOffset/2]) {
                shelf();
            }
        }
        else {
            // Shelf
            translate([0,0, (wellOffset -  shelfDepth) / 2]) {
                shelf();
            }
        }
    }
}
module table() {
    
    pos = max(0, min(slideMaxExtension, slideCurrentExtension));
    
    // Left Surface
    translate([-pos, 0, 0]) {
        tableLeft();
    }
    
    // Right Surface
    translate([overallLength/2 + pos, 0, 0]) {
        tableRight();
    }
    
    translate([tableEdge,tableEdge,tableSurfaceOffset - slideWidth - slideGap]) {
        slide(pos);
    }
    
    translate([tableEdge,overallWidth-tableEdge-slideThickness,tableSurfaceOffset - slideWidth - slideGap]) {
        slide(pos);
    }
    
    
    
    
    translate([(overallLength - tableEdge),tableEdge,tableSurfaceOffset - slideGap]) {
        rotate([0,180,0])
        slide(pos);
    }
    
    translate([(overallLength - tableEdge),overallWidth-tableEdge-slideThickness,tableSurfaceOffset - slideGap]) {
        rotate([0,180,0])
        slide(pos);
    }

}
module shelf() {
    shelfWidth = overallWidth - 2*tableEdge-2*slideThickness-2*wellThickness-2*legThickness;
    shelfLength = overallLength - 2*tableEdge-2*wellThickness-2*legThickness;
    
    shelfInnerWidth = shelfWidth - 2*shelfSupportThickness;
    
    // Front
    translate([0, 0, 0]) {
        addPart("Shelf Edge", shelfLength, shelfDepth, shelfSupportThickness);
        cube([shelfLength, shelfSupportThickness, shelfDepth]);
    }
    
    // Back
    translate([0,shelfWidth - shelfSupportThickness,0]) {
        addPart("Shelf Edge", shelfLength, shelfDepth, shelfSupportThickness);
        cube([shelfLength, shelfSupportThickness, shelfDepth]);
    }
    
    // Outer Left
    translate([shelfSupportThickness, shelfSupportThickness,0]) {
        rotate([0, 0, 90]) {
            addPart("Shelf Edge", shelfInnerWidth, shelfDepth, shelfSupportThickness);
            cube([shelfInnerWidth, shelfSupportThickness, shelfDepth]);
        }
    }
    
    // Inner Left
    translate([2*shelfSupportThickness, shelfSupportThickness,0]) {
        rotate([0, 0, 90]) {
            addPart("Shelf Support", shelfInnerWidth, shelfDepth-shelfThickness, shelfSupportThickness);
            cube([shelfInnerWidth, shelfSupportThickness, shelfDepth-shelfThickness]);
        }
    }
    
    //centre
    translate([(shelfLength - 2*shelfSupportThickness) / 2, shelfSupportThickness,0]) {
        rotate([0, 0, 90]) {
            addPart("Shelf Support", shelfInnerWidth, shelfDepth-shelfThickness, shelfSupportThickness);
            cube([shelfInnerWidth, shelfSupportThickness, shelfDepth-shelfThickness]);
        }
    }
    
    // Inner Right
    translate([shelfLength - shelfSupportThickness, shelfSupportThickness,0]) {
        rotate([0, 0, 90]) {
            addPart("Shelf Support", shelfInnerWidth, shelfDepth-shelfThickness, shelfSupportThickness);
            cube([shelfInnerWidth, shelfSupportThickness, shelfDepth-shelfThickness]);
        }
    }
    
    // Outer Right
    translate([shelfLength, shelfSupportThickness,0]) {
        rotate([0, 0, 90]) {
            addPart("Shelf Edge", shelfInnerWidth, shelfDepth, shelfSupportThickness);
            cube([shelfInnerWidth, shelfSupportThickness, shelfDepth]);
        }
    }
    
    // Sheet
    translate([shelfSupportThickness,shelfSupportThickness,shelfDepth-shelfThickness]) {
        addPart("Shelf", shelfLength  - 2*shelfSupportThickness, shelfInnerWidth, shelfSupportThickness);
        cube([shelfLength  - 2*shelfSupportThickness, shelfInnerWidth, shelfThickness]);
    }
}
module well() {
    wellWidth = overallWidth - 2*tableEdge-2*slideThickness;
    wellLength = overallLength - 2*tableEdge;
    
    wellInnerWidth = wellWidth - 2*wellThickness;
    
    //Front
    translate([0, 0, 0]) {
        cube([wellLength, wellThickness, wellDepth]);
        addPart("Well Side", wellLength, wellDepth, wellThickness);
    }
    
    // Back
    translate([0, wellWidth-wellThickness, 0]) {
        addPart("Well Side", wellLength, wellDepth, wellThickness);
        cube([wellLength, wellThickness, wellDepth]);
    }
    
    // Left
    translate([wellThickness, wellThickness, 0]) {
        rotate([0,0,90]) {
            addPart("Well Side", wellInnerWidth, wellDepth, wellThickness);
            cube([wellInnerWidth, wellThickness, wellDepth]);
        }
    }
    
    // Right
    translate([wellLength, wellThickness, 0]) {
        rotate([0,0,90]) {
            addPart("Well Side", wellInnerWidth, wellDepth, wellThickness);
            cube([wellInnerWidth, wellThickness, wellDepth]);
        }
    }
    
    
    
    // Left Buffer
    translate([slideMaxExtension-tableEdge, wellThickness, wellThickness]) {
        rotate([0,0,90]) {
            addPart("Well Buffer", wellInnerWidth, wellDepth-wellThickness, wellThickness);
            cube([wellInnerWidth, wellThickness, wellDepth-wellThickness]);
        }
    }
    
    // Right Buffer
    translate([slideMaxExtension-tableEdge + 2*slideMaxExtension + wellThickness, wellThickness, wellThickness]) {
        rotate([0,0,90]) {
            addPart("Well Buffer", wellInnerWidth, wellDepth-wellThickness, wellThickness);
            cube([wellInnerWidth, wellThickness, wellDepth-wellThickness]);
        }
    }
    
    
    // Well Bottom
    translate([slideMaxExtension-tableEdge-wellThickness, wellThickness, 0]) {
        rotate([90,0,90]) {
            addPart("Well Base", wellInnerWidth, 2*slideMaxExtension + 2*wellThickness, wellThickness);
            cube([wellInnerWidth, wellThickness, 2*slideMaxExtension + 2*wellThickness]);
        }
    }
}

module slide(extension = 0) {
    color("gray")
    translate([-extension, 0, 0])
    cube([slideLength + extension, slideThickness, slideWidth]);
}

module tableSurface() {
    
    width = overallWidth - (2*tableEdge) + 2*(tableDadoDepth);
    length = overallLength/2 - tableEdge + tableDadoDepth;
    
    addPart("Table Surface", length, width, tableSurfaceThickness);
    
    color("white")
    linear_extrude(tableSurfaceThickness) {
        square([length, width]);
    }
}

module tableLeft() {
    // Left
    translate([tableEdge,0,0]) {
        rotate([0,0,90]) {
            tableSidePiece(overallWidth);
        }
    }

    // Left Front
    translate([overallLength/2,tableEdge,0]) {
        rotate([0,0,180]) {
            tableSidePiece(overallLength/2, 0, 1);
        }
    }

    // Left Rear
    translate([0,overallWidth-tableEdge,0]) {
        rotate([0,0,0]) {
            tableSidePiece(overallLength/2, 1, 0);
        }
    }
    
    translate([tableEdge-tableDadoDepth,tableEdge-tableDadoDepth,tableSurfaceOffset]) {
        tableSurface();
    }
}

module tableRight() {
    // right
    translate([overallLength/2-tableEdge,overallWidth,0]) {
        rotate([0,0,-90]) {
            tableSidePiece(overallWidth);
        }
    }

    // Right Front
    translate([overallLength/2,tableEdge,0]) {
        rotate([0,0,180]) {
            tableSidePiece(overallLength/2, 1, 0);
        }
    }

    // Right Rear
    translate([0,overallWidth-tableEdge,0]) {
        rotate([0,0,0]) {
            tableSidePiece(overallLength/2, 0, 1);
        }
    }
    
    translate([0,tableEdge-tableDadoDepth,tableSurfaceOffset]) {
        tableSurface();
    }
}

module tableSidePiece(length, mitreLeft = true, mitreRight = true) {
    color("yellow")
    translate([length,tableEdge,tableHeight])
    rotate([180,90,0])
    difference() {
        linear_extrude(length) {
            tableProfile();
        }
        
        addPart("Table Edge", tableHeight, tableEdge, length);
        
        if(mitreLeft) {
            // mitre ends
            translate([tableHeight, tableEdge, length]) {
                rotate([90,90,-90]) {
                    linear_extrude(tableHeight) {
                        polygon([
                            [0, 0],
                            [tableEdge, 0],
                            [0, tableEdge]
                        ]);
                    }
                }
            }
        }
            
        if(mitreRight) {
        // mitre ends
            translate([0, tableEdge, 0]) {
                rotate([90,-90,90]) {
                    linear_extrude(tableHeight) {
                        polygon([
                            [0, 0],
                            [tableEdge, 0],
                            [0, tableEdge]
                        ]);
                    }
                }
            }
        }
    }
}

module tableProfile() {
    polygon([
        [0,                 0],
        [0,                 tableEdge],
        [tableHeight-tableSurfaceOffset,       tableEdge],
        [tableHeight-tableSurfaceOffset,       tableEdge-tableDadoDepth],
        [tableHeight-tableSurfaceOffset-tableSurfaceThickness,       tableEdge-tableDadoDepth],
        [tableHeight-tableSurfaceOffset-tableSurfaceThickness,       tableEdge],
        [tableHeight,       tableEdge],
        [tableHeight,       0]
    ]);
}

module leg() {
    rotate([90, 0, 90]) {
        legPart();
    }

    translate([legThickness, legThickness, 0])
    rotate([90, 0, 0]) {
        legPart();
    }
}

module legPart() {
    
    h=overallHeight - tableHeight + tableSurfaceOffset - slideGap;
    
    addPart("Leg", h, legWidth, legThickness);
    
    linear_extrude(legThickness) {
        polygon([
            [0,     0],
            [legWidth/2,   0],
            [legWidth,     h],
            [0,     h]
        ]);
    }
}

module addHeader() {
    // Type, Name, Width, Height, Depth, Description)
    echo("Type,Label,Width,Height,Depth,Description");
}

module addPart(label, width, height, depth, description="") {
    // Type, Name, Width, Height, Depth, Description)
    echo(str("PART,", label, ",",width,",",height,",",depth,",",description));
}

module addInfo(label, description="", width="", height="", depth="") {
    // Type, Name, Width, Height, Depth, Description)
    echo(str("INFO,", label, ",",width,",",height,",",depth,",",description));
}
ECHO Exporting all Scad Files...

SET APP="C:\Program Files\OpenSCAD\openscad.exe"

%APP% -o mkII_brush.stl -D model=0 single_mark2.scad
%APP% -o mkII_frontClip.stl -D model=1 single_mark2.scad
%APP% -o mkII_backClip.stl -D model=2 single_mark2.scad
%APP% -o mkII_box.stl -D model=3 single_mark2.scad
%APP% -o mkII_lid.stl -D model=4 single_mark2.scad

ECHO Done!
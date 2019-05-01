include <Basolur.scad>

$fn=200;
diam=24;
side=7;
height=4;
reduce=2;

function scaleDiam(base, reduce) = (base-reduce)/base;

difference(){
    minkowski(){
        linear_extrude(height=height, scale=scaleDiam(diam, reduce*2)) reuleaux(side=side, diameter=diam);
        sphere(0.2);
    }
    translate([0,0,-15]) cube([100,100,30],center=true);
}

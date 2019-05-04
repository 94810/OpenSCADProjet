include <Basolur.scad>

$fn=100;


module drop(diam=10){
  rotate([0,0, 45]) union(){
    circle(d=diam);
    difference(){
      square([diam, diam], center=true);
      translate([-diam/2, 0]) square([diam, diam]);
      translate([-diam/2, 0]) square([diam, diam], center=true);
    }
  }
}

drop();
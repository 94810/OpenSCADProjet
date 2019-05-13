include <Basolur.scad>

$fn=100;

diam=25;

function conscrit(x) = x;

difference(){
  reuleaux(side=3, diameter=conscrit(diam));
  circle(r=diam-rayon(diam, 360/3));
}
%circle(conscrit(diam)/2);


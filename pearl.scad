$fn=50;

stringDiam=2;
height=20;
diam=15;
step=5;
longFactor=1;

side=5;


function rayon(diameter, baseAngle) = diameter / (2*sin((360-baseAngle)/4));

function dot(baseAngle, nb, diameter) = rayon(diameter, baseAngle) * [-sin(baseAngle*nb),cos(baseAngle*nb)];

module reuleaux(side=3, diameter=10){
		dots = [for(i=[0:side-1])dot(360/side, i, diameter)];
		intersection_for(i=dots)
			translate(i)circle(r=diameter);
}

module halfSphere(step=5, diam=10, longFactor=1, side=3){
	hull(){
		for(angle=[0:step:90]){
			translate([0,0,diam*longFactor*0.5*sin(angle)]) linear_extrude(0.1) reuleaux(side=side, diameter=diam*cos(angle));
		}
	}
}

module reuleauxSphere(step=5, diam=10, longFactor=1, side=3){
  halfSphere(step, diam, longFactor, side);
  rotate([0,180,0]) halfSphere(step, diam, longFactor, side);
}

difference(){

    reuleauxSphere(step, diam, longFactor, side);
    translate([0,0,-diam/1.7]) reuleauxSphere(step, diam/1.5, longFactor, side);

  cylinder(stringDiam, h=100, center=true);
}
$fn=100;
border=37;

function rayon(diameter, baseAngle) = diameter / (2*sin((360-baseAngle)/4));
function dot(baseAngle, nb, diameter) = rayon(diameter, baseAngle) * [-sin(baseAngle*nb),cos(baseAngle*nb)];

module reuleaux(side=3, diameter=10){
		dots = [for(i=[0:side-1])dot(360/side, i, diameter)];
		intersection_for(i=dots)
			translate(i)circle(r=diameter);
}

difference(){
    reuleaux(side=4, diameter=15*8+border);
    square(15*8, center=true);
}
square(15, center=true);
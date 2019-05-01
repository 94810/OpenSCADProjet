
$fn=50;
tol=0.45;
pi = 3.141592 ;
font="Elric";

TolTest=0;

function rayon(diameter, baseAngle) = diameter / (2*sin((360-baseAngle)/4));
function dot(baseAngle, nb, diameter) = rayon(diameter, baseAngle) * [-sin(baseAngle*nb),cos(baseAngle*nb)];
module reuleaux(side=3, diameter=10){
		dots = [for(i=[0:side-1])dot(360/side, i, diameter)];
		intersection_for(i=dots)
			translate(i)circle(r=diameter);
}

module ballElt(
	ballDiam=4,
	pointDiam=12,
	pointThick=5,
	hole=0
	){

	union(){
		if(hole){
		cylinder(d=pointDiam+tol*2, h=pointThick, center=true);
		}else{
			intersection(){
				cylinder(d=pointDiam, h=pointThick, center=true);
				sphere(d=pointDiam, centre=true);
			}
		}
		
		if(hole){
			translate([pointDiam/2,0,0])sphere(d=ballDiam+tol*2);
			translate([-pointDiam/2,0,0])sphere(d=ballDiam+tol*2);
		}else {
			translate([pointDiam/2,0,0])sphere(d=ballDiam);
			translate([-pointDiam/2,0,0])sphere(d=ballDiam);
		}
	}
}

module fullLevel(
	diam=15,
	lvl=1,
	nbSlot=4,
	sep=2,
	pointSize=12,
	border=0,
	thick=5
){
	arcLen = nbSlot*(pointSize+sep+1);
	rotate_extrude()
		translate([0,diam+50])
			square([pointSize+sep*2, thick]);
}

module spellTrack(
	Maxlvl=9,
	slotArray=[4, 3, 3, 3, 3, 2, 2, 1, 1],
	pointDiam=12,
	sep=3,
	border=0,
	thick=5,
){
	holes = [for(i=[1:Maxlvl]) [i,slotArray[i-1]] ];
}

module tollTest(){
	difference(){
		cube([18,18, 5], center=true);
		ballElt(hole=1);
	}

	ballElt();
}

module test(diam=40, ep=8){

}


test();
//if(TolTest){
//	tollTest();
//}else {
//	spellTrack();	
//}
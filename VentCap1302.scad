/*
	Brake liquid tank cap with vent for VW 1302

	TearDrop() comme from "Reprap Teardrop Shot Glass by raldrich" http://www.thingiverse.com/thing:11944

	FUNCTION LIST

	tube(d,h,thick,center);

*/
use <gear.scad>
use <threads.scad>

$fn=200;

module _tubeCenter(d=10, h=20, thick=2){
	difference(){
		cylinder(d=d, h=h, center=true);
		cylinder(d=d-(thick*2), h=h+2, center=true);
	}
}

module _racord(d=10, thick=2){
	difference(){
		union(){
			cylinder(d1=d, h=7, d2=d+4);
			translate([0,0,7])cylinder(d1=d+4, h=8, d2=d);
		}
		cylinder(d=d-(thick*2), h=15);
	}
}

module tube(d=10, h=20, thick=2, center=false){
	if(!center){
		translate([0,0,h/2]){
			_tubeCenter(d=d, h=h, thick=thick);
		}
	}else _tubeCenter(d=d, h=h, thick=thick);
}
module TearDrop(h, r1, r2){
	union()
	{
	cylinder(h=h, r1=r1, r2=r2, $fn=50, center=true);

		intersection()
		{
			rotate([0, 0, 45])
			cylinder(h=h, r1=r1/sqrt(2)*2, r2=r2/sqrt(2)*2, $fn=4, center=true);

			union()
			{
			if (r1 > r2)
			{
				translate([r1/2, r1/2, 0])
				cube([r1, r1, h], center=true);
			}
			else
			{
				translate([r2/2, r2/2, 0])
				cube([r2, r2, h], center=true);
			}
			}
		}
	}
}

module _trapez(L1=2, L2=6, h=10){
	translate([0,h/2,0]){
		rotate([0,0,180]){
	difference(){
		hull(){
			square(size=[L1,h],center=true);
			translate([0,(h+1)/2,0]) square(size=[L2,1], center=true);
		}
		translate([0,(h+1)/2,0]) square(size=[L2,1], center=true);
	}}}
}

module _ventTubeNoCenter(d=10, h=20, thick=2, red=4.4, coefR=3.3){
	/*
		red tearDrop diam reduction coef
	*/
	difference(){
		union(){
		/* Base Tube*/
		tube(d=d, h=h, thick=thick);

		/* Reninforced junction */
		rotate_extrude() translate([(d-thick)/2,0,0])_trapez(L1=thick, L2=thick*coefR, h=d/2.4);
		}
		/* Bottom Holes*/

		rotate([90,-45,0]) TearDrop(r1=d/red,r2=d/red,h=d+thick*8, center=true);
		rotate([135,0,0])rotate([0,90,0]) TearDrop(r1=d/red,r2=d/red,h=d+thick*8, center=true);

	}
}

module renfort(d=10, thick=2, coefR=3.3, h=3){
			rotate_extrude() translate([(d-thick)/2,0,0])_trapez(L1=thick, L2=thick*coefR, h=h);

}

module ventTube(d=30, h=50, thick=2, red=4.4, center=false, coefR=3.3){
	if(center){
		translate([0,0,-h/2]) _ventTubeNoCenter(d=d, h=h, thick=thick, red=red, coefR=coefR);
	}else  _ventTubeNoCenter(d=d, h=h, thick=thick, red=red, coefR=coefR);
}

function _sphereRadiusFromTriangle(r=10, h=5) = h + ((r*r)-(h*h))/(2*h);
module ventSphere(d=30, thick=2, red=4, h=5){
	r_S=_sphereRadiusFromTriangle(r=d/2,h=h);

	difference(){
	intersection(){
		translate([0,0,-(r_S-h)]){
			difference(){
				sphere(r_S);
				sphere(r_S-thick);
			}}
		cylinder(r=r_S, h=h);
	}
		rotate([90,-45,0]) TearDrop(r1=h/red,r2=h/red,h=d+thick*8, center=true);
		rotate([135,0,0])rotate([0,90,0]) TearDrop(r1=h/red,r2=h/red,h=d+thick*8, center=true);
	}
}


/* WORK IN PROGRESS */
module Vent(thick=1.2){
	translate([0,0,15])ventSphere(d=32.05, thick=thick, h=6, red=2.3);
	union(){
		#cylinder(d=20, h=thick+1);
		translate([0,0,(11-thick)/2+thick])rotate([180,0,0])ventTube(d=20, h=11-thick, thick=thick, center=true, coefR=2);
		translate([0,0,thick])rotate([0,0,45]) ventTube(d=13, h=17, thick=thick, coefR=2);
	}
}

module _capBase(d_ext=32, d_int=27, h_int=11, h_ext=15){
	union(){
		difference(){
			cylinder(d=d_ext, h=h_ext);
			cylinder(d=d_int, h=h_int);
		}
		intersection(){
		translate([0,0,h_ext/2])double_helix_gear(bore_diameter=32,h=h_ext);
		sphere(21.93);
		translate([0,0,15]) sphere(22);
		}
	}
}

difference(){
	union(){
		_capBase();
	}
	cylinder(d=13, h=50);
	difference(){
		metric_thread (diameter=29.7, pitch=3, length=11);
		cylinder(d=27, h=11);
	}
}
Vent();

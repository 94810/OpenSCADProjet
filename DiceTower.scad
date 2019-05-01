/*
 ____            _                       
|  _ \ ___ _   _| | ___  __ _ _   ___  __
| |_) / _ \ | | | |/ _ \/ _` | | | \ \/ /
|  _ <  __/ |_| | |  __/ (_| | |_| |>  < 
|_| \_\___|\__,_|_|\___|\__,_|\__,_/_/\_\
  	   _____                      
	  |_   _|____      _____ _ __ 
	    | |/ _ \ \ /\ / / _ \ '__|
	    | | (_) \ V  V /  __/ |   
	    |_|\___/ \_/\_/ \___|_|   
                         
			  Basolur - 2018
*/

$fn=500;
nozzle=0.4;
tray=0; // with tray or compact tower

function rayon(diameter, baseAngle) = diameter / (2*sin((360-baseAngle)/4));
function dot(baseAngle, nb, diameter) = rayon(diameter, baseAngle) * [-sin(baseAngle*nb),cos(baseAngle*nb)];
function sideLong(diameter, side) = diameter*3.14/side;

module reuleaux(side=3, diameter=10){
		dots = [for(i=[0:side-1])dot(360/side, i, diameter)];
		intersection_for(i=dots)
			translate(i)circle(r=diameter);
}

module drop(diameter=10){
	rotate([0,0,-45]){
		circle(d=diameter);
		square([diameter/2, diameter/2]);
	}
}

module halfCylinder(diameter=10, bottom=2, height=10){
	
	translate([0,0,-height/2]) linear_extrude(height) union(){
	difference(){
		circle(d=diameter);
		translate([-diameter/2,0])square([diameter, diameter/2]);
	}
	translate([-diameter/2,0])square([diameter, bottom]);
	}
}

module plan(dim=60, angl=10){
	translate([-dim/2, -dim/2, 0])
	difference(){
		cube([dim,dim,dim]);
		rotate([angl,0,0])cube([dim,sqrt(2)*dim,dim]);
	}
}

module magnetHolder(diam=3, depth=1, border=3, thick=1){
	difference(){
		cylinder(d=diam+border*nozzle, h=depth+thick);
		translate([0,0,thick]) cylinder(d=diam, h=depth);
	}
}
 
module tray(
	ep_wall=6*nozzle,
	wall=8,
	ep_bottom=3,
	diameter=60,
	side=5,
	){
	
	difference(){
		linear_extrude(height=ep_bottom+wall)
				reuleaux(side=side, diameter=diameter);
		translate([0,0,ep_bottom]) linear_extrude(height=wall)
				reuleaux(side=side, diameter=diameter-2*ep_wall);
	}
}

module tower(
	side=5,
	diameter=60,
	height=110,
	ep_wall=6*nozzle,
	ep_bottom=3,
	door_diam=55.2,
	door_overShoot=8+3,
	nbPin=5,
	pinSpace=15,
	pinAngle=45,
	pinSize=5,
	pinBThick=1,
	twist=0*360,
	decorDepth=1,
	angl = 10,
	bottom_wall=10
){
	twist=twist/side;
	pinStart=door_diam;
	
	union(){
	difference(){
		linear_extrude(height=height, twist=twist)
				reuleaux(side=side, diameter=diameter);
		//Door 
		translate([0,-ep_wall*2,0]) difference(){
					difference(){
						//Shape
						translate([0,0,ep_bottom+door_overShoot])
							rotate([-90,-90,0])
								linear_extrude(diameter)
									drop(diameter=door_diam);
						//Base
						cube([diameter*2, diameter*2, ep_bottom*2+bottom_wall*2], center=true);
						translate([0,0,ep_bottom])linear_extrude(height=height, twist=twist)
							reuleaux(side=side, diameter=diameter-2*ep_wall);
					}
				
					linear_extrude(height=height, twist=twist)
						reuleaux(side=side, diameter=diameter);
		}
		
		//Hollow
		translate([0,0,ep_bottom])
			linear_extrude(height=height, twist=twist)
				reuleaux(side=side, diameter=diameter-2*ep_wall);
		
	}
		//Pin
		intersection(){
			//Actual Pin
			for(i=[0:nbPin]){
				translate([0,0,pinStart+ i*pinSpace])
					rotate([-90,0,i*pinAngle])
						halfCylinder(diameter=pinSize, bottom=pinBThick, height=diameter*2 );
			}
			
			//Tower
			linear_extrude(height=height, twist=twist)
				reuleaux(side=side, diameter=diameter);
		}
	
	//Pente pour le dé
	intersection(){
		translate([0,0,ep_bottom]) rotate([0,0,180]) plan(diameter, angl);
		linear_extrude(height=height, twist=twist)
			reuleaux(side=side, diameter=diameter);
	}	
	}
}

if(tray){
	union(){
		difference(){
			translate([0,30.255,0]) rotate([0,0,0]) tray(diameter=75);
			linear_extrude(height=50)
				reuleaux(side=5, diameter=60);
		}
		tower(bottom_wall=0);
	}
}else{
	tower();
}
_tol=0.2;
$fn=50;

thickS=3;
cstBlock=13.5;
penSize=10;

function toCreat(sideW, sep, long)=long/(sideW+sep);
function wideToSide(x) = x / sqrt(2);

module renfort(
long=5,
wide=5,
sideW=1,
middleW=1,
sep=1
){
	
	translate([-(toCreat(sideW, sep, long)*(sideW+sep))/2+(sideW/2),0])
	for(i=[0:1:toCreat(sideW, sep, long)]){
		translate([i*(sideW+sep),0,0]) rotate([45,0,0]) cube([sideW, wideToSide(wide), wideToSide(wide)], center=true);
	}
	cube([long, middleW, wide], center=true);
}

module chanfrein(r=5, h=10, a=0){
	rotate([0,0,a])difference(){
		cube([r*2, r*2, h], center=true);
		cylinder(r=r, h=h+1, center=true);
		translate([0,-r,0])cube([2*r+1, 2*r, h+1],center=true); //X
		translate([-r,0,0])cube([2*r, 2*r+1, h+1],center=true); //Y
		}
}

module screw(){
	blockT=cstBlock; //taille du block
	ep=5; //distance centre le trou et le block
	thick=thickS; //épaisseur de la piéce
	rScrew=2; //diametre du trou
	overcut=3.01; //chainfrein
	chanfConst=0.01;
	anticut=50;
	
	difference(){
		union(){
				
			difference(){
				union(){
					cube([blockT+ep,blockT+ep, thick ]);
					translate([0,13,0])cube([11,20,thick]);
				}
				
			
				translate([-anticut, -anticut])cube([blockT+_tol+anticut,blockT+_tol+anticut, thick]);
				
				translate([blockT+_tol-overcut+chanfConst,blockT+_tol-overcut+chanfConst,ep/2])chanfrein(r=ep-_tol+overcut, h=thick*2);}
				
			//oeil gauche
			translate([0,blockT+ep-_tol]) cylinder(d=rScrew*2+ep+_tol, h=thick);
			//oeil haut
			translate([blockT+ep-_tol,0]) cylinder(d=rScrew*2+ep+_tol, h=thick);}
		//Trous
		translate([0,blockT+ep]) cylinder(r=rScrew+_tol/2, h=thick*3, center=true);
		translate([blockT+ep,0]) cylinder(r=rScrew+_tol/2, h=thick*3, center=true);}
}

module pen(){
	penDiam=penSize;
	h=30;
	thick=2;
	negatif=0.3;
	gap=4;
	diamHold=25;
	thickHold=2;
	
	diamR = 3;
	advence = 0.7; 

	difference(){
		union(){	
			cylinder(d=penDiam+thick*2, h=h, center=true);
			difference(){
				rotate([0,90,0])cylinder(d=diamHold, h=gap+(thickHold*2), center=true);
				translate([0,diamHold/2,0])cube([gap+(thickHold*2)+1,diamHold,h], center=true);
			}
		}
		cylinder(d=penDiam-negatif, h=h+1, center=true);
		translate([0,-(diamHold)/2,0])cube([gap, diamHold, h+1], center=true);
		translate([gap/2+thickHold+advence,-diamHold/3,0])cylinder(d=diamR, h=diamHold, center=true);
		translate([-(gap/2+thickHold+advence),-diamHold/3,0])cylinder(d=diamR,h=diamHold,center=true);
	}
}

module assemblage(){
	screw();
    translate([5,28.5,9])rotate([-90,0,90])pen();
}

//chanfrein();
//extendeur();
//screw();

assemblage();

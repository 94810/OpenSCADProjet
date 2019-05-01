include <Basolur.scad>
$fn=100;
nozzle=0.4;
height=110;
nbWall=6;

controlPoints = [
[0,0],
[-3, 40],
[10,5],
[45, 70],
[70, -12],
[height, 12.5]
];


thick=0.2;
tol=0.01;
keyTol=0.3;
bottomCut=17;
topCut=15;
res=0.01;
side=5;

bezierCurve=true;

if(bezierCurve){
    for(i=bezierCurve(controlPoints, 0.01)){
        translate(i) cube(1);
    }

    translate([0,30]) square([300,1]);
    translate([0,20]) square([300,1]);
    translate([40,0]) square([1, 300]);


    for(i=controlPoints){
        translate(i) color("red") cube(1);
    }
} else{
    difference(){
        reuleauxBezierShape(side, bezierCurve(controlPoints, res), thick);

        difference(){
            reuleauxBezierShape(side, subOnList(bezierCurve(controlPoints, res), 1, nozzle*nbWall), 0.01, thick);
            translate([0,0, height]) cube([100, 100, topCut*2], center=true );
            cube([100, 100, bottomCut*2], center=true );
        }

        translate([0,0,-1.99]) cube([100, 100, 4], center=true); // Base cut

    }
}





$fn=100;
nozzle=0.4;
height=110;
nbWall=6;

// Bezier curve
function factorial(n) = n > 1 ? n*factorial(n-1) : 1;
function binomialCoef(m, n) = factorial(m) / (factorial(n)*factorial(m-n));
function bernsteinPol(m, n, u) = binomialCoef(m, n)*pow(u,n)*pow(1-u,m-n);
function termeBezier(controlPoints, step, t) = bernsteinPol(len(controlPoints)-1, step, t) * controlPoints[step];
function _bezierPoint(controlPoints, step, t) = step > 0 ? termeBezier(controlPoints, step, t) + _bezierPoint(controlPoints, step-1, t) : termeBezier(controlPoints, step, t) ;
function bezierPoint(controlPoints, t) = _bezierPoint(controlPoints, len(controlPoints)-1, t);
function bezierCurve(controlPoints, res) = [for(i=[0:res:1])bezierPoint(controlPoints, i)];

// Reuleaux polygone
function rayon(diameter, baseAngle) = diameter / (2*sin((360-baseAngle)/4));

function dot(baseAngle, nb, diameter) = rayon(diameter, baseAngle) * [-sin(baseAngle*nb),cos(baseAngle*nb)];

module reuleaux(side=3, diameter=10){
		dots = [for(i=[0:side-1])dot(360/side, i, diameter)];
		intersection_for(i=dots)
			translate(i)circle(r=diameter);
}

// Utils
function t(a, i, c)= i==c ? a : 0;
function subOnList(pointList, index, amount) = [for(i=pointList)[i[0]-t(amount, 0, index),i[1]-t(amount, 1, index)]];

module reuleauxBezierShapeElement(side,point, thick, tol=0){
    translate([0, 0, point[0]-tol/2]) linear_extrude(thick+tol) reuleaux(side, diameter=2*point[1]);
}

module reuleauxBezierShape(side, bezierCurve, thick, tol=0){
    for(i=[0:len(bezierCurve)-2]){
        union(){
            hull(){
                reuleauxBezierShapeElement(side, bezierCurve[i], thick, tol);
                reuleauxBezierShapeElement(side, bezierCurve[i+1], thick, tol);
            }
        }
    };
}


controlPoints = [
[0,0],
[-3, 50],
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




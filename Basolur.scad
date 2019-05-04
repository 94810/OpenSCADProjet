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
function _t(a, i, c)= i==c ? a : 0;
function subOnList(pointList, index, amount) = [for(i=pointList)[i[0]-_t(amount, 0, index),i[1]-_t(amount, 1, index)]];

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

// Other 

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
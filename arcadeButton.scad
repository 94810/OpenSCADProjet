include <Basolur.scad>

$fn=100;

// [ Render Value ]
// 1 edit button curve
// 2 the button
// 3 edit border curve
// 4 the external shell
// 5 Both
// 6 cross module

curveEdit=5;
reso=0.05;

cubeSize=0.1;
side=7;
tallShell=12;
shellThick=0.4*3;
topThick=1;
extShellTol=0.5;
extShellThick=0.4*3;
extBottomThick=1.41;

kailhBox=13.95;
switchTol=0.5;

switchCrossSize=4;
switchCrossXThick=1.1;
switchCrossYThick=1.3;
switchCrossheight=3.60;
crossTol=0.2;

dots = [
  [14,0],
  [14,9],
  [10,0],
  [0,0]
];

function findApex(arr, coor, index, sign) = sign * arr[index][coor] < sign * arr[index+1][coor] ? findApex(arr, coor, index+1, sign) : index;

function findMaxYindex(arr)=findApex(arr, 1, 0, 1);
function findMaxXindex(arr)=findApex(arr, 0, 0, 1);

res = bezierCurve(dots, reso);
buttonDiam = res[0][0]*2;

internalLastDot=buttonDiam/2 + extShellTol;

bDots = [
  [internalLastDot+3, 0],
  [internalLastDot+0.5, 4],
  [internalLastDot, 0]
];

border = bezierCurve(bDots, reso);

module preview(){

  translate([0,4,0])cube([50,cubeSize,cubeSize]);
  translate([15,0,0])cube([cubeSize,50,cubeSize]);

  for(i=res){
    translate(i) cube(cubeSize);
  }

  for(i=dots){
    translate(i) color("red") cube(cubeSize);
  }
}

module Bpreview(){
  translate([0,2,0])cube([50,cubeSize,cubeSize]);
  translate([internalLastDot,0,0])cube([cubeSize,50,cubeSize]);

  for(i=border){
    translate(i) cube(cubeSize);
  }

  for(i=bDots){
    translate(i) color("red") cube(cubeSize);
  }
}

module hulled(arr, i, thick=0.001, tol=0.1){
  hull(){
    translate([0, 0, arr[i][1]-tol/2]) linear_extrude(thick+tol) reuleaux(side, diameter=2*arr[i][0]);
    translate([0, 0, arr[i+1][1]-tol/2]) linear_extrude(thick+tol) reuleaux(side, diameter=2*arr[i+1][0]);
  }
}

module hat(){
  unionUntil = findMaxYindex(res);

  difference(){
    union() for(i=[0:unionUntil-1]) hulled(res, i);
    translate([0,0,0.2]) union() for(i=[unionUntil:len(res)-2]) hulled(res, i);
  }
}

module holeBorder(){
    unionUntil = findMaxYindex(res);

  difference(){
    union() for(i=[0:unionUntil-1]) hulled(border, i);
    
    translate([0,0,0.1]) union() for(i=[unionUntil:len(res)-2]) hulled(border, i);
    
    translate([0,0,-2]) linear_extrude(4) reuleaux(side, diameter=border[len(border)-1][0]*2);
  }
}

module internShell(){
  difference(){
    linear_extrude(tallShell) reuleaux(side, diameter=buttonDiam);
    linear_extrude(tallShell-topThick) reuleaux(side, diameter=2*(buttonDiam/2-shellThick));
  }
}

module extShell(){
  intDiam = buttonDiam + 2*extShellTol;

  difference(){
    cylinder(d=intDiam + 2*extShellThick, h=tallShell);
    linear_extrude(tallShell) reuleaux(side, diameter=intDiam);
  }
  
  extSwitchSupport();
}

module button(){
  internShell();
  translate([0,0,tallShell]) hat();
}

module extSwitchSupport(){
   intDiam=buttonDiam + 2*extShellTol;
   side=kailhBox+switchTol;
   difference(){
    cylinder(d=intDiam + 2*extShellThick, h=extBottomThick);
    cube([side, side, 40], center=true);
   }
}

module ext(){
    union(){
      extShell();
      translate([0,0,tallShell])holeBorder();
    }
}

module cross(){
  translate([0,0,switchCrossheight/2])union(){
    cube([switchCrossSize+crossTol, switchCrossXThick+crossTol, switchCrossheight], center=true);
    cube([switchCrossYThick+crossTol, switchCrossSize+crossTol, switchCrossheight], center=true);
  }

  difference(){
    cylinder(d=2*switchCrossSize, h=switchCrossheight);
    cylinder(d=switchCrossSize+1, h=2*switchCrossheight+1, center=true);
  }
  
}

if(curveEdit==2){
  button();
} else if (curveEdit==1) {
  preview();
} else if (curveEdit==4){
  ext();
} else if(curveEdit==3){
  Bpreview();
} else if(curveEdit==5){
  button();
  ext();
} else if(curveEdit==6){
  cross();
}
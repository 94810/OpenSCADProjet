include <Basolur.scad>
include <turboThread.scad>

$fn=100;

// [ Render Value ]
// 1 edit button curve
// 2 the button
// 3 edit border curve
// 4 the external shell
// 5 Both
// 6 cross module

curveEdit=4;
reso=0.1;

cubeSize=0.1;
side=5;
tallShell=20;
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
switchSup=0.1;
crossTol=0.2;

switchDepth=5-3.80;


pitch=2;
nbTurn=(tallShell-switchDepth)/pitch;

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
  [internalLastDot+6, 0],
  [internalLastDot+0.5, 4],
  [internalLastDot, 0]
];

border = bezierCurve(bDots, reso);

module cross(){
  translate([0,0,switchCrossheight/2])union(){
    cube([switchCrossSize+crossTol, switchCrossXThick+crossTol, switchCrossheight+switchSup], center=true);
    cube([switchCrossYThick+crossTol, switchCrossSize+crossTol, switchCrossheight+switchSup], center=true);
  }

  difference(){
    cylinder(d=2*switchCrossSize, h=switchCrossheight+switchSup);
    cylinder(d=switchCrossSize+1, h=2*switchCrossheight+switchSup+1, center=true);
  }
  
}


module preview(){

  translate([0,4,0])cube([50,cubeSize,cubeSize]);
  translate([14,0,0])cube([cubeSize,50,cubeSize]);

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

module hulled(arr, i, thick=0.001, tol=0){
  hull(){
    translate([0, 0, arr[i][1]-tol/2]) linear_extrude(thick+tol) reuleaux(side, diameter=2*arr[i][0]);
    translate([0, 0, arr[i+1][1]-tol/2]) linear_extrude(thick+tol) reuleaux(side, diameter=2*arr[i+1][0]);
  }
}

module hat(){
  unionUntil = findMaxYindex(res);

  difference(){
    union() for(i=[0:unionUntil-1]) hulled(res, i);
    translate([0,0,0]) union() for(i=[unionUntil:len(res)-2]) hulled(res, i);
  }
}

module holeBorder(){
  unionUntil = findMaxYindex(border);

  difference(){
    union() for(i=[0:unionUntil+1]) hulled(border, i);
    
    translate([0,0,0]) union() for(i=[unionUntil:len(border)-2]) hulled(border, i);
    
    translate([0,0,-2]) linear_extrude(4) reuleaux(side, diameter=border[len(border)-1][0]*2);
  }
}

module internShell(){
  difference(){
    linear_extrude(tallShell) reuleaux(side, diameter=buttonDiam);
    linear_extrude(tallShell-topThick) reuleaux(side, diameter=2*(buttonDiam/2-shellThick));
  }

  difference(){
    cylinder(d1=5, d2=11, h=tallShell);
    translate ([0,0,-switchSup]) cross();
  }
  
}

module extShell(){
  intDiam = buttonDiam + 2*extShellTol;



  difference(){
    union(){
      cylinder(d=intDiam + 2*extShellThick, h=tallShell+switchDepth);
      translate([0,0,2]) thread(pitch, intDiam + 2*extShellThick+2.2, 1, nbTurn);
    }
    linear_extrude(tallShell+switchDepth) reuleaux(side, diameter=intDiam);
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
   translate([0,0, -extBottomThick]) difference(){
    cylinder(d=intDiam + 2*extShellThick, h=extBottomThick);
    cube([side, side, 40], center=true);
   }
}

module ext(){
    union(){
      extShell();
      translate([0,0,tallShell+switchDepth]) holeBorder();
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
  translate([0,0,switchDepth]) button();
  ext();
} else if(curveEdit==6){
  cross();
}

include <Basolur.scad>

$fn=50;

cubeI=0.1;

function findApex(arr, coor, index, sign) = sign * arr[index][coor] < sign * arr[index+1][coor] ? findApex(arr, coor, index+1, sign) : index;

function findMaxYindex(arr)=findApex(arr, 1, 0, 1);
function findMaxXindex(arr)=findApex(arr, 0, 0, 1);

side=5;

dots = [
  [12,0],
  [12,6],
  [6,0],
  [0,0]
];

res = bezierCurve(dots, 0.01);

echo(res);

echo(findMaxYindex(res, 0));
module preview(){
  for(i=res){
    translate(i) cube(cubeI);
  }

  for(i=dots){
    translate(i) color("red") cube(cubeI);
  }
}

module hulled(arr, i, thick=0.01, tol=0.1){
  hull(){
    translate([0, 0, arr[i][1]-tol/2]) linear_extrude(thick+tol) reuleaux(side, diameter=2*arr[i][0]);
    translate([0, 0, arr[i+1][1]-tol/2]) linear_extrude(thick+tol) reuleaux(side, diameter=2*arr[i+1][0]);
  }
}

module hat(){
  unionUntil = findMaxYindex(res);

  difference(){
    union(){
      for(i=[0:unionUntil]){
        hulled(res, i);
      }
    }

    union(){
      for(i=[unionUntil:len(res)-2]){
        echo(res[i]);
        hulled(res, i);
      }
    }
  }
}

hat();

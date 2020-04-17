function halfDist(x, y) = abs(x-y) / 2;

function vectorAngle(v1, v2) = acos( (v1*v2) / (norm(v1)*norm(v2)) );

function angleXYPlane(v1) = vectorAngle(v1, [v1[0], v1[1], 0]);

function linearInterpolation(x, y, cursor) = (1-cursor)*x + cursor*y ;

// =========== CONST =============

// HOLDER
HolderWide=8;
HolderLong=19;
HolderOuterH1=7;
HolderOuterH2=4;
HolderTopEp=1;
HolderBottomEp=0.5;
HolderRailDist=1.5;

HolderInerH1 = HolderOuterH1-HolderTopEp-HolderBottomEp;
HolderInerH2 =HolderOuterH2-HolderTopEp-HolderBottomEp;

// BASE
BaseLong=17.5;
BaseFracture=8;
BaseLarg=15.5;
BaseLargMinus=0.5;
BaseEp=1;
BaseKnurledEp=7.5;
BaseEndHeight = 2;
BaseFractureHeight=2.5;
BaseFractureWide = linearInterpolation(BaseLarg, BaseLarg-BaseLargMinus, BaseFracture/BaseLong);


$fn=30;

// Precondition Y_1 >= Y_2
module wedge(size=[  
  12, // X
  9, // Y_1
  5, // Y_2
  2, // Z_1
  5 // Z_2
  ]) {

  centering = halfDist(size[1], size[2]);

  polyhedron(points = [
    [0, 0, 0],
    [0, size[1], 0], //1 Bottom
    [size[0], centering, 0], 
    [size[0], size[2]+centering, 0],
    [0, 0, size[3]], // 4 Top
    [0, size[1], size[3]],
    [size[0], centering, size[4]],
    [size[0], size[2]+centering, size[4]], // 7 
  ],
  faces = [
    [0, 2, 3, 1], // bottom X
    [5, 7, 6, 4], // top_1 X
    [4, 6, 2, 0], // front X
    [3, 7, 5, 1], // back
    [2, 6, 7, 3], // right
    [1, 5, 4, 0],// left
  ] 
  );
}

module sep(wide=7, epHole=1){
  d1=4; 
  d2=1.6;
  cube([6, wide, epHole]);
  difference(){
    translate([0,0,1]) cube([d1/2, wide, d1/2]);
    translate([d1/2, 0, d1/2+epHole]) rotate([-90, 0, 0]) cylinder(d=d1, h=wide);
  }
  difference(){
    translate([0,0,-d2/2]) cube([d2/2, wide, d2/2]);
    translate([d2/2, 0, -d2/2]) rotate([-90, 0, 0]) cylinder(d=d2, h=wide);
  }
}
 

module holderHole(){
    translate([-1, 1, HolderBottomEp]) wedge([ // Wedge hole
      HolderLong,
      HolderWide-2, 
      HolderWide-3,
      HolderInerH1,
      HolderInerH2
    ]);
}

module holder() {
  difference(){
    wedge([ // Wedge principale
      HolderLong,
      HolderWide, 
      HolderWide-1,
      HolderOuterH1,
      HolderOuterH2
    ]);

    holderHole();

    translate([0, 0, 1])  sep(HolderWide);

    translate([2, halfDist(HolderWide, 1.2), 0]) cube([5, 1.2, 2]); // trou
  }

   translate([7, halfDist(HolderWide, 1+2*1), 1]) rail([HolderLong/2, 1, 1], HolderRailDist); // rail bottom

   translate ([1, halfDist(HolderWide, 1+2*1), HolderInerH1-HolderBottomEp])
    rotate([0, angleXYPlane([HolderLong, 0, HolderInerH2-HolderInerH1]), 0])
      rail([HolderLong-2, 1, 1], HolderRailDist); // rail top

}

module _monoRail(size=[10,1,1]){
  difference(){
    cube(size);
    difference(){
      halfD = size[1]/2;
      cube([halfD, size[1], size[2]]);
      translate([halfD, halfD]) cylinder(d=size[1], h=size[2]);
    }

    difference(){
      halfD = size[1]/2;
      translate([size[0]-halfD,0,0]) cube([halfD, size[1], size[2]]);
      translate([size[0]-halfD, halfD]) cylinder(d=size[1], h=size[2]);
    }
  }
}

module rail(size=[10, 1, 1], dist=1,) {
    _monoRail(size);
    translate([0, size[1]+dist, 0]) _monoRail(size);
}

module baseSolid(){
  polyhedron(points = [
      [0, 0, 0],
      [0, BaseLarg, 0], //1 Bottom
      [BaseLong, BaseLargMinus, 0], 
      [BaseLong, BaseLarg-BaseLargMinus, 0],
      [-1, 0, 4], // 4 Top
      [-1, BaseLarg, 4],
      [BaseLong, BaseLargMinus, BaseEndHeight],
      [BaseLong, BaseLarg-BaseLargMinus, BaseEndHeight], // 7 
      [BaseFracture, halfDist(BaseLarg, BaseFractureWide), BaseFractureHeight], // 8 break
      [BaseFracture, BaseFractureWide, BaseFractureHeight],
    ],
    faces = [
      [0, 2, 3, 1], // bottom X
      [5, 9, 8, 4], // top_1 X
      [7, 6, 8, 9], // top_2 X
      [4, 8, 6, 2, 0], // front X
      [3, 7, 9, 5, 1], // back
      [2, 6, 7, 3], // right
      [1, 5, 4, 0],// left
    ] 
  );
}

module baseButton() {
  difference(){
    union(){
      baseSolid();
      translate([BaseLong-BaseKnurledEp-0.5, 1, BaseEndHeight+0.4])
        rotate([0, angleXYPlane([BaseLong-BaseFracture, 0, BaseEndHeight-BaseFractureHeight ]), 0])
          knurled([BaseKnurledEp, BaseLarg-BaseLargMinus*4, 0.4], 0.34, 0.8);
    }
    translate([-0.8, 1, 0])  wedge([BaseLong, BaseLarg-2, BaseLarg-(2*BaseLargMinus)-2, 2, 2]);
  }
}

module knurled(size=[20, 20, 0.5], pic=0.3, bevel=0.5){
  _length=size[1]+size[0];
  _kek=1/(pic*2);
  intersection(){
    translate([0, size[1], size[2]]) rotate([180, 0,0]) difference(){
    cube(size);
    for(i=[-_length*_kek:pic*sqrt(2):_length*_kek]) {
      translate([0, i, 0])  rotate([0, 90 , 0]) rotate([0,0,45]) cube([pic, pic, _length*2], center=true);
    }

      for(i=[0:pic*sqrt(2):_length*_kek]){
        translate([i, 0, 0])  rotate([0, 90 , 90]) rotate([0,0,45]) cube([pic, pic, _length*4], center=true);
      }
    }

    translate([size[0]/2, size[1]/2])
      linear_extrude(scale=(size[0]-bevel)/size[0], height=size[2])
        square([size[0], size[1]], center=true);
  }

}

back = -4.5;

union(){
  difference(){
    rotate([0, angleXYPlane([18.5,0,-1])]) baseButton();
    translate([back, halfDist(15, 8) , -2.8]) holderHole();
  }

  difference(){
    translate([back, halfDist(15, 8) , -2.8]) holder();
    difference(){
      translate([back, halfDist(15, 8) , -2.8]) holder();
      rotate([0, angleXYPlane([18.5,0,-1])]) baseSolid();
      translate([-15, 0, 0]) cube([30, 30, 30], center=true);
      translate([0, 0, -20]) cube([40, 40, 40], center=true);
    }
  }
}

module _HexGrid(size=[100,120,5], holeD=5, sep=0) {
  magickConst = 1.25;
  nbY=ceil(size[1] / (holeD+2*sep));
  nbX=ceil(size[0]*magickConst / (holeD+2*sep));
  decal=holeD + sep;

  $fn=30;
  #cylinder(d=holeD, h=size[2]);
  
  for(x=[0:nbX]){
    for(y=[0:nbY]){
      $fn=6;
      decalX= x*holeD/magickConst;
      decalY= y*decal + (x%2 * decal/2);

      translate([decalX, decalY, 0]) cylinder(d=holeD, h=size[2]);
    }
  }

}
module HexGrid(size=[100,120,5], holeD=5, sep=0) {
  intersection(){
    _HexGrid(size, holeD, sep);
    cube(size);
  }
}


HexGrid();
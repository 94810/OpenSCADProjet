thick=10;
leg=25;
ep=25;
onLogo=false;

module logo(){
    translate([2,70+thick/2,40])
    rotate([0,90,180]) 
        linear_extrude(2) resize([0,40,0], auto=true) import("logo.dxf");
}


difference(){
    linear_extrude(ep)  difference(){
        union (){
            square([40, 70+thick]);
            translate([40, 70]) square([leg, thick]);
            translate([-leg, 70]) square([leg, thick]);
        }
        translate([thick, 0, 0])square([40-(thick*2), 70]);
        #square([70,40]);

    }
 
    if(onLogo)logo();
}


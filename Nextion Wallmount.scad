//use <ESP8266Models.scad>

$fn=80;

width_plate = 54.94;
height_plate = 100.50;

width_window = 48.96;
height_window = 73.44   ;
margin_window = 0.5;

width_screen = 54.94;
height_screen = 85.50   ;
depth_screen = 3.85;
margin_screen = 0.9;

width_pcb = 54.94;
height_pcb = 100.50;
depth_pcb = 1.6;

screen_off_center = 8.45-3.61; //7.81;

module antennemount (x,y,z){
    translate([x,y,z])
    rotate([90,-45,0])
    difference() {
    cylinder(r=5,h=8,center=true);
    cylinder(r=2.5,h=10.5,center=true);
    translate([3,3,0])
        cube([8.5,8.5,10.5],center=true);
    }
 }

antennemount(-width_plate/2,-17,-5.3);
antennemount(-width_plate/2,17,-5.3);
antennemount(width_plate/2,-17,-5.3);
antennemount(width_plate/2,17,-5.3);

module mountpoint(x,y,z,r) {
    
    translate([x,y,z])
    rotate([0,0,r]) {
    hull (){
        translate([0,-4,0])
        cylinder(h=5,r=2);
        translate([0,3,0])
        cylinder(h=5,r=2);
        }
    translate([0,4,0])
    cylinder(h=5,r=3.5);
    
    }
}

module screenpoints(r,h,x,y,z){
    translate([x,y,z]) {

    translate([width_pcb/2-3.2,height_pcb/2-3.2,0])
            cylinder(h=h,r=r,center=true);

    translate([-width_pcb/2+3.2,height_pcb/2-3.2,0])
            cylinder(h=h,r=r,center=true);

    translate([-width_pcb/2+3.2,-height_pcb/2+3.2,0])
            cylinder(h=h,r=r,center=true);

    translate([width_pcb/2-3.2,-height_pcb/2+3.2,0])
            cylinder(h=h,r=r,center=true);

    }

}

//test
//screenpoints(3.2,3.2,0,screen_off_center,2-0.4);

intersection()
union()
{

/* box*/
difference() {
hull() {
    

    
    /* base spheric cube*/
    minkowski(){
        translate([0,0,-1])
    cube([width_plate-4,height_plate-4,0.5],center=true);
sphere(r=10);
}

translate([0,0,10])
minkowski(){
    cube([width_plate,height_plate,0.1],center=true);
cylinder(r=14,h=1);
}

}

walls = 0;

difference () {

union() {
hull() {
    
    minkowski(){
    
        translate([0,0,-1])
    cube([width_plate-4,height_plate-4,0.1],center=true);
sphere(r=8);
}

translate([0,0,10])
minkowski(){
    cube([width_plate,height_plate,0.1],center=true);
cylinder(r=12,h=1);
} // minkoski

} // hull


        minkowski() {
            cube([width_plate-2,height_plate-2,0.01],center=true);
            translate([0,0,3.5])
            cylinder(h=0.5, r1=11, r2=10, center=true);

        }


} //union


    /* screen mount holes */
   translate([0,-screen_off_center,-depth_screen-2])
    screenpoints(3.2,8);
}

    /* screen mount holes */
    translate([0,-screen_off_center,-depth_screen-1])
    screenpoints(1.6,9);


/* top cutoff*/
translate([0,0,15])
cube([300,300,20],center=true);

/* bottom cutoff*/
translate([0,0,-10.65])
cube([300,300,1.2],center=true);


/* bottom center hole*/
color("red")
cylinder(r=12.5,h=30,center=true);


/* mountpoints */
color("red"){
  mountpoint(width_plate/3,height_plate/3,-12,0);
    mountpoint(-width_plate/3,height_plate/3,-12,90);
    mountpoint(-width_plate/3,-height_plate/3,-12,0);
    mountpoint(width_plate/3,-height_plate/3,-12,90);
}

/* IO connector */
translate([-7,height_pcb/2+2,-1])
cube([20,7.5,9],center=true);

/* USB connector 1 */
translate([0,height_pcb/2,-6.04])
cube([12,20,6],center=true);

translate([11.5,height_plate/2-17,0])
cube([3,10*2.45,30],center=true);

translate([-11.5,height_plate/2-17,0])
cube([3,10*2.45,30],center=true);


/* USB connector 2 */
translate([-width_pcb/2,0,-6.04])
cube([20,12,6],center=true);

translate([-width_plate/2+17,11.5,0])
cube([10*2.45,3,30],center=true);

translate([-width_plate/2+17,-11.5,0])
cube([10*2.45,3,30],center=true);



}

*translate([width_plate/2-15,0, -5.9]) {
    rotate([0,0,90])
    WemosD1M(pins=1, atorg=WD1MOPOS); }
   



translate([0,0,5.5])

/* plate */
%difference() {

    union() {

        minkowski() {

            cube([width_plate-2,height_plate-2,0.01],center=true);

            translate([0,0,-3])
            cylinder(h=3, r1=8, r2=10, center=true);

        }

    /* screen mount standoffs */
    translate([0,-screen_off_center,-depth_screen])
    screenpoints(3.2,depth_screen);
    }

cube([width_window+margin_window,height_window+margin_window,10],center=true);

translate([0,-screen_off_center,-depth_screen-0])
cube([width_screen+margin_screen,height_screen+margin_screen,  depth_screen],center=true);

/* PIR sensor */
//translate([0,-height_pcb/2,-3])
//cylinder(r=5,h=6.2,center=true);

    /* screen mount holes */
    translate([0,-screen_off_center,-depth_screen-0.6])
    screenpoints(1.6,depth_screen*1.005);

}

}

/* hmi */
module nextion() {
    
translate([0,-screen_off_center,0])
    difference() {
union() {
    color("silver")
    translate([0,0,2])
    cube([width_screen, height_screen , depth_screen ], center=true);

    color("black")
    translate([0,screen_off_center,2.1])
    cube([width_window, height_window , depth_screen ], center=true);

    corner = (100.50-94.10)/2;
    color("green")
    translate([0,0,-1])
    minkowski() {
        cube([width_pcb-corner,height_pcb-corner,depth_pcb/2],center=true);
        cylinder(h=depth_pcb/2, r=corner, center=true);
    }
    
    color("gray")
    translate([0,7+1.6+screen_off_center+height_screen/2,-5.5])
    cube([15.12,screen_off_center,6],center=true);
    
    translate([0,0,-1])
    screenpoints(3.2,depth_pcb*1.01);

}

    translate([0,0,-1.725])
    screenpoints(1.6,3*depth_pcb);
}
}

/*$vpt = [4, 3, 15];
$vpr = [0,0, 360 * $t];
$vpd = 350;
*/
*nextion();

*color("red")
    translate([0,0,-3.5    ])
    cube([12,12,15.5],center=true);
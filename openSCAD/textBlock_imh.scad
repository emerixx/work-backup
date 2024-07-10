
module NewText(string, s = 20, h = 2, style = ":style=Bold", spacing = 1) {
  rotate([90, 0, 0])
    linear_extrude(height = h)
      text(string, size = s,
           spacing=spacing,
           font = str("Liberation Sans", style),
           $fn = 16);
}
/*difference(){
    translate([0,-1.9,-5])
    cube([120,5,20]);
    union(){
        translate([15,4,0])NewText("I miss her...", s=12,h=6);

        
    }
}
*/
union(){
    translate([15,0,0])NewText("I miss her...", s=12,h=5);
    translate([0,-1.9,-5])cube([120,5,20]);
}
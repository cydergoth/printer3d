base_hex_r = 54;
base_hex_d = base_hex_r*2;
base_hex_edge = base_hex_r;
base_hex_half_tri=(base_hex_r/2.0)*sqrt(3.0);
base_edge_w=3;
filet_length=base_hex_edge/2.5;
tab_w=2;
tab_h=1.5;
base_hex_h=4;

echo(base_hex_r);
echo(base_hex_d);
echo(base_hex_edge);
echo(base_hex_half_tri);

module eclipse_hex () {

  // Draw base hex
  difference() {
    cylinder(h=base_hex_h+2,d=base_hex_d,$fn=6);
    // Clear center
    cylinder(h=6,d=base_hex_d-2*base_edge_w,$fn=6);
    // Cut out ledge
    translate([0,0,base_hex_h]) {
      cylinder(h=base_hex_h,d=base_hex_d-base_edge_w,$fn=6);
    }
    // Cut out top ledge so corner filets
    // hold card
    translate([0,0,base_hex_h]) {
      for(i=[0:5]) {
        rotate([0,0,60*i]) {
          translate([0,base_hex_half_tri-base_edge_w/2,0]) {
            top_edge_cut();
          }
        }
      }
    }

    // Negative tabs - slightly larger
    for(k=[0:5]) {
      rotate([0,0,60*k]) {
        neg_tab();
      }
    }
  }
  // Provide some center support
  center_support();

  // Positive tabs
  for(k=[0:5]) {
    rotate([0,0,60*k]) {
      tab();
    }
  }
}

module neg_tab() {
  translate([-base_hex_edge/2+filet_length/2-tab_w-0.5,base_hex_half_tri-base_edge_w*2-1,0]) {
    cube([tab_w+1,base_edge_w*2+2,tab_h+0.5]);
  }
}

module tab() {
  translate([base_hex_edge/2-filet_length/2,base_hex_half_tri,0]) {
    cube([tab_w,base_edge_w+0.5,tab_h]);
  }
  translate([base_hex_edge/2-filet_length/2-4,base_hex_half_tri+base_edge_w+0.5,0]) {
    cube([6,tab_w,tab_h]);
  }
}

// Support for the card in the center
module center_support() {
  difference() {
    cylinder(h=base_hex_h,d=20,$fn=6);
    cylinder(h=base_hex_h,d=15,$fn=6);
  }
  for (j=[0:2]) {
    rotate([0,0,120*j]) {
      translate([-1,8,0]) {
        cube([2,base_hex_half_tri-9,base_hex_h/2]);
      }
    }
  }
  translate([-2,base_hex_half_tri-base_edge_w*2,0]) {
    cube([2,4,base_hex_h/2]);
  }
}


// Cubic cut out to reduce material on
// top outer edge so just corner filets
// hold hex card
module top_edge_cut() {
  rotate([0,0,90]) {
    translate([0,-(base_hex_edge-filet_length)/2,0]) {
      cube([base_edge_w,base_hex_edge-filet_length,4]);
    }
  }
}

eclipse_hex();
//translate([0,-base_hex_half_tri*2-0.5,0]) {
//  eclipse_hex();
//}

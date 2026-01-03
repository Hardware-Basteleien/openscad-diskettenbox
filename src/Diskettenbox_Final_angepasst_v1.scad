// ===============================================================
// Diskettenbox 3.5" - VERSION v1.0 Hardware-Basteleien 03.01.2026
// Bohrung korrigiert und Text für geschlossene Box
// ===============================================================

/* [Parameter] */
num_slots = 10;
wall = 2.4;
shaft_dia = 8;
knob_dia = 22;
cam_lift = 10;
slot_pitch = 8.5;

total_len = (num_slots * slot_pitch) + (wall * 2);
total_width = 92 + (wall * 2); 
total_height = 75; 

lid_inner_w = total_width + 1.0;
lid_h = 20;
shaft_z_pos = 15; 
$fn = 60;

// --- DRUCK-LAYOUT ---
MainBoxFinalFix();

// Deckel flach auf dem Druckbett (Z=0)
translate([0, -total_len - 30, 0]) 
    ExternalLid();

// Welle
translate([-40, total_len, 0]) 
    MechanismWithDetent();

// --- MODULE ---

module MainBoxFinalFix() {
    difference() {
        union() {
            cube([total_width, total_len, total_height]);
            for(side = [0, total_width]) {
                translate([side, total_len - 8, total_height - 8])
                rotate([0, (side == 0 ? -90 : 90), 0])
                cylinder(h=3, d=5);
            }
        }
        translate([wall, wall, wall]) 
            cube([total_width - (wall*2), total_len - (wall*2), total_height + 1]);
        
        translate([total_width/2, -1, shaft_z_pos]) {
            rotate([-90, 0, 0]) cylinder(h=wall + 2, d=shaft_dia + 0.6);
            translate([-(shaft_dia + 0.6)/2, 0, 0])
                cube([shaft_dia + 0.6, wall + 2, 25]);
        }
        
        translate([total_width/2, total_len - wall, shaft_z_pos]) {
            rotate([-90, 0, 0]) cylinder(h=wall + 1, d=shaft_dia + 0.6);
        }

        for(i=[0:num_slots-1]) {
            translate([total_width/2 - 6, wall + (i*slot_pitch) + 2.5, -1])
                cube([12, 4, wall + 2]);
        }
    }

    translate([total_width/2 - 1, wall + 0.5, shaft_z_pos + (shaft_dia/2) + 0.2])
        cube([2, 1.5, 1.2]); 

    for(i=[1:num_slots-1]) {
        translate([wall, wall + (i*slot_pitch) - 0.5, wall]) 
            difference() {
                cube([total_width - (wall*2), 1, total_height - 15]);
                translate([total_width/2 - wall, 0.5, shaft_z_pos - wall]) {
                    rotate([90,0,0]) cylinder(h=3, d=shaft_dia + 1.2, center=true);
                    translate([-(shaft_dia + 1.2)/2, -1.5, 0])
                        cube([shaft_dia + 1.2, 3, 25]);
                }
            }
    }
}

module ExternalLid() {
    lid_len = total_len + 10; 
    elid_h = lid_h + 44;
    azeile_h = 1;
    hinge_d = 5.6;
    hinge_z = lid_h / 2;
    hinge_y = total_len - 4;
    front_thick = wall * 1.5;

    difference() {
        // Zuerst den gesamten Deckelkörper inklusive Frontplatte bauen
        union() {
            difference() {
                cube([lid_inner_w + (wall * 2), lid_len + wall, elid_h]);
                translate([wall, wall, wall])
                    cube([lid_inner_w, lid_len, elid_h]);
            }
            cube([lid_inner_w + (wall * 2), front_thick, elid_h]);
        }
        
        // Jetzt alle Bohrungen und Ausschnitte abziehen
        // 1. Scharnierlöcher (jetzt NACH der Frontplatte, damit beide Seiten offen sind)
        translate([-1, hinge_y +5, hinge_z +44])
            rotate([0,90,0]) cylinder(h = lid_inner_w + (wall * 4), d = hinge_d);
        
        // 2. Hinten offen
        translate([-1, lid_len - 0.01, -1])
            cube([lid_inner_w + wall * 2 + 2, wall * 2, elid_h + 2]);

        // 3. Schriftzug (180 Grad gedreht für Lesbarkeit im geschlossenen Zustand)
        translate([(lid_inner_w + (wall * 2)) / 2, -0.5, lid_h / 3 + 3])
            rotate([90, 180, 180])
            mirror([1,0,0])
            linear_extrude(height = 1.5) 
            text("AMIGA Edition", size=8.5, font="Liberation Serif:style=Bold Italic", valign="center", halign="center");
        
        // 4. Games/Programme linke Seite Schriftzug (180 Grad gedreht für Lesbarkeit im geschlossenen Zustand)
            
        azeilen_abstand  = 5.5;   // Abstand zwischen den Zeilen
        text_left_margin = wall + 97;   // linke Seite
        

        disk_list = [
            "FD 1+ Turrican II",
            "FD 3   R-Type",          
            "FD 4   Alien Breed",
            "FD 5   Battle Squadron",
            "FD 6+ Gods",
            "FD 8   Battle Chess",
            "FD 9   Lotus Turbo Challenge II",
            "FD 10+ Boulderdash"
            
        ];


        for (i = [0 : len(disk_list)-1]) {

            translate([
                text_left_margin,
                -0.5,
                elid_h / 3.5 + i * azeilen_abstand
            ])
                rotate([90, 180, 180])
                mirror([1,0,0])
                linear_extrude(height = 1.5)
                    text(
                        disk_list[i],
                        size = 3.5,
                        font = "Liberation Serif:style=Bold Italic",
                        valign = "center",
                        halign = "left"
                    );
        }                  
    
        // 5. Games/Programme rechte Seite Schriftzug (180 Grad gedreht für Lesbarkeit im geschlossenen Zustand)
            

        disk_listr = [
            "FD 12   Hybris" ,
            "FD 13+ Project X",          
            "FD 15   SWIV",
            "FD 16+ Xenon II",
            "FD 18   Rick Dangerous",
            "FD 19+ Chaos Engine",
           
            
        ];


        for (i = [0 : len(disk_listr)-1]) {

              translate([
                (lid_inner_w + (wall * 2)) / 2,
                -0.5,
                elid_h / 3.5 + i * azeilen_abstand
            ])
                rotate([90, 180, 180])
                mirror([1,0,0])
                linear_extrude(height = 1.5)
                    text(
                        disk_listr[i],
                        size = 3.5,
                        font = "Liberation Serif:style=Bold Italic",
                        valign = "center",
                        halign = "left"
                    );
        }                  
            
    }

    // Seitenführungen innen
    for (x = [0, lid_inner_w + wall]) {
        translate([x, 0, 0]) cube([wall, 15, lid_h]);
    }
}

module MechanismWithDetent() {
    translate([0, 0, -12]) cylinder(h=total_len + 12, d=shaft_dia);
    translate([0, 0, -12]) {
        difference() {
            cylinder(h=10, d=knob_dia);
            for(a=[0:30:360]) rotate([0, 0, a]) translate([knob_dia/2, 0, 5]) cube([4, 2, 12], center=true);
        }
    }
    for(a=[0:360/num_slots:359]) rotate([0, 0, a]) translate([0, shaft_dia/2, 4.5]) sphere(d=1.6); 
    for(i=[0:num_slots-1]) {
        translate([0, 0, wall + (i*slot_pitch) + 3]) 
        rotate([0, 0, i * (360/num_slots)])
        linear_extrude(3) hull() {
            circle(d=shaft_dia);
            translate([cam_lift, 0]) circle(d=1.5); 
        }
    }
}
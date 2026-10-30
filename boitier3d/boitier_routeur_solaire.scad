// Boîtier routeur solaire - Ender 3 V3 KE (220 x 220 x 240) - PETG
// Cotes en mm. Choisir la pièce avec "part" (ou en ligne de commande : -D 'part="boite"').
// part = "boite" | "couvercle" | "plaque" | "support_oled" | "gabarit_oled" | "ensemble" (aperçu éclaté)
part = "ensemble";
$fn = 48;

// ---------------- Général ----------------
wall     = 3;     // épaisseur des parois
floor_t  = 3;     // épaisseur du fond
inset_d  = 4.2;   // trou pour insert à chaud M3
plot_h   = 6;     // hauteur des plots (fond)
plot_d   = 8;     // diamètre des plots
plot_hole = 2.8;  // trou des plots (vis M3 autotaraudeuse dans PETG)

// ---------------- Dissipateur (mesuré) ----------------
hs_l    = 120;    // longueur
hs_w    = 80;     // largeur
hs_base = 2.9;    // épaisseur de la base pleine, sans les ailettes (mesuré)
hs_gap  = 1.5;    // jeu par côté autour du dissipateur
// Canaux à vis ronds de l'extrusion, aux deux bords de la largeur, sur toute la longueur de 120 mm.
// Les vis M4 entrent par les deux extrémités (faces de 80 mm), le long de X.
chan_y  = 37;     // axe du canal : 3 mm du bord de la largeur (80/2 - 3), mesuré
chan_d  = 3.25;   // diamètre du canal (mesuré), vis M4 autotaraudeuse
chan_z  = 3;      // hauteur de l'axe du canal au-dessus de la face de pose du LSA (mesuré)

// ---------------- LSA (mesuré, oreilles comprises) ----------------
lsa_l = 105;
lsa_w = 75;
lsa_h = 45;

// ---------------- Niveaux (de bas en haut) ----------------
bt_h       = 53;  // hauteur du niveau basse tension (ESP32 + adaptateur) ; 45 avant, +8 mm pour loger le module USB 230 V -> 5 V suspendu sous la plaque
plate_t    = 3;   // plaque de séparation
notch_w    = 14;  // largeur des encoches de câbles (bord de la plaque)
notch_d    = 12;  // profondeur des encoches depuis le bord de la plaque
notch_pz_x = -44; // position X de l'encoche 2 : au-dessus du bornier du PZEM, loin de la découpe du presse-étoupe
gl_notch_w = 31;  // largeur des découpes face aux presse-étoupes (écrou + filetage) ; 26 avant, +5 mm
gl_notch_d = 19;  // profondeur de ces découpes depuis le bord de la plaque ; 14 avant, +5 mm
term_clear = 5;   // dégagement entre le dessous du LSA et la plaque (20 mm avant, baissé de 15 mm)

// ---------------- Dimensions intérieures ----------------
int_x = 130;      // sens de la longueur du dissipateur
int_y = 130;      // sens des presse-étoupes AC
int_h = bt_h + plate_t + term_clear + lsa_h;
out_x = int_x + 2*wall;
out_y = int_y + 2*wall;
top_z = floor_t + int_h;           // dessus des parois

// ---------------- Couvercle ----------------
lid_t   = 8;                       // plateau épais : l'axe des vis passe dedans
hs_off  = 1;                       // la face de pose du LSA est 1 mm au-dessus du dessous du couvercle (centre le trou des vis dans le plateau)

// ---------------- Presse-étoupes / traversées ----------------
gland_d = 20.4;                    // PG13.5 (câble 3G2.5)
gland_above = 9;                   // [A MESURER] hauteur de l'entrée de fil des bornes de puissance au-dessus de la face basse du LSA (retourné)
gland_z = floor_t + bt_h + plate_t + term_clear + gland_above;   // axe des presse-étoupes, à hauteur des bornes du LSA
esp_hole_z = 20;                   // hauteur des perçages alimentation et antenne au-dessus du fond (15 avant : le câble arrive 5 mm plus haut à cause de l'adaptateur)
pwr_d   = 12.5;                    // PG7, alimentation 5 V
ant_d   = 6.6;                     // embase d'antenne type SMA

// ---------------- Cartes (entraxes mesurés) ----------------
esp_board = [77.5, 63];            // carte adaptateur ESP32 (mesuré au pied à coulisse)
esp_pitch = [72.5, 57.5];          // entraxe des 4 trous (mesuré ; 92 = la diagonale)
esp_c     = [18, 15];              // centre ; USB côté +X, aligné avec le trou d'alimentation (y = 15) ; >= 18 mm de dégagement sous les borniers
dac_pitch = 21;                    // entraxe des 2 trous du Gravity (côté IN)
dac_c     = [18, -40.5];           // centre de la carte, déplacé vers l'intérieur (implantation de la photo)
dac_hole_dx = 13.5;                // trous à ~4 mm du bord IN (à vérifier)
dac_flip  = false;                 // false : côté IN (I2C) vers +X, borne OUT vers -X ; true : carte tournée de 180°, borne OUT vers l'encoche 1 (+X)
pz_use_enclosure = false;          // false : PZEM nu sur 4 plots (trous d'angle) ; true : berceau pour son boîtier 77 x 37 (non adapté à l'implantation verticale)
pz_enc  = [77, 37];
pz_pitch = [25, 70];               // trous du circuit seul : 25 mm selon X, 70 mm selon Y (PZEM posé en long, bornier vers -Y)
pz_c    = [-44, -2];               // centre, le long de la paroi -X

// ---------------- Module USB 230 V -> 5 V (carte nue, suspendue sous la plaque) ----------------
// Carte posée à plat sous la plaque, composants vers le bas, prise USB vers la paroi +X,
// bornier 230 V côté -X. Repère "plaque" : z = 0 au dessous de la plaque, négatif vers le bas.
usb_on      = true;
usb_pcb     = [30.8, 36.77]; // X : de la prise USB au bornier (30,80) ; Y : entre les glissières (36,77) (mesuré ; 38 x 30 avant, dans le mauvais sens)
usb_pcb_t   = 1.6;         // [A MESURER] épaisseur du PCB
usb_comp_h  = 15;          // hauteur du composant le plus haut, côté composants (mesuré)
usb_above   = 2;           // bas de la prise USB au-dessus de la surface du PCB (mesuré)
usb_h       = 6;           // [A MESURER] hauteur de la prise USB (la fenêtre fait 7)
usb_front_len = 5.77;      // longueur de la partie avant étroite de la carte, du bord de la plaque vers l'intérieur (mesuré)
usb_front_w = 33.63;       // largeur de cette partie avant (mesuré) ; l'épaulement entre 36,77 et 33,63 sert de butée
usb_front_inset = 0;       // recul de la face avant de la carte par rapport au bord de la plaque (0 : à fleur)
usb_y       = 15;          // axe Y de la carte, même axe que le trou d'alimentation de l'ESP32
usb_win     = [14, 7];     // fenêtre dans la paroi : largeur, hauteur (mesuré)
usb_rec     = [22, 12, 2]; // logement extérieur pour le corps du connecteur : largeur, hauteur, profondeur
usb_top_gap = 3;           // dégagement entre le dessus du PCB (soudures) et la plaque
usb_hole    = [12, 32];    // trou dans la plaque pour les fils 230 V, à côté du bornier : X, Y
rail_wall   = 2.4;         // épaisseur de la paroi des glissières
rail_lip    = 1.5;         // recouvrement de la carte par les lèvres et les épaulements
rail_t      = 1.5;         // épaisseur des épaulements sous la carte
rail_gap    = 0.4;         // jeu autour de la carte (0,3 avant)
rail_start  = 14;          // lèvres et épaulements seulement à partir de là (laisse libre le côté bornier)
usb_x_edge = (int_x - 0.6)/2;      // bord de la plaque côté +X
usb_x1 = usb_x_edge - usb_front_inset;   // face avant de la carte (côté prise USB)
usb_xs = usb_x1 - usb_front_len;         // épaulement de la carte = butée dans les glissières
usb_x0 = usb_x1 - usb_pcb[0];            // face arrière de la carte (côté bornier)
usb_zc = -(usb_top_gap + usb_pcb_t + usb_above + usb_h/2);   // axe de la prise, repère plaque

// ---------------- Écran OLED 0,96" (SSD1306 128x64, I2C 4 broches, module JMD0.96C) ----------------
// Support imprimé à part, vissé à l'extérieur d'une paroi du boîtier existant par 4 vis M2 dans des inserts à chaud.
// Dessiné à plat : face avant sur le plateau, poche du circuit vers le haut. Vue de face : connecteur 4 broches en bas.
// Pièces : part = "support_oled" et part = "gabarit_oled" (gabarit de perçage de la paroi).
oled_pcb      = [28.6, 27.15]; // circuit : largeur x hauteur (mesuré)
oled_t        = 4.0;           // épaisseur totale du module avec le verre, sans le connecteur (mesuré ; 2 mm sans le verre)
oled_gap      = 0.25;          // jeu autour du circuit dans la poche
oled_win      = [23.4, 15.5];  // fenêtre de la face avant : zone visible du verre, 2,6 mm de marge à droite et à gauche, 15,5 de haut (mesuré)
oled_win_dy   = -1.0;          // [A VERIFIER] centre de la fenêtre par rapport au centre du circuit ; négatif = vers le connecteur (estimé sur la photo : 6,8 mm entre le bord du circuit opposé au connecteur et le haut de la zone visible)
oled_hdr_dy   = -(oled_pcb[1]/2 - 2.0);   // axe du connecteur, à ~2 mm du bord du circuit (estimé sur la photo)
oled_hdr_hole = [14, 6];       // trou dans la paroi pour les broches et les Dupont : largeur x hauteur
oled_skin     = 1.6;           // épaisseur de la face avant
oled_scr_d    = 2.4;           // trou de passage des vis M2
oled_head_d   = 4.4;           // logement de la tête de vis
oled_head_h   = 1.6;           // profondeur de ce logement
oled_scr_edge = 3.8;           // distance de l'axe des vis au bord de la poche
oled_ins_d    = 3.2;           // [A CONFIRMER] trou des inserts à chaud dans la paroi (gabarit)
oled_on       = true;          // prévoir dans la boîte les 4 trous d'inserts et le trou des Dupont de l'écran
oled_y        = -24;           // position du centre de l'écran sur la paroi +X : Y (vu de l'extérieur, négatif = à gauche du trou d'alimentation, qui est à y = 15)
oled_z        = 28;            // position du centre de l'écran : hauteur au-dessus du bas du boîtier

// Dimensions du support OLED (dérivées)
oled_px   = oled_pcb[0] + 2*oled_gap;                  // poche
oled_py   = oled_pcb[1] + 2*oled_gap;
oled_sx   = oled_px/2 + oled_scr_edge;                 // axes des vis
oled_sy   = oled_py/2 + oled_scr_edge;
oled_w    = 2*(oled_sx + 3.5);                         // support
oled_h    = 2*(oled_sy + 3.5);
oled_th   = oled_skin + oled_t + 0.2;                  // épaisseur totale : face avant + poche


// ---------------- Positions des bossages de couvercle ----------------
bx = int_x/2 - 4.5;
by = int_y/2 - 4.5;
boss_pos = [[bx,by],[-bx,by],[bx,-by],[-bx,-by]];

module plot(x, y) {
    translate([x, y, floor_t - 0.01]) difference() {
        cylinder(d = plot_d, h = plot_h + 0.01);
        translate([0, 0, 1]) cylinder(d = plot_hole, h = plot_h);
    }
}

module pz_cradle() {
    pw = pz_enc[0] + 0.6;
    ph = pz_enc[1] + 0.6;
    t = 2.4; a = 12; h = 10;
    for (sx = [-1, 1], sy = [-1, 1])
        translate([pz_c[0], pz_c[1], floor_t - 0.01]) {
            translate([sx*(pw/2 - a/2), sy*(ph/2 + t/2), h/2]) cube([a, t, h], center = true);
            translate([sx*(pw/2 + t/2), sy*(ph/2 - a/2), h/2]) cube([t, a, h], center = true);
            translate([sx*(pw/2 + t/2), sy*(ph/2 + t/2), h/2]) cube([t, t, h], center = true);
        }
}

module boite() {
    difference() {
        union() {
            // coque
            difference() {
                translate([-out_x/2, -out_y/2, 0]) cube([out_x, out_y, top_z]);
                translate([-int_x/2, -int_y/2, floor_t]) cube([int_x, int_y, int_h + 1]);
            }
            // bossages de couvercle et appuis de plaque
            for (p = boss_pos) {
                translate([p[0], p[1], floor_t - 0.01]) cylinder(d = 10, h = int_h + 0.01);
                translate([p[0], p[1], floor_t + bt_h - 4]) cylinder(d = 14, h = 4);
            }
            // plots ESP32
            for (sx = [-1, 1], sy = [-1, 1])
                plot(esp_c[0] + sx*esp_pitch[0]/2, esp_c[1] + sy*esp_pitch[1]/2);
            // plots Gravity (2 trous côté IN)
            for (sy = [-1, 1]) plot(dac_c[0] + (dac_flip ? -dac_hole_dx : dac_hole_dx), dac_c[1] + sy*dac_pitch/2);
            // PZEM
            if (pz_use_enclosure) pz_cradle();
            else for (sx = [-1, 1], sy = [-1, 1])
                plot(pz_c[0] + sx*pz_pitch[0]/2, pz_c[1] + sy*pz_pitch[1]/2);
        }
        // inserts M3 en haut des bossages
        for (p = boss_pos) translate([p[0], p[1], top_z - 9]) cylinder(d = inset_d, h = 9.01);
        // presse-étoupes AC sur les deux parois Y
        translate([0, 0, gland_z]) rotate([90, 0, 0]) cylinder(d = gland_d, h = out_y + 2, center = true);
        // alimentation et antenne sur la paroi +X, côté ESP32
        translate([int_x/2 + wall/2, 15, floor_t + esp_hole_z]) rotate([0, 90, 0]) cylinder(d = pwr_d, h = wall + 2, center = true);
        translate([int_x/2 + wall/2, 40, floor_t + esp_hole_z]) rotate([0, 90, 0]) cylinder(d = ant_d, h = wall + 2, center = true);
        // écran OLED 0,96" sur la paroi +X : 4 trous pour les inserts à chaud M2 et trou des Dupont
        if (oled_on) {
            for (sx = [-1, 1], sy = [-1, 1])
                translate([int_x/2 + wall/2, oled_y + sx*oled_sx, oled_z + sy*oled_sy])
                    rotate([0, 90, 0]) cylinder(d = oled_ins_d, h = wall + 2, center = true, $fn = 24);
            translate([int_x/2 + wall/2, oled_y, oled_z + oled_hdr_dy])
                cube([wall + 2, oled_hdr_hole[0], oled_hdr_hole[1]], center = true);
        }
        // fenêtre USB du module 230 V -> 5 V, au-dessus du trou d'alimentation de l'ESP32
        if (usb_on) {
            zc = floor_t + bt_h + usb_zc;
            translate([int_x/2 + wall/2, usb_y, zc]) cube([wall + 2, usb_win[0], usb_win[1]], center = true);
            // logement du corps du connecteur, côté extérieur
            translate([int_x/2 + wall - usb_rec[2] + (usb_rec[2] + 1)/2, usb_y, zc])
                cube([usb_rec[2] + 1, usb_rec[0], usb_rec[1]], center = true);
        }
    }
}

// Encoche ouverte sur le bord de la plaque : le câble reste coincé entre la paroi et le fond
// de l'encoche, la plaque se soulève sans rien débrancher puis le câble sort par l'ouverture.
// Le module est dessiné ouvert vers +X, avec l'origine au centre du fond arrondi.
module encoche() {
    hull() {
        translate([0, 0, -1]) cylinder(d = notch_w, h = plate_t + 2);
        translate([notch_d - notch_w/2, -notch_w/2, -1]) cube([2, notch_w, plate_t + 2]);
    }
}

// Glissières sous la plaque : la carte entre par le côté bornier (-X). Les glissières se resserrent sur les
// 5,77 mm de la partie avant étroite de la carte ; l'épaulement de la carte vient buter contre ce resserrement.
module usb_rails() {
    y0 = usb_y - usb_pcb[1]/2;      // bords de la partie large
    y1 = usb_y + usb_pcb[1]/2;
    y0n = usb_y - usb_front_w/2;    // bords de la partie avant étroite
    y1n = usb_y + usb_front_w/2;
    z_lo = -(usb_top_gap + usb_pcb_t + 0.15);   // dessus de l'épaulement (sous la carte)
    z_hi = -(usb_top_gap - 0.15);               // dessous de la lèvre (sur la carte)
    zb   = z_lo - rail_t;                       // bas des glissières
    xw0  = usb_x0 - 4;                          // début des parois (guidage à l'entrée)
    xl0  = usb_x0 + rail_start;                 // début des lèvres et des épaulements
    xe   = usb_x_edge;                          // fin des glissières : bord de la plaque
    for (s = [0, 1]) {
        yw = (s == 0) ? y0 - rail_gap - rail_wall : y1 + rail_gap;   // paroi
        yl = (s == 0) ? y0 - rail_gap : y1 - rail_lip;               // lèvre et épaulement, partie large
        yn = (s == 0) ? y0n - rail_gap : y1n - rail_lip;             // lèvre et épaulement, partie étroite
        translate([xw0, yw, zb]) cube([xe - xw0, rail_wall, -zb + 0.01]);                                  // paroi, sur toute la longueur
        translate([xl0, yl, z_hi]) cube([usb_xs - xl0, rail_lip + rail_gap, -z_hi + 0.01]);                // lèvre, partie large
        translate([xl0, yl, zb]) cube([usb_xs - xl0, rail_lip + rail_gap, rail_t + 0.01]);                 // épaulement, partie large
        translate([usb_xs, yn, z_hi]) cube([xe - usb_xs, rail_lip + rail_gap, -z_hi + 0.01]);              // lèvre, partie étroite
        translate([usb_xs, yn, zb]) cube([xe - usb_xs, rail_lip + rail_gap, rail_t + 0.01]);               // épaulement, partie étroite
        // butée : comble l'écart entre la paroi et la partie étroite, la partie large de la carte s'y appuie
        if (s == 0) translate([usb_xs, y0 - rail_gap, zb]) cube([xe - usb_xs, y0n - y0, -zb + 0.01]);
        else        translate([usb_xs, y1n + rail_gap, zb]) cube([xe - usb_xs, y1 - y1n, -zb + 0.01]);
    }
}

// Volumes indicatifs du module, pour l'aperçu "ensemble" (repère plaque)
module usb_module() {
    translate([usb_x0, usb_y - usb_pcb[1]/2, -usb_top_gap - usb_pcb_t]) color("green", 0.5) cube([usb_xs - usb_x0, usb_pcb[1], usb_pcb_t]);
    translate([usb_xs, usb_y - usb_front_w/2, -usb_top_gap - usb_pcb_t]) color("green", 0.5) cube([usb_front_len, usb_front_w, usb_pcb_t]);
    translate([usb_x0, usb_y - usb_pcb[1]/2 + 2, -usb_top_gap - usb_pcb_t - usb_comp_h]) color("red", 0.4) cube([usb_pcb[0] - 6, usb_pcb[1] - 4, usb_comp_h]);
    translate([usb_x1 - 14, usb_y - 6.75, -usb_top_gap - usb_pcb_t - usb_above - usb_h]) color("white", 0.7) cube([14, 13.5, usb_h]);
}

module plaque() {
    ph = (int_x - 0.6)/2;               // demi-côté de la plaque
    difference() {
        union() {
            translate([-ph, -ph, 0]) cube([2*ph, 2*ph, plate_t]);
            if (usb_on) usb_rails();
        }
        // trou pour les fils 230 V du module, juste derrière le bornier
        if (usb_on) translate([usb_x0 - 0.5 - usb_hole[0], usb_y - usb_hole[1]/2, -1]) cube([usb_hole[0], usb_hole[1], plate_t + 2]);
        for (p = boss_pos) translate([p[0], p[1], -1]) cylinder(d = 10.8, h = plate_t + 2);
        // commande LSA vers Gravity : ouverte vers la paroi +X, face au Gravity
        translate([ph - notch_d + notch_w/2, dac_c[1], 0]) encoche();
        // tension LSA et tore vers PZEM : ouverte vers la paroi -Y, au-dessus du PZEM
        translate([notch_pz_x, -(ph - notch_d + notch_w/2), 0]) rotate([0, 0, -90]) encoche();
        // découpes face aux deux presse-étoupes (x = 0, parois +Y et -Y) : l'écrou et le
        // filetage dépassent dans la boîte à hauteur de la plaque
        for (s = [-1, 1])
            translate([-gl_notch_w/2, (s > 0) ? ph - gl_notch_d : -ph - 1, -1])
                cube([gl_notch_w, gl_notch_d + 1, plate_t + 2]);
    }
}

module couvercle() {
    ox = hs_l + 2*hs_gap;
    oy = hs_w + 2*hs_gap;
    difference() {
        translate([-out_x/2, -out_y/2, 0]) cube([out_x, out_y, lid_t]);
        translate([-ox/2, -oy/2, -1]) cube([ox, oy, lid_t + 2]);
        // 4 vis M4 le long de X, depuis les tranches du couvercle jusque dans les canaux du dissipateur
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx*(out_x/2 - (out_x/2 - ox/2)/2), sy*chan_y, chan_z + hs_off])
                rotate([0, 90, 0]) cylinder(d = 4.4, h = (out_x - ox)/2 + 0.02, center = true);
        // vis M3 vers les inserts
        for (p = boss_pos) translate([p[0], p[1], -1]) cylinder(d = 3.4, h = lid_t + 2);
    }
}

module rect_arrondi(w, h, r, t) {
    hull() for (sx = [-1, 1], sy = [-1, 1])
        translate([sx*(w/2 - r), sy*(h/2 - r), 0]) cylinder(r = r, h = t);
}

module support_oled() {
    difference() {
        rect_arrondi(oled_w, oled_h, 3, oled_th);
        // poche du circuit, ouverte côté paroi (vers le haut sur le plateau)
        translate([-oled_px/2, -oled_py/2, oled_skin]) cube([oled_px, oled_py, oled_th]);
        // fenêtre de la face avant
        translate([-oled_win[0]/2, oled_win_dy - oled_win[1]/2, -1]) cube([oled_win[0], oled_win[1], oled_skin + 2]);
        // 4 vis M2, tête noyée dans la face avant
        for (sx = [-1, 1], sy = [-1, 1]) translate([sx*oled_sx, sy*oled_sy, 0]) {
            translate([0, 0, -1]) cylinder(d = oled_scr_d, h = oled_th + 2, $fn = 24);
            translate([0, 0, -1]) cylinder(d = oled_head_d, h = oled_head_h + 1, $fn = 24);
        }
    }
}

// Gabarit : plaqué sur la paroi, il donne les 4 trous des inserts et la place du trou des Dupont.
module gabarit_oled() {
    difference() {
        rect_arrondi(oled_w, oled_h, 3, 2);
        for (sx = [-1, 1], sy = [-1, 1]) translate([sx*oled_sx, sy*oled_sy, -1]) cylinder(d = oled_ins_d, h = 4, $fn = 24);
        translate([-oled_hdr_hole[0]/2, oled_hdr_dy - oled_hdr_hole[1]/2, -1]) cube([oled_hdr_hole[0], oled_hdr_hole[1], 4]);
    }
}

// Pour l'impression, la plaque est retournée : face supérieure sur le plateau, glissières vers le haut, sans supports.
module plaque_impression() {
    translate([0, 0, plate_t]) rotate([180, 0, 0]) plaque();
}

if (part == "boite") boite();
else if (part == "couvercle") couvercle();
else if (part == "plaque") plaque_impression();
else if (part == "support_oled") support_oled();
else if (part == "gabarit_oled") gabarit_oled();
else {
    boite();
    translate([0, 0, floor_t + bt_h]) { color("orange") plaque(); if (usb_on) usb_module(); }
    translate([0, 0, top_z + 25]) color("gray") couvercle();
}

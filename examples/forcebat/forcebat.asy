/* Forcebat 3D iso
   v1.0
   Exemple de la bibliothèque
   11/06/2024
   Anthony Meurdefroid */


// Paramètres de sortie
// settings.outformat = "pdf" ;
settings.render = -4 ;
settings.prc = false ;

// Import biblio des laisons
import biblioLiaisons ;
/* Le point O(0,0,0) et un objet base b0 avec
b0.x = (1,0,0)
b0.y = (0,1,0)
b0.z = (0,0,1)
est générée par défaut */

// taille police
defaultpen(fontsize(10pt));

// mise à l'échelle des dimensions - ne pas changer 
unitsize(1cm);


// Mise à jour de la scène :
// d'où on regarde le point (0,0,0)
triple eye = (1,1,1) ;
// quel vecteur vers le haut
triple up = (0,1,0) ;
// MAJ scène + pas d'effet de lumière (variables globales importées par les packages)
currentprojection = orthographic(eye, up, O) ;
currentlight = nolight;

// param
real coeff = 1/100 ;
real Lm = coeff * 300 ;
real Lv = coeff * 1000 ;
real a = coeff * 1000 ;
real b = coeff * 100 ;
real h = coeff * 100 ;

real r27 = coeff * 20 ;
real r6 = coeff * 50 ;
real r28 = r6 ;
real r16 = r27 ;


real theta20 = 30/360*2*pi ;

// Pas de LES implémenté -- uniquement pour chaine + roue et vis sans fin

real theta40 = 10/360*2*pi ; 

// Bases
basis b2 = rotationBasis(2, b0, theta20, 'y', b0.y) ;
basis b4 = rotationBasis(4, b0, theta40, 'y', b0.y) ;


// Points 
triple D = O + a*b0.x - b*b0.z ;
triple A = O + Lm*b0.x ;
triple B = A + Lm*b2.z ;
triple C = D + Lv*b4.z ;
triple E = O + 2*h*b0.y ;
triple F = O + 3*h*b0.y ;
triple G = A + 3*h*b0.y ;
triple K = A + Lm*b0.x ;
triple L = K + h*b0.y ;
triple H = K + 2*h*b0.y ;
triple I = A + Lm/2*b0.x - Lm/4*b0.z + h*b0.y ;
triple J = I + Lm/2*b0.x ;


// CEC
pen CEC0 = black ;
pen CEC1 = red ;
pen CEC2 = blue ;
pen CEC3 = deepgreen ;
pen CEC4 = purple ;
pen CEC5 = cyan ;
pen CEC6 = orange ;

// Relier
link(O -- K, CEC0) ;
link(A -- A + Lm/2*b0.x -- A + Lm/2*b0.x - Lm/4*b0.z -- I, CEC0) ;
link(B -- B-1*b0.y -- A-1*b0.y -- A, CEC2) ;
link(B -- C, CEC3) ;
link(D -- D + 0.8*Lv*b4.z -- D + 0.8*Lv*b4.z - 1*b0.y -- C - b0.y -- C, CEC4) ;

bati(O - 1*b0.x, b0.y, -b0.x, CEC0) ;
link(O -- O - 1*b0.x, CEC0) ;
bati(D - 1*b0.x, b0.y, -b0.x, CEC0) ;
link(D -- D - 1*b0.x, CEC0) ;

link(A -- G, CEC2) ;
link(O -- F, CEC1) ;
link(K -- H, CEC5) ;


// Liaisons
liaisonPivot(O, b0.y, b0.z, CEC0, CEC1) ;
liaisonPivot(A, b0.y, b0.z, CEC0, CEC2) ;
liaisonPivot(B, b0.y, b2.x, CEC3, CEC2) ;
liaisonPivot(C, b0.y, b4.x, CEC3, CEC4) ;
liaisonPivot(D, b0.y, b0.z, CEC4, CEC0) ;
liaisonPivot(K, b0.y, b0.z, CEC0, CEC5) ;
liaisonPivot(I, b0.x, b0.z, CEC0, CEC6) ;

transChaine(F, b0.y, r27,  CEC1, G, b0.y, r6, CEC2) ;
transChaine(E, b0.y, r28,  CEC1, H, b0.y, r16, CEC5) ;

transRoueVis(J, b0.x, CEC6, L, b0.y, CEC5) ;

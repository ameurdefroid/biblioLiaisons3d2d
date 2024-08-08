/* Direction camion 3D iso
   v1.0
   Exemple de la bibliothèque
   13/06/2024
   Anthony Meurdefroid */


// Paramètres de sortie
// settings.outformat = "pdf" ;
settings.render = -2 ; // pour limiter la taille
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
triple eye = (-3,0.5,1) ;
// quel vecteur vers le haut
triple up = (0,0,1) ;
// MAJ scène + pas d'effet de lumière (variables globales importées par les packages)
currentprojection = orthographic(eye, up, O) ;
currentlight = nolight;


// parameters
// lengths
real coeff = 1/150 ;
real l1 = coeff * 340 ;
real bz = coeff * 220 ;
real bx = coeff * 250 ;
real bx1 = coeff * 350 ;
real l2 = coeff * 800 ;
real e = l2 ;
real l5 = coeff * 800 ;
real f = l5 - bx ;
real g = bz + l1 ;
real h = l1 ;
real lR = bx ;

// astuce pour documentation
// animationScriptPython()
// angle
real epsilon = -5/360*2*pi ; // cst
real delta = 0*20/360*2*pi ; // m1
real tau = 0*10/360*2*pi ; // m2
real psi = 7/360*2*pi ; // cst
real betag = 0/360*2*pi ; // A calculer
real gamma31 = -166.5/360*2*pi ; // cst
real gamma311 = -90/360*2*pi ; // cst
real betad = 0/360*2*pi ; // A calculer

real l4 = 2*l5 + 2*bx1*sin(gamma31) ;

// basis
basis b01 = rotationBasis(101, b0, epsilon, 'y', b0.y) ;
basis b1 = rotationBasis(1, b0, delta, 'y', b0.y) ;

basis b5 = rotationBasis(5, b01, tau, 'x', b01.x) ;
basis b51 = rotationBasis(51, b5, psi, 'x', b5.x) ;
basis b511 = rotationBasis(511, b5, -psi, 'x', b5.x) ;

basis b3 = rotationBasis(3, b51, betag, 'z', b51.z) ;
basis b31 = rotationBasis(31, b3, gamma31, 'z', b3.z) ;
basis b311 = rotationBasis(311, b3, gamma311, 'z', b3.z) ;

basis b6 = rotationBasis(6, b511, betad, 'z', b511.z) ;
basis b61 = rotationBasis(61, b6, -gamma31, 'z', b6.z) ;


// points

triple H = O - h*b01.x ;
triple A = H - l5*b5.y ;
triple B = H + l5*b5.y ;
triple E = A - bz*b6.z + bx1*b61.x ;
triple D = B - bz*b3.z + bx1*b31.x ;
triple G = B + bz*b3.z + bx*b311.x ;
triple L = H + e*b0.x + f*b0.y + g*b0.z ;
triple M = L - l1*b1.z ;

// CEC
pen CEC0 = black ;
pen CEC1 = purple ;
pen CEC2 = orange ;
pen CEC3 = blue ;
pen CEC4 = deepgreen ;
pen CEC5 = red ;
pen CEC6 = deepblue ;


// Boite
triple coinBas = -(bx1+1)*b0.x - (l5+lR+1)*b0.y - (bz+l1+1)*b0.z ;
triple coinHaut = +(bx1+1)*b0.x + (l5+lR+1)*b0.y + (bz+l1+1)*b0.z ;
parallelepipedBounding(coinBas, coinHaut) ;



// Link
link(D -- E, CEC4) ;
link(O -- H -- A -- B, CEC5) ;
link(M -- G, CEC2) ;
link(M -- L, CEC1) ;
link(G -- B + bz*b3.z -- B -- B - bz*b3.z -- D, CEC3) ;
link(A -- A - bz*b6.z -- E, CEC6) ;
triple BR = B + lR*b3.y ;
triple AR = A - lR*b6.y ;
link(B -- BR, CEC3) ;
link(A -- AR, CEC6) ;

// Bases et paramétrages
showBasis(b0, H, coeff=(4,4,4)) ; 
int[] tabAxis = {0} ;
showAxis(b5, tabAxis, H, 4, style=black+0.25) ;
showAxis(b31, tabAxis, B - bz*b3.z, 3, style=black+0.25) ;
showAxis(b61, tabAxis, A - bz*b6.z, 3, style=black+0.25) ;

showAxis(b0, tabAxis, L, 2, style=black+0.25) ;
showAxis(b1, tabAxis, L, 2, style=black+0.25) ;


// liaisons
liaisonPivot(O, b01.x, b01.y, CEC0, CEC5) ;
liaisonPivot(A, b511.z, b6.y, CEC5, CEC6) ;
liaisonPivot(B, b51.z, b3.y, CEC5, CEC6) ;
liaisonRotule(E, unit(E-D), CEC6, CEC4) ;
liaisonRotule(D, unit(D-E), CEC3, CEC4) ;
liaisonRotule(M, unit(M-G), CEC1, CEC2) ;
liaisonRotule(G, unit(G-M), CEC3, CEC2) ;
liaisonPivot(L, b0.y, b0.x, CEC1, CEC0) ;


//formes 
addDisque(BR, b3.y, 1, CEC3) ;
addDisque(AR, b6.y, 1, CEC6) ;


// Noms des points
namePoint(O,"O",NE) ;
namePoint(H,"H",NE) ;
namePoint(A,"A",NE) ;
namePoint(B,"B",NE) ;
namePoint(E,"E",NE) ;
namePoint(D,"D",NE) ;
namePoint(G,"G",NE) ;
namePoint(M,"M",NE) ;
namePoint(L,"L",NE) ;
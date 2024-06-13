/* Pilote 5000 xy
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

// mise à l'échelle des dimensions - ne pas changer à mon avis
unitsize(1cm);


// Mise à jour de la scène :
// d'où on regarde
triple eye = (0, 0, 1) ;
// quel vecteut vers le haut
triple up = (0,1,0) ;
// MAJ scène + pas d'effet de lumière (variables globales importées par les packages)
currentprojection = orthographic(eye, up, O) ;
currentlight = nolight;


// Parameters
real L1 = 5 ;
real L2 = 5 ;
real R = 2 ;
real beta = pi/6 ;


// astuce pour documentation
// animationScriptPython()
// LES
real lambda = sqrt(L1^2+L2^2+R^2+2*R*L1*sin(beta) - 2*R*L2*cos(beta)) ;
real alpha = atan((L2-R*cos(beta))/(L1+R*sin(beta))) ;



// Création bases
basis b1 = rotationBasis(1, b0, alpha, 'z', b0.z) ;
basis b2 = rotationBasis(2, b0, beta, 'z', b0.z) ;

// creation des points
triple A = O + lambda*b1.x ;
triple B = O + L1*b0.x + L2*b0.y;
triple PG = O + 1/2*sqrt(L1^2+L2^2)*b1.x;


// Couleurs CEC
pen CEC0 = black ;
pen CEC1 = red ;
pen CEC2 = blue ;
pen CEC3 = deepgreen ;


// Boite englobante 
triple coinBas = (-1)*b0.x + (-1)*b0.y + (-1)*b0.z ;
triple coinHaut = (L1+1)*b0.x + (L2+1)*b0.y + (1)*b0.z ;
parallelepipedBounding(coinBas, coinHaut) ;


// Schéma :
showBasis(b0, O, coeff=(L1+2,L2+2,2), style=black+0.25) ;


// Relier et bâti
real decBati = 0.75 ;
bati(O-decBati*b0.y, b0.x, -b0.y, CEC0) ;
link(O-decBati*b0.y -- O, CEC0) ;
bati(B+decBati*b0.x, b0.y, b0.x, CEC0) ;
link(B+decBati*b0.x -- B, CEC0) ;
real prof = 1 ;
path3 pCEC1 = O -- O+prof*b1.y -- PG+prof*b1.y -- PG ;
link(pCEC1, CEC1) ;
path3 pCEC2 = A -- A-4*b1.x;
link(pCEC2, CEC2) ;
link(B -- A, CEC3) ;



// liaisons
liaisonPivot(O, b0.z, b0.x, CEC1, CEC0) ;
liaisonPivot(A, b0.z, b1.x, CEC2, CEC3) ;
liaisonPivot(B, b0.z, b2.x, CEC3, CEC0) ;
liaisonGlissiere(PG, b1.x, b1.y, CEC1, CEC2) ;




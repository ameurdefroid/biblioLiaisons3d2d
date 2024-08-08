/* Pilote Safran iso
   v1.0.1
   Exemple de la bibliothèque
   31/07/2024
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
triple eye = (1, 1, -1) ;
// quel vecteut vers le haut
triple up = (1, 0, 0) ;
// MAJ scène + pas d'effet de lumière (variables globales importées par les packages)
currentprojection = orthographic(eye, up, O) ;
currentlight = nolight;

// Parameters
real a = 0.5 ;
real b = 1.5 ;
real c = 3 ;
real d = 1.5 ;
real e = 3 ; 

// creation des points
triple A = O -a*b0.z ;
triple B = O + b*b0.x ;
triple C = B + c*b0.x ;
triple D = C + d*b0.x ;
triple E = D +e*b0.z ;

// Couleurs CEC
pen CEC0 = black ;
pen CEC1 = deepgreen ;
pen CEC2 = blue ;

// Schéma :
showBasis(b0, O, coeff=(b+c+d+2,2,e), style=black+0.25) ;

// Relier et bâti
link(O + 0.5*b0.x -- B -- C -- D, CEC1) ;
real dec = 1 ;
link(D -- D + dec*b0.y -- D + dec*b0.y + dec*b0.z -- D + dec*b0.z -- E, CEC2) ;
link(D -- D - dec*b0.y -- D - dec*b0.y + dec*b0.z -- D + dec*b0.z, CEC2) ;
link(C -- C + dec*b0.z, CEC0) ;
link(B -- B + dec*b0.z, CEC0) ;

triple P = B + 0.5*(C-B) + dec*b0.z ;
addSurfPlane(P, b0.y, 1*dec, b0.x, c+d/2, CEC0) ;

// Points et paramétrages
namePoint(A,"A",(-1.5,1.5)) ;
namePoint(B,"B", (-2.5,1.5)) ;
namePoint(C,"C", (-2.5,1.5)) ;
namePoint(D,"D", (-2.5,-2.5)) ;
namePoint(E,"E", S) ;

// Dimensions
showDimension(A, O, b0.z, -b0.x, "a", offset=1.5, pos=1*N, style=black+0.25, posDim='right') ;
real decgauche = 2.5 ;
showDimension(O, B, b0.x, -b0.z, "b", offset=decgauche, pos=1*W, style=black+0.25, posDim='middle') ;
showDimension(B, C, b0.x, -b0.z, "c", offset=decgauche, pos=1*W, style=black+0.25, posDim='middle') ;
showDimension(C, D, b0.x, -b0.z, "d", offset=decgauche, pos=1*W, style=black+0.25, posDim='middle') ;
showDimension(D, E, b0.z, b0.x, "e", offset=1.5, pos=1*N, style=black+0.25, posDim='middle') ;

// liaisons
liaisonPivot(D, b0.y, b0.z, CEC1, CEC2) ;
liaisonLineaireAnnulaire(B, b0.x, b0.z, CEC1, CEC0) ;
liaisonRotule(C, -b0.z, CEC0, CEC1) ;

//STL
importSTL('saf.stl', A, b0.z, b0.x, 0.5, CEC1) ;
addArrowText(E - 2*b0.y, E, "$\vec{F}$", posText=0.7, pos = 1*N, style = black+0.5) ;
addArrowText(A + 2*b0.y, A, "$\vec{F}_h$", posText=0.1, pos = 1*S, style = black+0.5) ;

// Features 
addText("Coque (0)", P, pos=(4,0)) ;
nameClasse2points("1", C, B, pos=1*W, p=CEC1) ;
nameClasse1point("2", D + dec*b0.y + dec*b0.z, pos=1*(1,0), p=CEC2) ;
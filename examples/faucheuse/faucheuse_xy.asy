/* Faucheuse 
   v1.0
   Exemple de la bibliothèque
   24/06/2024
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
triple eye = (0,0,1) ;
// quel vecteur vers le haut
triple up = (0,0,1) ;
// MAJ scène + pas d'effet de lumière (variables globales importées par les packages)
currentprojection = orthographic(eye, up, O) ;
currentlight = nolight;


// Import de la structure commmune à toutes les projections
include "faucheuse_structure.asy" ; 


// Pour chaque vue car position dépend de la vue

// pour galet
link(shift(B)*arcPath, CEC2) ;
draw(reflect(project(B), project(B+b0.x))*project(shift(B)*arcPath), CEC2) ;


// Noms des points
namePoint(O,"O",SE) ;
namePoint(A,"A",(-2,-3)) ;
namePoint(B,"B",(-1,0.25)) ;
namePoint(D,"D",(-3,-2)) ;
namePoint(H,"H",1.5*(1,1)) ;
//namePoint(F,"F",NE) ;
namePoint(E,"E",(-3,-0.5)) ;
namePoint(B+rg*b3.y,"C",(1.5,1.5)) ;



// numéro classes
nameClasse1point('1', A1, pos=1.5*S, p=CEC1) ;
nameClasse1point('2', B+rg*b0.z, pos=(-1.5,2.5), p=CEC2) ;
nameClasse2points('3', Bproj + rg*b3.x, D, pos=1.5*N, p=CEC3) ;
nameClasse2points('4', H, F, pos=1.5*SE, p=CEC4) ;
nameClasse1point('0', A+decBati*b0.y, pos=2.5*N, p=CEC0) ;


// axes et parametres
int[] tabAxis = {0} ;
showAxis(b3, tabAxis, Bproj, length(E-Bproj)+1.5, style=black+0.25) ;
int[] tabAxis = {1} ;
showAxis(b3, tabAxis, B-rg*b3.y, 3*rg+1.5, style=black+0.25) ;
showParameter(D, -b0.x, -b3.x, "$\varphi$", coeff=length(D - (Bproj + rg*b3.x) )*0.75, style=black+0.25) ;
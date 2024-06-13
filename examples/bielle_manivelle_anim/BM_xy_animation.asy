/* Bielle manivelle animation xy
   v1.0
   Exemple de la bibliothèque
   23/06/2023
   Anthony Meurdefroid */


// Paramètres de sortie
settings.render = -4 ;
settings.prc = false ;
settings.tex="pdflatex";


// Import biblio des laisons
import biblioLiaisons ;
/* Le point O(0,0,0) et un objet base b0 avec
b0.x = (1,0,0)
b0.y = (0,1,0)
b0.z = (0,0,1)
est générée par défaut */

// Décommenter la ligne pour créer une animation séparée
//usepackage("animate");

animation Anim  ;



// taille police
defaultpen(fontsize(10pt));

// mise à l'échelle des dimensions - ne pas changer 
unitsize(1cm);


// Mise à jour de la scène :
// d'où on regarde le point (0,0,0)
triple eye = (0,0,1) ;
// quel vecteur vers le haut
triple up = (0,1,0) ;
// MAJ scène + pas d'effet de lumière (variables globales importées par les packages)
currentprojection = orthographic(eye, up, O) ;
currentlight = nolight;



/* Structure bielle manivelle */

// Parameters :
real R = 2 ;
real L = 3 ;
real theta10 = 55/360*2*pi ;
real theta20 = asin(-R/L*sin(theta10)) ;
real pos = R*cos(theta10) + L *sqrt(1-(R/L*sin(theta10))^2) ;
basis b1 = rotationBasis(1, b0, theta10, 'z', b0.z) ;
basis b2 = rotationBasis(2, b0, theta20, 'z', b0.z) ;
triple A = R*b1.x ;
triple B = pos*b0.x ;
real dec = 1 ;
triple C = (R + L + 2*dec)*b0.x ;
triple D = B + (2*R + 4*dec)*b0.x ;


// CEC 
pen CEC0 = black ;
pen CEC1 = red ;
pen CEC2 = purple ;
pen CEC3 = deepgreen ;


int n = 36 ;
real pas = 360/n ;

// Boite englobante 
triple coinBas = (-R-1)*b0.x + (-R-1)*b0.y + (-2)*b0.z ;
triple coinHaut = (3*R+L+5*dec)*b0.x + (R+1)*b0.y + (2)*b0.z ;
parallelepipedBounding(coinBas,  coinHaut) ;




for(int i=0; i < n ; ++i) {
  save();
  
  // MAJ paramètres
  theta10 = i*pas/360*2*pi ;
  theta20 = asin(-R/L*sin(theta10)) ;
  pos = R*cos(theta10) + L *sqrt(1-(R/L*sin(theta10))^2) ;

  // Bases et points :
  b1 = rotationBasis(1, b0, theta10, 'z', b0.z) ;
  b2 = rotationBasis(2, b0, theta20, 'z', b0.z) ;

  A = R*b1.x ;
  B = pos*b0.x ;
  dec = 1 ;
  C = (R + L + 2*dec)*b0.x  ;
  D = B + (2*R + 4*dec)*b0.x ;

  // Relier et bâti
  real decBati = 0.75 ;
  bati(O-decBati*b0.y, b0.x, -b0.y, CEC0) ;
  link(O-decBati*b0.y -- O, CEC0) ;
  bati(C-decBati*b0.y, b0.x, -b0.y, CEC0) ;
  link(C-decBati*b0.y -- C, CEC0) ;
  real prof = -1 ;
  path3 pCEC1 = O -- O+prof*b0.z -- A+prof*b0.z -- A ;
  link(pCEC1, CEC1) ;
  link(A--B, CEC2) ;
  link(B--D, CEC3) ;

  // Liaisons
  liaisonPivot(O, b0.z, b0.x, CEC0, CEC1) ;
  liaisonPivotGlissant(A, b0.z, CEC2, CEC1) ;
  liaisonRotule(B, -b0.x, CEC2, CEC3) ;
  liaisonGlissiere(C, b0.x, b0.y, CEC0, CEC3) ;

  // Formes supplémentaires
  addCylinder(D, b0.x, 0.35, 0.25, CEC3) ;

  Anim.add(); // Add currentpicture to animation.
  restore();
}

erase() ;
endAnimationPDF(Anim) ;
/* I3D animation iso
   v1.0
   Exemple de la bibliothèque
   11/06/2024
   Anthony Meurdefroid */


// Paramètres de sortie
// settings.outformat = "pdf" ;
settings.render = -2 ;
settings.prc = false ;
settings.tex="pdflatex";


// Import biblio des laisons
import biblioLiaisons ;
/* Le point O(0,0,0) et un objet base b0 avec
b0.x = (1,0,0)
b0.y = (0,1,0)
b0.z = (0,0,1)
est générée par défaut */

//usepackage("animate");
import animation;
// Global = false pour éviter les out of memory
animation Anim = animation(global=false);

// taille police
defaultpen(fontsize(10pt));

// mise à l'échelle des dimensions - ne pas changer à mon avis
unitsize(1cm);


// Mise à jour de la scène :
// d'où on regarde
triple eye = (1,1,1) ;
// quel vecteut vers le haut
triple up = (0,0,1) ;
// MAJ scène + pas d'effet de lumière (variables globales importées par les packages)
currentprojection = orthographic(eye, up, O) ;
currentlight = nolight;


// Parameters
real R = 5 ;
real h = 10 ;
real L = 5 ;
real dec = 1 ;
real r = 2 ;
real thetaStruc = 15/360*2*pi ;
real thetaPlateau = asin(R*sin(thetaStruc)/r) ;
real gt = 2*pi/3 ;




triple forwardKinematics(real[] dZ)  {
    triple [] dColP = new triple [3] ;
    triple temp ;
    transform3 r3 ;
    for(int iIdx = 0; iIdx < 3; ++iIdx) {
        r3 = rotate(iIdx*gt/(2*pi)*360, O, O+b0.z) ;
        temp = r3*((R*cos(thetaStruc) - dec - r*cos(thetaPlateau))*b0.x) + dZ[iIdx]*b0.z ;
        dColP[iIdx] = temp ;
        }

triple p12 = dColP[1] - dColP[0] ;
real d = length(p12) ;
triple ex  = 1/d*p12 ;

triple p13 = dColP[2] - dColP[0] ;
real i = dot(ex, p13) ;
triple iex  = i*ex ;

triple ey = p13 - iex ;
real j = length(ey) ;
ey = 1/j*ey ;
triple ez = cross(ex, ey) ;

real Xnew = d/2 ;
real Ynew = ((i * i + j * j)/2 - i * Xnew)/j ;
real Znew = sqrt(L^2 - Xnew * Xnew - Ynew * Ynew) ;

triple cartesian = dColP[0] + Xnew*ex + Ynew*ey - Znew*ez ;

return cartesian;
}

real[] doubleDZ(real[] dZ)  {
    real [] dzdouble = new real [6] ;
    for(int ii = 0; ii < dZ.length ; ++ii) {
    dzdouble[2*ii] = dZ[ii] ;
    dzdouble[2*ii+1] = dZ[ii] ;
    }
    return dzdouble ;
}




pen CEC0 = red ;
pen CEC1 = blue ;
pen CEC2 = deepgreen ;
pen CEC3 = purple ;




// base
transform3 r3 = rotate(gt/(2*pi)*360, O, O+b0.z) ; 
transform3 hh = shift(h*b0.z) ;
triple P1 = R*cos(-thetaStruc)*b0.x + R*sin(-thetaStruc)*b0.y ;
triple P2 = R*cos(thetaStruc)*b0.x + R*sin(thetaStruc)*b0.y ;
triple P3 = r3*P1 ;
triple P4 = r3*P2 ;
triple P5 = r3*P3 ;
triple P6 = r3*P4 ;
path3 base = P1 -- P2 -- P3 -- P4 -- P5 -- P6 -- cycle ;
path3 baseHaute = hh*base ;



// plateau 
triple P1p = r*cos(-thetaPlateau)*b0.x + r*sin(-thetaPlateau)*b0.y ;
triple P2p = r*cos(thetaPlateau)*b0.x + r*sin(thetaPlateau)*b0.y ;
triple P3p = r3*P1p ;
triple P4p = r3*P2p ;
triple P5p = r3*P3p ;
triple P6p = r3*P4p ;
path3 basePlateau = P1p -- P2p -- P3p -- P4p -- P5p -- P6p -- cycle ;
surface surfBP = surface(basePlateau) ;



showBasis(b0, O, coeff=(R+1,R+1,h+4)) ; 

link(base, CEC0) ;
link(baseHaute, CEC0) ;


triple [] arrBase = {P1,P2,P3,P4,P5,P6} ;
triple [] arrPlateau = {P1p,P2p,P3p,P4p,P5p,P6p} ;
real [] dzdouble = new real [6] ;

// Animation -- paramètres
int n = 4 ;
real pas = 1/n ;

for(int i=0; i < n ; ++i) {
  save();

    // LES
    real z1 = 8 + 1*sin(i*n*2*pi) ;
    real z2 = 8 + 1*cos(i*n*2*pi) ;
    real z3 = 8 ;
    real [] dZ  = {z1, z2, z3} ;
    triple PP = forwardKinematics(dZ) ;
    write('PP ' + (string)PP) ;


    link(shift(PP-dec*b0.z)*basePlateau, CEC3) ;
    draw(shift(PP-dec*b0.z)*surfBP, 0.5*CEC3+0.5*white) ;

    dzdouble = doubleDZ(dZ) ;

    for (int i = 0 ; i<arrBase.length; ++i) {

        link(arrBase[i] -- hh*arrBase[i], CEC0 ) ;

        triple Cpg = shift(dzdouble[i]*b0.z)*arrBase[i] ;
        liaisonPivotGlissant(Cpg, b0.z, CEC1, CEC0) ;

        real ilocal = floor(i/2) ;
        triple dirlocal = rotate(ilocal*gt/(2*pi)*360, O, O+b0.z)*b0.x ; 
        triple Crot1 = Cpg - dec*dirlocal ;

        triple Crot2 = shift(PP)*arrPlateau[i] ;

        triple axe = Crot1 - Crot2 ;
        triple n1 = unit(axe) ;

        liaisonRotule(Crot1, n1, CEC1, CEC2) ;
        liaisonRotule(Crot2, -n1, CEC3, CEC2) ;

        link(Crot1 -- Crot2 , CEC2) ;
        link(Crot1 -- Cpg , CEC1) ;
        link(Crot2 -- shift(PP-dec*b0.z)*arrPlateau[i] , CEC1) ;
    }

    for (int i = 0 ; i<arrBase.length/2; ++i) {
        link(shift(dZ[i]*b0.z)*arrBase[2*i] -- shift(dZ[i]*b0.z)*arrBase[2*i+1], CEC1) ;
    }
    Anim.add(); // Add currentpicture to animation.
    restore();
}

erase();

endAnimationPDF(Anim) ;



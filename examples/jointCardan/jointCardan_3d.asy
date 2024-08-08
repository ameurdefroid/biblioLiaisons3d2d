/* joint de Cardan 3d iso
31/07/24
alexandre Perraud
PSI Dijon */

settings.render = -4 ;
settings.prc = false ;
         
// Import biblio des liaisons e
import biblioLiaisons ;
defaultpen(fontsize(10pt));
unitsize(1cm);
triple eye = (1,0.5,0.8) ;
triple up = (0,0,1) ;
currentprojection = orthographic(eye, up, O) ;
currentlight = nolight;
// Parameters :
real L1 = 3 ;
real L2 = 3 ;
real alpha = -30/360*2*pi ;
real theta10 = 20/360*2*pi ;
real theta20 = atan(cos(alpha)*tan(theta10)) ;
         
// Basis 
basis b0p = rotationBasis(10, b0, alpha, 'z', b0.z) ;
basis b1 = rotationBasis(1, b0, theta10, 'y', b0.y) ;
basis b2 = rotationBasis(2, b0p, theta20, 'y', b0p.y) ;
basis b3 = createBasis(3, b2.x, unit(cross(b1.z, b2.x))) ; 

// Points
triple A = -L1*b0.y ;
real prof = 1.5 ;
triple A1 = A + prof*b0.y ;
triple A2 = A1 + prof*b1.z ; 
triple B = A2 + prof*b0.y ;
triple D = L1*b0p.y ;
triple D1 = D - prof*b0p.y ;
triple D2 = D1 + prof*b2.x ;
triple C = D2 - prof*b2.y ;

// CEC 
pen CEC0 = black ;
pen CEC2 = red ;
pen CEC3 = purple ;
pen CEC1 = deepgreen ;
    
// Bases et paramétrages

int [] tabAxis = {0} ;
showAxis(b0 , tabAxis , O, coeff = 3*prof) ;

showAxisName(b0.z, O, "$\vec{z}_0=\vec{z}_{0'}$", coeff=3*prof) ;
showAxisName(b1.z, O, "$\vec{z}_1=\vec{z}_{3}$", coeff=3*prof) ;

showAxisName(b0p.x, O, "$\vec{x}_{0'}$", coeff=3*prof) ;
showAxisName(b2.x, O, "$\vec{x}_2=\vec{x}_{3}$", coeff=3*prof) ;

showAxisName(b0.y, O, "$\vec{y}_0=\vec{y}_{1}$", coeff=3*prof) ;
showAxisName(b0p.y, O, "$\vec{y}_{0'}=\vec{y}_{2}$", coeff=3*prof) ;

showParamAng(O, b0.z, b1.z, "$\theta_{10}$", coeff=2*prof, style=CEC1+0.25) ;
showParamAng(O, b0p.x, b2.x, "$\theta_{30}$", coeff=2*prof, style=CEC2+0.25) ;
showParamAng(O, b0.y, b0p.y, "$\alpha$", coeff=1*prof, style=CEC0+0.25) ;

// Liens
real decBati = 0.75;
bati(A-decBati*b0.z, b0.y, -b0.z, CEC0) ;
link(A-decBati*b0.z -- A, CEC0) ;
bati(D-decBati*b0p.z, b0p.y, -b0p.z, CEC0) ;
link(D-decBati*b0.z -- D, CEC0) ;

link(A -- A1 -- A2 -- B, CEC1) ;
link(D -- D1 -- D2 -- C, CEC2) ;
link(B -- B-prof*b3.z -- C, CEC3) ;

// Liaisons
liaisonPivot(A, b0.y, b1.z, CEC0, CEC1) ;
liaisonPivot(B, b1.z, b3.x, CEC1, CEC3) ; 
liaisonPivot(C, b2.x, b3.z, CEC2, CEC3) ;
liaisonPivot(D, b0p.y, b2.z, CEC0, CEC2) ;
    
// Noms des points
namePoint(O,"O",pos = 2.5*NE) ;
namePoint(A,"A",pos = 3*N) ;
namePoint(C,"C",pos = 2.5*NW) ;
namePoint(B,"B",pos = 3*NE) ;
namePoint(D,"D",pos = 2.5*NE) ;
    
    
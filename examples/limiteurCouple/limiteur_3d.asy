/* limiteur de couple 3d
v1.0.0
from : 
https://tex.stackexchange.com/questions/634358/how-to-draw-this-3d-kinematics-diagram/723203#723203
01/08/24
Anthony Meurdefroid */

// Settings pdf
settings.render = -4 ;
settings.prc = false ;

// Package + stage
import biblioLiaisons ;
defaultpen(fontsize(10pt));
unitsize(1cm);
triple eye = (1,0.8,0.4) ;
triple up = (0,1,0) ;
currentprojection = orthographic(eye, up, O) ;
currentlight = nolight;

// Parameters
real R = 2 ;
real la = 2.5 ;
real lb = 1.5 ;
real ld = 3 ;
real Rsphere = 0.25 ;
real theta = 20/360*2*pi ;
real dec = Rsphere/cos(theta) ;

// Points
triple A = la*b0.z ;
triple A1 = la/2*b0.z ;
triple B = -lb*b0.z ;
triple D = -ld*b0.z ;

// CEC
pen CEC0 = black ;
pen CEC1 = red ;
pen CEC2 = deepgreen ;
pen CEC3 = blue ;

// Joints
liaisonGlissiere(B, b0.z, b0.x, CEC3, CEC0) ;
liaisonAppuiPlan(A, b0.z, b0.x, CEC0, CEC2) ;
addSurfPlane(D-(1)*b0.z, b0.x, 2, b0.y, 2, CEC0) ;
link(D -- D-(1)*b0.z, CEC0) ;
triple R1 = D+R/2*b0.y ;
triple R2 =  B+R/2*b0.y ;
addSpring(R1, R2, N=6) ;
link(B -- D -- D + (R+1)*b0.y -- A + (1)*b0.z + (R+1)*b0.y -- A + (1)*b0.z  -- A, CEC0) ;

// for loop
basis b1 ;
basis b2 ;
triple C ;
for (int i=0;i<3;++i){
    b2 = rotationBasis(2, b0, i*2*pi/3, 'z', b0.z) ;
    b1 = rotationBasis(1, b2, theta, 'y', b2.y) ;
    C = R*b2.y ;
    liaisonPonctuelle(C - Rsphere*b1.z, b1.z, b1.x, CEC1, CEC3) ;
    namePoint(C,"C_"+(string) i,NE) ;
    liaisonPonctuelle(C + Rsphere*b1.z, -b1.z, b1.x, CEC1, CEC2) ;
    link(B -- B + R*b2.y -- C - dec*b0.z, CEC3) ;
    link(C + dec*b0.z -- A1 + R*b2.y -- A1 -- A, CEC2);
}

// Improve the drawing
showBasis(b0, O, coeff=(R+2,R+2,la+2)) ;
namePoint(O,"O",NE) ;
namePoint(A,"A",(-2.5,1.5)) ;
namePoint(B,"B",2.5*SE) ;
addText("ressort", R1+(R2-R1)*0.5, pos = 4*N, style = black) ;

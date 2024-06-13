/* pompe pistons axiaux structure */

// Parameters :
real coeff = 1/5 ;
real R = coeff*20 ;
real dec = R/2 ;
real Lpiston = R ;
real hpatin = R/4 ;
real a = 1.5*R ;
real Rdisque = 1.25*R ;

real alpha = 10/360*2*pi ;
real theta = 25/360*2*pi ;
real lambdaParticulier = a-dec - hpatin/cos(alpha) ;//a - dec - hpatin*cos(alpha) - tan(alpha)*(R+hpatin*sin(alpha)) - R*tan(alpha) ;
real lambda = -R*cos(theta)*tan(alpha) + lambdaParticulier ; //LES

// Bases et points :
basis b1 = rotationBasis(1, b0, theta, 'x', b0.x) ;
basis b2 = rotationBasis(2, b0, alpha, 'z', b0.z) ;

triple H = O + dec*b0.x ;
triple A = H + R*b1.y ;
triple B = A + lambda*b0.x ;
triple Bp = B - Lpiston*b1.x ;
triple C = B + hpatin*b2.x ;
triple D = O + a*b0.x ;

// CEC 
pen CEC0 = black ;
pen CEC1 = deepgreen ;
pen CEC2 = purple ;
pen CEC3 = blue ;


// Relier et bâti
bati(O-1*b0.y, b0.x, -b0.y, CEC0) ;
bati(D-1*b0.x, b0.y, -b0.x, CEC0) ;

link(O-1*b0.y -- O, CEC0) ;
link(O -- H -- A, CEC1) ;
link(Bp -- B, CEC2) ;
link(B -- C, CEC3) ;
link(D -- D-1*b0.x, CEC0) ;


// Liaisons
liaisonPivot(O, b0.x, b0.y, CEC0, CEC1) ;
liaisonPivotGlissant(A, b1.x, CEC1, CEC2) ;
liaisonRotule(B, -b2.x, CEC2, CEC3) ;
liaisonAppuiPlan(C, -b2.x, b2.y, CEC3, white) ; //astuce

// Formes
addDisque(D, b2.x, Rdisque, CEC0) ;

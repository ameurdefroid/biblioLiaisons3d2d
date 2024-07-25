/* Structure croix Malte */

// Parameters :
real L = 8 ; //espacement
int N = 6 ; // rainures
real Rg = 0.5 ; // galet
real R = L*sin(pi/N) ;

// positions extrêmes
real theta1max = pi/2 + asin(R/L) ;
real theta1min = 2*pi - theta1max ;
real theta3max = asin(R/L) ;
real theta3min = -theta3max ;

real theta1 = 130/360*2*pi ;
real theta20 = pi/3;

real lambda(real angleInput) {
    real value = sqrt(L^2+R^2+2*L*R*cos(angleInput)) ;
    return value ;
}

real computeTheta2(real angleInput) {
  real value ;
  if (angleInput >= 0 && angleInput < theta1max) {
    value = theta20 ; 
    }
  else if (angleInput < theta1min && angleInput >= theta1max) {
    value = 1/Rg * (sqrt(L^2-R^2)-lambda(theta1)) + theta20 ; 
    }
  else {
    value = 1/Rg * (sqrt(L^2-R^2)-lambda(theta1min)) + theta20 ;  
    }
  return value;
}

real theta2 = computeTheta2(theta1)  ;

real computeTheta3(real angleInput) {
  real value ;
  if (angleInput >= 0 && angleInput < theta1max) {
    value = theta3max ; 
    }
  else if (angleInput < theta1min && angleInput >= theta1max) {
    value = atan((R*sin(angleInput))/(R*cos(angleInput)+L)) ; 
    }
  else {
    value = theta3min ; 
    }
  return value;
}

real theta3 = computeTheta3(theta1) ;

// Basis 
basis b1 = rotationBasis(1, b0, theta1, 'z', b0.z) ;
basis b2 = rotationBasis(2, b1, theta2, 'z', b0.z) ;
basis b3 = rotationBasis(3, b0, theta3, 'z', b0.z) ;

// Points
triple A = L*b0.x ;
triple B = A+R*b1.x ;
triple B1 = (L-R-Rg)*b3.x ;
real dec = 1 ;
triple I1 = B + Rg*b2.x ;
triple I2 = B - Rg*b2.x ;

// CEC 
pen CEC0 = black ;
pen CEC1 = red ;
pen CEC2 = purple ;
pen CEC3 = deepgreen ;

// Link and ground link
real decBati = 1 ;
bati(O-decBati*b0.y-decBati*b0.z, b0.x, -b0.y, CEC0) ;
link(O -- shift(-decBati*b0.z)*O -- shift(-decBati*(b0.z+b0.y))*O, CEC0) ;
bati(A-decBati*b0.y, b0.x, -b0.y, CEC0) ;
link(A-decBati*b0.y -- A, CEC0) ;

link(shift(-dec*b0.z)*(A--B), CEC1) ;
link(O--B1, CEC3) ;
link(B--I1, CEC2) ;
link(B--I2, CEC2) ;

// shape Galet
addSurfCylinder(B, b0.z, Rg, dec, CEC2) ; 

//shapes rainures
for (int i=0; i<N; ++i){
real angletemp = i*2*pi/N ;
basis btemp = rotationBasis(111, b0, theta3 + angletemp, 'z', b0.z) ;
triple B1temp = rotate(angletemp/(2*pi)*360, O, b0.z)*B1 ;
link(O--B1temp, CEC3) ;
addUshape(B1temp, b0.z, btemp.x, dec, sqrt(L^2-R^2)-(L-R-Rg), 2*Rg, CEC3) ;
}

// Liaisons
liaisonPivot(O, b0.z, b0.x, CEC3, CEC0) ;
liaisonPivot(A, b0.z, b0.x, CEC0, CEC1) ;
liaisonPivot(B, b0.z, b0.x, CEC2, CEC1) ;

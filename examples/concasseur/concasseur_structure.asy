/* concasseur structure */

// Parameters :
real coeff = 1/450 ;
real a = coeff * 890 ;
real b = coeff * 445 ; 

real e = coeff * 900 ;
real g = coeff * 900 ;
real R = coeff * 1325 ;  
real h = coeff * 1250 ; 
real entraxe = coeff * 1500 ;
real dpm = coeff * 420 ;
real dp1 = coeff * 1600 ;

real theta20 = 0/360*2*pi ;
real alpha = -3*2.4/360*2*pi ; //amplification
real theta32 = -theta20*(cos(alpha)+h/R*sin(alpha)) ;

real c = abs(tan(alpha)) * (h + g) ; //amplification

// Bases et points :
basis b2 = rotationBasis(2, b0, theta20, 'z', b0.z) ;
basis b21 = rotationBasis(21, b2, alpha, 'x', b2.x) ;
basis b3 = rotationBasis(3, b21, theta32, 'z', b21.z) ;

triple I = O - h*b21.z ;
triple A = I - R*b21.y ;
triple K = I + R*b21.y ;
triple B = I - g*b21.z ;
triple C = B + c*b21.y - e*b0.z ;
triple P = C - 2*b*b0.z ;
triple P2 = P + b*b0.z ;
triple P1 = P + a*b0.y ;
triple D1 = P1 + a*b0.y ;
triple D2 = D1 + a*b0.y ;
triple D3 = D2 + a*b0.y ;
triple D4 = D3 - entraxe*b0.x + 1*a*b0.z ;
triple D5 = D4 - a*b0.y ;


// CEC 
pen CEC0 = black ;
pen CEC1 = deepgreen ;
pen CEC2 = purple ;
pen CEC3 = red ;
pen CEC4 = blue ;


// Relier et bâti
link(O -- I, CEC3) ;
link(K -- I, CEC3) ;
link(A -- I, CEC3) ;
link(B -- I, CEC3) ;

link(D4 -- D5, CEC4) ;
link(B -- B+c*b21.y -- C -- P2, CEC2) ;
link(P1 -- D1 -- D2 -- D3, CEC1) ;

bati(O+1*b0.z, b0.y, b0.z, CEC0) ;
bati(C+1*b0.y, b0.z, b0.y, CEC0) ;
bati(D1-1*b0.z, b0.y, -b0.z, CEC0) ;
bati(D2-1*b0.z, b0.y, -b0.z, CEC0) ;
bati(D5-1*b0.z, b0.y, -b0.z, CEC0) ;

link(O -- O+1*b0.z, CEC0) ;
link(C -- C+1*b0.y, CEC0) ;
link(D1 -- D1-1*b0.z, CEC0) ;
link(D2 -- D2-1*b0.z, CEC0) ;
link(D5 -- D5-1*b0.z, CEC0) ;


// Formes
addSurfConiqueTronquee(O, -b21.z, 0.9*h, 1.1*h,atan(R/h), CEC3) ;
addSurfConiqueTronquee(O, -b0.z, 0.5*h, 1.5*h, atan(R/h) + abs(alpha), CEC0) ;

// Liaisons
liaisonRotule(O, -b0.z, CEC3, CEC0) ;
liaisonLineaireAnnulaire(B, b21.z, b21.y, CEC2, CEC3) ;
liaisonPivot(C, b0.z, b0.y, CEC0, CEC2) ;

transPoulieCourroie(D4, b0.y, dpm/2, CEC4, D3, b0.y, dp1/2, CEC1) ;
liaisonPivot(D5, b0.y, b0.z, CEC0, CEC4) ;

transEngrenages(P1, -b0.y, b, CEC1, P2, -b0.z, CEC2) ;

liaisonRotule(D1, b0.z, CEC1, CEC0) ;
liaisonLineaireAnnulaire(D2, b0.y, -b0.z, CEC0, CEC1) ;


// points
namePoint(O, "O") ;
namePoint(I, "I") ;
namePoint(A, "A") ;
namePoint(K, "K") ;
namePoint(B, "B") ;
namePoint(C, "C") ;
namePoint(P, "P") ;
namePoint(P1, "P1") ;
namePoint(P2, "P2") ;
namePoint(D1, "D1") ;
namePoint(D2, "D2") ;
namePoint(D3, "D3") ;
namePoint(D4, "D4") ;
namePoint(D5, "D5") ;






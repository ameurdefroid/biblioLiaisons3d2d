/* pince Coupe Cable structure */

// Parameters :
real coeff = 1/5 ;
real CO = coeff*15 ;
real OB = coeff*8 ;
real h = coeff*9 ;
real OQ = coeff*25 ;
real rg = coeff*8 ;
real Lo = coeff*(25+15) ;

real angle = 10/360*2*pi ;

// Bases et points :
basis b51 = rotationBasis(51, b0, angle, 'z', b0.z) ;
basis b52 = rotationBasis(52, b0, -angle, 'z', b0.z) ;

triple C = O - CO*b0.x ;
triple Bp = O + OB*b0.x + h*b0.y ;
triple B = O + OB*b0.x - h*b0.y ;
triple Q = O + OQ*b0.x + h*b0.y ;
triple P = O + OQ*b0.x - h*b0.y ;
triple K = Q - rg*b51.y ;
triple L = P + rg*b52.y ;
triple M = O + Lo*b0.x ;
triple G = M + 2*b0.x ;

// CEC 
pen CEC0 = black ;
pen CEC1 = red ;
pen CEC2 = purple ;
pen CEC3 = deepgreen ;
pen CEC4 = blue ;
pen CEC5 = yellow ;
pen CEC5p = magenta ;


// Relier et bâti
bati(O-1*b0.x, b0.y, -b0.x, CEC0) ;
bati(M-1*b0.y, b0.x, -b0.y, CEC0) ;
link(O+b0.z -- O+b0.z-1*b0.x -- O-b0.z-1*b0.x -- O-b0.z, CEC0) ;
link(M -- M-1*b0.y, CEC0) ;

link(C -- C - h*b0.y -- O - h*b0.y -- O -- O+1*b0.z, CEC2) ;
link(O - h*b0.y -- P, CEC2) ;

link(C -- C + h*b0.y -- O + h*b0.y -- O -- O-1*b0.z, CEC3) ;
link(O + h*b0.y -- Q, CEC3) ;

link(Q -- K, CEC5p) ;
link(P -- L, CEC5) ;


link(K -- L, CEC4) ;
link(dot(K-O, b0.x)*b0.x -- G, CEC4) ;
link(G+1/2*b0.y -- G-1/2*b0.y, CEC4) ;

addSpring(B, Bp) ;
addSpring(M+0.5*b0.x, G, N= 4) ;




// Liaisons
liaisonPivot(O+1*b0.z, b0.z, b0.y, CEC0, CEC2) ;
liaisonPivot(O-1*b0.z, b0.z, b0.y, CEC0, CEC3) ;

liaisonPonctuelle(C, b0.y, b0.x, CEC3, CEC0) ;
liaisonPonctuelle(C, -b0.y, b0.x, CEC2, CEC0) ;

liaisonPivot(Q, b0.z, b0.y, CEC5p, CEC3) ;
liaisonPivot(P, b0.z, b0.y, CEC5, CEC2) ;

liaisonLineaireRectiligne(K, b51.y, b0.z, CEC5p, CEC4) ;
liaisonLineaireRectiligne(L, -b52.y, b0.z, CEC5, CEC4) ;

liaisonPivotGlissant(M, b0.x, CEC0, CEC4) ;

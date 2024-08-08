settings.render = -4 ;
settings.prc = false ;
import biblioLiaisons ;
defaultpen(fontsize(10pt)) ;
unitsize(1cm) ;
triple eye = (0,0,1) ;
triple up = (0,1,0) ;
currentprojection = orthographic(eye, up, O) ;
currentlight = nolight ;
simpleCubeBounding(1.5) ;
showBasis(b0, O, coeff=1.5*(1,1,1)) ;
basis b1 = rotationBasis(1, b0, pi/6, 'z', b0.z) ;
int[] tabAxis = {0,1} ;
showAxis(b1, tabAxis, O, coeff=1.5, style = 0.25+blue) ;
showParamAng(O, b0.x, b1.x, "$\theta$", coeff=1, style=0.25+blue) ;
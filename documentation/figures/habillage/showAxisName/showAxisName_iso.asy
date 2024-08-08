settings.render = -4 ;
settings.prc = false ;
import biblioLiaisons ;
defaultpen(fontsize(10pt)) ;
unitsize(1cm) ;
triple eye = (1,1,1) ;
triple up = (0,1,0) ;
currentprojection = orthographic(eye, up, O) ;
currentlight = nolight ;
simpleSphereBounding (1.5) ;
showBasis(b0, O, coeff=1.5*(1,1,1)) ;
basis b1 = rotationBasis(1, b0, 60/360*2*pi, 'z', b0.z) ;
showAxisName(b1.x, O, "$\vec{x}_1=\vec{x}_2$", coeff=0.7, style = red+0.25) ;
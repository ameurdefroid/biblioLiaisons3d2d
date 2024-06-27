# AM

### imports
import sympy as sy
import sympy.physics.vector as v
from IPython import display
import os

from scipy import optimize
import matplotlib.pyplot as plt
import numpy as np


### param
boolASY = True
shortName = 'falconHaptic_3d_'
chemin = ""
mvt = "droite_"


### Problem to solve
# vecteurs positions
px, py, pz, pu1, pu2, pu3, pv1, pv2, pv3, pw1, pw2, pw3 = sy.symbols('px py pz pu1 pu2 pu3 pv1 pv2 pv3 pw1 pw2 pw3')
# angles bras
t11, t12, t13, t21, t22, t23, t31, t32, t33 = sy.symbols('t11 t12 t13 t21 t22 t23 t31 t32 t33')
# longueurs
a, b, c, d, e, f, g, r, s = sy.symbols('a b c d e f g r s')
# angles 3 bras
phii, phi1, phi2, phi3 = sy.symbols('phii phi1 phi2 phi3')



def evaluateR(phii) :
    return sy.Matrix([[sy.cos(phii), sy.sin(phii), 0],[-sy.sin(phii), sy.cos(phii), 0],[0,0,1]])

def evaluatePi(phii, px, py, pz, r, s) :
    R = evaluateR(phii)
    pi = R*sy.Matrix([[px],[py],[pz]])+sy.Matrix([[-r],[s],[0]])
    return pi

#R = sy.Matrix([[sy.cos(phii), sy.sin(phii), 0],[-sy.sin(phii), sy.cos(phii), 0],[0,0,1]])


equ1 = pu1 - (a*sy.cos(t11) - c + sy.cos(t12)*(e + d - b*sy.sin(t13)))
eqv1 = pv1 - (b*sy.cos(t13) + f)
eqw1 = pw1 - (-a*sy.sin(t11) - sy.sin(t12)*(e + d - b*sy.sin(t13)))


a_num, b_num, c_num, d_num, e_num, f_num, g_num, r_num, s_num = 60, 102.5, 15.7, 11.5, 11.5, 26.2, 27.9, 36.6, 27.2
offset_num = 14.44/360*2*np.pi
phi1_num, phi2_num, phi3_num = offset_num + np.pi/2, offset_num + np.pi/2 + 2*np.pi/3, offset_num + np.pi/2 + 4*np.pi/3
tabPhi = [phi1_num, phi2_num, phi3_num]


# Substitute parameters into the equations
param = {
    "a": a_num, "b": b_num, "c": c_num, "d": d_num, "e": e_num, "f": f_num,
    "g": g_num, "r": r_num, "s": s_num, "phi1": phi1_num, "phi2": phi2_num, "phi3": phi3_num
}


f11_sub = equ1.subs(param)
f12_sub = eqv1.subs(param)
f13_sub = eqw1.subs(param)

# Create a list of equations
equations = [f11_sub, f12_sub, f13_sub]

# Calculate the Jacobian matrix
jacobian_matrix = sy.Matrix(equations).jacobian([t11, t12, t13])


# Convert sympy equations to numerical functions
f11_num = sy.lambdify((t11, t12, t13, pu1, pv1, pw1), f11_sub, 'numpy')
f12_num = sy.lambdify((t11, t12, t13, pu1, pv1, pw1), f12_sub, 'numpy')
f13_num = sy.lambdify((t11, t12, t13, pu1, pv1, pw1), f13_sub, 'numpy')

# Convert sympy Jacobian to numerical functions
jacobian_num = sy.lambdify((t11, t12, t13, pu1, pv1, pw1), jacobian_matrix, 'numpy')


# Define the function to solve
def func_to_solve(X, pu1, pv1, pw1):
    t11, t12, t13 = X[0], X[1], X[2]
    return [f11_num(t11, t12, t13, pu1, pv1, pw1), f12_num(t11, t12, t13, pu1, pv1, pw1), f13_num(t11, t12, t13, pu1, pv1, pw1)]

# Define the Jacobian function
def jacobian(X, pu1, pv1, pw1):
    t11, t12, t13 = X[0], X[1], X[2]
    return jacobian_num(t11, t12, t13, pu1, pv1, pw1)



## resolution

nbPoints = 18
Lt = np.zeros([3,3,nbPoints])

px_num, py_num, pz_num = 20, 5, 140

Lpx = np.linspace(0.9*px_num, 1.1*px_num, nbPoints)
Lpy = np.linspace(0.9*py_num, 1.1*py_num, nbPoints)
Lpz = np.linspace(70, 180, nbPoints)


t11_init, t12_init, t13_init = 20/360*2*np.pi, -100/360*2*np.pi, -100/360*2*np.pi
initial_guess = [t11_init, t12_init, t13_init]

for i in range(0,nbPoints) :
    for j in  range(3) :
        phi = tabPhi[j]
        print(j,i)
        p1_num = evaluatePi(phi, Lpx[i],Lpy[i],Lpz[i], r_num, s_num)
        pu1_num, pv1_num, pw1_num = eval(str(p1_num[0])), eval(str(p1_num[1])), eval(str(p1_num[2]))

        solution = optimize.root(func_to_solve, initial_guess, args=(pu1_num, pv1_num, pw1_num), jac=jacobian, method='hybr')
        Lt[j,:,i] = solution.x
        initial_guess = [t11_init, t12_init, t13_init]
    initial_guess = solution.x

    # all unknowns are computed
    if boolASY :
        f1 = open(chemin + 'falconHaptic_3d_droite.asy')
        toutesLesLignes = f1.readlines()
        f1.close()
        nom =  shortName + mvt + str(i) + '.asy'
        fid = open(nom,'w')
        for ligne in toutesLesLignes :
            if 'real theta11 = ' in ligne :
                aEcrire = 'real theta11 = '+ str(Lt[0,0,i])
                fid.write(aEcrire + ' ; \n')
            elif 'real theta12 = ' in ligne :
                aEcrire = 'real theta12 = '+ str(Lt[0,1,i])
                fid.write(aEcrire + ' ; \n')
            elif 'real theta13 = ' in ligne :
                aEcrire = 'real theta13 = '+ str(Lt[0,2,i])
                fid.write(aEcrire + ' ; \n')
            elif 'real theta21 = ' in ligne :
                aEcrire = 'real theta21 = '+ str(Lt[1,0,i])
                fid.write(aEcrire + ' ; \n')
            elif 'real theta22 = ' in ligne :
                aEcrire = 'real theta22 = '+ str(Lt[1,1,i])
                fid.write(aEcrire + ' ; \n')
            elif 'real theta23 = ' in ligne :
                aEcrire = 'real theta23 = '+ str(Lt[1,2,i])
                fid.write(aEcrire + ' ; \n')
            elif 'real theta31 = ' in ligne :
                aEcrire = 'real theta31 = '+ str(Lt[2,0,i])
                fid.write(aEcrire + ' ; \n')
            elif 'real theta32 = ' in ligne :
                aEcrire = 'real theta32 = '+ str(Lt[2,1,i])
                fid.write(aEcrire + ' ; \n')
            elif 'real theta33 = ' in ligne :
                aEcrire = 'real theta33 = '+ str(Lt[2,2,i])
                fid.write(aEcrire + ' ; \n')
            else :
                fid.write(ligne)
        fid.close()
        commande = ' "C:/Program Files/Asymptote/asy.exe" -render -2 -f pdf -noView -compact -o '+ shortName + mvt + str(i) + ' '  + nom
        os.system(commande)

        commande = ' "C:/Program Files/Asymptote/asy.exe" -render 4 -f png -compact -noView -o '+ shortName + mvt + str(i) + ' '  + nom
        os.system(commande)
        print("OK figure " + str(i))

        commande = 'del '+ nom
        os.system(commande)
        print("OK suppression " + str(i))


## fusion pdf
if boolASY :
    #merge pdfs
    from pypdf import PdfWriter
    merger = PdfWriter()
    for i in range(nbPoints) :
        pdf =  shortName + mvt + str(i) + '.pdf'
        merger.append(pdf)

    merger.write(shortName + mvt + 'all.pdf')
    merger.close()

### GIF creation
#Create GIF

if boolASY :
    from PIL import Image
    import os

    # List of image filenames
    image_filenames = []
    for i in range(nbPoints):
        image_filenames.append(shortName+mvt+str(i)+'.png')

    # Load images
    images = [Image.open(filename) for filename in image_filenames]

    # Save as a GIF
    output_filename = 'falconHaptic_droite_gif.gif'
    images[0].save(output_filename, save_all=True, append_images=images[1:], duration=110, loop=0)

    print(f'GIF saved as {output_filename}')




## Affichage

if not boolASY :
    plt.figure()
    plt.plot(Lpz, (Lt[0,0,:]/(2*np.pi)*360), 'b+-', label='Lt11')
    plt.plot(Lpz, (Lt[0,1,:]/(2*np.pi)*360), 'r+-', label='Lt12')
    plt.plot(Lpz, (Lt[0,2,:]/(2*np.pi)*360), 'g+-', label='Lt13')
    plt.legend()
    plt.grid(True)
    plt.grid('on')
    plt.show()
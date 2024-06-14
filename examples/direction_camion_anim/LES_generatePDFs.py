# AM

### imports
import sympy as s
import sympy.physics.vector as v
from IPython import display
import os

### param
boolASY = True
shortName = 'directionCamion_'
chemin = ""

### Resolution sympy

# les différentes bases
b0 = v.ReferenceFrame('b0')
b01 = v.ReferenceFrame('b01')
b1 = v.ReferenceFrame('b1')

b5 = v.ReferenceFrame('b5')
b51 = v.ReferenceFrame('b51')
b511 = v.ReferenceFrame('b511')

b3 = v.ReferenceFrame('b3')
b31 = v.ReferenceFrame('b31')
b311 = v.ReferenceFrame('b311')

b6 = v.ReferenceFrame('b6')
b61 = v.ReferenceFrame('b61')

epsilon, delta, tau, psi, betag, gamma31, gamma311, betad = s.symbols('epsilon delta tau psi betag gamma31 gamma311 betad')

b01.orient(b0, 'Axis', [epsilon, b0.y])
b1.orient(b0, 'Axis', [delta, b0.y])

b5.orient(b01, 'Axis', [tau, b01.x])
b51.orient(b5, 'Axis', [psi, b5.x])
b511.orient(b5, 'Axis', [-psi, b5.x])

b3.orient(b51, 'Axis', [betag, b51.z])
b31.orient(b3, 'Axis', [gamma31, b3.z])
b311.orient(b3, 'Axis', [gamma311, b3.z])

b6.orient(b511, 'Axis', [betad, b511.z])
b61.orient(b6, 'Axis', [-gamma31, b6.z])


l1, l2, l4, bz, bx, bx1, e, f, g, l5 = s.symbols('l1 l2 l4 bz bx bx1 e f g l5')

ML = l1*b1.z
BG = bz*b3.z + bx*b311.x
BD = -bz*b3.z + bx1*b31.x
HL = e*b0.x + f*b0.y + g*b0.z
AE = -bz*b6.z + bx1*b61.x
AH = l5*b5.y
HB = l5*b5.y

pFerm1 = ML - HL + HB + BG
ferm1 = v.dot(pFerm1,pFerm1) - l2**2

pFerm2 = -BD - HB - AH + AE
ferm2 = v.dot(pFerm2,pFerm2) - l4**2


from scipy import optimize
import matplotlib.pyplot as plt
import numpy as np


l5 = 800
bx1 =  350
gamma31 = -166.5/360*2*np.pi
psi = 7/360*2*np.pi

l4 = 2*l5 + 2*bx1*np.sin(gamma31) # gamm31 negatif
bx = 250
f = l5 - bx
bz = 220
l1 = 340
g = bz + l1
l2 = 800
e = l2
print(l4,f, g)

# Substitute parameters into the equations
param = {"epsilon":-5/360*2*np.pi, "psi":psi, "gamma31": gamma31, "gamma311":-90/360*2*np.pi, "l1":l1, "l2":l2, "l4":l4, "bz":bz, "bx":bx, "bx1":bx1, "e":e, "f":f, "g":g, "l5":l5}

f1_sub = ferm1.subs(param)
f2_sub = ferm2.subs(param)

# Create a list of equations
equations = [f1_sub, f2_sub]

# Calculate the Jacobian matrix
jacobian_matrix = s.Matrix(equations).jacobian([betag, betad])

# Convert sympy equations to numerical functions
f1_num = s.lambdify((betag, betad, delta, tau), f1_sub, 'numpy')
f2_num = s.lambdify((betag, betad, delta, tau), f2_sub, 'numpy')

# Convert sympy Jacobian to numerical functions
jacobian_num = s.lambdify((betag, betad, delta, tau), jacobian_matrix, 'numpy')


# Define the function to solve
def func_to_solve(X, delta, tau):
    betag, betad = X[0], X[1]
    return [f1_num(betag, betad, delta, tau), f2_num(betag, betad, delta, tau)]

# Define the Jacobian function
def jacobian(X, delta, tau):
    betag, betad = X[0], X[1]
    return jacobian_num(betag, betad, delta, tau)

initial_guess = [0,0]




###### Mobilté 1

nbPoints = 11
Lbetag = np.zeros([nbPoints])
Lbetad = np.zeros([nbPoints])

Ldelta = np.linspace(-25/360*2*np.pi,25/360*2*np.pi,nbPoints)
Ltau = 0/360*2*np.pi*np.ones([nbPoints])

for i in range(0,nbPoints):
    print(i)
    solution = optimize.root(func_to_solve, initial_guess, args=(Ldelta[i],Ltau[i]), jac=jacobian, method='hybr')
    Lbetag[i], Lbetad[i] = solution.x

    if boolASY :
        f1 = open(chemin + 'directionCamion_iso.asy')
        toutesLesLignes = f1.readlines()
        f1.close()
        nom =  shortName + 'm1_' + str(i) + '.asy'
        fid = open(nom,'w')
        for ligne in toutesLesLignes :
            if 'real delta = 0*20/360*2*pi ; // m1' in ligne :
                aEcrire = 'real delta = '+ str(Ldelta[i])
                fid.write(aEcrire + ' ; \n')
            elif 'real tau = 0*10/360*2*pi ; // m2' in ligne :
                aEcrire = 'real tau = '+ str(Ltau[i])
                fid.write(aEcrire + ' ; \n')
            elif 'real betag = 0/360*2*pi ; // A calculer' in ligne :
                aEcrire = 'real betag = '+ str(Lbetag[i])
                fid.write(aEcrire + ' ; \n')
            elif 'real betad = 0/360*2*pi ; // A calculer' in ligne :
                aEcrire = 'real betad = '+ str(Lbetad[i])
                fid.write(aEcrire + ' ; \n')
            else :
                fid.write(ligne)
        fid.close()
        commande = ' "C:/Program Files/Asymptote/asy.exe" -f pdf -noView -compact -o '+ shortName + 'm1_' + str(i) + ' '  + nom
        os.system(commande)
        print("OK figure " + str(i))

        commande = 'del '+ nom
        os.system(commande)
        print("OK suppression " + str(i))

if boolASY :
    #merge pdfs
    from pypdf import PdfWriter
    merger = PdfWriter()
    for i in range(len(Ldelta)) :
        pdf =  shortName + 'm1_' + str(i) + '.pdf'
        merger.append(pdf)

    merger.write(shortName + 'm1_all.pdf')
    merger.close()

if not boolASY :
    plt.figure()
    plt.plot(Ldelta/(2*np.pi)*360, Lbetag/(2*np.pi)*360, 'b+-', label='betag')
    plt.plot(Ldelta/(2*np.pi)*360, Lbetad/(2*np.pi)*360, 'r+-', label='betad')
    plt.legend()
    plt.grid(True)
    plt.grid('on')
    plt.show()

###### Mobilté 2

nbPoints = 11
Lbetag = np.zeros([nbPoints])
Lbetad = np.zeros([nbPoints])

Ldelta = np.zeros([nbPoints])
Ltau = np.linspace(-10/360*2*np.pi,10/360*2*np.pi,nbPoints)

for i in range(0,nbPoints):
    print(i)
    solution = optimize.root(func_to_solve, initial_guess, args=(Ldelta[i],Ltau[i]), jac=jacobian, method='hybr')
    Lbetag[i], Lbetad[i] = solution.x

    if boolASY :
        f1 = open(chemin + 'directionCamion_iso.asy')
        toutesLesLignes = f1.readlines()
        f1.close()
        nom =  shortName + 'm2_' + str(i) + '.asy'
        fid = open(nom,'w')
        for ligne in toutesLesLignes :
            if 'real delta = 0*20/360*2*pi ; // m1' in ligne :
                aEcrire = 'real delta = '+ str(Ldelta[i])
                fid.write(aEcrire + ' ; \n')
            elif 'real tau = 0*10/360*2*pi ; // m2' in ligne :
                aEcrire = 'real tau = '+ str(Ltau[i])
                fid.write(aEcrire + ' ; \n')
            elif 'real betag = 0/360*2*pi ; // A calculer' in ligne :
                aEcrire = 'real betag = '+ str(Lbetag[i])
                fid.write(aEcrire + ' ; \n')
            elif 'real betad = 0/360*2*pi ; // A calculer' in ligne :
                aEcrire = 'real betad = '+ str(Lbetad[i])
                fid.write(aEcrire + ' ; \n')
            else :
                fid.write(ligne)
        fid.close()
        commande = ' "C:/Program Files/Asymptote/asy.exe" -f pdf -noView -compact -o '+ shortName + 'm2_' + str(i) + ' '  + nom
        os.system(commande)
        print("OK figure " + str(i))

        commande = 'del '+ nom
        os.system(commande)
        print("OK suppression " + str(i))

if boolASY :
    #merge pdfs
    from pypdf import PdfWriter
    merger = PdfWriter()
    for i in range(len(Ldelta)) :
        pdf =  shortName + 'm2_' + str(i) + '.pdf'
        merger.append(pdf)

    merger.write(shortName + 'm2_all.pdf')
    merger.close()

if not boolASY :
    plt.figure()
    plt.plot(Ltau/(2*np.pi)*360, Lbetag/(2*np.pi)*360, 'b+-', label='betag')
    plt.plot(Ltau/(2*np.pi)*360, Lbetad/(2*np.pi)*360, 'r+-', label='betad')
    plt.legend()
    plt.grid(True)
    plt.grid('on')
    plt.show()


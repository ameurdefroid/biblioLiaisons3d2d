# AM
import numpy as np
import os

# os.chdir(r"path/to/your/folder/depending/on/your/pov")


nbPoints = 64
Ltheta = np.arange(0,2*np.pi,2*np.pi/nbPoints)
shortName = 'croixMalte_xy_anim_'


for i in range(len(Ltheta)) :
    chemin = "" # same as before
    f1 = open(chemin + shortName + 'python.asy')
    toutesLesLignes = f1.readlines()
    f1.close()

    nom = shortName + str(i) + '.asy'
    fid = open(nom,'w')
    for ligne in toutesLesLignes :
        if 'real theta1 = 0 ;' in ligne :
            aEcrire = 'real theta1 = ' + str(Ltheta[i]) 
            fid.write(aEcrire + ' ;\n')
        else :
            fid.write(ligne)


    fid.close()
    commande = ' "C:/Program Files/Asymptote/asy.exe" -f png -compact -render 4 -noView -o '+ shortName + str(i) + ' '  + nom
    os.system(commande)
    print("OK figure " + str(i))

    commande = 'del '+ nom
    os.system(commande)
    print("OK suppression " + str(i))

### GIF creation
#Create GIF
from PIL import Image
import os

# List of image filenames
image_filenames = []
for i in range(nbPoints):
    image_filenames.append(shortName+str(i)+'.png')

# Load images
images = [Image.open(filename) for filename in image_filenames]

# Save as a GIF
output_filename = 'croixMalte_xy_gif.gif'
images[0].save(output_filename, save_all=True, append_images=images[1:], duration=110, loop=0)

print(f'GIF saved as {output_filename}')

# Delete the PNG files
# for filename in image_filenames:
#     os.remove(filename)
#     print(f'Deleted {filename}')




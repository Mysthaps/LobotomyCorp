import os
from PIL import Image

for root, dirs, files in os.walk("assets/1x/", topdown=False):
    for name in files:
        filename_original = os.path.join(root, name)
        filename_upscale = os.path.join("assets/2x/", name)
        
        image = Image.open(filename_original)
        width, height = image.size
        image = image.resize((width*2,height*2), Image.NEAREST)
        image.save(filename_upscale)
        
        print("upscaled " + filename_upscale)
        
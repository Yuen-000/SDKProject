#!/bin/sh
mkdir -p tex_astc/ 
rm -f tex_astc/*.pvr
PVRTexToolCLI -i "tex_sample/Texture000.png" -o tex_astc/Texture000.pvr -m 16 -f ASTC_4x4,UBN,sRGB
PVRTexToolCLI -i "tex_sample/Texture001.png" -o tex_astc/Texture001.pvr -m 16 -f ASTC_4x4,UBN,sRGB
PVRTexToolCLI -i "tex_sample/Texture002.png" -o tex_astc/Texture002.pvr -m 16 -f ASTC_4x4,UBN,sRGB
PVRTexToolCLI -i "tex_sample/Texture003.png" -o tex_astc/Texture003.pvr -m 16 -f ASTC_4x4,UBN,sRGB
PVRTexToolCLI -i "tex_sample/Texture004.png" -o tex_astc/Texture004.pvr -m 16 -f ASTC_4x4,UBN,sRGB
echo skip tex_sample/Texture005.png
PVRTexToolCLI -i "tex_sample/Texture006.png" -o tex_astc/Texture006.pvr -m 16 -f ASTC_4x4,UBN,sRGB
PVRTexToolCLI -i "tex_sample/Texture007.png" -o tex_astc/Texture007.pvr -m 16 -f ASTC_4x4,UBN,sRGB

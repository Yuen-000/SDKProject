#!/bin/sh
mkdir -p tex_astc/ 
rm -f tex_astc/*.pvr
PVRTexToolCLI -i "tex_sample/000_Atlas_1.png" -o tex_astc/000.pvr -m 16 -f ASTC_4x4,UBN,sRGB
PVRTexToolCLI -i "tex_sample/001_Atlas_1_Normal.png" -o tex_astc/001.pvr -m 16 -f ASTC_4x4,UBN,sRGB
PVRTexToolCLI -i "tex_sample/002_Atlas_2.png" -o tex_astc/002.pvr -m 16 -f ASTC_4x4,UBN,sRGB
PVRTexToolCLI -i "tex_sample/003_Atlas_2_Normal.png" -o tex_astc/003.pvr -m 16 -f ASTC_4x4,UBN,sRGB
PVRTexToolCLI -i "tex_sample/004_Atlas_Alpha.png" -o tex_astc/004.pvr -m 16 -f ASTC_4x4,UBN,sRGB
PVRTexToolCLI -i "tex_sample/005_Atlas_Alpha_Normal.png" -o tex_astc/005.pvr -m 16 -f ASTC_4x4,UBN,sRGB
PVRTexToolCLI -i "tex_sample/006_Atlas_Alpha_Glow.png" -o tex_astc/006.pvr -m 16 -f ASTC_4x4,UBN,sRGB

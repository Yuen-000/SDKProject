#!/bin/sh
mkdir -p tex_astc/ 
rm -f tex_astc/*.pvr
PVRTexToolCLI -i "tex_sample/Texture000.png" -o tex_astc/Texture000.pvr -m 16 -f ASTC_4x4,UBN,sRGB

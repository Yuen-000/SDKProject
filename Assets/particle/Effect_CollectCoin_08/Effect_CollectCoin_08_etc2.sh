#!/bin/sh
mkdir -p tex_etc/ 
rm -f tex_etc/*.pvr
PVRTexToolCLI -i "tex_sample/Texture000.png" -o tex_etc/Texture000.pvr -m 16 -f ETC2_RGBA,UBN,sRGB

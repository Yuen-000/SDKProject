#!/bin/sh
mkdir -p tex_etc/ 
rm -f tex_etc/*.pvr
PVRTexToolCLI -i "tex_sample/000_000_CosmicCoolCloudFront.png" -o tex_etc/000.pvr -m 16 -f ETC2_RGB,UBN,sRGB

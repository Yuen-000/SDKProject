#!/bin/sh
mkdir -p tex_etc/ 
rm -f tex_etc/*.pvr
PVRTexToolCLI -i "tex_sample/000_CosmicCoolCloudFront.png" -o tex_etc/000.pvr -m 16 -f ETC2_RGB,UBN,sRGB
PVRTexToolCLI -i "tex_sample/001_T_colorpallet_building_a.png" -o tex_etc/001.pvr -m 16 -f ETC2_RGB,UBN,sRGB
PVRTexToolCLI -i "tex_sample/002_T_banner_grifith.png" -o tex_etc/002.pvr -m 16 -f ETC2_RGB,UBN,sRGB
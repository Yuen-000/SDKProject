#!/bin/sh
mkdir -p tex_astc/ 
rm -f tex_astc/*.pvr
PVRTexToolCLI -i "tex_sample/000_CosmicCoolCloudFront.png" -o tex_astc/000.pvr -m 16 -f ASTC_4x4,UBN,sRGB
PVRTexToolCLI -i "tex_sample/001_T_colorpallet_building_a.png" -o tex_astc/001.pvr -m 16 -f ASTC_4x4,UBN,sRGB
PVRTexToolCLI -i "tex_sample/002_T_banner_grifith.png" -o tex_astc/002.pvr -m 16 -f ASTC_4x4,UBN,sRGB

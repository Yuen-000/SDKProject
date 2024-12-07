md tex_astc\ 
del tex_astc\*.pvr
PVRTexToolCLI.exe -i "tex_sample\Texture000.png" -o tex_astc\Texture000.pvr -m 16 -f ASTC_4x4,UBN,sRGB
PVRTexToolCLI.exe -i "tex_sample\Texture001.png" -o tex_astc\Texture001.pvr -m 16 -f ASTC_4x4,UBN,sRGB
PVRTexToolCLI.exe -i "tex_sample\Texture002.png" -o tex_astc\Texture002.pvr -m 16 -f ASTC_4x4,UBN,sRGB
pause

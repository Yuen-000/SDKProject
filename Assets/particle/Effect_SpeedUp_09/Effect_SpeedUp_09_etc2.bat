md tex_etc\ 
del tex_etc\*.pvr
PVRTexToolCLI.exe -i "tex_sample\Texture000.png" -o tex_etc\Texture000.pvr -m 16 -f ETC2_RGBA,UBN,sRGB
PVRTexToolCLI.exe -i "tex_sample\Texture001.png" -o tex_etc\Texture001.pvr -m 16 -f ETC2_RGBA,UBN,sRGB
PVRTexToolCLI.exe -i "tex_sample\Texture002.png" -o tex_etc\Texture002.pvr -m 16 -f ETC2_RGBA,UBN,sRGB
pause
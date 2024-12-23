md tex_etc\ 
del tex_etc\*.pvr
PVRTexToolCLI.exe -i "tex_sample\Texture000.png" -o tex_etc\Texture000.pvr -m 16 -f ETC2_RGBA,UBN,sRGB
PVRTexToolCLI.exe -i "tex_sample\Texture001.png" -o tex_etc\Texture001.pvr -m 16 -f ETC2_RGBA,UBN,sRGB
PVRTexToolCLI.exe -i "tex_sample\Texture002.png" -o tex_etc\Texture002.pvr -m 16 -f ETC2_RGBA,UBN,sRGB
PVRTexToolCLI.exe -i "tex_sample\Texture003.png" -o tex_etc\Texture003.pvr -m 16 -f ETC2_RGBA,UBN,sRGB
PVRTexToolCLI.exe -i "tex_sample\Texture004.png" -o tex_etc\Texture004.pvr -m 16 -f ETC2_RGBA,UBN,sRGB
echo skip tex_sample\Texture005.png
PVRTexToolCLI.exe -i "tex_sample\Texture006.png" -o tex_etc\Texture006.pvr -m 16 -f ETC2_RGBA,UBN,sRGB
PVRTexToolCLI.exe -i "tex_sample\Texture007.png" -o tex_etc\Texture007.pvr -m 16 -f ETC2_RGBA,UBN,sRGB
pause

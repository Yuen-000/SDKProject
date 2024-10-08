md tex_etc\ 
del tex_etc\*.pvr
PVRTexToolCLI.exe -i "tex_sample\000_Atlas_1.png" -o tex_etc\000.pvr -m 16 -f ETC2_RGBA,UBN,sRGB
PVRTexToolCLI.exe -i "tex_sample\001_Atlas_1_Normal.png" -o tex_etc\001.pvr -m 16 -f ETC2_RGBA,UBN,sRGB
PVRTexToolCLI.exe -i "tex_sample\002_Atlas_2.png" -o tex_etc\002.pvr -m 16 -f ETC2_RGBA,UBN,sRGB
PVRTexToolCLI.exe -i "tex_sample\003_Atlas_2_Normal.png" -o tex_etc\003.pvr -m 16 -f ETC2_RGBA,UBN,sRGB
PVRTexToolCLI.exe -i "tex_sample\004_Atlas_Alpha.png" -o tex_etc\004.pvr -m 16 -f ETC2_RGBA,UBN,sRGB
PVRTexToolCLI.exe -i "tex_sample\005_Atlas_Alpha_Normal.png" -o tex_etc\005.pvr -m 16 -f ETC2_RGBA,UBN,sRGB
PVRTexToolCLI.exe -i "tex_sample\006_Atlas_Alpha_Glow.png" -o tex_etc\006.pvr -m 16 -f ETC2_RGBA,UBN,sRGB
pause

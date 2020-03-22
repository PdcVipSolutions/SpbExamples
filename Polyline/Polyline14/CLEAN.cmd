if exist dd.bat del dd.bat
dir /s/b vip7*.dll >>dd.bat
dir /s/b *.obj >>dd.bat
dir /s/b *.exe >>dd.bat
dir /s/b *.pzl >>dd.bat
dir /s/b *.pzr >>dd.bat

dir /s/b *.sym >>dd.bat
dir /s/b *.scc >>dd.bat
dir /s/b *.map >>dd.bat
dir /s/b *.bro >>dd.bat
dir /s/b *.rlt >>dd.bat
dir /s/b *.rc >>dd.bat
dir /s/b *.deb >>dd.bat
dir /s/b *.vrf >>dd.bat
dir /s/b *.scope >>dd.bat
dir /s/b *.scopeinfo >>dd.bat
dir /s/b *.tmp >>dd.bat
dir /s/b $*.* >>dd.bat
dir /s/b @*.* >>dd.bat
dir /s/b capdos.inp >>dd.bat
dir /s/b capdos.out >>dd.bat
dir /s/b dd.* >>dd.bat
..\..\..\cmd\delfiles.exe dd.bat
del dd.bat
pause

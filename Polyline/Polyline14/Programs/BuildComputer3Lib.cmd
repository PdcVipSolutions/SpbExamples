chcp 1251
echo off
set LIBMAKER= ..\..\..\..\SpbVipTools\3P_tools\MStools\lib.exe

if not exist %LIBMAKER%  goto :NOLIB

set Obj=.\MonoApplicaion\Obj\

set Lib_COMP3=..\Logic\Packs\Players\Computer3\$LibVersion\

%LIBMAKER% /OUT:%Lib_COMP3%Computer3.lib ^
	%Obj%Computer3*.obj > nul
if errorlevel 0 (echo ok Computer3.lib) else echo NOT built Computer3.lib

goto :eof

:NOLIB 
echo NOT built Computer3 Library. The Microsoft Library Maker "%LIBMAKER%" not found.
if exist "%Lib_COMP3%Computer3.lib"  echo default version Computer3.lib in use!

pause

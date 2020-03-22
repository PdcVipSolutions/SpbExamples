echo off
set LIBMAKER= ..\..\..\..\SpbVipTools\3P_tools\MStools\lib.exe

if not exist %LIBMAKER%  goto :NOLIB

set Obj=.\MonoApplicaion\Obj\

set Lib=..\HumanInterface\$LibVersion\

%LIBMAKER% /OUT:%Lib%HumanInterface.lib ^
	%Obj%HumanInterface*.obj ^
	%Obj%GameView*.obj ^
	%Obj%GameBoard*.obj ^
	%Obj%GameSettings*.obj ^
	%Obj%PlayerProperties_UI*.obj ^
	%Obj%PolyLineTextEn*.obj ^
	%Obj%PolylineTextRu*.obj > nul
if errorlevel 0 (echo ok HumanInterface.lib) else echo NOT built HumanInterface.lib

goto :eof

:NOLIB 
echo NOT built HumanInterface.lib Library. The Microsoft Library Maker %LIBMAKER% not found. 
if exist "%Lib%HumanInterface.lib"  echo default version HumanInterface.lib in use!

pause

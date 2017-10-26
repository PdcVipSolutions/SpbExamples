rem chcp 1251
echo off
set LIBMAKER= ..\..\..\..\SpbVipTools\3P_tools\MStools\lib.exe

if not exist %LIBMAKER%  goto :NOLIB

set Obj_WIN=.\ObjectWin0\Obj\

set Lib_Win=..\HumanInterface\ObjectWin\$LibVersion\
rem chcp 866

%LIBMAKER% /OUT:%Lib_Win%HumanInterfaceWin.lib ^
	%Obj_WIN%HumanInterface.*.obj ^
	%Obj_WIN%GameView.*.obj ^
	%Obj_WIN%GameBoard.*.obj ^
	%Obj_WIN%GameSettings.*.obj ^
	%Obj_WIN%PlayerProperties_UI.*.obj ^
	%Obj_WIN%PolyLineTextEn.*.obj ^
 	%Obj_WIN%PolyLineTextRu.*.obj
 	%Obj_WIN%PolyLineTextRu.*.obj > nul
if errorlevel 0 (echo ok HumanInterfaceWin.lib) else NOT built HumanInterfaceWin.lib
pause

goto :eof

:NOLIB 
echo NOT built HumanInterface Libraries. The Microsoft Library Maker "%LIBMAKER%" not found. 
if exist %Lib_Win%HumanInterfaceWin.lib  echo default version HumanInterfaceWin.lib in use!
pause





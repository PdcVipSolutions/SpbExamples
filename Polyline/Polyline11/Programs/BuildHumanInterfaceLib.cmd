chcp 1251
echo off
set LIBMAKER= ..\..\..\..\SpbVipTools\3P_tools\MStools\lib.exe

set Obj_CON=.\Console\Obj\
set Obj_OC=.\ObjectConsole\Obj\
set Obj_WIN=.\ObjectWin\Obj\

set Lib_CON=..\HumanInterface\Console\$LibVersion\
set Lib_OC=..\HumanInterface\ObjectConsole\$LibVersion\
set Lib_Win=..\HumanInterface\ObjectWin\$LibVersion\

if not exist %LIBMAKER%  goto :NOLIB

%LIBMAKER% /OUT:%Lib_CON%HumanInterfaceConsole.lib ^
	%Obj_CON%HumanInterface.*.obj ^
	%Obj_CON%PolyLineTextEn.*.obj  ^
	%Obj_CON%PolylineTextRu.*.obj > nul
if errorlevel 0 (echo ok HumanInterfaceConsole.lib) else NOT built HumanInterfaceConsole.lib

%LIBMAKER% /OUT:%Lib_OC%HumanInterfaceObjConsole.lib  ^
	%Obj_OC%HumanInterface.*.obj ^
	%Obj_OC%GameBoard.*.obj ^
	%Obj_OC%GameSettings.*.obj ^
	%Obj_OC%GameView.*.obj ^
	%Obj_OC%GameViewLocalization.*.obj ^
	%Obj_OC%GetColor.*.obj ^
	%Obj_OC%ConsoleControl.*.obj ^
	%Obj_OC%ConsoleControlContainer.*.obj ^
	%Obj_OC%ConsoleEventSource.*.obj ^
	%Obj_OC%ConsoleButtonControl.*.obj ^
	%Obj_OC%ConsoleCheckBoxControl.*.obj ^
	%Obj_OC%ConsoleEditControl.*.obj ^
	%Obj_OC%ConsoleListViewControl.*.obj ^
	%Obj_OC%ConsoleTextControl.*.obj ^
	%Obj_OC%ConsoleWaitControl.*.obj ^
	%Obj_OC%PlayerProperties.*.obj ^
	%Obj_OC%PolyLineTextEn.*.obj ^
	%Obj_OC%PolylineTextRu.*.obj ^
 	%Obj_OC%StatisticsView.*.obj > nul

if errorlevel 0 (echo ok HumanInterfaceObjConsole.lib) else NOT built HumanInterfaceObjConsole.lib

%LIBMAKER% /OUT:%Lib_Win%HumanInterfaceWin.lib ^
	%Obj_WIN%HumanInterface.*.obj ^
	%Obj_WIN%GameView.*.obj ^
	%Obj_WIN%GameBoard.*.obj ^
	%Obj_WIN%GameSettings.*.obj ^
	%Obj_WIN%PlayerProperties_UI.*.obj ^
	%Obj_WIN%PolyLineTextEn.*.obj ^
 	%Obj_WIN%PolylineTextRu.*.obj > nul
if errorlevel 0 (echo ok HumanInterfaceWin.lib) else NOT built HumanInterfaceWin.lib

goto :ending

:NOLIB 
echo NOT built HumanInterface Libraries. The Microsoft Library Maker "%LIBMAKER%" not found.  
if exist %Lib_CON%HumanInterfaceConsole.lib echo default version HumanInterfaceConsole.lib in use!
if exist %Lib_OC%HumanInterfaceObjConsole.lib  echo default version HumanInterfaceObjConsole.lib in use!
if exist %Lib_Win%HumanInterfaceWin.lib  echo default version HumanInterfaceWin.lib in use!

:ending
if not defined LIBMAKER echo "LIBMaker" not defined 
pause


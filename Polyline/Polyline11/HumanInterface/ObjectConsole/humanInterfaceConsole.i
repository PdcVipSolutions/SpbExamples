/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
interface humanInterfaceConsole
    supports humanInterface
    open core

constants
    boardPosition_C="boardPosition".

properties
    statusLine_V:consoleTextControl.
    messageLine_V:consoleTextControl.

predicates
    announce:(polylineText::actionID_D AnnounceID,string AnnounceText).

end interface humanInterfaceConsole

/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
interface humanInterfaceConsole
    supports humanInterface
    open core

predicates
    announce:(polylineText::actionID_D AnnounceID,string AnnounceText).

end interface humanInterfaceConsole

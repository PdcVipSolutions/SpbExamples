/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/

interface gameSettings
    supports consoleControl
    supports consoleControlContainer

    open core
/*
predicates
    xSize:()->positive.
    ySize:()->positive.
*/
predicates
    showStarterName:().

predicates
    showStatus:(polylineDomains::gameStatus_D).

end interface gameSettings
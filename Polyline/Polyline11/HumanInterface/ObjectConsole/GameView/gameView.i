/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
interface gameView
    supports consoleControl
    supports consoleControlContainer

    open core

predicates
    showStatus:(polylineDomains::gameStatus_D).

predicates
    showProgress:().

end interface gameView
/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/

interface gameBoard
    supports consoleControl

    open core
predicates
    modifyLayout:().

predicates
    onMove:notificationAgency::notificationListener.

predicates
    showStatus:(polylineDomains::gameStatus_D).

end interface gameBoard
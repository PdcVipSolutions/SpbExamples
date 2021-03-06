/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/

interface gameView supports userControlSupport
    open core

properties
    drawVertPos_V:integer.

predicates
    xSize:()->positive.
    ySize:()->positive.

predicates
    showStatus:(polylineDomains::gameStatus_D).

end interface gameView
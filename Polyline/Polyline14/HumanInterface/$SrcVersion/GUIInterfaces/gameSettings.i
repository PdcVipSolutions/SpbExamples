/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
interface gameSettings supports userControlSupport
    open core

predicates
    xSize:()->positive.
    ySize:()->positive.

predicates
    showStarterName:().

predicates
    showStatus:(humanInterface::gameStatus_D).

end interface gameSettings
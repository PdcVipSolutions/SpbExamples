/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
interface genericComputer
    supports player
    supports polylineStrategy

    open core

properties
    game_V:game.

predicates
    setpolylineStrategy:(polylineStrategy).
    stepCandidate: (polyLineDomains::cell*,polyLineDomains::cell* [out],polyLineDomains::cell [out]) nondeterm.
    setDaughter:(player Daughter).

predicates
    isInterrupted:() determ.

end interface genericComputer

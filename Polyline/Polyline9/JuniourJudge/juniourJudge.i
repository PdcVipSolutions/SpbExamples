/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
interface juniourJudge
    open core

properties
    maxRow_P:positive.
    maxColumn_P:positive.
    polyline_P:polyLineDomains::cell*.
 
predicates
    defineStage:().
    neighbour_nd: (polyLineDomains::cell,polyLineDomains::cell) nondeterm (i,o) (i,i).
    neighbourOutOfPolyLine_nd:(polyLineDomains::cell,polyLineDomains::cell)->polyLineDomains::cell nondeterm.
    set: (string ).
    isGameOver:() determ.
    reset:().

end interface juniourJudge

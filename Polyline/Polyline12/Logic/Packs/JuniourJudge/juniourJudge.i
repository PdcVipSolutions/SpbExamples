/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
interface juniourJudge
    supports notificationAgency
    open core

properties
    maxRow_P:positive.
    maxColumn_P:positive.
    polyline_P:polyLineDomains::cell*.
 
predicates
    neighbour_nd: (polyLineDomains::cell,polyLineDomains::cell) nondeterm (i,o) (i,i).
    neighbourOutOfPolyLine_nd:(polyLineDomains::cell,polyLineDomains::cell)->polyLineDomains::cell nondeterm.

predicates
    onMoveDone:notificationAgency::notificationListener.
    makeInitialExternalMove:(polylineDomains::roundPhase_D).
    isGameOver:() determ.
    reset:().

end interface juniourJudge

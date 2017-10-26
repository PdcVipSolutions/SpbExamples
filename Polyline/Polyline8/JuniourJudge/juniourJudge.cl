/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
class juniourJudge
    open core

domains
    cell = c(positive,positive).
    stepType_D=
        ordinary_S;
        winner_S.

properties
    maxRow_P:positive.
    maxColumn_P:positive.
    polyline_P:cell*.

predicates
    defineStage:().
    neighbour_nd: (cell,cell) nondeterm (i,o) (i,i).
    neighbourOutOfPolyLine_nd:(cell,cell)->cell nondeterm.
    set: (string ).
    isGameOver:() determ.
    reset:().

end class juniourJudge
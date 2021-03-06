/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
interface genericComputer
    supports player
    supports polylineStrategy

    open core
 
predicates
    setpolylineStrategy:(polylineStrategy).
    stepCandidate: (juniourJudge::cell*,juniourJudge::cell* [out],juniourJudge::cell [out]) nondeterm.

end interface genericComputer

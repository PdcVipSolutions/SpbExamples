/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
interface polyLineStrategy
    open core

predicates
    setGenericComputer:(genericComputer).
    successfulStep: (juniourJudge::cell*)->juniourJudge::cell nondeterm.
    randomStep:()->juniourJudge::cell determ.

end interface polyLineStrategy
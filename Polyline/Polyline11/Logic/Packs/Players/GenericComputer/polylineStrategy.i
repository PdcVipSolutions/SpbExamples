/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
interface polyLineStrategy

open core

predicates
    setGenericComputer:(genericComputer).
    successfulStep: (polyLineDomains::cell*)->polyLineDomains::cell nondeterm.
    randomStep:()->polyLineDomains::cell determ.
    getStrategyAttribute:()->namedValue.
    setStrategyAttribute:(namedValue).

end interface polyLineStrategy
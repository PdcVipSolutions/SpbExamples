/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
interface game
    open core

properties
    seniourJudge_V:seniourJudge.
    juniourJudge_V:juniourJudge.
    humanInterface_V:humanInterface.
    competitors_V:competitors.
    gameStatistics_V:gameStatistics.

properties
    language_V:polyLineDomains::language_D.

predicates
    play:().

predicates
    complete:().
    
end interface game
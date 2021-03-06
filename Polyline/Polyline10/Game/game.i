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

properties
    language_V:polyLineDomains::language_D.
    players_V:player*.
    multiMode_V:boolean.

predicates
    play:().

predicates
    addPlayer:(player Player).

end interface game

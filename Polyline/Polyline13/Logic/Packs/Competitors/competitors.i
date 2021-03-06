/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
interface competitors
    open core

properties
    players_V:player*.

predicates
    getCandidates:()->namedValue* PlayersDescriptorList.

predicates
    createPlayerObject:(string StrindID)->player.

predicates
    isNameUnique:(player PlayerObject,string Name) determ.
    isNameUnique:(string Name) determ.

predicates
    isLegendUnique:(player PlayerObject,integer Legend) determ.
    isLegendUnique:(integer Legend) determ.

predicates
    addPlayer:(player Player).

predicates
    removePlayer:(positive PlayerIndex).

predicates
    shiftPlayer:(positive PlayerIndex,polyLineDomains::direction_D).

predicates
    stopPlayers:().

end interface competitors

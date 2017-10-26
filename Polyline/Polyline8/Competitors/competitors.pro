/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement competitors
    open core

clauses
    involvePlayers():-
        involvePlayers(1).

class predicates
    involvePlayers:(positive PlayerNo).
clauses
    involvePlayers(PlayerNo):-
        humanInterface::announceStartUp(),
        PlayerDescriptorList = [ PlayerDescriptor || playerDescriptor(No, PlayerDescriptorSrc),
        PlayerDescriptor = string::format("% - %\n", No, PlayerDescriptorSrc) ],
        PlayersDescriptor=string::concatList(PlayerDescriptorList),
        PlayerType=humanInterface::getInput(humanInterface::playerType_S,toString([PlayersDescriptor,toString(PlayerNo)])),
        not(PlayerType=""),
        try
            Player=createPlayerObject(toTerm(PlayerType)),
            Player:setName(toString(PlayerNo)),
            game::addPlayer(Player),
            NewPlayerNo=PlayerNo+1
        catch _TraceID do
            humanInterface::announce(humanInterface::errorPlayerType_S,""),
            NewPlayerNo=PlayerNo
        end try,
        !,
        involvePlayers(NewPlayerNo).
    involvePlayers(_PlayerNo).

class predicates
    playerDescriptor:(positive No [out],string PlayerDescriptorSrc [out]) multi.
clauses
    playerDescriptor(1,human::getPlayerDescriptor(game::language_V)).
    playerDescriptor(2,computer0::getPlayerDescriptor(game::language_V)).
    playerDescriptor(3,computer1::getPlayerDescriptor(game::language_V)).
    playerDescriptor(4,computer2::getPlayerDescriptor(game::language_V)).

class predicates
    createPlayerObject:(positive)->player.
clauses
    createPlayerObject(1)=Player:-
        !,
        Player=human::new().
    createPlayerObject(2)=Player:-
        !,
        Player=computer0::new().
    createPlayerObject(3)=Player:-
        !,
        Player=computer1::new().
    createPlayerObject(4)=Player:-
        !,
        Player=computer2::new().
    createPlayerObject(_)=_Player:-
        exception::raise_user("Wrong User\'s ID").

end implement competitors

/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement competitors
    open core

facts
    game_V:game:=erroneous.

clauses
    new(GameObj):-
        game_V:=convert(game,GameObj).

clauses
    involvePlayers():-
        involvePlayers(1).

predicates
    involvePlayers:(positive PlayerNo).
clauses
    involvePlayers(PlayerNo):-
        game_V:humanInterface_V:announceStartUp(),
        PlayerDescriptorList = [ PlayerDescriptor || playerDescriptor(No, PlayerDescriptorSrc),
        PlayerDescriptor = string::format("% - %\n", No, PlayerDescriptorSrc) ],
        PlayersDescriptor=string::concatList(PlayerDescriptorList),
        PlayerType=game_V:humanInterface_V:getInput(humanInterface::playerType_S,toString([PlayersDescriptor,toString(PlayerNo)])),
        not(PlayerType=""),
        try
            Player=createPlayerObject(toTerm(PlayerType)),
            Player:setName(toString(PlayerNo)),
            game_V:addPlayer(Player),
            Player:subscribe(game_V:juniourJudge_V:onMoveDone),
            NewPlayerNo=PlayerNo+1
        catch _TraceID do
            game_V:humanInterface_V:announce(humanInterface::errorPlayerType_S,""),
            NewPlayerNo=PlayerNo
        end try,
        !,
        involvePlayers(NewPlayerNo).
    involvePlayers(_PlayerNo).

predicates
    playerDescriptor:(positive No [out],string PlayerDescriptorSrc [out]) multi.
clauses
    playerDescriptor(1,human::getPlayerDescriptor(game_V:language_V)).
    playerDescriptor(2,computer0::getPlayerDescriptor(game_V:language_V)).
    playerDescriptor(3,computer1::getPlayerDescriptor(game_V:language_V)).
    playerDescriptor(4,computer2::getPlayerDescriptor(game_V:language_V)).

predicates
    createPlayerObject:(positive)->player.
clauses
    createPlayerObject(1)=Player:-
        !,
        Player=human::new(game_V).
    createPlayerObject(2)=Player:-
        !,
        Player=computer0::new(game_V).
    createPlayerObject(3)=Player:-
        !,
        Player=computer1::new(game_V).
    createPlayerObject(4)=Player:-
        !,
        Player=computer2::new(game_V).
    createPlayerObject(_)=_Player:-
        exception::raise_User("Not existing Model").

end implement competitors

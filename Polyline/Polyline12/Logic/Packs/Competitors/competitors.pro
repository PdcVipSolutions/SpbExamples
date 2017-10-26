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
    getCandidates()=PlayerDescriptorList:-
        PlayerDescriptorList = [ PlayerDescriptor || playerShortDescriptor(PlayerDescriptor) ].

/***************************
  Players
***************************/
facts
    players_V:player*:=[].

clauses
    addPlayer(Player):-
        players_V:=list::append(players_V,[Player]),
        game_V:seniourJudge_V:subscribe(Player:onNotification),
        Player:subscribe(game_V:juniourJudge_V:onMoveDone),
        Player:setHumanInterface(game_V:humanInterface_V).

clauses
   removePlayer(PlayerIndex):-
        list::split(PlayerIndex, players_V, LeftList, RightList),
        RightList=[IndexedPlayer|Tail],
        !,
        players_V:= list::append(LeftList, Tail),
        game_V:seniourJudge_V:unsubscribe(IndexedPlayer:onNotification),
        IndexedPlayer:unsubscribe(game_V:juniourJudge_V:onMoveDone),
        try % starter_V may be erroneous and we can not check it here, just the exception signals
            Starter=game_V:seniourJudge_V:starter_V,
            if Starter=IndexedPlayer then
                game_V:seniourJudge_V:resetStarter()
            end if
        catch _TraceID do
            succeed
        end try.
   removePlayer(_PlayerIndex).

clauses
    shiftPlayer(PlayerIndex,polyLineDomains::up):-
        PlayerIndex>0,
        list::split(PlayerIndex-1, players_V, LeftList, RightList),
        RightList=[PreviousPlayer,IndexedPlayer|Tail],
        !,
        players_V:= list::append(LeftList,[IndexedPlayer,PreviousPlayer|Tail]).
   shiftPlayer(PlayerIndex,polyLineDomains::down):-
        list::split(PlayerIndex, players_V, LeftList, RightList),
        RightList=[IndexedPlayer,NextPlayer|Tail],
        !,
        players_V:= list::append(LeftList,[NextPlayer,IndexedPlayer|Tail]).
   shiftPlayer(_PlayerIndex,_Direction).

clauses
    isNameUnique(Name):-
        Player=list::getMember_nd(players_V),
        Player:name=Name,
        !,
        fail.
    isNameUnique(_Any).

clauses
    isNameUnique(PlayerObject,Name):-
        Player=list::getMember_nd(players_V),
        not(Player=PlayerObject),
        Player:name=Name,
        !,
        fail.
    isNameUnique(_PlayerObject,_Any).

clauses
    isLegendUnique(Legend):-
        Player=list::getMember_nd(players_V),
        Player:legend_V=Legend,
        !,
        fail.
    isLegendUnique(_Any).

clauses
    isLegendUnique(PlayerObject,Legend):-
        Player=list::getMember_nd(players_V),
        not(Player=PlayerObject),
        Player:legend_V=Legend,
        !,
        fail.
    isLegendUnique(_PlayerObject,_Any).

clauses
    stopPlayers():-
        Player=list::getMember_nd(players_V),
            Player:stopGame(),
        fail.
    stopPlayers().

predicates
    playerShortDescriptor:(string PlayerDescriptorSrc [out]) multi.
clauses
    playerShortDescriptor(human::getPlayerShortDescriptor(game_V:language_V)).
    playerShortDescriptor(computer00::getPlayerShortDescriptor(game_V:language_V)).
    playerShortDescriptor(computer0::getPlayerShortDescriptor(game_V:language_V)).
    playerShortDescriptor(computer1::getPlayerShortDescriptor(game_V:language_V)).
    playerShortDescriptor(computer2::getPlayerShortDescriptor(game_V:language_V)).

clauses
    createPlayerObject(human::getPlayerShortDescriptor(game_V:language_V))=Player:-
        !,
        Player=human::new(game_V).
    createPlayerObject(computer00::getPlayerShortDescriptor(game_V:language_V))=Player:-
        !,
        Player=computer00::new(game_V).
    createPlayerObject(computer0::getPlayerShortDescriptor(game_V:language_V))=Player:-
        !,
        Player=computer0::new(game_V).
    createPlayerObject(computer1::getPlayerShortDescriptor(game_V:language_V))=Player:-
        !,
        Player=computer1::new(game_V).
    createPlayerObject(computer2::getPlayerShortDescriptor(game_V:language_V))=Player:-
        !,
        Player=computer2::new(game_V).
    createPlayerObject(_)=_Player:-
        exception::raise_User("Wrong Player/'s ID").

end implement competitors

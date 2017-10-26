/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement seniourJudge
    inherits notificationAgency
open core, humanInterface

facts
    game_V:game:=erroneous.
    starter_V:player:=erroneous.
    noOfRounds_V:positive:=10.
    inProgress_V:boolean:=false.
    externalFirstMove_V:boolean:=false.
    multiMode_V:boolean:=false.

clauses
    new(GameObject):-
        game_V:=convert(game,GameObject),
        game_V:juniourJudge_V:subscribe(onMoveDone),
        game_V:humanInterface_V:subscribe(onUIRequest).

clauses
    resetStarter():-
        starter_V:=erroneous.

clauses
    onUIRequest(_Object_1,_Object_2,_Object_3,string(polylineDomains::uiRequestRun_C),_None):-
        !,
        play().
    onUIRequest(_Object_1,_Object_2,_Object_3,string(polylineDomains::uiRequestStop_C),_None):-
        !,
        inProgress_V:=false,
        stopGame().
    onUIRequest(_Object_1,_Object_2,_Object_3,_EventID,_EventValue).

clauses
    play():-
        if multiMode_V=true then
            subscribe(onGameComplete),
            [FirstPlayer|_Tail]=game_V:competitors_V:players_V,
            starter_V:=FirstPlayer,
            gameCounter_V:=1,
            game_V:humanInterface_V:showStatus(polylineDomains::newGame)
        end if,
        playGame(),
        !.
    play().

predicates
    playGame:().
clauses
    playGame():-
        game_V:humanInterface_V:showStatus(polylineDomains::initial),
        inProgress_V:=true,
        if (multiMode_V=true and externalFirstMove_V=true) then
            if [starter_V|_Tail]=game_V:competitors_V:players_V then
                game_V:juniourJudge_V:makeInitialExternalMove(polylineDomains::initialGame_C)
            else
                game_V:juniourJudge_V:makeInitialExternalMove(polylineDomains::nextGame_C)
            end if
        else
            notify(This,object(starter_V),none) % invites player to make Move
        end if.

predicates
    onMoveDone:notificationAgency::notificationListener.
clauses
    onMoveDone(_Object_1,_Object_2,_Object_3,object(PlayerObj),none):-
        game_V:juniourJudge_V:isGameOver(),
        !,
        Player=convert(player,PlayerObj),
        addWinner(Player),
        inProgress_V:=false,
        game_V:humanInterface_V:showStatus(polylineDomains::complete),
        game_V:juniourJudge_V:reset(),
        notify(This,string(polylineDomains::playerWon_C),string(Player:name)).% Game is Over. Notify Players regarding the result
    onMoveDone(_Object_1,_Object_2,_Object_3,object(PlayerObj),none):-
        !,
        NextPlayer=nextPlayer(PlayerObj),
        try
            notify(This,object(NextPlayer),none)  % Invite Next Player to make Move
        catch _TraceID do
            stopGame()
        end try.
    onMoveDone(_Object_1,_Object_2,_Object_3,_EventID,_EventValue).

facts
    gameCounter_V:positive:=0.
predicates
    onGameComplete:notificationAgency::notificationListener.
clauses
    onGameComplete(_Object_1,_Object_2,_Object_3,string(polylineDomains::playerWon_C),_Value):-
        not(gameCounter_V=noOfRounds_V*list::length(game_V:competitors_V:players_V)),
        !,
        starter_V:=nextPlayer(starter_V),
        gameCounter_V:=gameCounter_V+1,
        game_V:humanInterface_V:showStatus(polylineDomains::newGame),
        playGame().
    onGameComplete(_Object_1,_Object_2,_Object_3,string(polylineDomains::playerWon_C),_Value):-
        !,
        unsubscribe(onGameComplete).
    onGameComplete(_Object_1,_Object_2,_Object_3,_Any1,_Any2).

predicates
    stopGame:() procedure.
clauses
    stopGame():-
        game_V:juniourJudge_V:reset(),
        game_V:competitors_V:stopPlayers(),
        game_V:humanInterface_V:showStatus(polylineDomains::interrupted),
        try
            unsubscribe(onGameComplete)
        catch _TraceID do
            succeed
        end try.

predicates
    nextPlayer:(object  CurrentPlayer)->player NextPlayer.
clauses
    nextPlayer(JuniourJudge)=starter_V:-
        JuniourJudge=game_V:juniourJudge_V,
        !.
    nextPlayer(PlayerObj)=NextPlayer:-
        Player=convert(player,PlayerObj),
        Index=list::tryGetIndex(Player,game_V:competitors_V:players_V),
        NextPlayer=list::tryGetNth(Index+1,game_V:competitors_V:players_V),
        !.
    nextPlayer(_Player)=list::nth(0,game_V:competitors_V:players_V).

predicates
    addWinner:(player).
clauses
    addWinner(Player):-
        if Player=starter_V then
            TrueIfStarted=true
        else
            TrueIfStarted=false
        end if,
        game_V:gameStatistics_V:addWinner(TrueIfStarted,Player:name).

end implement seniourJudge

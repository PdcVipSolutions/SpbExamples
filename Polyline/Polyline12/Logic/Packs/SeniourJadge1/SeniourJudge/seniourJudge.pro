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
        if multiMode_V=true then
            subscribe(onGameComplete),
            [FirstPlayer|_Tail]=game_V:competitors_V:players_V,
            starter_V:=FirstPlayer,
            gameCounter_V:=1,
            game_V:humanInterface_V:showStatus(polylineDomains::newGame)
        end if,
        !,
        try
            playGame()
        catch _TraceID do
            stopGame
        end try.
    onUIRequest(_Object_1,_Object_2,_Object_3,string(polylineDomains::uiRequestStop_C),_None):-
        !,
        inProgress_V:=false,
        stopGame().
    onUIRequest(_Object_1,_Object_2,_Object_3,_EventID,_EventValue).

facts
    lastMove_F:(object LastMovedPlayer).
predicates
    playGame:().
clauses
    playGame():-
        game_V:humanInterface_V:showStatus(polylineDomains::initial),
        inProgress_V:=true,
        notify(This,object(starter_V),none), % invites first player to make Move
        std::repeat(),
            game_V:humanInterface_V:inLoopPoint(),
            retract(lastMove_F(PlayerObj)),
            if game_V:juniourJudge_V:isGameOver() then
                !,
                handleGameIsOver(PlayerObj)
            else
                notify(This,object(nextPlayer(PlayerObj)),none), % invites next player to make Move
                fail
            end if.
    playGame().

predicates
    handleGameIsOver:(object Player).
clauses
    handleGameIsOver(PlayerObj):-
        Player=convert(player,PlayerObj),
        addWinner(Player),
        inProgress_V:=false,
        game_V:humanInterface_V:showStatus(polylineDomains::complete),
        game_V:juniourJudge_V:reset(),
        notify(This,string(polylineDomains::playerWon_C),string(Player:name)).% Game is Over. Notify Players regarding the result

/*
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
*/
predicates
    onMoveDone:notificationAgency::notificationListener.
clauses
    onMoveDone(_Object_1,_Object_2,_Object_3,object(PlayerObj),none):-
        !,
        assert(lastMove_F(PlayerObj)).
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
%/*
        try
            unsubscribe(onGameComplete)
%        finally
        catch _TraceID do
            succeed
        end try.
%*/
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

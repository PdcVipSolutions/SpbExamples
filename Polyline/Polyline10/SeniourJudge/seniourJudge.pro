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

clauses
    new(GameObject):-
        game_V:=convert(game,GameObject).

clauses
    playSingle():-
        not(isErroneous(starter_V)),
        !,
        playSingle(starter_V),
        playSingle().
    playSingle():-
        starter_V:=chooseStartingPlayer(),
        !,
        playSingle().
    playSingle().

/***************************
 Shoose Starting Player
***************************/
predicates
    chooseStartingPlayer:()->player StartingPlayer determ.
clauses
    chooseStartingPlayer()=Player:-
        not(game_V:players_V=[]) and not(game_V:players_V=[_SiglePlayer]),
        PlayList = [ PlayListMember || PlayListMember = playListMember() ],
        PlayListStr=string::concatList(PlayList),
        StartingPlayer=getStartingPlayerInput(PlayListStr),
        Player=list::nth(StartingPlayer-1,game_V:players_V).

predicates
    playListMember:()->string nondeterm.
clauses
    playListMember()=PlayersListMember:-
        I = std::fromTo(1, list::length(game_V:players_V)),
            Player=list::nth(I-1,game_V:players_V),
            PlayersListMember=string::format("\n% - %",I,Player:name).

predicates
    getStartingPlayerInput:(string PlayListStr)->positive StartingPlayerNo determ.
clauses
    getStartingPlayerInput(PlayListStr)=StartingPlayer:-
        StartingPlayerStr=game_V:humanInterface_V:getInput(humanInterface::startingPlayer_S,PlayListStr),
        if StartingPlayerStr="" then
            !,
            fail
        else
            try
                StartingPlayer=toTerm(StartingPlayerStr),
                !
            catch _TraceID1 do
                game_V:humanInterface_V:announce(humanInterface::errorMustBeNumber_S,""),
                fail
            end try,
            if StartingPlayer>list::length(game_V:players_V) then
                game_V:humanInterface_V:announce(humanInterface::errorStartingPlayer_S,""),
                fail
            end if
        end if.
    getStartingPlayerInput(PlayListStr)=StartingPlayer:-
        StartingPlayer=getStartingPlayerInput(PlayListStr).

predicates
    playSingle:(player CurrentPlayer).
clauses
    playSingle(Player):-
        inProgress_V=false,
        game_V:humanInterface_V:showStage(),
        game_V:humanInterface_V:announce(humanInterface::starter_S,Player:name),
        inProgress_V:=true,
        notify(This,object(Player),none), % invites player to make Move
        playSingle(Player),
        !.
    playSingle(Player):-
        game_V:juniourJudge_V:isGameOver(),
        !,
        if game_V:multiMode_V=false then
            notify(This,object(Player),string(Player:name)), % notifies Players regarding the result
            starter_V:=erroneous
        else
            addWinner(Player)
        end if,
        inProgress_V:=false,
        game_V:juniourJudge_V:reset().
    playSingle(Player):-
        NextPlayer=nextPlayer(Player),
        notify(This,object(NextPlayer),none),  % invites player to make Move
        !,
        playSingle(NextPlayer).

predicates
    nextPlayer:(player CurrentPlayer)->player NextPlayer.
clauses
    nextPlayer(Player)=NextPlayer:-
        Index=list::tryGetIndex(Player,game_V:players_V),
        NextPlayer=list::tryGetNth(Index+1,game_V:players_V),
        !.
    nextPlayer(_Player)=list::nth(0,game_V:players_V).

/************************
  Multi Mode Handle
************************/
predicates
    defineNoOfRounds:().
clauses
    defineNoOfRounds():-
        InputString=game_V:humanInterface_V:getInput(humanInterface::noOfRounds_S,toString(noOfRounds_V)),
        not(InputString=""),
        try
            noOfRounds_V:=toTerm(InputString)
        catch _TraceID do
            game_V:humanInterface_V:announce(humanInterface::errorNoOfRounds_S,""),
            defineNoOfRounds()
        end try,
        !.
    defineNoOfRounds().

facts
    statistics_F:(boolean TrueIfWon,player,positive Won).

clauses
    playMulti():-
        defineNoOfRounds(),
        Player=list::getMember_nd(game_V:players_V),
            starter_V:=Player,
            playRound(noOfRounds_V),
        fail().
    playMulti():-
        game_V:humanInterface_V:reset(),
        retractAll(statistics_F(_,_,_)),
        PlayersNo=list::length(game_V:players_V),
        game_V:humanInterface_V:announce(humanInterface::reportHeader_S,toString(PlayersNo*noOfRounds_V)),
        PlayerResiltListList = [ PlayerResiltList || Player = list::getMember_nd(game_V:players_V),
        WinsFirst = calculateWins(Player, true),
        WinsNext = calculateWins(Player, false),
        WnsTotal = WinsFirst + WinsNext,
        PlayerResiltList = [Player:name, toString(WnsTotal), toString(WinsFirst), toString(WinsNext)] ],
        game_V:humanInterface_V:announce(humanInterface::report_S,toString(PlayerResiltListList)),
        fail().
    playMulti():-
        InputString=game_V:humanInterface_V:getInput(humanInterface::continueMultiGame_S),
        if InputString="" then
        else
            playMulti()
        end if.

facts
    wins_V:integer:=0.
predicates
    calculateWins:(player Player,boolean TrueIfFirst)->integer Sum.
clauses
    calculateWins(Player,TrueIfFirst)=_:-
        wins_V:=0,
        statistics_F(TrueIfFirst,Player,Won),
            try
            	wins_V := wins_V + Won
            catch _TraceID do
            	fail
            end try,
        fail.
    calculateWins(_Player,_TrueIfFirst)=wins_V.

predicates
    playRound:(positive NoOfRounds).
clauses
    playRound(0):-!.
    playRound(NoOfRounds):-
        game_V:humanInterface_V:announce(round_S,toString(noOfRounds_V-NoOfRounds+1)),
        playSingle(starter_V),
        playRound(NoOfRounds-1).

predicates
    addWinner:(player).
clauses
    addWinner(Player):-
        if Player=starter_V then
            TrueIfStarted=true
        else
            TrueIfStarted=false
        end if,
        addWinner(TrueIfStarted,Player).

predicates
    addWinner:(boolean TrueIfStarted,player Player).
clauses
    addWinner(TrueIfStarted,Player):-
        retract(statistics_F(TrueIfStarted,Player,Won)),
        !,
        assert(statistics_F(TrueIfStarted,Player,Won+1)).
    addWinner(TrueIfStarted,Player):-
        assert(statistics_F(TrueIfStarted,Player,1)).
end implement seniourJudge

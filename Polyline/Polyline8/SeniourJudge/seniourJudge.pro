/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement seniourJudge
open core, humanInterface

class facts
    inProgress_V:boolean:=false.

clauses
    playSingle(Player):-
        inProgress_V=false,
        humanInterface::showStage(),
        humanInterface::announce(humanInterface::starter_S,Player:name),
        inProgress_V:=true,
        Player:move(),
        playSingle(Player),
        !.
    playSingle(Player):-
        juniourJudge::isGameOver(),
        !,
        if game::multiMode_V=false then
            Player:announceWin(),
            foreach (Participant=list::getMember_nd(game::players_V) and not(Participant=Player)) do
                Participant:announceLoss()
            end foreach
        else
            addWinner(Player)
        end if,
        inProgress_V:=false,
        juniourJudge::reset().
    playSingle(Player):-
        NextPlayer=nextPlayer(Player),
        NextPlayer:move(),
        !,
        playSingle(NextPlayer).

class predicates
    nextPlayer:(player CurrentPlayer)->player NextPlayer.
clauses
    nextPlayer(Player)=NextPlayer:-
        Index=list::tryGetIndex(Player,game::players_V),
        NextPlayer=list::tryGetNth(Index+1,game::players_V),
        !.
    nextPlayer(_Player)=list::nth(0,game::players_V).

/************************
  Multi Mode Handle
************************/
class predicates
    defineNoOfRounds:().
clauses
    defineNoOfRounds():-
        InputString=humanInterface::getInput(humanInterface::noOfRounds_S,toString(noOfRounds_V)),
        not(InputString=""),
        try
            noOfRounds_V:=toTerm(InputString)
        catch _TraceID do
            humanInterface::announce(humanInterface::errorNoOfRounds_S,""),
            defineNoOfRounds()
        end try,
        !.
    defineNoOfRounds().

class facts
    starter_V:player:=erroneous.
    noOfRounds_V:positive:=10.
    statistics_F:(boolean TrueIfWon,player,positive Won).

clauses
    playMulti():-
        defineNoOfRounds(),
        Player=list::getMember_nd(game::players_V),
            starter_V:=Player,
            playRound(noOfRounds_V),
        fail().
    playMulti():-
        humanInterface::reset(),
        PlayersNo=list::length(game::players_V),
        humanInterface::announce(humanInterface::reportHeader_S,toString(PlayersNo*noOfRounds_V)),
        PlayerResiltListList = [ PlayerResiltList || Player = list::getMember_nd(game::players_V),
        WinsFirst = calculateWins(Player, true),
        WinsNext = calculateWins(Player, false),
        WnsTotal = WinsFirst + WinsNext,
        PlayerResiltList = [Player:name, toString(WnsTotal), toString(WinsFirst), toString(WinsNext)] ],
        humanInterface::announce(humanInterface::report_S,toString(PlayerResiltListList)),
        fail().
    playMulti():-
        humanInterface::waitOK().

class facts
    wins_V:integer:=0.
class predicates
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

class predicates
    playRound:(positive NoOfRounds).
clauses
    playRound(0):-!.
    playRound(NoOfRounds):-
        humanInterface::announce(round_S,toString(noOfRounds_V-NoOfRounds+1)),
        seniourJudge::playSingle(starter_V),
        playRound(NoOfRounds-1).

class predicates
    addWinner:(player).
clauses
    addWinner(Player):-
        if Player=starter_V then
            TrueIfStarted=true
        else
            TrueIfStarted=false
        end if,
        addWinner(TrueIfStarted,Player).

class predicates
    addWinner:(boolean TrueIfStarted,player Player).
clauses
    addWinner(TrueIfStarted,Player):-
        retract(statistics_F(TrueIfStarted,Player,Won)),
        !,
        assert(statistics_F(TrueIfStarted,Player,Won+1)).
    addWinner(TrueIfStarted,Player):-
        assert(statistics_F(TrueIfStarted,Player,1)).
end implement seniourJudge

/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/

implement game
    open core

class facts
    language_V:language_D:=en.
    multiMode_V:boolean:=false.

clauses
    run():-
        setLanguage(),
        Mode=chooseSingleOrMultiGame(),
        setGameProperties(),
        competitors::involvePlayers(),
        if Mode=single_S then
            playSingle()
        else
            multiMode_V:=true,
            seniourJudge::playMulti()
        end if.

domains
    mode_D=
        single_S;
        multi_S.

class predicates
    setLanguage:().
clauses
    setLanguage():-
        CommandLine = exe_native::getCommandLine(),
        if string::hasSuffix(CommandLine,"ru",_RestRu) then
            language_V:=ru
        end if,
        if string::hasSuffix(CommandLine,"en",_RestEn) then
            language_V:=en
        end if,
        humanInterface::setLanguage(language_V).

class predicates
    chooseSingleOrMultiGame:()->mode_D GameOrCompetition.
clauses
    chooseSingleOrMultiGame()=Choice:-
        ChoiceStr=humanInterface::getInput(humanInterface::singleOrMulti_S),
        if (string::equalIgnoreCase(ChoiceStr,"S") or ChoiceStr=""),! then
            Choice=single_S,
            !
        else
            Choice=multi_S
        end if.

class predicates
    playSingle:().
clauses
    playSingle():-
        StartingPlayer=chooseStartingPlayer(),
        seniourJudge::playSingle(StartingPlayer),
        !,
        playSingle().
    playSingle().

class predicates
    setGameProperties:().
clauses
    setGameProperties():-
        juniourJudge::defineStage().

/***************************
  Players
***************************/
class facts
    players_V:player*:=[].

clauses
    addPlayer(Player):-
        players_V:=list::append(players_V,[Player]).

/***************************
 Shoose Starting Player
***************************/
class predicates
    chooseStartingPlayer:()->player determ.
clauses
    chooseStartingPlayer()=Player:-
        not(players_V=[]) and not(players_V=[_SiglePlayer]),
        PlayList = [ PlayListMember || PlayListMember = playListMember() ],
        PlayListStr=string::concatList(PlayList),
        StartingPlayer=getStartingPlayerInput(PlayListStr),
        Player=list::nth(StartingPlayer-1,players_V).

class predicates
    playListMember:()->string nondeterm.
clauses
    playListMember()=PlayersListMember:-
        I = std::fromTo(1, list::length(game::players_V)),
            Player=list::nth(I-1,game::players_V),
            PlayersListMember=string::format("\n% - %",I,Player:name).

class predicates
    getStartingPlayerInput:(string PlayListStr)->positive StartingPlayerNo determ.
clauses
    getStartingPlayerInput(PlayListStr)=StartingPlayer:-
        StartingPlayerStr=humanInterface::getInput(humanInterface::startingPlayer_S,PlayListStr),
        if StartingPlayerStr="" then
            !,
            fail
        else
            try
                StartingPlayer=toTerm(StartingPlayerStr),
                !
            catch _TraceID1 do
                humanInterface::announce(humanInterface::errorMustBeNumber_S,""),
                fail
            end try,
            if StartingPlayer>list::length(players_V) then
                humanInterface::announce(humanInterface::errorStartingPlayer_S,""),
                fail
            end if
        end if.
    getStartingPlayerInput(PlayListStr)=StartingPlayer:-
        StartingPlayer=getStartingPlayerInput(PlayListStr).

end implement game

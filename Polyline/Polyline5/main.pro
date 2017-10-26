/****************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline

Predicates, which represent the strategy
    neighbour_nd,
    neighbourOutOfPolyLine_nd,
    stepCandidate
based on solutions proposed by Elena Efimova
Predidcates
    resolveStep
    successfulStep
modified
*****************************************************/
goal
    mainExe::run(main::run).

/**************
Class Main
**************/
implement main
    open core

clauses
    run():-
        console::init(),
        game::run().

end implement main

/******************************************
  Class Game
******************************************/
class game
open core

predicates
    run:().
end class game

implement game
open core

class facts
    playerNo_V:positive:=1.

clauses
    run():-
        humanInterface::announceStartUp(),
        PlayerType=humanInterface::getInput(humanInterface::playerType_S,toString(playerNo_V)),
        not(PlayerType=""),
        try
            Player=createPlayerObject(toTerm(PlayerType)),
            seniourJudge::addPlayer(Player),
            playerNo_V:=playerNo_V+1
        catch _TraceID do
            humanInterface::announceManagerError(humanInterface::errorPlayerType_S)
        end try,
        !,
        run().
    run():-
        startingPlayer().

class predicates
    playListMember:()->string nondeterm.
clauses
    playListMember()=PlayersListMember:-
        I = std::fromTo(1, list::length(seniourJudge::players_V)),
            Player=list::nth(I-1,seniourJudge::players_V),
            PlayersListMember=string::format("\n% - %",I,Player:name).

class predicates
    startingPlayer:().
clauses
    startingPlayer():-
        not(seniourJudge::players_V=[]) and not(seniourJudge::players_V=[_SiglePlayer]),
        PlayList = [ PlayListMember || PlayListMember = playListMember() ],
        PlayListStr=string::concatList(PlayList),
        StartingPlayerStr=humanInterface::getInput(humanInterface::startingPlayer_S,PlayListStr),
        not(StartingPlayerStr=""),
        try
            StartingPlayer=toTerm(StartingPlayerStr),
            !,
            startGame(StartingPlayer)
        catch _TraceID1 do
            humanInterface::announceManagerError(humanInterface::errorMustBeNumber_S),
            !,
            startingPlayer()
        end try.
    startingPlayer().

class predicates
    startGame:(positive).
clauses
    startGame(StartingPlayer):-
        try
            Player=list::nth(StartingPlayer-1,seniourJudge::players_V), % list::nth(...) needs unsigned
            !,
            seniourJudge::play(Player)
        catch _Trace_D do
            humanInterface::announceManagerError(humanInterface::errorStartingPlayer_S),
            !
        end try,
        !,
        startingPlayer().


class predicates
    createPlayerObject:(positive)->player.
clauses
    createPlayerObject(1)=Player:-
        !,
        Player=human::new().
    createPlayerObject(2)=Player:-
        !,
        Player=computer::new().
    createPlayerObject(_)=_Player:-
        exception::raise_user("wrong player!").

end implement game

/************************
  Class SeniorJudge
************************/
class seniourJudge
open core

properties
    players_V:player*.
    inProgress_V:boolean.

predicates
    play:(player CurrentPlayer).
    addPlayer:(player NextPlayer).
end class seniourJudge

implement seniourJudge
open core, humanInterface

class facts
    players_V:player*:=[].
    inProgress_V:boolean:=false.

clauses
    play(Player):-
        inProgress_V=false,
        humanInterface::showStage(),
        inProgress_V:=true,
        Player:move(),
        humanInterface::announceStarter(Player:name),
        play(Player),
        !.
    play(Player):-
        juniourJudge::isGameOver(),
        !,
        Player:announceWin(),
        foreach (Participant=list::getMember_nd(players_V) and not(Participant=Player)) do
            Participant:announceLoss()
        end foreach,
        inProgress_V:=false,
        juniourJudge::reset().
    play(Player):-
        NextPlayer=nextPlayer(Player),
        NextPlayer:move(),
        !,
        play(NextPlayer).

clauses
    addPlayer(NextPlayer):-
        players_V:=list::append(players_V,[NextPlayer]).

class predicates
    nextPlayer:(player CurrentPlayer)->player NextPlayer.
clauses
    nextPlayer(Player)=NextPlayer:-
        Index=list::tryGetIndex(Player,players_V),
        NextPlayer=list::tryGetNth(Index+1,players_V),
        !.
    nextPlayer(_Player)=list::nth(0,players_V).

end implement seniourJudge

/************************
  Class JuniourJudge
************************/
class juniourJudge
open core

domains
    cell = c(positive,positive).
    stepType_D=
        ordinary_S;
        winner_S.

properties
    maxRow_P:positive.
    maxColumn_P:positive.
    polyline_P:cell*.

predicates
    neighbour_nd: (cell,cell) nondeterm (i,o) (i,i).
    neighbourOutOfPolyLine_nd:(cell,cell)->cell nondeterm.
    set: (string ).
    isGameOver:() determ.
    reset:().

end class juniourJudge

implement juniourJudge
open core, humanInterface

class facts
    maxRow_P:positive:=10.
    maxColumn_P:positive:=10.
    polyline_P:cell*:=[].
    endOfGame_V:boolean:=false.

clauses
    isGameOver():-
        endOfGame_V=true.

clauses
    set(InputString):-
        Cell=toTerm(InputString),
        handleInput (Cell).

clauses
    reset():-
        juniourJudge:: polyline_P:=[],
        juniourJudge::endOfGame_V:=false.

class predicates
    handleInput:(juniourJudge::cell).
clauses
    handleInput(Cell):-
        list::isMember(Cell,polyline_P),
        try
            _=makePolyLine(Cell,polyline_P) % it will be an exception if wrong Cell, but we ignore it by failing
        catch _TraceID do
            fail
        end try,
        !,
        endOfGame_V:=true,
        humanInterface::showStep(Cell,winner_S).
    handleInput (Cell):-
        polyline_P:=makePolyLine(Cell,polyline_P),
        !,
        humanInterface::showStep(Cell,ordinary_S).

class predicates
    makePolyLine: (cell,cell*)-> cell* multi.
clauses
    makePolyLine(c(X,Y),[])=[c(X,Y)]:-
        X>0,X<=maxColumn_P,
        Y>0,Y<=maxRow_P,
        !.
    makePolyLine(NewCell,[SingleCell])=[NewCell,SingleCell]:-
        neighbour_nd(SingleCell, NewCell),
        !.
    makePolyLine(NewCell,[Left, RestrictingCell | PolyLineTail])=[NewCell, Left, RestrictingCell | PolyLineTail]:-
        NewCell=neighbourOutOfPolyLine_nd(Left,RestrictingCell).
    makePolyLine(NewCell,PolyLine)=list::reverse([NewCell,Left, RestrictingCell | PolyLineTail]):-
        [Left, RestrictingCell | PolyLineTail]= list::reverse(PolyLine),
        NewCell=neighbourOutOfPolyLine_nd(Left,RestrictingCell).
    makePolyLine(NewCell,_PolyLine)= _PolyLine1:-
        exception::raise_user("the point % can not prolong the polyline!",[namedValue("data",string(toString(NewCell)))]).

clauses
    neighbourOutOfPolyLine_nd(Cell,RestrictingCell)=NewCell:-
        neighbour_nd(Cell,NewCell),
            not(NewCell = RestrictingCell).

clauses
    neighbour_nd(c(X, Y), c(X + 1, Y)):- X < maxColumn_P.
    neighbour_nd(c(X, Y), c(X, Y + 1)):- Y < maxrow_P.
    neighbour_nd(c(X, Y), c(X - 1, Y)):- X > 1.
    neighbour_nd(c(X, Y), c(X, Y - 1)):- Y > 1.

end implement juniourJudge

/******************************************
  Interface Player
******************************************/
interface player

predicates
    move:().
    announceWin:().
    announceLoss:().

properties
    name:string.

end interface player

/******************************************
  Class Human
******************************************/
class human:player
open core
end class human

implement human
open core

facts
    name:string:=string::format("Hum_%",toString(This)).

clauses
    new():-
        Name=humanInterface::getInput(humanInterface::playerName_S,name),
        if not(Name="") then
            name:=Name
        end if.

clauses
    move():-
        InputString=humanInterface::getInput(humanInterface::playerStep_S),
        try
            juniourJudge::set(InputString)
        catch TraceID do
            handleException(TraceID),
            fail
        end try,
        !.
    move():-
        move().

clauses
    announceWin():-
        humanInterface::announceWin(name).

    announceLoss():-
        humanInterface::announceLoss(name).


class predicates
    handleException:(exception::traceId TraceID).
clauses
    handleException(TraceID):-
        foreach Descriptor=exception::getDescriptor_nd(TraceID) do
            Descriptor = exception::descriptor
                (
                _ProgramPoint,
                exception(_ClassName,_ExceptionName,Description),
                _Kind,
                ExtraInfo,
                _GMTTime,
                _ThreadId
                ),
            if
                ExtraInfo=[namedValue("data",string(CellPointer))]
            then
                ErrorMsg=string::format(Description,CellPointer),
                humanInterface::announceError(ErrorMsg)
            else
                humanInterface::announceError("")
            end if
        end foreach.

end implement human

/******************************************
  Class Computer
******************************************/
class computer:player
end class computer

implement computer
    inherits genericComputer
end implement computer
/******************************************
  Class GenericComputer
******************************************/
interface genericComputer
    supports player
    supports polyLineBrain

end interface genericComputer

class genericComputer:genericComputer
open core, exception

end class genericComputer

implement genericComputer
    inherits polyLineBrain2
open core

facts
    name:string:=string::format("Cmp_%",toString(This)).

clauses
    new():-
        Name=humanInterface::getInput(humanInterface::playerName_S,name),
        if not(Name="") then
            name:=Name
        end if.

clauses
    move():-
        humanInterface::announceThinker(name),
        Cell=resolveStep(),
        juniourJudge::set(toString(Cell)).

predicates
    resolveStep:()->juniourJudge::cell.
clauses
    resolveStep()=Cell:-
        Cell=successfulStep(juniourJudge::polyline_P),
        !.
    resolveStep()=Cell:-
        Cell=randomStep(),
        !.
    resolveStep()=juniourJudge::c(X+1,Y+1):-
        X=math::random(juniourJudge::maxColumn_P-1),
        Y=math::random(juniourJudge::maxRow_P-1).

clauses
    stepCandidate([Cell],[Cell,NewCell], NewCell):-
        juniourJudge::neighbour_nd(Cell, NewCell).
    stepCandidate([Left, RestrictingCell | PolyLine],[NewCell,Left, RestrictingCell| PolyLine], NewCell):-
        NewCell=juniourJudge::neighbourOutOfPolyLine_nd(Left,RestrictingCell).
    stepCandidate(PolyLine,list::reverse([NewCell,Left, RestrictingCell |PolyLineTail]),NewCell):-
        [Left, RestrictingCell |PolyLineTail] = list::reverse(PolyLine),
        NewCell=juniourJudge::neighbourOutOfPolyLine_nd(Left,RestrictingCell).

clauses
    announceWin():-
        humanInterface::announceWin(name).

clauses
    announceLoss():-
        humanInterface::announceLoss(name).

end implement genericComputer

/******************************************
  Interface PolylineBrain
******************************************/
interface polylineBrain
open core

constants
   notDefinedPredicate_C="The predicate is not defined. Must be defined in the daughter class. ".

predicates
    stepCandidate: (juniourJudge::cell*,juniourJudge::cell* [out],juniourJudge::cell [out]) nondeterm.
    successfulStep: (juniourJudge::cell*)->juniourJudge::cell nondeterm.
    randomStep:()->juniourJudge::cell determ.

end interface polyLineBrain

/******************************************
  Class PolylineBrain2
******************************************/
class polyLineBrain2:polyLineBrain
open core

end class polyLineBrain2

implement polyLineBrain2
open core, exception

facts
    depth_V:positive:=20.
clauses
    new():-
        defineSearchDepth().

predicates
    defineSearchDepth:().
clauses
    defineSearchDepth():-
        DepthStr=humanInterface::getInput(humanInterface::searchDepth_S,toString(depth_V)),
        not(DepthStr=""),
        !,
        try
            depth_V:=toTerm(DepthStr)
        catch _TraceID1 do
            humanInterface::announceManagerError(humanInterface::errorMustBeNumber_S),
            defineSearchDepth()
        end try.
    defineSearchDepth().

predicates
    successfulStep: (integer Counter, juniourJudge::cell*)->juniourJudge::cell nondeterm.
clauses
    successfulStep(PolyLine)=BestMove:-
        BestMove=successfulStep(depth_V,PolyLine).

    successfulStep(Counter,PolyLine)=BestMove:-
        This:stepCandidate(PolyLine,_PolyLine1,BestMove),
        isStepSuccessful(Counter,PolyLine,BestMove),
        !.
    successfulStep(Counter,PolyLine)=Cell:-
        This:stepCandidate(PolyLine, PolyLine1,Cell),
            not(_=successfulStep(Counter-1,PolyLine1)).

clauses
    randomStep()=Cell:-
        CellCandidateListWithDuplicates = [ NewCell || This:stepCandidate(juniourJudge::polyline_P, _Polyline1, NewCell) ],
        CellCandidateList=list::removeDuplicates(CellCandidateListWithDuplicates),
        not(CellCandidateList=[]),
        NoOfVariants=list::length(CellCandidateList),
        ChoiceNo=math::random(NoOfVariants-1),
        Cell=list::nth(ChoiceNo+1,CellCandidateList).

class predicates
    isStepSuccessful:(integer Counter,juniourJudge::cell* PolyLine,juniourJudge::cell BestMove) determ.
clauses
    isStepSuccessful(_Counter,PolyLine,BestMove):-
        list::isMember(BestMove, PolyLine),
        !.
    isStepSuccessful(Counter,_PolyLine,_BestMove):-
        Counter<=1.

clauses
    stepCandidate(_Cell,_PolyLine,_Move):-
        exception::raise_user(notDefinedPredicate_C).

end implement polylineBrain2

/******************************************
  Class HumanInterface
******************************************/
class humanInterface
open core

predicates
    announceStartUp:().

predicates
    showStage:().
    showStep:(juniourJudge::cell,juniourJudge::stepType_D).
    getInput:(inputType_D,string StringParameter)->string InputString.
    getInput:(inputType_D)->string InputString.

predicates
    announceManagerError:(choiceError_D).

predicates
    announceStarter:(string Name).
    announceThinker:(string Name).
    announceWin:(string Name).
    announceLoss:(string Name).
    announceError:(string Description).
    announceError:().

domains
    choiceError_D=
        errorPlayerType_S;
        errorMustBeNumber_S;
        errorstartingPlayer_S.

domains
    inputType_D=
        playerStep_S;
        playerType_S;
        playerName_S;
        startingPlayer_S;
        searchDepth_S.

end class humanInterface

implement humanInterface
open core

constants
    cellMarkedOrdinary_C="*".
    cellMarkedWinner_C="O".

constants % messages
    thinker_C="% is thinking ...".
    beginner_C="First move done by: %".
    error_C="Error, % ".
    congratulation_C="Player % won!".
    sorryLoss_C="%,  Sorry, you loss :-(".

    playerStep_C="Please enter your move as c(X,Y): ".
    playerType_C="\nPlayer #%s. Please enter the player type (1-human, 2-computer, Enter - end of choice):".
    playerName_C="\nPlease assign the name to the player (% proposed):".
    startingPlayer_C="\nWho moves the first (PlayerNo or Enter - end of the game)?:".
    searchDepth_C="\nDefine the depth of the search (% - by default)?? ".

    errorPlayerType_C="\nNo such player type exists! Enter - repeat input:".
    errorMustBeNumber_C="\nMust be number! Please repeat input:".
    errorstartingPlayer_C="\nNo such Player exiasts! Please repeat input:".

constants
    verticalSpace_C=2.
    horizontalSpace_C=3.
    emptyLineLenght_C=80.

constants % Position of Line
    starterLine_C=1.
    announceLine_C=starterLine_C+1.
    actionLine_C=announceLine_C+1.

clauses
    getInput(InputType)=Input:-
        Input=getInput(InputType,"").

    getInput(InputType,StringParameter)=Input:-
        inputInvitation(InputType,StringParameter),
        Input = console::readLine(),
        console::clearInput().

class predicates
    inputInvitation:(inputType_D,string StringParameter).
clauses
    inputInvitation(playerStep_S,_StringParameter):-
        clearMessageArea(actionLine_C),
        writeMessage(actionLine_C,"%",playerStep_C).
    inputInvitation(playerName_S,StringParameter):-
        console::writef(playerName_C,StringParameter).
    inputInvitation(playerType_S,StringParameter):-
        console::writef(playerType_C,StringParameter).
    inputInvitation(startingPlayer_S,StringParameter):-
        console::write(StringParameter,startingPlayer_C).
    inputInvitation(searchDepth_S,StringParameter):-
        console::writef(searchDepth_C,StringParameter).

clauses
    showStage():-
        console::clearOutput(),
        foreach I = std::fromTo(1, juniourJudge::maxColumn_P) do
            console::setLocation(console_native::coord(horizontalSpace_C*I, 0)),
            console::write(I)
        end foreach,
        foreach J = std::fromTo(1, juniourJudge::maxRow_P) do
            console::setLocation(console_native::coord(0, verticalSpace_C*J)),
            console::write(J)
        end foreach.

clauses
    showStep(juniourJudge::c(X,Y),_Type):-
        console::setLocation(console_native::coord(horizontalSpace_C*X, verticalSpace_C*Y)),
        fail.
    showStep(_Cell,juniourJudge::ordinary_S):-
        console::write(cellMarkedOrdinary_C).
    showStep(_Cell,juniourJudge::winner_S):-
        console::write(cellMarkedWinner_C).

clauses
    announceStartUp():-
        console::clearOutput().

clauses
    announceStarter(Name):-
        clearMessageArea(starterLine_C),
        writeMessage(starterLine_C,beginner_C,Name).

clauses
    announceManagerError(errorPlayerType_S):-
        console::write(errorPlayerType_C),
        _=console::readLine().
    announceManagerError(errorMustBeNumber_S):-
        console::write(errorMustBeNumber_C).
    announceManagerError(errorstartingPlayer_S):-
        console::write(errorstartingPlayer_C).

clauses
    announceError():-
        announceError("").

    announceError(ErrorText):-
        clearMessageArea(announceLine_C),
        writeMessage(announceLine_C,error_C,ErrorText).

clauses
    announceWin(Name):-
        clearMessageArea(announceLine_C),
        clearMessageArea(actionLine_C),
        writeMessage(announceLine_C,congratulation_C,Name),
        _ = console::readLine().

    announceLoss(Name):-
        clearMessageArea(announceLine_C),
        clearMessageArea(actionLine_C),
        writeMessage(announceLine_C,sorryLoss_C,Name),
        _ = console::readLine().

clauses
    announceThinker(Name):-
        clearMessageArea(announceLine_C),
        clearMessageArea(actionLine_C),
        writeMessage(actionLine_C,thinker_C,Name).

class predicates
    clearMessageArea:(positive AreaID).
clauses
    clearMessageArea(AreaID):-
        console::setLocation(console_native::coord(0,juniourJudge::maxRow_P*verticalSpace_C+AreaID)),
        console::write(string::create(emptyLineLenght_C," ")).

class predicates
    writeMessage:(positive AreaID,string FormatString,string ParameterString).
clauses
    writeMessage(AreaID,FormatString,ParameterString):-
        console::setLocation(console_native::coord(0, juniourJudge::maxRow_P*verticalSpace_C+AreaID)),
        console::writef(FormatString,ParameterString).

end implement humanInterface

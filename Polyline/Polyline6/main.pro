/****************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline

Predicates, which represent the strategy
    neighbour_nd,
    neighbourOutOfPolyLine_nd,
    stepCandidate
based on solutions proposed by Elena Efimova
Predidcates
    successfulStep
modified
*****************************************************/
/*****************
  GOAL
*****************/
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

class game
open core

properties
    players_V:player*.
    multiMode_V:boolean.

predicates
    run:().
end class game

implement game
open core

class facts
    multiMode_V:boolean:=false.

clauses
    run():-
        Mode=chooseSingleOrMultiGame(),
        setGameProperties(),
        involvePlayers(),
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
 Involving Players
***************************/
class facts
    players_V:player*:=[].

class predicates
    involvePlayers:().
clauses
    involvePlayers():-
        createPlayers(1).

class predicates
    createPlayers:(positive PlayerNo).
clauses
    createPlayers(PlayerNo):-
        humanInterface::announceStartUp(),
        PlayerDescriptorList = [ PlayerDescriptor || playerDescriptor(No, PlayerDescriptorSrc),
        PlayerDescriptor = string::format("% - %\n", No, PlayerDescriptorSrc) ],
        PlayersDescriptor=string::concatList(PlayerDescriptorList),
        PlayerType=humanInterface::getInput
            (
            humanInterface::playerType_S,
            string::format("Possible types of players:\n%s\nPlayer #%s",PlayersDescriptor,toString(PlayerNo))
            ),
        not(PlayerType=""),
        try
            Player=createPlayerObject(toTerm(PlayerType)),
            Player:setName(toString(PlayerNo)),
            players_V:=list::append(players_V,[Player]),
            NewPlayerNo=PlayerNo+1
        catch _TraceID do
            humanInterface::announceSettingsError(humanInterface::errorPlayerType_S),
            NewPlayerNo=PlayerNo
        end try,
        !,
        createPlayers(NewPlayerNo).
    createPlayers(_PlayerNo).

/* Potential Players List*/
class predicates
    playerDescriptor:(positive No [out],string PlayerDescriptorSrc [out]) multi.
clauses
    playerDescriptor(1,human::playerDescriptor_C).
    playerDescriptor(2,computer1::playerDescriptor_C).
    playerDescriptor(3,computer2::playerDescriptor_C).

class predicates
    createPlayerObject:(positive)->player.
clauses
    createPlayerObject(1)=Player:-
        !,
        Player=human::new().
    createPlayerObject(2)=Player:-
        !,
        Player=computer1::new().
    createPlayerObject(3)=Player:-
        !,
        Player=computer2::new().
    createPlayerObject(_)=_Player:-
        exception::raise_user("Wrong player\'s ID",[]).

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
                humanInterface::announceSettingsError(humanInterface::errorMustBeNumber_S),
                fail
            end try,
            if StartingPlayer>list::length(players_V) then
                humanInterface::announceSettingsError(humanInterface::errorStartingPlayer_S),
                fail
            end if
        end if.
    getStartingPlayerInput(PlayListStr)=StartingPlayer:-
        StartingPlayer=getStartingPlayerInput(PlayListStr).

end implement game

/************************
  Class seniorJudge
************************/
class seniourJudge
open core

properties
    inProgress_V:boolean.

predicates
    playSingle:(player CurrentPlayer).
    playMulti:().

end class seniourJudge

implement seniourJudge
open core, humanInterface

class facts
    inProgress_V:boolean:=false.

clauses
    playSingle(Player):-
        inProgress_V=false,
        if game::multiMode_V=false then
            humanInterface::showStage(),
            humanInterface::announceStarter(Player:name)
        end if,
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
            humanInterface::announceSettingsError(humanInterface::errorNoOfRounds_S),
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
        humanInterface::announce
            (
            humanInterface::report_S,
            string::format("\nResults of % games:",toString(PlayersNo*noOfRounds_V))
            ),
        Player=list::getMember_nd(game::players_V),
            PlayerWinsFirst=calculateWins(Player,true),
            PlayerWinsNext=calculateWins(Player,false),
            Report=string::format
                (
                "\nPlayer %:\n\t Wins Total % including:\n\t\tWhile moving first - \t%\n\t\tWhile moving next - \t% ",
                Player:name,
                toString(PlayerWinsFirst+PlayerWinsNext),
                toString(PlayerWinsFirst),
                toString(PlayerWinsNext)
                ),
            humanInterface::announce(humanInterface::report_S,Report),
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

/************************
  Class juniourJudge
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
    defineStage:().
    neighbour_nd: (cell,cell) nondeterm (i,o) (i,i).
    neighbourOutOfPolyLine_nd:(cell,cell)->cell nondeterm.
    set: (string ).
    isGameOver:() determ.
    reset:().

end class juniourJudge

implement juniourJudge
open core, humanInterface

class facts
    maxRow_P:positive:=6.
    maxColumn_P:positive:=6.
    polyline_P:cell*:=[].
    endOfGame_V:boolean:=false.

domains
    fieldSize_D=tableSize(positive X,positive Y).

clauses
    defineStage():-
        defineFieldSize().

class predicates
    defineFieldSize:().
clauses
    defineFieldSize():-
        InputString=humanInterface::getInput
            (
            humanInterface::fieldSize_S,
            string::format("%s,%s",toString(maxColumn_P),toString(maxRow_P))
            ),
        not(InputString=""),
        try
            hasDomain(fieldSize_D,FieldSize),
            FieldSize=toTerm(string::format("tableSize(%s)",InputString)),
            FieldSize=tableSize(X,Y),
            maxColumn_P:=X,
            maxRow_P:=Y
        catch _TraceID do
            humanInterface::announceSettingsError(humanInterface::errorFieldSize_S),
            defineFieldSize()
        end try,
        !.
    defineFieldSize().

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
            _=makePolyLine(Cell,polyline_P)   % it will be an exception if wrong Cell,
                                                            % but we ignore it by failing
        catch _TraceID do
            fail
        end try,
        !,
        endOfGame_V:=true,
        humanInterface::showStep(Cell,winner_S).
    handleInput (Cell):-
        polyline_P:=makePolyLine(Cell,polyline_P),
        !,
        if game::multiMode_V=false then
            humanInterface::showStep(Cell,ordinary_S)
        end if.

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
    setName:(string).
    move:().
    announceWin:().
    announceLoss:().

properties
    name:string.

end interface player

/******************************************
  Class HumanInterface
******************************************/
class humanInterface
open core

predicates
   reset:().

predicates
    announceStartUp:().

predicates
    waitOK:().
    showStage:().
    showStep:(juniourJudge::cell,juniourJudge::stepType_D).
    getInput:(inputType_D,string StringParameter)->string InputString.
    getInput:(inputType_D)->string InputString.

predicates
    announceSettingsError:(choiceError_D).

predicates
    announce:(announceID_D AnnounceID,string AnnounceText).
    announceStarter:(string Name).
    announceThinker:(string Name).
    announceWin:(string Name).
    announceLoss:(string Name).
    announceError:(string Description).
    announceError:().

domains
    announceID_D=
        report_S;
        starter_S.

domains
    choiceError_D=
        errorPlayerType_S;
        errorMustBeNumber_S;
        errorstartingPlayer_S;
        errorFieldSize_S;
        errorNoOfRounds_S.

domains
    inputType_D=
        fieldSize_S;
        playerStep_S;
        playerType_S;
        playerName_S;
        startingPlayer_S;
        searchDepth_S;
        noOfRounds_S;
        singleOrMulti_S.

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

    gameOrCompetition_C="Please choose the mode (S or Enter - single game, other - multiple):".
    fieldSize_C="\nPlease enter the size of the board X,Y (% by default):".
    playerStep_C="Please enter your move as c(X,Y):".
    playerType_C="\n%. Please enter the player type (Enter - end of list):".
    playerName_C="\nPlease assign the name to the player (% proposed):".
    startingPlayer_C="\nWho moves the first (PlayerNo or Enter - end of the game)?:".
    searchDepth_C="\nChoose the depth of the prognosis (% - by default): ".
    noOfRounds_C="\nPlease enter the number of rounds (% by default):".

    errorPlayerType_C="\nNo such player type exiasts! Enter - repeat input:".
    errorMustBeNumber_C="\nMust be number! Please repeat input:".
    errorstartingPlayer_C="\nNo such Player exiasts! Please repeat input:".
    errorFieldSize_C="\nWrong size of the board entered! Please repeat input:".
    errorNoOfRounds_C="\nWrong amount of rounds entered! Please repeat input:".

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
    inputInvitation(fieldSize_S,StringParameter):-
        console::writef(fieldSize_C,StringParameter).
    inputInvitation(noOfRounds_S,StringParameter):-
        console::writef(noOfRounds_C,StringParameter).
    inputInvitation(singleOrMulti_S,_StringParameter):-
        console::write(gameOrCompetition_C).

clauses
    showStage():-
        game::multiMode_V=true,
        !.
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
    showStep(_Point,_Type):-
        game::multiMode_V=true,
        !.
    showStep(juniourJudge::c(X,Y),_Type):-
        console::setLocation(console_native::coord(horizontalSpace_C*X, verticalSpace_C*Y)),
        fail.
    showStep(_Cell,juniourJudge::ordinary_S):-
        console::write(cellMarkedOrdinary_C).
    showStep(_Cell,juniourJudge::winner_S):-
        console::write(cellMarkedWinner_C).

clauses
    announceStartUp():-
        reset().

clauses
    announceStarter(_Name):-
        game::multiMode_V=true,
        !.
    announceStarter(Name):-
        clearMessageArea(starterLine_C),
        writeMessage(starterLine_C,beginner_C,Name).

clauses
    announceSettingsError(errorPlayerType_S):-
        console::write(errorPlayerType_C),
        _=console::readLine().
    announceSettingsError(errorMustBeNumber_S):-
        console::write(errorMustBeNumber_C).
    announceSettingsError(errorStartingPlayer_S):-
        console::write(errorStartingPlayer_C).
    announceSettingsError(errorFieldSize_S):-
        console::write(errorFieldSize_C).
    announceSettingsError(errorNoOfRounds_S):-
        console::write(errorNoOfRounds_C).

clauses
    announce(report_S,Report):-
        !,
        console::write(Report).
    announce(_AnnounceID,_AnnounceText).

clauses
    waitOK():-
        _=console::readLine().
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
    announceThinker(_Name):-
        game::multiMode_V=true,
        !.
    announceThinker(Name):-
        clearMessageArea(announceLine_C),
        clearMessageArea(actionLine_C),
        writeMessage(actionLine_C,thinker_C,Name).

clauses
    reset():-
        console::setLocation(console_native::coord(0,0)),
        console::write(string::create(1600," ")),
        console::clearOutput().

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

/******************************************
  Class human
******************************************/
class human:player
open core
constants
    playerDescriptor_C="Human: Your strategy".
end class human

implement human
open core

facts
    name:string:="Hum_".

clauses
    setName(ProposedId):-
        name:=string::format("%s%s",name,ProposedId),
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

/************************
  Class GenericComputer
************************/
interface genericComputer
    supports player
    supports polyLineBrain

predicates
    setPolyLineBrain:(polyLineBrain).
    stepCandidate: (juniourJudge::cell*,juniourJudge::cell* [out],juniourJudge::cell [out]) nondeterm.

end interface genericComputer

class genericComputer:genericComputer
open core, exception

end class genericComputer

implement genericComputer
open core

    delegate interface polyLineBrain to polyLineBrain_V


facts
    name:string:="Cmp_".
    polyLineBrain_V:polyLineBrain:=erroneous.

clauses
    setName(ProposedId):-
        name:=string::format("%s%s",name,ProposedId),
        Name=humanInterface::getInput(humanInterface::playerName_S,name),
        if not(Name="") then
            name:=Name
        end if.

clauses
    setPolyLineBrain(PolyLineBrainObject):-
        polyLineBrain_V:=PolyLineBrainObject,
        polyLineBrain_V:setGenericComputer(This).

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

predicates
    setGenericComputer:(genericComputer).
    successfulStep: (juniourJudge::cell*)->juniourJudge::cell nondeterm.
    randomStep:()->juniourJudge::cell determ.

end interface polyLineBrain

/******************************************
  Class computer1
******************************************/
class computer1:player
open core

constants
    playerDescriptor_C=polyLineBrain1::playerDescriptor_C.

end class computer1

implement computer1
    inherits genericComputer
open core

clauses
    new():-
        PolyLineBraneObj=polyLineBrain1::new(),
        setPolyLineBrain(PolyLineBraneObj).

end implement computer1

/******************************************
  Class PolylineBrain1
******************************************/
class polyLineBrain1:polyLineBrain
open core

constants
    playerDescriptor_C="Computer1: The full depth search strategy".

end class polyLineBrain1

implement polyLineBrain1
open core, exception

facts
    genericComputer_V:genericComputer:=erroneous.

clauses
    setGenericComputer(GenericComputerObj):-
        genericComputer_V:=GenericComputerObj.

clauses
    successfulStep(PolyLine)=BestMove:-
        genericComputer_V:stepCandidate(PolyLine, _PolyLine1,BestMove),
        list::isMember(BestMove, PolyLine),
        !.
    successfulStep(PolyLine)=Cell:-
        genericComputer_V:stepCandidate(PolyLine, PolyLine1,Cell),
            not(_=successfulStep(PolyLine1)).

clauses
    randomStep()=Cell:-
        CellCandidateListWithDuplicates = [ NewCell || genericComputer_V:stepCandidate(juniourJudge::polyline_P, _Polyline1, NewCell) ],
        CellCandidateList=list::removeDuplicates(CellCandidateListWithDuplicates),
        not(CellCandidateList=[]),
        NoOfVariants=list::length(CellCandidateList),
        ChoiceNo=math::random(NoOfVariants-1),
        Cell=list::nth(ChoiceNo+1,CellCandidateList).

end implement polylineBrain1

/******************************************
  Class computer2
******************************************/
class computer2:player
open core
constants
    playerDescriptor_C=polyLineBrain2::playerDescriptor_C.

end class computer2

implement computer2
    inherits genericComputer
open core

clauses
    new():-
        PolyLineBraneObj=polyLineBrain2::new(),
        setPolyLineBrain(PolyLineBraneObj).

end implement computer2

/******************************************
  Class PolylineBrain2
******************************************/
class polyLineBrain2:polyLineBrain
open core

constants
    playerDescriptor_C="Computer2: Easy strategy. The prognosis depth is limited".

end class polyLineBrain2

implement polyLineBrain2
open core, exception

facts
    depth_V:positive:=5.
    genericComputer_V:genericComputer:=erroneous.

clauses
    new():-
        defineSearchDepth().

clauses
    setGenericComputer(GenericComputerObj):-
        genericComputer_V:=GenericComputerObj.

predicates
    defineSearchDepth:().
clauses
    defineSearchDepth():-
        DepthStr=humanInterface::getInput(humanInterface::searchDepth_S,toString(depth_V)),
        not(DepthStr=""),
        !,
        try
            depth_V:=toTerm(DepthStr),
            if depth_V mod 2 = 0 then
                depth_V:=depth_V+1
            end if
        catch _TraceID1 do
            humanInterface::announceSettingsError(humanInterface::errorMustBeNumber_S),
            defineSearchDepth()
        end try.
    defineSearchDepth().

predicates
    successfulStep: (integer Counter, juniourJudge::cell*)->juniourJudge::cell nondeterm.
clauses
    successfulStep(PolyLine)=BestMove:-
        BestMove=successfulStep(depth_V,PolyLine).

    successfulStep(Counter,PolyLine)=BestMove:-
        genericComputer_V:stepCandidate(PolyLine,_PolyLine1,BestMove),
        isStepSuccessful(Counter,PolyLine,BestMove),
        !.
    successfulStep(Counter,PolyLine)=Cell:-
        genericComputer_V:stepCandidate(PolyLine, PolyLine1,Cell),
            not(_=successfulStep(Counter-1,PolyLine1)).

clauses
    randomStep()=Cell:-
        CellCandidateListWithDuplicates = [ NewCell || genericComputer_V:stepCandidate(juniourJudge::polyline_P, _Polyline1, NewCell) ],
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

end implement polylineBrain2
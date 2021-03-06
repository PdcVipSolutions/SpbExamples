/*********************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline

Predicates, which represent the strategy
  resolveMove,
  moveCandidate,
  successfulMove,
  rule_nd,
based on solutions proposed by Elena Efimova
*********************************************************/
goal
    mainExe::run(main::run).
 
implement main
open core
 
constants
    className = "PolyLine".
    classVersion = "1.0".
 
clauses
    classInfo(className, classVersion).
 
clauses
    run():-
        console::init(),
        game::run().
end implement main
 
/**************************************
The Game class manages the playing process
**************************************/
class game
    open core
 
predicates
    classInfo : core::classInfo.
 
constants
    maxRow_C:positive=6.
    maxColumn_C:positive=6.
 
domains
    cell = c(positive,positive).
    moveType_D=
        ordinary_S;
        winner_S.
 
properties
    polyline_P:cell*.
 
predicates
    run:().
    set:(string CellAsString).
    rule_nd: (cell,cell) nondeterm (i,o) (i,i).
    ruleLimited_nd:(cell,cell)->cell nondeterm.
 
end class game
 
implement game
open core
 
constants
    className = "Game".
    classVersion = "1.0".
 
clauses
    classInfo(className, classVersion).
 
class facts
    human_V:player:=erroneous.
    computer_V:player:=erroneous.
    polyline_P:cell*:=[].
    endOfGame_V:boolean:=false.
 
clauses
    run():-
        human_V:=human::new(),
        computer_V:=computer::new(),
        playerTurn().
 
class predicates
    playerTurn:().
clauses
    playerTurn():-
        PlayerTurnStr=humanInterface::getInput(humanInterface::playerTurn_S),
        not(PlayerTurnStr=""),
        try
            hasDomain(positive,PlayerTurn),
            PlayerTurn=toTerm(PlayerTurnStr),
            if PlayerTurn=2 then
                Player=human_V,
                StarterName="Computer" % because of it is used NextPlayer in the Play predicate
            else
                Player=computer_V,
                StarterName="Human"
            end if,
            humanInterface::showStage(),
            !,
            humanInterface::announceStarter(StarterName),
            play(Player)
        catch _TraceID1 do
            humanInterface::announceChoiceError(humanInterface::errorMustBeNumber_S)
        end try,
            !,
            polyline_P:=[],
            endOfGame_V:=false,
            playerTurn().
    playerTurn().
 
class predicates
    play:(player Player).
clauses
    play(Player):-
        endOfGame_V=true,
        !,
        if Player=human_V then
            humanInterface::announceWin("Human")
        else
            humanInterface::announceWin("Computer")
        end if.
    play(Player):-
        if Player=human_V then
            NextPlayer=computer_V,
            Name="Computer"
        else
            NextPlayer=human_V,
            Name="Human"
        end if,
        !,
        humanInterface::announceMovingPlayer(Name),
        NextPlayer:move(),
        play(NextPlayer).
 
clauses
    set(InputString):-
        Cell=toTerm(InputString),
        handleInput (Cell).
 
class predicates
    handleInput:(cell Cell).
clauses
    handleInput(Cell):-
        list::isMember(Cell,polyline_P),
        try
            _=makePolyLine(Cell,polyline_P)   % If the Cell is not acceptable,
                                                            % then exception appears and we ignore it
                                                            % using fail
        catch _TraceID do
            fail
        end try,
        !,
        endOfGame_V:=true,
        humanInterface::showMove(Cell,winner_S).
    handleInput (Cell):-
        polyline_P:=makePolyLine(Cell,polyline_P),
        !,
        humanInterface::showMove(Cell,ordinary_S).
 
class predicates
    makePolyLine: (cell,cell*)-> cell* multi.
clauses
    makePolyLine(c(X,Y),[])=[c(X,Y)]:-
        X>0,X<=maxColumn_C,
        Y>0,Y<=maxRow_C,
        !.
    makePolyLine(NewCell,[SingleCell])=[NewCell,SingleCell]:-
        game::rule_nd(SingleCell, NewCell),
        !.
    makePolyLine(NewCell,[Left, RestrictingCell | PolyLineTail])=[NewCell, Left, RestrictingCell | PolyLineTail]:-
        NewCell=ruleLimited_nd(Left,RestrictingCell).
    makePolyLine(NewCell,PolyLine)=list::reverse([NewCell,Left, RestrictingCell | PolyLineTail]):-
        [Left, RestrictingCell | PolyLineTail]= list::reverse(PolyLine),
        NewCell=ruleLimited_nd(Left,RestrictingCell).
    makePolyLine(NewCell,_PolyLine)= _PolyLine1:-
        exception::raise(classInfo,wrongMoveException,[namedValue("data",string(toString(NewCell)))]).
 
class predicates
    wrongMoveException:exception.
clauses
    wrongMoveException
        (
        classInfo,
        predicate_Name(),
        "The point % can not prolong the polyline!"
        ).
 
clauses
    ruleLimited_nd(Cell,RestrictingCell)=NewCell:-
        rule_nd(Cell,NewCell),
            not(NewCell = RestrictingCell).
 
clauses
    rule_nd(c(X, Y), c(X + 1, Y)):- X < maxColumn_C.
    rule_nd(c(X, Y), c(X, Y + 1)):- Y < maxrow_C.
    rule_nd(c(X, Y), c(X - 1, Y)):- X > 1.
    rule_nd(c(X, Y), c(X, Y - 1)):- Y > 1.
 
end implement game
 
/******************************************
  Interface Player
  Player in responce to predicate call move()
  must  reply by calling set(ResponceMove)
******************************************/
interface player
 
predicates
    move:().
end interface player
 
/********************************
  The Class Human
********************************/
class human:player
open core
 
end class human
 
implement human
open core, exception
 
clauses
    move():-
        InputString=humanInterface::getInput(humanInterface::playerMove_S),
        try
            game::set(InputString)
        catch TraceID do
            handleException(TraceID),
            fail
        end try,
        !.
    move():-
        move().
 
class predicates
    handleException:(exception::traceId TraceID).
clauses
    handleException(TraceID):-
        foreach Descriptor=exception::getDescriptor_nd(TraceID) do
            Descriptor = exception::descriptor(
                _ClassInfo1,
                exception::exceptionDescriptor(_ClassInfo2,_PredicateName,Description),
                _Kind,
                ExtraInfo,
                _GMTTime,
                _ExceptionDescription,
                _ThreadId),
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
  Class Сomputer
******************************************/
class computer:player
predicates
    classInfo : core::classInfo.
end class computer
 
implement computer
open core
 
constants
    className = "Computer".
    classVersion = "1.0".
 
clauses
    classInfo(className, classVersion).
 
clauses
    move():-
        Cell=resolveMove(),
        game::set(toString(Cell)).
 
predicates
    resolveMove:()->game::cell.
clauses
    resolveMove()=Cell:-
        Cell=successfulMove(game::polyline_P),
        !.
    resolveMove()=Cell:-
        moveCandidate(game::polyline_P,_PolyLine,Cell),
        !.
    resolveMove()=game::c(X+1,Y+1):-
        X=math::random(game::maxColumn_C-1),
        Y=math::random(game::maxRow_C-1).
 
class predicates
    successfulMove: (game::cell*)->game::cell nondeterm.
clauses
    successfulMove(PolyLine)=Cell:-
        moveCandidate(PolyLine,_PolyLine1,Cell),
            list::isMember(Cell, PolyLine),
            !.
    successfulMove(PolyLine)=Cell:-
        moveCandidate(PolyLine, PolyLine1, Cell),
            not(_=successfulMove(PolyLine1)).
 
class predicates
    moveCandidate: (game::cell*,game::cell* [out],game::cell [out]) nondeterm.
clauses
    moveCandidate([Cell],[Cell,NewCell], NewCell):-
        game::rule_nd(Cell, NewCell),
        !.
    moveCandidate([Left, RestrictingCell | PolyLine],[NewCell,Left, RestrictingCell| PolyLine], NewCell):-
        NewCell=game::ruleLimited_nd(Left,RestrictingCell).
    moveCandidate(PolyLine,list::reverse([NewCell,Left, RestrictingCell |PolyLineTail]),NewCell):-
        [Left, RestrictingCell |PolyLineTail] = list::reverse(PolyLine),
        NewCell=game::ruleLimited_nd(Left,RestrictingCell).
 
end implement computer
 
/******************************************
  Class HumanInterface supports the communication
  of the human with the computer
******************************************/
class humanInterface
open core
 
predicates
    showStage:().
    showMove:(game::cell,game::moveType_D).
    getInput:(inputType_D)->string InputString.
 
domains
    inputType_D=
        playerMove_S;
        playerTurn_S.
 
predicates
    announceStarter:(string Name).
    announceMovingPlayer:(string Name).
    announceWin:(string Name).
    announceError:(string Description).
    announceError:().
 
domains
    choiceError_D=
        errorMustBeNumber_S;
        errorPlayerTurn_S.
predicates
    announceChoiceError:(choiceError_D).
 
end class humanInterface
 
implement humanInterface
open core
 
constants
    cellMarkedOrdinary_C="*".
    cellMarkedWinner_C="O".
 
constants % messages
    movingPlayer_C="% is thinking".
    beginner_C="First move done by: %".
    error_C="Error, % ".
    congratulation_C="Player % has won!".
 
    playerMove_C="Enter the move as  c(X,Y): ".
    playerTurn_C="\nWho is moving first (1-human, 2-computer, Enter-exit)?:".
 
    errorMustBeNumber_C="\nIt must be numeric! Please repeat the input:".
    errorPlayerTurn_C="\nNo player with this ID! Please repeat the input:".
 
constants
    verticalSpace_C=2.
    horizontalSpace_C=3.
    emptyLineLenght_C=80.
 
constants % Position of Line
    starterLine_C=1.
    announceLine_C=starterLine_C+1.
    actionLine_C=announceLine_C+1.
    polylineLine_C=actionLine_C+1.
 
clauses
    getInput(InputType)=Input:-
        inputInvitation(InputType),
        Input = console::readLine(),
        console::clearInput().
 
class predicates
    inputInvitation:(inputType_D).
clauses
    inputInvitation(playermove_S):-
        clearMessageArea(actionLine_C),
        writeMessage(actionLine_C,"%",playermove_C).
    inputInvitation(playerTurn_S):-
        console::clearOutput(),
        console::write(playerTurn_C).
 
clauses
    showStage():-
        console::clearOutput(),
        foreach I = std::fromTo(1, game::maxColumn_C) do
            console::setLocation(console_native::coord(horizontalSpace_C*I, 0)),
            console::write(I)
        end foreach,
        foreach J = std::fromTo(1, game::maxRow_C) do
            console::setLocation(console_native::coord(0, verticalSpace_C*J)),
            console::write(J)
        end foreach.
 
clauses
    showMove(game::c(X,Y),_Type):-
        console::setLocation(console_native::coord(horizontalSpace_C*X, verticalSpace_C*Y)),
        fail.
    showMove(_Cell,game::ordinary_S):-
        console::write(cellMarkedOrdinary_C).
    showMove(_Cell,game::winner_S):-
        console::write(cellMarkedWinner_C).
 
clauses
    announceStarter(Name):-
        clearMessageArea(starterLine_C),
        writeMessage(starterLine_C,beginner_C,Name).
 
clauses
    announceChoiceError(errorMustBeNumber_S):-
        console::write(errorMustBeNumber_C),
        _ = console::readLine().
    announceChoiceError(errorPlayerTurn_S):-
        console::write(errorPlayerTurn_C),
        _ = console::readLine().
 
clauses
    announceError():-
        announceError("").
 
    announceError(ErrorText):-
        clearMessageArea(announceLine_C),
        writeMessage(announceLine_C,error_C,ErrorText).
 
clauses
    announceWin(Name):-
        clearMessageArea(announceLine_C),
        writeMessage(announceLine_C,congratulation_C,Name),
        showPolyLine(),
        _ = console::readLine().
 
clauses
    announceMovingPlayer(Name):-
        clearMessageArea(announceLine_C),
        clearMessageArea(actionLine_C),
        writeMessage(actionLine_C,movingPlayer_C,Name).
 
class predicates
    showPolyLine:().
clauses
    showPolyLine():-
        clearMessageArea(actionLine_C),
        writeMessage(polylineLine_C,"%",toString(game::polyline_P)).
 
class predicates
    clearMessageArea:(positive AreaID).
clauses
    clearMessageArea(AreaID):-
        console::setLocation(console_native::coord(0,game::maxRow_C*verticalSpace_C+AreaID)),
        console::write(string::create(emptyLineLenght_C," ")).
 
class predicates
    writeMessage:(positive AreaID,string FormatString,string ParameterString).
clauses
    writeMessage(AreaID,FormatString,ParameterString):-
        console::setLocation(console_native::coord(0, game::maxRow_C*verticalSpace_C+AreaID)),
        console::writef(FormatString,ParameterString).
 
end implement humanInterface
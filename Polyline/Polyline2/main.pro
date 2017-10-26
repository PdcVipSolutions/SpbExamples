/*********************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline

*********************************************************/
goal
    mainExe::run(main::run).

implement main
open core

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

domains
    cell=cell(positive X,positive Y).
    status=status(player Player, cell Move, cell* Line).

constants
    xMax_C:positive=6.
    yMax_C:positive=5.

predicates
    run:().

predicates
    neighbor_nd: (cell Move)-> cell NeghborMove nondeterm.

predicates
    updateLine:(cell* Line, cell Move)->cell* NewLine.

end class game

implement game
open core

class facts
    human_V:player:=erroneous.
    computer_V:player:=erroneous.

clauses
    run():-
        human_V:=human::new(),
        computer_V:=computer::new(),
        InitialPlayerID=getInitialPlayerID(),
        not(InitialPlayerID=3),
        !,
        humanInterface::show([]),
        if InitialPlayerID = 1 then
            LastStatus=play(human_V,[])
        else
            LastStatus=play(computer_V,[])
        end if,
        LastStatus=status(Player,VictoryMove,_Line),
        OppositePlayer=getNextPlayer(Player),
        Player:announceVictory(VictoryMove),
        OppositePlayer:announceDefeat(),
        humanInterface::sayGoodby().
    run().

class predicates
    getInitialPlayerID:()->positive InputString.
clauses
    getInitialPlayerID()=InitialPlayerID:-
        InputString=humanInterface::getInput(humanInterface::getInitialPlayer_S),
        if
            not(InputString = "")
        then
            try
                InitialPlayerID=toTerm(InputString)
            catch TraceID do
                handleException(TraceID),
                fail
            end try
        else
            InitialPlayerID=3
        end if,
        !.
    getInitialPlayerID()=getInitialPlayerID().

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
                _ExtraInfo,
                _GMTTime,
                _ThreadId
                ),
                humanInterface::announceError(Description)
        end foreach.

class predicates
    play:(player Player, cell* Line) -> status Status.
clauses
    play(Player, Line)=Status:-
        Move=Player:getMove(Line),
        if
            tryBelongsTo(Move, Line)
        then
            Status=status(Player,Move,Line)
        else
            NewLine=updateLine(Line,Move),
            NextPlayer=getNextPlayer(Player),
            humanInterface::show(NewLine),
            Status=play(NextPlayer,NewLine)
        end if.

class predicates
    getNextPlayer:(player CurrentPlayer)->player NextPlayer.
clauses
    getNextPlayer(computer_V)=human_V:-!.
    getNextPlayer(_Human)=computer_V.

class predicates
    tryBelongsTo:(game::cell Move,game::cell* Line) determ.
clauses
    tryBelongsTo(Move,Line):-
        list::isMember(Move, Line).

clauses
    updateLine([],cell(X,Y))=[cell(X,Y)]:-
        X>0 and X<=xMax_C,
        Y>0 and X<=yMax_C,
        !.
    updateLine([A],Move)=[A,Move]:-
        A=neighbor_nd(Move),
        !.
    updateLine([A,B|RestOfLine],Move)=[Move,A,B|RestOfLine]:-
        not(Move = B),
        A=neighbor_nd(Move),
        !.
    updateLine(Line,Move)=[Move,A, B |RestOfReversedLine]:-
        [A, B |RestOfReversedLine] = list::reverse(Line),
        not(Move = B),
        A=neighbor_nd(Move),
        !.
    updateLine(_Line,Move)=_NewLine:-
        ErrorMessage=string::format("The Move <%> is wrong! ",Move),
        exception::raise_user(ErrorMessage).

clauses
    neighbor_nd(cell(X, Y))=cell(X - 1, Y):- X > 1.
    neighbor_nd(cell(X, Y))=cell(X + 1, Y):- X < xMax_C.
    neighbor_nd(cell(X, Y))=cell(X, Y - 1):- Y > 1.
    neighbor_nd(cell(X, Y))=cell(X, Y + 1):- Y < yMax_C.

end implement game

/******************************************
  Interface Player
  Player in responce to predicate call move()
  must  reply by calling set(ResponceMove)
******************************************/
interface player

properties
    name_P:string (o).

predicates
    getMove:(game::cell* Line)->game::cell Move.

predicates
    announceVictory:(game::cell VictoryMove).
    announceDefeat:().

end interface player

/********************************
  The Class Human
********************************/
class human:player

end class human

implement human
open core, exception

constants
    victoryChar_C='@'.

clauses
   name_P()="Human".

clauses
    getMove(Line)=Move:-
        InputString=humanInterface::getInput(humanInterface::getMove_S),
        try
            Move=toTerm(InputString),
            _NewLine=game::updateLine(Line,Move)
        catch TraceID do
            handleException(TraceID),
            fail
        end try,
        !.
    getMove(Line)=getMove(Line).

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
                if UserMessage = namedValue::tryGetNamed_string(ExtraInfo, "userMessage")
                then
                    humanInterface::announceError(UserMessage)
                else
                    humanInterface::announceError(Description)
                end if
        end foreach.

clauses
    announceVictory(VictoryMove):-
        humanInterface::announceVictory(VictoryMove,victoryChar_C).

    announceDefeat():-
        humanInterface::announceDefeat().

end implement human

/********************************
  The Class Computer
********************************/
class computer:player

end class computer

implement computer
open core, game

constants
    victoryChar_C='#'.

facts
   name_P:string:="Human".

constants
    initialComputerMove_C:game::cell=cell(3,3).
clauses
    getMove([])=initialComputerMove_C:-
        !.
    getMove(Line)=Move:-
        humanInterface::announceThinking(This),
        Move=getBestMove_nd(Line),
        !.
    getMove(Line)=Move:-
        Move=getPossibleMove_nd(Line),
        !.
    getMove(_Line)=_Move:-
        exception::raise_user("unexpected alternative").

class predicates
    getBestMove_nd:(game::cell* Line)->game::cell Move nondeterm.

clauses
    getBestMove_nd(Line)=Move:-
        Move=getPossibleMove_nd(Line),
            if
                tryBelongsTo(Move, Line)
            then
                !
            else
                NewLine=updateLine(Line,Move),
                not(_BadMove=getBestMove_nd(NewLine))
            end if.

class predicates
    tryBelongsTo:(game::cell Move,game::cell* Line) determ.
clauses
    tryBelongsTo(Move,Line):-
        list::isMember(Move, Line).

class predicates
    getPossibleMove_nd:(cell* Line)-> cell Move nondeterm.
clauses
    getPossibleMove_nd([A])=Move:-
        Move=game::neighbor_nd(A).
    getPossibleMove_nd([A,B|_Line])=Move:-
        Move=game::neighbor_nd(A),
            not(Move = B).
    getPossibleMove_nd(Line)=Move:-
        [A, B |_RestOfReversedLine] = list::reverse(Line),
        Move=game::neighbor_nd(A),
            not(Move = B).

clauses
    announceVictory(VictoryMove):-
        humanInterface::announceVictory(VictoryMove,victoryChar_C ).

    announceDefeat().

end implement computer

/******************************************
  Class HumanInterface supports the communication
  of the human with the computer
******************************************/
class humanInterface
open core

domains
    inputType=
        getMove_S;
        getInitialPlayer_S.

constants % messages
    playerIsThinking_C="% is thinking...".
    inviteToChooseInitialPlayer_C="\nWho makes the first move (1-human, 2-computer, 3 - exit)?:".
    invitePlayerToMakeMove_C="Enter the move as  cell(X,Y): ".
    victoryAnnouncement_C="Congratulations! You have won!\n".
    defeatAnnouncement_C="Sorry. You have lost.\n".
    endOfGameAnnounce_C="End Of Game! Press any key to leave the application ...\n".
    error_C="ERROR! % ".

predicates
    getInput:(inputType)->string InputString.

predicates
    show: (game::cell* Line).

predicates
    announceError:(string Description).

predicates
    announceThinking:(player Player).

predicates
    announceVictory:(game::cell VictoryCell,char VictoryChar).

predicates
    announceDefeat:().

predicates
    sayGoodby:().

end class humanInterface

implement humanInterface
open core, game

constants
    rowHeight_C=2.
    colWidth_C=3.
    emptyLineLenght_C=80.

constants % Position of Line
    announceLine_C=game::yMax_C*rowHeight_C+2.
    actionLine_C=announceLine_C+1.
    moveHistoryLine_C=actionLine_C+2.

clauses
    show(Line):-
        console::clearOutput(),
        foreach Column = std::fromTo(1, xMax_C) do
            console::setLocation(console_native::coord(colWidth_C*Column, 0)),
            console::write(Column)
        end foreach,
        foreach Row = std::fromTo(1, yMax_C) do
            console::setLocation(console_native::coord(0, rowHeight_C*Row)),
            console::write(Row)
        end foreach,
        foreach cell(MoveCol, MoveRow) = list::getMember_nd(Line) do
            console::setLocation(console_native::coord(colWidth_C*MoveCol, rowHeight_C*MoveRow)),
            console::write("*")
        end foreach,
        console::setLocation(console_native::coord(0, moveHistoryLine_C)),
        console::write(Line,"\n").

clauses
    getInput(InputType)=Input:-
        inputInvitation(InputType),
        Input = console::readLine(),
        console::clearInput().

clauses
    sayGoodby():-
        writeMessage(actionLine_C,"%",endOfGameAnnounce_C),
        console::clearInput(),
        _ = console::readChar().

class predicates
    inputInvitation:(inputType).
clauses
    inputInvitation(getMove_S):-
        writeMessage(actionLine_C,"%",invitePlayerToMakeMove_C).
    inputInvitation(getInitialPlayer_S):-
        console::clearOutput(),
        console::write(inviteToChooseInitialPlayer_C).

clauses
    announceError(ErrorText):-
        writeMessage(announceLine_C,error_C,ErrorText).

clauses
    announceVictory(cell(MoveCol, MoveRow),VictoryChar):-
        console::setLocation(console_native::coord(colWidth_C*MoveCol, rowHeight_C*MoveRow)),
        console::write(VictoryChar),
        writeMessage(announceLine_C,"%",victoryAnnouncement_C).

clauses
    announceDefeat():-
        writeMessage(announceLine_C,"%",defeatAnnouncement_C).

clauses
    announceThinking(Player):-
        writeMessage(actionLine_C,playerIsThinking_C,Player:name_P).

class predicates
    writeMessage:(positive AreaID,string FormatString,string ParameterString).
clauses
    writeMessage(AreaID,FormatString,ParameterString):-
        console::setLocation(console_native::coord(0,convert(unsigned16,AreaID))),
        console::write(string::create(emptyLineLenght_C," ")),
        console::setLocation(console_native::coord(0, convert(unsigned16,AreaID))),
        console::writef(FormatString,ParameterString).

end implement humanInterface

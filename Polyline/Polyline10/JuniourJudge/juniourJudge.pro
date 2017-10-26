/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement juniourJudge
    open core

facts
    game_V:game:=erroneous.

clauses
    new(GameObject):-
        game_V:=convert(game,GameObject).

facts
    maxRow_P:positive:=6.
    maxColumn_P:positive:=6.
    polyline_P:polyLineDomains::cell*:=[].
    endOfGame_V:boolean:=false.

domains
    fieldSize_D=tableSize(positive X,positive Y).

clauses
    defineStage():-
        defineFieldSize().

predicates
    defineFieldSize:().
clauses
    defineFieldSize():-
        InputString=game_V:humanInterface_V:getInput(humanInterface::fieldSize_S,string::format("%s,%s",toString(maxColumn_P),toString(maxRow_P))),
        not(InputString=""),
        try
            hasDomain(fieldSize_D,FieldSize),
            FieldSize=toTerm(string::format("tableSize(%s)",InputString)),
            FieldSize=tableSize(X,Y),
            maxColumn_P:=X,
            maxRow_P:=Y
        catch _TraceID do
            game_V:humanInterface_V:announce(humanInterface::errorFieldSize_S,""),
            defineFieldSize()
        end try,
        !.
    defineFieldSize().

clauses
    isGameOver():-
        endOfGame_V=true.

clauses
    onMoveDone(_Object1,_Object2,_Object3,_Value1,string(InputString)):-
        Cell=convertToCell(InputString),
        handleInput (Cell),
        !.
    onMoveDone(_Object1,_Object2,_Object3,_Value1,_Value2).

class predicates
    convertToCell:(string InputString)->polyLineDomains::cell.
clauses
    convertToCell(InputString)=Cell:-
        try
        	Cell = toTerm(InputString)
        catch _TraceID do
        	fail
        end try,
        !.
    convertToCell(InputString)=Cell:-
        CellString=string::format("c(%s)",InputString),
        try
        	Cell = toTerm(CellString)
        catch _TraceID do
        	fail
        end try,
        !.
    convertToCell(InputString)=toTerm(InputString).

clauses
    reset():-
        polyline_P:=[],
        endOfGame_V:=false.

predicates
    handleInput:(polyLineDomains::cell).
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
        game_V:humanInterface_V:showStep(Cell,humanInterface::winner_S).
    handleInput (Cell):-
        polyline_P:=makePolyLine(Cell,polyline_P),
        !,
        game_V:humanInterface_V:showStep(Cell,humanInterface::ordinary_S).

predicates
    makePolyLine: (polyLineDomains::cell,polyLineDomains::cell*)-> polyLineDomains::cell* multi.
clauses
    makePolyLine(polyLineDomains::c(X,Y),[])=[polyLineDomains::c(X,Y)]:-
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
        exception::raise_User("Wrong Move",[namedValue("data",string(toString(NewCell)))]).
%        exception::raise(classInfo,wrongStepException,[namedValue("data",string(toString(NewCell)))]).

clauses
    neighbourOutOfPolyLine_nd(Cell,RestrictingCell)=NewCell:-
        neighbour_nd(Cell,NewCell),
            not(NewCell = RestrictingCell).

clauses
    neighbour_nd(polyLineDomains::c(X, Y), polyLineDomains::c(X + 1, Y)):- X < maxColumn_P.
    neighbour_nd(polyLineDomains::c(X, Y), polyLineDomains::c(X, Y + 1)):- Y < maxrow_P.
    neighbour_nd(polyLineDomains::c(X, Y), polyLineDomains::c(X - 1, Y)):- X > 1.
    neighbour_nd(polyLineDomains::c(X, Y), polyLineDomains::c(X, Y - 1)):- Y > 1.

end implement juniourJudge

/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline

Predicates
    neighbour_nd,
    neighbourOutOfPolyLine_nd
based on solutions proposed by Elena Efimova
******************************************************************************/
implement juniourJudge
    open core

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
        InputString=humanInterface::getInput(humanInterface::fieldSize_S,string::format("%s,%s",toString(maxColumn_P),toString(maxRow_P))),
        not(InputString=""),
        try
            hasDomain(fieldSize_D,FieldSize),
            FieldSize=toTerm(string::format("tableSize(%s)",InputString)),
            FieldSize=tableSize(X,Y),
            maxColumn_P:=X,
            maxRow_P:=Y
        catch _TraceID do
            humanInterface::announce(humanInterface::errorFieldSize_S,""),
            defineFieldSize()
        end try,
        !.
    defineFieldSize().

clauses
    isGameOver():-
        endOfGame_V=true.

clauses
    set(InputString):-
        Cell=convertToCell(InputString),
        handleInput (Cell).

class predicates
    convertToCell:(string InputString)->cell.
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
        exception::raise_user("",[namedValue("data",string(toString(NewCell)))]).

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

/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement juniourJudge
    inherits notificationAgency
    open core, polylineDomains

clauses
    new(_GameObject).

facts
    maxRow_P:positive:=6.
    maxColumn_P:positive:=6.
    polyline_P:polyLineDomains::cell*:=[].
    endOfGame_V:boolean:=false.

clauses
    isGameOver():-
        endOfGame_V=true.

facts
    initialRandomMove_V:polylineDomains::cell:=erroneous.
clauses
    makeInitialExternalMove(initialGame_C):-
        !,
        X=math::random(maxColumn_P-1),
        Y=math::random(maxRow_P-1),
        initialRandomMove_V:=polylineDomains::c(convert(positive,X+1),convert(positive,Y+1)),
        makeExternalMove().
    makeInitialExternalMove(nextGame_C):-
        makeExternalMove().

predicates
    makeExternalMove:().
clauses
    makeExternalMove():-
        polyline_P:=makePolyLine(initialRandomMove_V,polyline_P),
        !,
        notify(This,string(initialExternalMove_C),string(toString(initialRandomMove_V))), % Announces this Player's Move
        notify(This,object(This),none). % Announces player have made Move

clauses
    onMoveDone(_Object1,_Object2,Player,string(polylineDomains::playerMove_C),string(InputString)):-
        Cell=convertToCell(InputString),
        handleInput (convert(player,Player),Cell),
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

constants
    playLimit_C:positive=1000.
%    playLimit_C:positive=10000.
%    playLimit_C:positive=100000.
facts
    moveCounter_V:positive:=playLimit_C.
predicates
    handleInput:(player Player,polyLineDomains::cell).
clauses
    handleInput(Player,c(999,999)):-
        !,
        moveCounter_V:=moveCounter_V-1,
        if moveCounter_V=0 then
            endOfGame_V:=true,
            moveCounter_V:=playLimit_C
        end if,
        notify(This,object(Player),none). % Announces the fact that Player have made Move
    handleInput(Player,Cell):-
        list::isMember(Cell,polyline_P),
        try
            _=makePolyLine(Cell,polyline_P) % it will be an exception if wrong Cell, but we ignore it by failing
        catch _TraceID do
            fail
        end try,
        !,
        endOfGame_V:=true,
        notify(Player,string(winnerMove_C),string(toString(Cell))), % Announces this Player's Move
        notify(This,object(Player),none). % Announces the fact that Player have made Move
    handleInput (Player,Cell):-
        polyline_P:=makePolyLine(Cell,polyline_P),
        !,
        notify(Player,string(ordinaryMove_C),string(toString(Cell))), % Announces this Player's Move
        notify(This,object(Player),none). % Announces player have made Move

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
        exception::raise_User("Wrong Step Exception!",[namedValue(polylineDomains::wrongCellData_C,string(toString(NewCell)))]).

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

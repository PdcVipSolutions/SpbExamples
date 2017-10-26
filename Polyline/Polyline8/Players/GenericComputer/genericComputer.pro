/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement genericComputer
    open core

delegate interface polylineStrategy to polylineStrategy_V

facts
    name:string:="Cmp_".
    polylineStrategy_V:polylineStrategy:=erroneous.

clauses
    setName(ProposedId):-
        name:=string::format("%s%s",name,ProposedId),
        Name=humanInterface::getInput(humanInterface::playerName_S,name),
        if not(Name="") then
            name:=Name
        end if.

clauses
    setpolylineStrategy(PolylineStrategyObject):-
        polylineStrategy_V:=PolylineStrategyObject,
        polylineStrategy_V:setGenericComputer(This).

clauses
    move():-
        humanInterface::announce(humanInterface::thinker_S,name),
        Cell=resolveStep(),
        try
            juniourJudge::set(toString(Cell))
        catch _Trace_D do
            humanInterface::announce(humanInterface::error_S,"Internal Error in the computerStrategy\n"),
            humanInterface::waitOk()
        end try.

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
        humanInterface::announce(humanInterface::win_S,name).

clauses
    announceLoss():-
        humanInterface::announce(humanInterface::loss_S,name).

end implement genericComputer

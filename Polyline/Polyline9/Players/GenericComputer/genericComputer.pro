/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement genericComputer
    open core

delegate interface polylineStrategy to polylineStrategy_V

facts
    game_V:game:=erroneous.

clauses
    new(GameObject):-
        game_V:=GameObject.

facts
    name:string:="Cmp_".
    polylineStrategy_V:polylineStrategy:=erroneous.

clauses
    setName(ProposedId):-
        name:=string::format("%s%s",name,ProposedId),
        Name=game_V:humanInterface_V:getInput(humanInterface::playerName_S,name),
        if not(Name="") then
            name:=Name
        end if.

clauses
    setpolylineStrategy(PolylineStrategyObject):-
        polylineStrategy_V:=PolylineStrategyObject,
        polylineStrategy_V:setGenericComputer(This).

clauses
    move():-
        game_V:humanInterface_V:announce(humanInterface::thinker_S,name),
        Cell=resolveStep(),
        try
            game_V:juniourJudge_V:set(toString(Cell))
        catch _Trace_D do
            game_V:humanInterface_V:announce(humanInterface::error_S,"Internal Error in the computerStrategy\n"),
            game_V:humanInterface_V:waitOk()
        end try.

predicates
    resolveStep:()->polyLineDomains::cell.
clauses
    resolveStep()=Cell:-
        Cell=successfulStep(game_V:juniourJudge_V:polyline_P),
        !.
    resolveStep()=Cell:-
        Cell=randomStep(),
        !.
    resolveStep()=polyLineDomains::c(X+1,Y+1):-
        X=math::random(game_V:juniourJudge_V:maxColumn_P-1),
        Y=math::random(game_V:juniourJudge_V:maxRow_P-1).

clauses
    stepCandidate([Cell],[Cell,NewCell], NewCell):-
        game_V:juniourJudge_V:neighbour_nd(Cell, NewCell).
    stepCandidate([Left, RestrictingCell | PolyLine],[NewCell,Left, RestrictingCell| PolyLine], NewCell):-
        NewCell=game_V:juniourJudge_V:neighbourOutOfPolyLine_nd(Left,RestrictingCell).
    stepCandidate(PolyLine,list::reverse([NewCell,Left, RestrictingCell |PolyLineTail]),NewCell):-
        [Left, RestrictingCell |PolyLineTail] = list::reverse(PolyLine),
        NewCell=game_V:juniourJudge_V:neighbourOutOfPolyLine_nd(Left,RestrictingCell).

clauses
    announceWin():-
        game_V:humanInterface_V:announce(humanInterface::win_S,name).

clauses
    announceLoss():-
        game_V:humanInterface_V:announce(humanInterface::loss_S,name).

end implement genericComputer

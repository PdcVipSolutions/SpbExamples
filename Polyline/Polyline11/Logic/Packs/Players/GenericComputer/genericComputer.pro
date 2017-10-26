/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement genericComputer
    inherits notificationAgency

    open core

    delegate interface polylineStrategy to polylineStrategy_V

facts
    legend_V:integer:=0.

facts
    game_V:game:=erroneous.
    daughter_V:player:=erroneous.
    humanInterface_V:humanInterface:=erroneous.

clauses
    new(GameObject):-
        game_V:=GameObject,
        name:=string::concat(name,toString(This)).

clauses
    stopGame().

clauses
    setDaughter(Daughter):-
        daughter_V:=Daughter.

clauses
    setAttributes(_NamedValue).
    getAttributes()=[].

clauses
    setHumanInterface(HumanInterface):-
        humanInterface_V:=HumanInterface.

facts
    name:string:="Cmp_".
    polylineStrategy_V:polylineStrategy:=erroneous.

clauses
    setpolylineStrategy(PolylineStrategyObject):-
        polylineStrategy_V:=PolylineStrategyObject,
        polylineStrategy_V:setGenericComputer(This).

clauses
    onNotification(_Object1,_Object2,_Object3,object(daughter_V),none):- % Invites to make Move
        humanInterface_V:showStatus(polylineDomains::computerMove(daughter_V)),
        Move=resolveStep(),
        try
            notify(daughter_V,string(polylineDomains::playerMove_C),string(toString(Move))) % Announces this Player's Move
        catch _Trace_D do
            succeed
%            game_V:humanInterface_V:announce(humanInterface::error_S,"Internal Error in the computerStrategy\n")
        end try,
        !.
    onNotification(_Object1,_Object2,_Object3,string(polylineDomains::playerWon_C),string(Name)):- % Notifies the Win
        !,
        notify(This,string(polylineDomains::playerWon_C),string(Name)).
    onNotification(_Object1,_Object2,_Object3,_Value1,_Value2).

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
    isInterrupted():-
        humanInterface_V:canContinue(),
        !,
        fail.
    isInterrupted(). % Interrupts the process

clauses
    stepCandidate([Cell],[Cell,NewCell], NewCell):-
        game_V:juniourJudge_V:neighbour_nd(Cell, NewCell).
    stepCandidate([Left, RestrictingCell | PolyLine],[NewCell,Left, RestrictingCell| PolyLine], NewCell):-
        NewCell=game_V:juniourJudge_V:neighbourOutOfPolyLine_nd(Left,RestrictingCell).
    stepCandidate(PolyLine,list::reverse([NewCell,Left, RestrictingCell |PolyLineTail]),NewCell):-
        [Left, RestrictingCell |PolyLineTail] = list::reverse(PolyLine),
        NewCell=game_V:juniourJudge_V:neighbourOutOfPolyLine_nd(Left,RestrictingCell).

end implement genericComputer

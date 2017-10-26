/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement genericComputer
    inherits notificationAgency
    open core
    delegate interface polylineStrategy to polylineStrategy_V


facts
    game_V:game:=erroneous.
    daughter_V:player:=erroneous.

clauses
    new(GameObject):-
        game_V:=GameObject,
        game_V:seniourJudge_V:subscribe(onNotification).

clauses
    setDaughter(Daughter):-
        daughter_V:=Daughter.

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
    onNotification(_Object1,_Object2,_Object3,object(daughter_V),none):- % Invites to make Move
        game_V:humanInterface_V:announce(humanInterface::thinker_S,name),
        Cell=resolveStep(),
        try
            notify(This,none,string(toString(Cell))) % Announces this Player's Move
        catch _Trace_D do
            game_V:humanInterface_V:announce(humanInterface::error_S,"Internal Error in the computerStrategy\n"),
            game_V:humanInterface_V:waitOk()
        end try,
        !.
    onNotification(_Object1,_Object2,_Object3,object(daughter_V),string(name)):- % Notifies the Win
        !,
        game_V:humanInterface_V:announce(humanInterface::won_S,name).
    onNotification(_Object1,_Object2,_Object3,object(_AnyOther),string(_WinnerName)):-% Notifies the Loss
        !,
        game_V:humanInterface_V:announce(humanInterface::loss_S,name).
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
    stepCandidate([Cell],[Cell,NewCell], NewCell):-
        game_V:juniourJudge_V:neighbour_nd(Cell, NewCell).
    stepCandidate([Left, RestrictingCell | PolyLine],[NewCell,Left, RestrictingCell| PolyLine], NewCell):-
        NewCell=game_V:juniourJudge_V:neighbourOutOfPolyLine_nd(Left,RestrictingCell).
    stepCandidate(PolyLine,list::reverse([NewCell,Left, RestrictingCell |PolyLineTail]),NewCell):-
        [Left, RestrictingCell |PolyLineTail] = list::reverse(PolyLine),
        NewCell=game_V:juniourJudge_V:neighbourOutOfPolyLine_nd(Left,RestrictingCell).

end implement genericComputer

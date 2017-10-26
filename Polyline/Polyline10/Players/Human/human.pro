/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement human
    inherits notificationAgency

    open core

facts
    game_V:game:=erroneous.

clauses
    new(GameObject):-
        game_V:=convert(game,GameObject),
        game_V:seniourJudge_V:subscribe(This:onNotification).

facts
    name:string:="Hum_".

clauses
   getPlayerDescriptor(polyLineDomains::en)="Human: Your strategy".
   getPlayerDescriptor(polyLineDomains::ru)="Человек: Ваша стратегия".

clauses
    setName(ProposedId):-
        name:=string::format("%s%s",name,ProposedId),
        Name=game_V:humanInterface_V:getInput(humanInterface::playerName_S,name),
        if not(Name="") then
            name:=Name
        end if.

predicates
    move:().
clauses
    move():-
        InputString=game_V:humanInterface_V:getInput(humanInterface::playerStep_S),
        try
            notify(This,none,string(InputString))
        catch TraceID do
            handleException(TraceID),
            move()
        end try.

clauses
    onNotification(_Object1,_Object2,_Object3,object(This),none):- % Invites to make Move
        move(),
        !.
    onNotification(_Object1,_Object2,_Object3,object(This),string(name)):-
        !,
        game_V:humanInterface_V:announce(humanInterface::won_S,name).
    onNotification(_Object1,_Object2,_Object3,object(_This),string(_WinnerName)):-% Notifies the Win
        !,
        game_V:humanInterface_V:announce(humanInterface::loss_S,name).% Notifies the Loss
    onNotification(_Object1,_Object2,_Object3,_Value1,_Value2).

predicates
    handleException:(exception::traceId TraceID).
clauses
    handleException(TraceID):-
        foreach Descriptor=exception::getDescriptor_nd(TraceID) do
            Descriptor = exception::descriptor(
                _ProgramPoint,
                _Exception,
                _Kind,
                ExtraInfo,
                _GMTTime,
                _ThreadId),
            if
                ExtraInfo=[namedValue("data",string(CellPointer))]
            then
                game_V:humanInterface_V:announce(humanInterface::errorWrongCell_S,CellPointer)
            else
                game_V:humanInterface_V:announce(humanInterface::error_S,"")
            end if
        end foreach.

end implement human

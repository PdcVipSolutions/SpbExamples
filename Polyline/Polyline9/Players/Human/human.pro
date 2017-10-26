/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement human
    open core

facts
    game_V:game:=erroneous.

clauses
    new(GameObject):-
        game_V:=convert(game,GameObject).

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

clauses
    move():-
        InputString=game_V:humanInterface_V:getInput(humanInterface::playerStep_S),
        try
            game_V:juniourJudge_V:set(InputString)
        catch TraceID do
            handleException(TraceID),
            fail
        end try,
        !.
    move():-
        move().

clauses
    announceWin():-
        game_V:humanInterface_V:announce(humanInterface::win_S,name).

    announceLoss():-
        game_V:humanInterface_V:announce(humanInterface::loss_S,name).

predicates
    handleException:(exception::traceId TraceID).
clauses
    handleException(TraceID):-
        foreach Descriptor=exception::getDescriptor_nd(TraceID) do
            Descriptor = exception::descriptor
                (
                _ProgramPoint,
                _Exception,
                _Kind,
                ExtraInfo,
                _GMTTime,
                _ThreadId
                ),
            if
                ExtraInfo=[namedValue("data",string(CellPointer))]
            then
                game_V:humanInterface_V:announce(humanInterface::errorWrongCell_S,CellPointer)
            else
                game_V:humanInterface_V:announce(humanInterface::error_S,"")
            end if
        end foreach.

end implement human

/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement human
    open core

facts
    name:string:="Hum_".

clauses
   getPlayerDescriptor(game::en)="Human: Your strategy".
   getPlayerDescriptor(game::ru)="Человек: Ваша стратегия".

clauses
    setName(ProposedId):-
        name:=string::format("%s%s",name,ProposedId),
        Name=humanInterface::getInput(humanInterface::playerName_S,name),
        if not(Name="") then
            name:=Name
        end if.

clauses
    move():-
        InputString=humanInterface::getInput(humanInterface::playerStep_S),
        try
            juniourJudge::set(InputString)
        catch TraceID do
            handleException(TraceID),
            fail
        end try,
        !.
    move():-
        move().

clauses
    announceWin():-
        humanInterface::announce(humanInterface::win_S,name).

    announceLoss():-
        humanInterface::announce(humanInterface::loss_S,name).

class predicates
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
                humanInterface::announce(humanInterface::errorWrongCell_S,CellPointer)
            else
                humanInterface::announce(humanInterface::error_S,"")
            end if
        end foreach.

end implement human

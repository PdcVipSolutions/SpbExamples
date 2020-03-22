/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
implement pzlGame
    open core
    open exception

clauses
    new(Container)=convert(iPzlGame, Object):-
        try
            Object = pzl::newByID(iPzlGame::componentID_C, Container)
        catch TraceID do
            Msg = string::format("Can not create the Object of the class %", toString(iPzlGame::componentID_C)),
            continue_User(TraceID, Msg)
        end try.

end implement pzlGame

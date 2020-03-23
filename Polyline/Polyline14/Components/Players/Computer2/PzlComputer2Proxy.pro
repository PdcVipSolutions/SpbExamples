/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
implement pzlComputer2
    open core
    open exception

clauses
    new(Container)=convert(iPzlComputer2, Object):-
        try
        	Object = pzl::newByID(iPzlComputer2::componentID_C, Container)
        catch TraceID do
        	Msg = string::format("Can not create the Object of the class %", toString(iPzlComputer2::componentID_C)),
            continue_User(TraceID, Msg)
        end try.

end implement pzlComputer2

/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
implement pzlComputer1
    open core
    open exception

clauses
    new(Container)=convert(iPzlComputer1, Object):-
        try
        	Object = pzl::newByID(iPzlComputer1::componentID_C, Container)
        catch TraceID do
        	Msg = string::format("Can not create the Object of the class %", toString(iPzlComputer1::componentID_C)),
            continue_User(TraceID, Msg)
        end try.

end implement pzlComputer1

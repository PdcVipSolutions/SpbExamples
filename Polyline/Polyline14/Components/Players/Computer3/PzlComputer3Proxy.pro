/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
implement pzlComputer3
    open core
    open exception

clauses
    new(Container)=convert(iPzlComputer3, Object):-
        try
        	Object = pzl::newByID(iPzlComputer3::componentID_C, Container)
        catch TraceID do
        	Msg = string::format("Can not create the Object of the class %", toString(iPzlComputer3::componentID_C)),
            continue_User(TraceID, Msg)
        end try.

end implement pzlComputer3

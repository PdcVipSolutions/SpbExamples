/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
implement pzlHumanInterface
    open core
    open exception

clauses
    new(Container)=convert(iPzlHumanInterface, Object):-
        try
        	Object = pzl::newByID(iPzlHumanInterface::componentID_C, Container)
        catch TraceID do
        	Msg = string::format("Can not create the Object of the class %", toString(iPzlHumanInterface::componentID_C)),
            continue_User(TraceID, Msg)
        end try.

end implement pzlHumanInterface

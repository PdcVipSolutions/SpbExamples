/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
implement pzlHuman
    open core
    open exception

clauses
    new(Container)=convert(iPzlHuman, Object):-
        try
        	Object = pzl::newByID(iPzlHuman::componentID_C, Container)
        catch TraceID do
        	Msg = string::format("Can not create the Object of the class %", toString(iPzlHuman::componentID_C)),
            continue_User(TraceID, Msg)
        end try.

end implement pzlHuman

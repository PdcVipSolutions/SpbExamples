/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
implement pzlGameStatistics
    open core
    open exception

clauses
    new(Container)=convert(iPzlGameStatistics, Object):-
        try
        	Object = pzl::newByID(iPzlGameStatistics::componentID_C, Container)
        catch TraceID do
        	Msg = string::format("Can not create the Object of the class %", toString(iPzlGameStatistics::componentID_C)),
            continue_User(TraceID, Msg)
        end try.

end implement pzlGameStatistics

/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
implement pzlJuniourJudge
    open core
    open exception

clauses
    new(Container)=convert(iPzlJuniourJudge, Object):-
        try
        	Object = pzl::newByID(iPzlJuniourJudge::componentID_C, Container)
        catch TraceID do
        	Msg = string::format("Can not create the Object of the class %", toString(iPzlJuniourJudge::componentID_C)),
            continue_User(TraceID, Msg)
        end try.

end implement pzlJuniourJudge

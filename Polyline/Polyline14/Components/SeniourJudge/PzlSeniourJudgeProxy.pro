/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
implement pzlSeniourJudge
    open core
    open exception

clauses
    new(Container)=convert(iPzlSeniourJudge, Object):-
        try
        	Object = pzl::newByID(iPzlSeniourJudge::componentID_C, Container)
        catch TraceID do
        	Msg = string::format("Can not create the Object of the class %", toString(iPzlSeniourJudge::componentID_C)),
            continue_User(TraceID, Msg)
        end try.

end implement pzlSeniourJudge

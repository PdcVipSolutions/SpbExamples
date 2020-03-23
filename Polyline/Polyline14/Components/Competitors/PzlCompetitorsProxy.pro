/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
implement pzlCompetitors
    open core
    open exception

clauses
    new(Container)=convert(iPzlCompetitors, Object):-
            try
            	Object = pzl::newByID(iPzlCompetitors::componentID_C, Container)
            catch TraceID do
            	Msg = string::format("Can not create the Object of the class %", toString(iPzlCompetitors::componentID_C)),
                continue_User(TraceID, Msg)
            end try.

end implement
/*****************************************************************************
Copyright (c) 2006-2016 PDCSPB

Author: Виктор Юхтенко/WIN-5L3MH3V6R7Q
******************************************************************************/
implement fePzlHttp_Febe
    open core
    open exception

clauses
    new(Container)=convert(ifePzlHttp_Febe, Object):-
        try
            Object = pzl::newByID(ifePzlHttp_Febe::componentID_C,Container),
        catch TraceID do
            Msg=string::format("Can not create the Object of the class %",toString(ifePzlHttp_Febe::componentID_C)),
            continue_User(TraceID,Msg)
        end try.

end implement fePzlHttp_Febe

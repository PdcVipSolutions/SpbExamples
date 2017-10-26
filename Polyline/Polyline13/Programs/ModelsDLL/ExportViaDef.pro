/*****************************************************************************
Copyright (c) Victor Yukhtenko
******************************************************************************/
implement exportViaDef
    open core

clauses
    computer0_GetPlayerShortDescriptor(Language)=ShortDescription:-
        ShortDescription=computer0::getPlayerShortDescriptor(Language).

clauses
    computer1_GetPlayerShortDescriptor(Language)=ShortDescription:-
        ShortDescription=computer1::getPlayerShortDescriptor(Language).

clauses
    computer2_GetPlayerShortDescriptor(Language)=ShortDescription:-
        ShortDescription=computer2::getPlayerShortDescriptor(Language).

end implement exportViaDef

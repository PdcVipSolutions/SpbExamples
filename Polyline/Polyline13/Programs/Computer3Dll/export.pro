/*****************************************************************************
Copyright (c) Victor Yukhtenko
******************************************************************************/
#export export
implement export
    open core

clauses
    computer3(GameMain)=Computer3:-
        Computer3=computer3::new(GameMain).

clauses
    computer3_GetPlayerShortDescriptor(Language)=ShortDescription:-
        ShortDescription=computer3::getPlayerShortDescriptor(Language).

    % predicate, which is exported by DLL

end implement export

/*****************************************************************************
Copyright (c) Victor Yukhtenko
******************************************************************************/
#export export
implement export
    open core

clauses
    computer0(GameMain)=PlayerAsComputer:-
        PlayerAsComputer=computer0::new(GameMain).
clauses
    computer1(GameMain):-
%    computer1(GameMain)=PlayerAsComputer:-
        _PlayerAsComputer=computer1::new(GameMain). % this is the demonstration of  bug, which will be seen at runtime
clauses
    computer2(GameMain)=PlayerAsComputer:-
        PlayerAsComputer=computer2::new(GameMain).

    % predicate, which is exported by DLL
end implement export

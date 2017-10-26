/*****************************************************************************
Copyright (c) Victor Yukhtenko
******************************************************************************/

implement main inherits mainDll
    open core

clauses
    new():-
        mainDll::new(),
        addDestroyListener(onDestroy).
        %add your initialization code here

predicates
    onDestroy : resourceEventSource::destroyListener.
clauses
    onDestroy(_ObjectMainDll).
    %add your code for unloading DLL here
end implement main

goal
    DLL = main::new(),
    DLL:init().

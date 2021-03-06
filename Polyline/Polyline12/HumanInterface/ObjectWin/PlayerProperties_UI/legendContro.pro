/*****************************************************************************
Copyright (c) Victor Yukhtenko
******************************************************************************/

implement legendContro
    inherits drawControlSupport
    open core, vpiDomains

constants
    className = "SpbSolutions/PlayerProperties_UI/legendContro".
    classVersion = "".

clauses
    classInfo(className, classVersion).

clauses
    new(Parent):-
        new(),
        setContainer(Parent).

clauses
    new():-
        drawControlSupport::new(),
        generatedInitialize().

% This code is maintained automatically, do not update it manually. 19:16:42-29.2.2008
facts

predicates
    generatedInitialize : ().
clauses
    generatedInitialize():-
        setText("legendContro"),
        This:setSize(240, 120).
% end of automatic code
end implement legendContro

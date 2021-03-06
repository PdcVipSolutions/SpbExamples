/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/

interface consoleControlContainer
    open core

predicates
    addControl:(consoleControl ConsoleControl).

predicates
    showControls:().

predicates
    tryDefineFocus:(consoleControl CurrentlyFocusedControl)->consoleControl FocusedControl determ. 

predicates
    invalidate:().

predicates
    invalidateAll:().

predicates
    remove:(consoleControl ControlToBeRemoved).

predicates
    removeAll:().

end interface consoleControlContainer
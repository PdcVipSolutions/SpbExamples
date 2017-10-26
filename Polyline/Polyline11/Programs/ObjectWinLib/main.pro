/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/

implement main
    open core

clauses
    run():-
        TaskWindow = taskWindow::new(),
        TaskWindow:show().
end implement main

goal
    mainExe::run(main::run).

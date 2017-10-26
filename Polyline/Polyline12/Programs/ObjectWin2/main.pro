/*****************************************************************************
Copyright (c) Victor Yukhtenko
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

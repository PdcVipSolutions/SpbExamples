/*****************************************************************************

                        Copyright (c) 2013 Prolog Development Center

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
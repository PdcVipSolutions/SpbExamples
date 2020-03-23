/*****************************************************************************

                        Copyright (c) 2013 SPBrSolutions branch

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
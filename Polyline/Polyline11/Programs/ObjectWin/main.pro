/*****************************************************************************
Copyright (c) Victor Yukhtenko
******************************************************************************/

implement main
    open core

clauses
    run():-
%        console::init(),
%        game::run().
%        vpi::init(),
        TaskWindow = taskWindow::new(),
        TaskWindow:show().
end implement main

goal
    mainExe::run(main::run).

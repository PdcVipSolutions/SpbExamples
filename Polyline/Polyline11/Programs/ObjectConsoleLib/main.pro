/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/

implement main
    open core

clauses
    run():-
        console::init(),
        game::run().

end implement main

goal
    mainExe::run(main::run).

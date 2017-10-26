/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
/*****************
  GOAL
*****************/
goal
    mainExe::run(main::run).

/*****************
  Class Main
*****************/
implement main
    open core

clauses
    run():-
        console::init(),
        game::run().

end implement main

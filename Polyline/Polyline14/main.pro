/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement main
    open core

constants
    className = "SpbSolutions/main".
    classVersion = "".

clauses
    classInfo(className, classVersion).

clauses
    run():-
		pzlPort::init(),
        PzlGame=pzlGame::new(),
        PzlGame:spbRun("").

end implement main

goal
    mainExe::run(main::run).

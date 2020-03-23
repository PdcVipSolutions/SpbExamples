/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
implement pzlGame
    inherits pzlComponent
    inherits game

    open core

clauses
    new(_Container):-
        pzlComponent::new(),
        game::new().

clauses
    new():-
        new(This).

clauses
	pzlInit(_UserText).

clauses
	pzlRun(_UserText):-
        play().

clauses
    pzlComplete():-
        exception::raise_User("Not Supported").

end implement pzlGame

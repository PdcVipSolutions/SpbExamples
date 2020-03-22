/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
implement pzlComputer0
    inherits pzlComponent
    inherits computer0

    open core

clauses
    new(Container):-
        pzlComponent::new(),
        computer0::new(Container).

end implement pzlComputer0

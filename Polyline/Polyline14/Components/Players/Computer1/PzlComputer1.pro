/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
implement pzlComputer1
    inherits pzlComponent
    inherits computer1

    open core

clauses
    new(Container):-
        pzlComponent::new(),
        computer1::new(Container).

end implement pzlComputer1

/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
implement pzlComputer2
    inherits pzlComponent
    inherits computer2

    open core

clauses
    new(Container):-
        pzlComponent::new(),
        computer2::new(Container).

end implement pzlComputer2

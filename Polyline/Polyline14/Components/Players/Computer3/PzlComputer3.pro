/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
implement pzlComputer3
    inherits pzlComponent
    inherits computer3

    open core

clauses
    new(Container):-
        pzlComponent::new(),
        computer3::new(Container).



end implement pzlComputer3

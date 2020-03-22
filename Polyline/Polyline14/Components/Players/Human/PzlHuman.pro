/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
implement pzlHuman
    inherits pzlComponent
    inherits human

    open core

clauses
    new(Container):-
        pzlComponent::new(),
        human::new(Container).



end implement pzlHuman

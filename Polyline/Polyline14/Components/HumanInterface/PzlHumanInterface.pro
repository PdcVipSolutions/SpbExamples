/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
implement pzlHumanInterface
    inherits cHumanInterface
    inherits pzlComponent

    open core

clauses
    new(Container):-
        pzlComponent::new(),
        cHumanInterface::new(convert(game,Container)).

end implement pzlHumanInterface

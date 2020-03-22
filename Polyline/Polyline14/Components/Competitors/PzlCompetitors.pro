/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
implement pzlCompetitors
    inherits pzlComponent
    inherits competitors

    open core

clauses
    new(Container):-
        pzlComponent::new(),
        competitors::new(convert(game,Container)).

end implement pzlCompetitors

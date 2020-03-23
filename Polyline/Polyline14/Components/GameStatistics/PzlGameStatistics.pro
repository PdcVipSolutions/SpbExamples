/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
implement pzlGameStatistics
    inherits pzlComponent
    inherits gameStatistics

    open core

clauses
    new(Container):-
        pzlComponent::new(),
        gameStatistics::new(convert(game,Container)).

end implement pzlGameStatistics

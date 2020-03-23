/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
implement pzlSeniourJudge
    inherits pzlComponent
    inherits seniourJudge

    open core
    open stdIO

clauses
    new(Container):-
        pzlComponent::new(),
        seniourJudge::new(convert(game,Container)) .


end implement pzlSeniourJudge

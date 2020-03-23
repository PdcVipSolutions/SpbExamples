/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
implement pzlJuniourJudge
    inherits pzlComponent
    inherits juniourJudge

    open core

clauses
    new(Container):-
        pzlComponent::new(),
        juniourJudge::new(Container).

end implement pzlJuniourJudge

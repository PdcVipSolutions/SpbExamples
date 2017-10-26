/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
class game
    open core

domains
    language_D=
        en;
        ru.

properties
    language_V:language_D.
    players_V:player*.
    multiMode_V:boolean.

predicates
    run:().
    addPlayer:(player Player).

end class game

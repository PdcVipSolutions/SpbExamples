/*****************************************************************************
Copyright (c) Victor Yukhtenko
******************************************************************************/
implement game_UI
    open core

constants
    className = "SpbDemo/Game_UI".
    classVersion = "".

clauses
    classInfo(className, classVersion).

facts
    game_V:game:=erroneous.
    
clauses
    new(GameObject):-
        game_V:=convert(game,GameObject).


end implement game_UI

/*****************************************************************************
Copyright (c) Victor Yukhtenko
******************************************************************************/
class game_UI : game_UI
    open core

predicates
    classInfo : core::classInfo.
    % @short Class information  predicate. 
    % @detail This predicate represents information predicate of this class.
    % @end

constructors
    new:(object GameObject).
    
end class game_UI
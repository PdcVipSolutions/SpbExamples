/*****************************************************************************
Copyright (c) Victor Yukhtenko
******************************************************************************/
class export
    open core

predicates
%    computer0 : (game)->player language stdcall as "computer5".
    computer0 : (game)->player language stdcall as "computer0".

predicates
%    computer1 : (game)->player language prolog as "computer1".
    computer1 : (game) language prolog as "computer1".

predicates
    computer2 : (game)->player language prolog as "computer2".

end class export
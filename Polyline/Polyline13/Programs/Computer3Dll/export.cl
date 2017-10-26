/*****************************************************************************
Copyright (c) Victor Yukhtenko
******************************************************************************/
class export
    open core

predicates
    computer3 : (game)->player procedure (i)  language stdcall as "computer3".

predicates
    computer3_GetPlayerShortDescriptor:(polyLineDomains::language_D)->string ShortDescription language stdcall as "modelTitle3".

end class export
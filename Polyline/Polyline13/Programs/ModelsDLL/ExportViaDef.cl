/*****************************************************************************
Copyright (c) Victor Yukhtenko
******************************************************************************/
class exportViaDef
    open core

predicates
    computer0_GetPlayerShortDescriptor:(polyLineDomains::language_D)->string ShortDescription language stdcall as "modelTitle0".

predicates
    computer1_GetPlayerShortDescriptor:(polyLineDomains::language_D)->string ShortDescription language prolog as "modelTitle1".

predicates
    computer2_GetPlayerShortDescriptor:(polyLineDomains::language_D)->string ShortDescription language prolog as "modelTitle2".

end class exportViaDef
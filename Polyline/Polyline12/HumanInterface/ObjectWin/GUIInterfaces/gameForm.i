/*****************************************************************************
Copyright (c) Victor Yukhtenko
******************************************************************************/
interface gameForm 
    supports dialog
    supports humanInterface
    
    open core

predicates
    status:(string StatusText).

properties
    localization_V:polyLineText.

predicates
    getText:(polylineText::actionID_D)->string Text.

predicates
    announce:(polylineText::actionID_D AnnounceID,string AnnounceText).

end interface gameForm
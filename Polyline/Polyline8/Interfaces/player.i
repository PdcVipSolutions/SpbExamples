/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
interface player
    open core

predicates
    setName:(string).
    move:().
    announceWin:().
    announceLoss:().
 
properties
    name:string.

end interface player
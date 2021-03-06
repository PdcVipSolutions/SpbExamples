/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
interface humanInterface
    supports notificationAgency

    open core

domains
    textID_D=
        wonMsg_S;
        errorMsg_S.

properties
    logicProvider_V:game.

predicates
    showUI:().

predicates
    showStatus:(polylineDomains::gameStatus_D).
 
predicates
    canContinue :() determ ().

predicates
    inLoopPoint:().
    
predicates
    setLanguage:(polyLineDomains::language_D).

end interface humanInterface

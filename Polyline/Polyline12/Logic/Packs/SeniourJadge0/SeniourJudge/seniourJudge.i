/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
interface seniourJudge
    supports notificationAgency
    open core

properties
    inProgress_V:boolean.
    multiMode_V:boolean.
    starter_V:player.
    noOfRounds_V:positive.
    gameCounter_V:positive.
    externalFirstMove_V:boolean.

predicates
    resetStarter:().
    
predicates
    onUIRequest:notificationAgency::notificationListener.

predicates
    play:().
 
end interface seniourJudge

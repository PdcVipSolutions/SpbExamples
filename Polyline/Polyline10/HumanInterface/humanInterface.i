/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
interface humanInterface
    open core

domains
    stepType_D=
        ordinary_S;
        winner_S.

domains
    actionID_D=
        starter_S;
        thinker_S;
 
        reportHeader_S;
        playerReport_S;
        report_S;
 
        won_S;
        loss_S;
 
        round_S;
        continueMultiGame_S;

        singleOrMultipleChoice_S;
        fieldSize_S;
        playerStep_S;
        playerType_S;
        playerName_S;
        startingPlayer_S;
        searchDepth_S;
        noOfRounds_S;
 
        singleOrMulti_S;
 
        error_S;
        errorPlayerType_S;
        errorMustBeNumber_S;
        errorstartingPlayer_S;
        errorFieldSize_S;
        errorNoOfRounds_S;
        errorWrongCell_S.

predicates
    reset:().
 
predicates
    announceStartUp:().
 
predicates
    setLanguage:(polyLineDomains::language_D).
    waitOK:().
    showStage:().
    showStep:(polyLineDomains::cell,stepType_D).
    getInput:(actionID_D,string StringParameter)->string InputString.
    getInput:(actionID_D)->string InputString.
    announce:(actionID_D AnnounceID,string AnnounceText).

end interface humanInterface

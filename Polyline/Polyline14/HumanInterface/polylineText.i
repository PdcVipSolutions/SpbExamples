/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
interface polylineText
    open core

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
    getText:(actionID_D)->string Text.

end interface polylineText
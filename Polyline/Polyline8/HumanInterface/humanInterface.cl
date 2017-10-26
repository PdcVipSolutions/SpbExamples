/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
class humanInterface
    open core

domains
    actionID_D=
        beginner_S;
        thinker_S;
        congratulation_S;
        sorryLoss_S;

        reportHeader_S;
        playerReport_S;
        report_S;

        round_S;
        starter_S;

        win_S;
        loss_S;

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
    setLanguage:(game::language_D).
    waitOK:().
    showStage:().
    showStep:(juniourJudge::cell,juniourJudge::stepType_D).
    getInput:(actionID_D,string StringParameter)->string InputString.
    getInput:(actionID_D)->string InputString.
    announce:(actionID_D AnnounceID,string AnnounceText).

end class humanInterface
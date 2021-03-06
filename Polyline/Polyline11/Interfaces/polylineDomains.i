/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
interface polylineDomains
    open core

constants
    descriptorID_C="descriptor".
    shortDescriptorID_C="shortDescriptor".
    maxDepthID_C="MaxDepth".

constants % predefinded legends
    juniourJudgeMove_C:integer=0x0.
    
constants
    wrongCellData_C="wrongCell".

constants
    initialExternalMove_C="external".
    ordinaryMove_C="ordinary".
    winnerMove_C="winner".

constants
    uiRequestRun_C="Run".
    uiRequestStop_C="Stop".

domains
    roundPhase_D=boolean.
constants
    initialGame_C:roundPhase_D=true.
    nextGame_C:roundPhase_D=false.

constants
    uiRequestDatabase_C="database".
    databaseClear_C="clear".

constants
    playerMove_C="playerMove".
    humanMove_C="humanMove".
    playerWon_C="playerWon".

constants
    gameComplete_C="complete".
    dataModifiedEventID_C="dataModified".

domains
    cell = c(positive Xaxis,positive Yaxis).

domains
    language_D=
        en; % English
        ru.  % Russian

domains
    direction_D=
        up;
        down.

domains
    gameStatus_D=
        newSize;
        initial;
        humanMove(player Player);
        computerMove(player Player);
        newGame;
        interrupted;
        complete.

end interface polylineDomains

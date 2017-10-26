/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/

implement polyLineTextEn
open core, humanInterface

clauses
    getText(TextID)=Text:-
        Text=getTextInt(TextID),
        !.
    getText(_TextID)="No Text Exists".

class predicates
    getTextInt:(humanInterface::actionID_D TextID)->string Text determ.
clauses
    getTextInt(thinker_S)="% is thinking ...".
    getTextInt(round_S)="Round: %".
    getTextInt(starter_S)="First move done by: %".
    getTextInt(won_S)="Player % won!".
    getTextInt(loss_S)="%,  Sorry, you loss :-(".

    getTextInt(singleOrMultipleChoice_S)="Please choose the mode (S or Enter - single game, other - multiple):".
    getTextInt(fieldSize_S)="\nPlease enter the size of the playing field X,Y (% by default):".
    getTextInt(playerStep_S)="Please enter your move as c(X,Y) or as X,Y: ".
    getTextInt(playerType_S)="\nPossible player types:\n%s\nPlayer #%s. Please enter the player type (Enter - end of list):".
    getTextInt(playerName_S)="\nPlease assign the name to the player (% proposed):".
    getTextInt(startingPlayer_S)="\nWho moves the first (PlayerNo or Enter - end of the game)?:".
    getTextInt(searchDepth_S)="\nChoose the depth of the prognosis (% - by default): ".
    getTextInt(noOfRounds_S)="\nPlease enter the number of games (% by default):".
    getTextInt(reportHeader_S)="\nResult of % games:".
    getTextInt(playerReport_S)="\nPlayer %:\n\t Wins Total % and:\n\t\tWhile first move - \t%\n\t\tWhile next move - \t% ".
    getTextInt(continueMultiGame_S)="\n\nNew set of rounds (Enter - end of game, Other - Yes)?".


    getTextInt(error_S)="Error, % ".
    getTextInt(errorPlayerType_S)="\nNo such player type exiasts! Enter - repeat input:".
    getTextInt(errorMustBeNumber_S)="\nMust be number! Please repeat input:".
    getTextInt(errorstartingPlayer_S)="\nNo such Player exiasts! Please repeat input:".
    getTextInt(errorFieldSize_S)="\nWrong size of the field entered! Please repeat input:".
    getTextInt(errorNoOfRounds_S)="\nWrong amount of games entered! Please repeat input:".
    getTextInt(errorWrongCell_S)="The Move % doesn't prolong the PolyLine:".

end implement polyLineTextEn

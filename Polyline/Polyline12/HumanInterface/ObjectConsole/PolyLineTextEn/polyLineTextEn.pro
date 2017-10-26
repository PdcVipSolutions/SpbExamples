/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/

implement polyLineTextEn
open core, humanInterface

clauses
    getText(won_S)="Player % won!":-!.
    getText(loss_S)="%,  Sorry, you loss :-(":-!.

    getText(error_S)="Error, % ":-!.
    getText(errorWrongCell_S)="The Move % doesn't prolong the PolyLine":-!.

    getText(_Any)=_:-
        exception::raise_User("No text for the given TextID").

end implement polyLineTextEn

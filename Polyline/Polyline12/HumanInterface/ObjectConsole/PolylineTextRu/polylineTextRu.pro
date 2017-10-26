/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/

implement polylineTextRu
    open core, humanInterface

clauses
    getText(won_S)="Игрок % выиграл!":-!.
    getText(loss_S)="%,  к сожалению, Вы проиграли :-(":-!.

    getText(error_S)="Ошибка, % ":-!.
    getText(errorWrongCell_S)="Ход % не может быть продолжением линии":-!.

    getText(_Any)=_:-
        exception::raise_User("Текст для данного ID не предусмотрен").

end implement polylineTextRu

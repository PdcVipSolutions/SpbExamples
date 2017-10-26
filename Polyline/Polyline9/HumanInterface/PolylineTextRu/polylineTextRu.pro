/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/

implement polylineTextRu
    open core, humanInterface

clauses
    getText(TextID)=Text:-
        Text=getTextInt(TextID),
        !.
    getText(_TextID)="Текст не предусмотрен".

class predicates
    getTextInt:(humanInterface::actionID_D TextID)->string Text determ.
clauses
    getTextInt(thinker_S)="% думает ...".
    getTextInt(round_S)="Раунд: %".
    getTextInt(beginner_S)="Первый ход: %".
    getTextInt(congratulation_S)="Игрок % выиграл!".
    getTextInt(sorryLoss_S)="%,  к сожалению, Вы проиграли :-(".

    getTextInt(singleOrMultipleChoice_S)="Выберите режим (S или Enter - одиночная игра, другое - мульти):".
    getTextInt(fieldSize_S)="\nВведите размер игрового поля X,Y (по умолчанию %):".
    getTextInt(playerStep_S)="Введите координаты клетки как c(X,Y) или как X,Y: ".
    getTextInt(playerType_S)="\nВозможные типы игроков:\n%s\nИгрок #%s. Укажите тип (Enter - конец выбора игроков):".
    getTextInt(playerName_S)="\nВведите имя Игрока (предлагается %):".
    getTextInt(startingPlayer_S)="\nКто первый ходит (номер Игрока или Enter - конец игры)?:".
    getTextInt(searchDepth_S)="\nУкажите глубину поиска решения в шагах(% - по умолчанию): ".
    getTextInt(noOfRounds_S)="\nВведите число партий игры (по умолчанию %):".
    getTextInt(reportHeader_S)="\nРезультаты % игр:".
    getTextInt(playerReport_S)="\nИгрок %:\n\t Всего побед % из них:\n\t\tПри ходе первым - \t%\n\t\tПри ходе следующим - \t% ".

    getTextInt(error_S)="Ошибка, % ".
    getTextInt(errorPlayerType_S)="\nТакого ТИПА Игрока нет! Enter - для повторного ввода:".
    getTextInt(errorMustBeNumber_S)="\nДолжен быть номер! Повторите ввод:".
    getTextInt(errorstartingPlayer_S)="\nТакого Игрока нет! Повторите ввод:".
    getTextInt(errorFieldSize_S)="\nНеправильно указан размер игрового поля! Повторите ввод:".
    getTextInt(errorNoOfRounds_S)="\nНеправильно указано число партий! Повторите ввод:".
    getTextInt(errorWrongCell_S)="Ход % не может быть продолжением линии:".

end implement polylineTextRu

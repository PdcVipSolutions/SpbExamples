/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/

implement gameViewLocalization
    open core

clauses
    getText(polylineDomains::en,viewBoard_S)="Vie&w Board".
    getText(polylineDomains::ru,viewBoard_S)="Показать Ходы".
    getText(polylineDomains::en,viewStatistics_S)="View Statistics".
    getText(polylineDomains::ru,viewStatistics_S)="Статистика".
    getText(polylineDomains::en,clearStatistics_S)="Cle&ar Statistics".
    getText(polylineDomains::ru,clearStatistics_S)="Очистить".
    getText(polylineDomains::en,playerReport_S)="\nPlayer %:\n    Wins Total % and:\n        While first move - \t%\n        While next move - \t% ".
    getText(polylineDomains::ru,playerReport_S)="\nИгрок %:\n    Всего побед % из них:\n        При ходе первым - \t%\n        При ходе следующим - \t% ".

end implement gameViewLocalization

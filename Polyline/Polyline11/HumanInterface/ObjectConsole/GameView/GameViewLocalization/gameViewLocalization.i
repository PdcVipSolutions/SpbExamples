/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
interface gameViewLocalization
    open core

domains
    textID_D=
        viewBoard_S;
        viewStatistics_S;
        clearStatistics_S;
        playerReport_S.

predicates
    getText:(polylineDomains::language_D Language,textID_D TextID)->string LocalizedText.

end interface gameViewLocalization
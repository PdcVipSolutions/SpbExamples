/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/

interface gameStatistics
    supports notificationAgency
    open core

predicates
    addWinner:(boolean TrueIfStarted,string PlayerID).

predicates
    getStatistics:()->string. % [PlayerName,WinsTotalStr,WinsFirstStr,WinsNextSTr]*


end interface gameStatistics
/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement gameStatistics
    inherits notificationAgency
    open core

facts
    game_V:game:=erroneous.

clauses
    new(GameObj):-
        game_V:=convert(game,GameObj),
        game_V:humanInterface_V:subscribe(onClearStatistics,string(polylineDomains::uiRequestDatabase_C)).

predicates
    onClearStatistics:notificationAgency::notificationListenerFiltered.
clauses
    onClearStatistics(_Object_2,_Object_3,string(polylineDomains::databaseClear_C)):-
        retractAll(statistics_F(_,_,_)),
        notify(This,string(polylineDomains::dataModifiedEventID_C),unsigned(convert(unsigned,countRecords()))),
        !.
    onClearStatistics(_Object_2,_Object_3,_Value2).

facts
    statistics_F:(boolean TrueIfWon,string PlayerID,positive Won).

facts
    wins_V:integer:=0.
predicates
    calculateWins:(string PlayerID,boolean TrueIfFirst)->integer Sum.
clauses
    calculateWins(PlayerID,TrueIfFirst)=_:-
        wins_V:=0,
        statistics_F(TrueIfFirst,PlayerID,Won),
            try
            	wins_V := wins_V + Won
            catch _TraceID do
            	fail
            end try,
        fail.
    calculateWins(_PlayerID,_TrueIfFirst)=wins_V.

clauses
    addWinner(_TrueIfStarted,_PlayerID):-
        notify(This,string(polylineDomains::dataModifiedEventID_C),unsigned(countRecords()+1)),
        fail.
    addWinner(TrueIfStarted,PlayerID):-
        retract(statistics_F(TrueIfStarted,PlayerID,Won)),
        !,
        assert(statistics_F(TrueIfStarted,PlayerID,Won+1)).
    addWinner(TrueIfStarted,PlayerID):-
        assert(statistics_F(TrueIfStarted,PlayerID,1)).

facts
    count_V:positive:=0.
predicates
    countRecords:()->positive.
clauses
    countRecords()=_Count:-
        count_V:=0,
        statistics_F(_TrueIfFirst,_PlayerID,_Won),
            count_V:=count_V+1,
        fail.
    countRecords()=count_V.

clauses
    getStatistics()=toString(PlayerResiltListList):-
        PlayerResiltListList = [ PlayerResiltList || PlayersListWithDuplicates = [ Player || statistics_F(_TrueIfStarted, Player, _Wins) ],
        PlayersListUnsorted = list::removeDuplicates(PlayersListWithDuplicates),
        PlayersList = list::sort(PlayersListUnsorted),
        PlayerID = list::getMember_nd(PlayersList),
        WinsFirst = calculateWins(PlayerID, true),
        WinsNext = calculateWins(PlayerID, false),
        WnsTotal = WinsFirst + WinsNext,
        PlayerResiltList = [PlayerID, toString(WnsTotal), toString(WinsFirst), toString(WinsNext)] ].

end implement gameStatistics

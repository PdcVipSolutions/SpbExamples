/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement gameView
    inherits consoleControl
    inherits consoleControlContainer
    inherits gameViewLocalization

    open core

clauses
    new(ConsoleControlContainer):-
        new(),
        setConsoleControlContainer(ConsoleControlContainer).

facts
    statisticsPB_ctl:consoleButtonControl:=erroneous.
    clearStatisticsPB_ctl:consoleButtonControl:=erroneous.
    gameBoard_ctl:gameBoard:=erroneous.
    statisticsView_ctl:statisticsView:=erroneous.
    wait_ctl:consoleWaitControl:=erroneous.

clauses
    new():-
        statisticsPB_ctl:=consoleButtonControl::new(This),
        statisticsPB_ctl:setPosition(0,1),
        statisticsPB_ctl:setWidth(17),
        statisticsPB_ctl:setText("Show Statistics"),
        statisticsPB_ctl:setVisible(true),

        clearStatisticsPB_ctl:=consoleButtonControl::new(This),
        clearStatisticsPB_ctl:setPosition(22,1),
        clearStatisticsPB_ctl:setWidth(18),
        clearStatisticsPB_ctl:setText("Clear Statistics"),
        clearStatisticsPB_ctl:setVisible(false),

        gameBoard_ctl:=gameBoard::new(This),
        gameBoard_ctl:setPosition(2,2),
        gameBoard_ctl:setHeight(18),
        gameBoard_ctl:setWidth(80),
        gameBoard_ctl:setText("gameBoard"),
        gameBoard_ctl:subscribe(onMouseMove,string(humanInterfaceConsole::boardPosition_C)),
        gameBoard_ctl:setVisible(true),

        statisticsView_ctl:=statisticsView::new(This),
        statisticsView_ctl:setPosition(2,2),
        statisticsView_ctl:setHeight(18),
        statisticsView_ctl:setWidth(80),
        statisticsView_ctl:setText("statisticsView"),
        statisticsView_ctl:setVisible(false),

        wait_ctl:=consoleWaitControl::new(This),
        wait_ctl:setPosition(2,2),
        wait_ctl:setHeight(1),
        wait_ctl:setWidth(1),
        wait_ctl:setVisible(true),

        subscribe(onShow,string(consoleEventSource::showEventID_C)),
        statisticsPB_ctl:subscribe(onShowStatisticsOrMoves,string(consoleEventSource::buttonClickEventID_C)),
        clearStatisticsPB_ctl:subscribe(onClearStatistics,string(consoleEventSource::buttonClickEventID_C)).

predicates
    onShow:notificationAgency::notificationListenerFiltered.
clauses
    onShow(_NotificationAgency,This,none):-
        !,
        showBackGround().
    onShow(_NotificationAgency,_This,_AnyValue).

clauses
    showProgress():-
        wait_ctl:tic().

clauses
    showStatus(GameStatus):-
        if GameStatus=polylineDomains::computerMove(_Player)
        then
            wait_ctl:setEnabled(true)
        else
            wait_ctl:setEnabled(false)
        end if,
        gameBoard_ctl:showStatus(GameStatus),
        fail.
    showStatus(GameStatus):-
        gameBoard_ctl:showStatus(GameStatus),
        fail.
    showStatus(polylineDomains::complete):-
        !,
        showStatistics().
    showStatus(_GameStatus).

domains
    stringStarStar_D=string**.
predicates
    showStatistics:().
clauses
    showStatistics():-
        HumanInterface=convert(humanInterface,getConsoleRoot()),
        PlayerResiltListListStr=HumanInterface:logicProvider_V:gameStatistics_V:getStatistics(),
        hasDomain(stringStarStar_D,PlayerResultListList),
        PlayerResultListList=toTerm(PlayerResiltListListStr),
        PlayerReportList = [ PlayerReport || hasDomain(string, Name),
        [Name, WinsTotal, WinsFirst, WinsNext] = list::getMember_nd(PlayerResultListList),
        PlayerReport = string::format(getText(HumanInterface:logicProvider_V:language_V, playerReport_S), Name, WinsTotal, WinsFirst, WinsNext) ],
            StatisticsText=string::concatList(PlayerReportList),
            statisticsView_ctl:setText(StatisticsText).

predicates
    onShowStatisticsOrMoves:notificationAgency::notificationListenerFiltered.
clauses
    onShowStatisticsOrMoves(_NotificationAgency,_NotificationSource,none):-
        if true=gameBoard_ctl:getVisible() then
            statisticsPB_ctl:setText("ShowMoves"),
            gameBoard_ctl:setVisible(false),
            statisticsView_ctl:setVisible(true),
            clearStatisticsPB_ctl:setVisible(true)
        else
            statisticsPB_ctl:setText("Show Statistics"),
            statisticsView_ctl:setVisible(false),
            clearStatisticsPB_ctl:setVisible(false),
            gameBoard_ctl:setVisible(true)
        end if,
        !.
    onShowStatisticsOrMoves(_NotificationAgency,_NotificationSource,_EventValue).

predicates
    onClearStatistics:notificationAgency::notificationListenerFiltered.
clauses
    onClearStatistics(_NotificationAgency,_NotificationSource,none):-
        !,
        HumanInterface=convert(humanInterface,getConsoleRoot()),
        HumanInterface:notify(This,string(polylineDomains::uiRequestDatabase_C),string(polylineDomains::databaseClear_C)),
        statisticsView_ctl:setText("").
    onClearStatistics(_NotificationAgency,_NotificationSource,_AnyValue).

predicates
    onMouseMove:notificationAgency::notificationListenerFiltered.
clauses
    onMouseMove(_NotificationAgency,gameBoard_ctl,string(CellTxt)):-
        HumanInterface=getConsoleControlContainer(),
        convert(humanInterfaceConsole,HumanInterface):statusLIne_V:setText(CellTxt),
        !.
    onMouseMove(_NotificationAgency,_AnyID,_AnyValue).

clauses
    updateView():-
        !,
        showBackGround().

predicates
    showBackGround:().
clauses
    showBackGround():-
        console_native::coord(X,Y)=getCtrlLocation(),
        console::setLocation(console_native::coord(X,Y)),
        console::write(".. Game View .....................................").

end implement gameView

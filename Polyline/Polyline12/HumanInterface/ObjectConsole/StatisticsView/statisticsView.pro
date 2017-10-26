/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement statisticsView
    inherits consoleControl
    open core

clauses
    new(ConsoleControlContainer):-
        new(),
        setConsoleControlContainer(ConsoleControlContainer).

clauses
    new():-
        subscribe(onShow,string(consoleEventSource::showEventID_C)).

predicates
    onShow:notificationAgency::notificationListenerFiltered.
clauses
    onShow(_NotificationAgency,_NotificationSource,_AnyData):-
        GameStatistics=convert(humanInterface,getConsoleRoot()):logicProvider_V:gameStatistics_V,
        GameStatistics:subscribe(onDataModified,string(polylineDomains::dataModifiedEventID_C)).

clauses
    trySetFocus():-
        ThisControlLocation=getCtrlLocation(),
        console::setLocation(ThisControlLocation).

predicates
    onDataModified:notificationAgency::notificationListenerFiltered.
clauses
    onDataModified(_NotificationAgency,_NotificationSource,unsigned(RecordsAmount)):-
        if RecordsAmount>0 then
            setHeight(RecordsAmount*4+1)
        end if,
        !.
    onDataModified(_NotificationAgency,_NotificationSource,_AnyData).

clauses
    updateView():-
        (getEnabled()=false or getVisible()=false),
        !.
    updateView():-
        Location=getCtrlLocation(),
        console::setLocation(Location),
        console::setModeProcessed(true),
        console::write(getText()),
        console::setModeProcessed(false).

end implement statisticsView

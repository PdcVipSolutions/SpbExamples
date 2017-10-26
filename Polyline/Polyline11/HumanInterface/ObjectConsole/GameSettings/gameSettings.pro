/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement gameSettings
    inherits consoleControl
    inherits consoleControlContainer

    open core

clauses
    new(ConsoleControlContainer):-
        new(),
        setConsoleControlContainer(ConsoleControlContainer).

facts % controls
    xSizeTitle_ctl:consoleTextControl:=erroneous.
    xSize_ctl:consoleEditControl:=erroneous.
    ySizeTitle_ctl:consoleTextControl:=erroneous.
    ySize_ctl:consoleEditControl:=erroneous.
    applyAction_ctl:consoleButtonControl:=erroneous.

    multiModeTitle_ctl:consoleTextControl:=erroneous.
    multiMode_ctl:consoleCheckBoxControl:=erroneous.
    roundsTitle_ctl:consoleTextControl:=erroneous.
    rounds_ctl:consoleEditControl:=erroneous.
    externalEntry_ctl:consoleCheckBoxControl:=erroneous.
    externalEntryTitle_ctl:consoleTextControl:=erroneous.

    newPlayer_ctl:consoleButtonControl:=erroneous.
    deletePlayer_ctl:consoleButtonControl:=erroneous.
    playerUp_ctl:consoleButtonControl:=erroneous.
    playerDown_ctl:consoleButtonControl:=erroneous.
    starter_ctl:consoleButtonControl:=erroneous.
    starterTitle_ctl:consoleTextControl:=erroneous.

    players_ctl:consoleListViewControl:=erroneous.
    startPB_ctl:consoleButtonControl:=erroneous.

constants
    xSizePosition_C=4.
    xSizeWidth_C=4.

    ySizePosition_C=12.
    ySizeWidth_C=4.

    applyActionPosition_C=18.
    applyActionWidth_C=13.
    applyActionTitle_C="Apply".

    multiModePosition_C=12.
%    multiModeWidth_C=1.

    roundsPosition_C=24.
    roundsWidth_C=5.

    externalEntryPosition_C=46.
%    externalEntryWidth_C=1.

    newPlayerTitle_C="New".
    deletePlayerTitle_C="Delete".
    playerUpTitle_C="Up".
    playerDownTitle_C="Down".
    starterTitle_C="Starter".

clauses
    new():-
        xSizeTitle_ctl:=consoleTextControl::new(This),
        xSizeTitle_ctl:setPosition(xSizePosition_C-4,1),
        xSizeTitle_ctl:setWidth(4),
        xSizeTitle_ctl:setText("X:"),

        xSize_ctl:=consoleEditControl::new(This),
        xSize_ctl:setPosition(xSizePosition_C,1),
        xSize_ctl:setWidth(xSizeWidth_C),

        ySizeTitle_ctl:=consoleTextControl::new(This),
        ySizeTitle_ctl:setPosition(ySizePosition_C-4,1),
        ySizeTitle_ctl:setWidth(4),
        ySizeTitle_ctl:setText("Y:"),

        ySize_ctl:=consoleEditControl::new(This),
        ySize_ctl:setPosition(ySizePosition_C,1),
        ySize_ctl:setWidth(ySizeWidth_C),

        applyAction_ctl:=consoleButtonControl::new(This),
        applyAction_ctl:setPosition(applyActionPosition_C,1),
        applyAction_ctl:setWidth(applyActionWidth_C),
        applyAction_ctl:setText(applyActionTitle_C),
        applyAction_ctl:subscribe(onApplySizePB,string(consoleEventSource::buttonClickEventID_C)),

        multiModeTitle_ctl:=consoleTextControl::new(This),
        multiModeTitle_ctl:setPosition(multiModePosition_C-12,3),
        multiModeTitle_ctl:setWidth(13),
        multiModeTitle_ctl:setText("Multi Game:"),

        multiMode_ctl:=consoleCheckBoxControl::new(This),
        multiMode_ctl:setPosition(multiModePosition_C,3),
        multiMode_ctl:setChecked(false),
        multiMode_ctl:subscribe(onMultiModeChanged,string(consoleEventSource::checkBoxStatusChangedEventID_C)),

        roundsTitle_ctl:=consoleTextControl::new(This),
        roundsTitle_ctl:setPosition(16,3),
        roundsTitle_ctl:setWidth(8),
        roundsTitle_ctl:setText("Rounds"),
        roundsTitle_ctl:setEnabled(false),

        rounds_ctl:=consoleEditControl::new(This),
        rounds_ctl:setPosition(roundsPosition_C,3),
        rounds_ctl:setWidth(roundsWidth_C),
        rounds_ctl:setEnabled(false),

        externalEntryTitle_ctl:=consoleTextControl::new(This),
        externalEntryTitle_ctl:setPosition(30,3),
        externalEntryTitle_ctl:setWidth(16),
        externalEntryTitle_ctl:setText("External Entry"),
        externalEntryTitle_ctl:setEnabled(false),

        externalEntry_ctl:=consoleCheckBoxControl::new(This),
        externalEntry_ctl:setPosition(externalEntryPosition_C,3),
        externalEntry_ctl:setChecked(false),
        externalEntry_ctl:setEnabled(false),
        externalEntry_ctl:subscribe(onExternalEntryStateChanged,string(consoleEventSource::checkBoxStatusChangedEventID_C)),

        newPlayer_ctl:=consoleButtonControl::new(This),
        newPlayer_ctl:setPosition(2,7),
        newPlayer_ctl:setWidth(9),
        newPlayer_ctl:setText(newPlayerTitle_C),
        newPlayer_ctl:subscribe(onNewPlayer,string(consoleEventSource::buttonClickEventID_C)),

        deletePlayer_ctl:=consoleButtonControl::new(This),
        deletePlayer_ctl:setPosition(2,8),
        deletePlayer_ctl:setWidth(9),
        deletePlayer_ctl:setText(deletePlayerTitle_C),
        deletePlayer_ctl:subscribe(onDeletePlayer,string(consoleEventSource::buttonClickEventID_C)),

        playerUp_ctl:=consoleButtonControl::new(This),
        playerUp_ctl:setPosition(2,9),
        playerUp_ctl:setWidth(9),
        playerUp_ctl:setText(playerUpTitle_C),
        playerUp_ctl:subscribe(onPlayerUp,string(consoleEventSource::buttonClickEventID_C)),

        playerDown_ctl:=consoleButtonControl::new(This),
        playerDown_ctl:setPosition(2,10),
        playerDown_ctl:setWidth(9),
        playerDown_ctl:setText(playerDownTitle_C),
        playerDown_ctl:subscribe(onPlayerDown,string(consoleEventSource::buttonClickEventID_C)),

        starter_ctl:=consoleButtonControl::new(This),
        starter_ctl:setPosition(2,11),
        starter_ctl:setWidth(9),
        starter_ctl:setText(starterTitle_C),
        starter_ctl:subscribe(onSetStarter,string(consoleEventSource::buttonClickEventID_C)),

        players_ctl:=consoleLIstViewControl::new(This),
        players_ctl:setPosition(16,6),
        players_ctl:setWidth(20),
        players_ctl:setHeight(6),
        players_ctl:subscribe(onPlayerDblClick,string(consoleEventSource::mouseDblClickEventID_C)),

        starterTitle_ctl:=consoleTextControl::new(This),
        starterTitle_ctl:setPosition(2,13),
        starterTitle_ctl:setWidth(30),
        starterTitle_ctl:setText("Starter:"),

        startPB_ctl:=consoleButtonControl::new(This),
        startPB_ctl:setPosition(34,13),
        startPB_ctl:setWidth(7),
        startPB_ctl:setText("Run"),
        startPB_ctl:subscribe(onStart,string(consoleEventSource::buttonClickEventID_C)),

        subscribe(onShow,string(consoleEventSource::showEventID_C)).

domains
    textID_D=
        run_S;
        stop_S;
        auto_S;
        starter_S;
        startedNotAssigned_S.
predicates
    getText:(textID_D LocalizedStringID)->string LocalizedString.
clauses
    getText(run_S)="Run".
    getText(stop_S)="Stop".
    getText(auto_S)="Auto".
    getText(starter_S)="Starter: ".
    getText(startedNotAssigned_S)="Starter: Not Assigned".

predicates
    onShow:notificationAgency::notificationListenerFiltered.
clauses
    onShow(_NotificationAgency,This,_Status):-
        !,
        showBackGround(),
        showStarterName(),
        HumanInterface=convert(humanInterface,getConsoleRoot()),
        rounds_ctl:setText(toString(HumanInterface:logicProvider_V:seniourJudge_V:noOfRounds_V)),
        Xsize=HumanInterface:logicProvider_V:juniourJudge_V:maxColumn_P,
        Ysize=HumanInterface:logicProvider_V:juniourJudge_V:maxRow_P,
        xSize_ctl:setText(toString(Xsize)),
        ySize_ctl:setText(toString(Ysize)),
        HumanInterface:logicProvider_V:seniourJudge_V:multiMode_V=TrueIf_MM,
        multiMode_ctl:setChecked(TrueIf_MM),
        rounds_ctl:setEnabled(TrueIf_MM),
        roundsTitle_ctl:setEnabled(TrueIf_MM),
        externalEntryTitle_ctl:setEnabled(TrueIf_MM),
        externalEntry_ctl:setEnabled(TrueIf_MM),
        if HumanInterface:logicProvider_V:seniourJudge_V:externalFirstMove_V=true then
            externalEntry_ctl:setChecked(true)
        else
            externalEntry_ctl:setChecked(false)
        end if.
    onShow(_NotificationAgency,_NotificationSource,_Value).

clauses
    showStatus(polylineDomains::newSize):-
        !.
    showStatus(_Status):-
        showStarterName(),
        fail.
    showStatus(Status):-
        (Status=polylineDomains::complete or Status=polylineDomains::interrupted),
        !,
        setControlsEnability(true).
    showStatus(_Any):-
        setControlsEnability(false).

predicates
    setControlsEnability:(boolean TrueIfEnable).
clauses
    setControlsEnability(TrueIfEnable):-
        applyAction_ctl:setEnabled(TrueIfEnable),
        xSize_ctl:setEnabled(TrueIfEnable),
        ySize_ctl:setEnabled(TrueIfEnable),
        newPlayer_ctl:setEnabled(TrueIfEnable),
        players_ctl:setEnabled(TrueIfEnable),
        playerUp_ctl:setEnabled(TrueIfEnable),
        playerDown_ctl:setEnabled(TrueIfEnable),
        deletePlayer_ctl:setEnabled(TrueIfEnable),
        HumanInterface=convert(humanInterface,getConsoleRoot()),
        HumanInterface:logicProvider_V:seniourJudge_V:multiMode_V=TrueIf_MM,
        if TrueIf_MM=true then
            rounds_ctl:setEnabled(TrueIfEnable),
            externalEntry_ctl:setEnabled(TrueIfEnable)
        end if,
        starter_ctl:setEnabled(TrueIfEnable),
        multiMode_ctl:setEnabled(TrueIfEnable),
        if TrueIfEnable=true then
            startPB_ctl:setText(This:getText(run_S))
        else
            startPB_ctl:setText(This:getText(stop_S))
        end if.

clauses
    showStarterName():-
        true=multiMode_ctl:getChecked(),
        !,
        HumanInterface=convert(humanInterface,getConsoleRoot()),
        try
            StarterName=HumanInterface:logicProvider_V:seniourJudge_V:starter_V:name
        catch _TraceID do
            StarterName=This:getText(auto_S)
        end try,
        starterTitle_ctl:setText(string::concat(This:getText(starter_S),StarterName)),
        startPB_ctl:setEnabled(true()).
    showStarterName():-
        HumanInterface=convert(humanInterface,getConsoleRoot()),
        try
            starterTitle_ctl:setText(string::concat(This:getText(starter_S),HumanInterface:logicProvider_V:seniourJudge_V:starter_V:name)),
            startPB_ctl:setEnabled(true())
        catch _TraceID do
            starterTitle_ctl:setText(This:getText(startedNotAssigned_S)),
            startPB_ctl:setEnabled(false())
        end try.

clauses
    updateView():-
        !,
        showBackGround().

predicates
    showBackGround:().
clauses
    showBackGround().
/*
        console::location(X,Y)=getLocation(),
        console::setLocation(console::location(X,Y)),
        console::write(".. Settings .....................................").
*/
predicates
    onApplySizePB:notificationAgency::notificationListenerFiltered.
clauses
    onApplySizePB(_NotificationAgency,_This,_AnyValue):-
        not(isPositive(xSize_ctl)),
        consoleEventSource::messageBox("Must be Positive Value","Error",0),
        xSize_ctl:trySetFocus(),
        !.
    onApplySizePB(_NotificationAgency,_This,_AnyValue):-
        not(isPositive(ySize_ctl)),
        consoleEventSource::messageBox("Must be Positive Value","Error",0),
        ySize_ctl:trySetFocus(),
        !.
    onApplySizePB(_NotificationAgency,_This,_AnyValue):-
        HumanInterface=convert(humanInterface,getConsoleRoot()),
        HumanInterface:logicProvider_V:juniourJudge_V:maxColumn_P:=toTerm(xSize_ctl:getText()),
        HumanInterface:logicProvider_V:juniourJudge_V:maxRow_P:=toTerm(ySize_ctl:getText()),
        HumanInterface:showStatus(polylineDomains::newSize).

predicates
    isPositive:(consoleControl EditControl) determ.
clauses
    isPositive(Control):-
        try
        	PositiveNumericValue = toTerm(Control:getText())
        catch _TraiceID do
        	fail
        end try,
        hasDomain(positive,PositiveNumericValue).

facts
    playerPropertiesDLG_V:playerProperties:=erroneous.
predicates
    onNewPlayer:notificationAgency::notificationListenerFiltered.
clauses
    onNewPlayer(_NotificationAgency,_This,none):-
        !,
        playerPropertiesDLG_V:=playerProperties::new(This),
        playerPropertiesDLG_V:setModal(newPlayer_ctl),
        playerPropertiesDLG_V:show(),
        playerPropertiesDLG_V:subscribe(onNewPlayerComplete,string(consoleEventSource::closedEventID_C)).
    onNewPlayer(_NotificationAgency,_NotificationSource,_Status).

predicates
    onNewPlayerComplete:notificationAgency::notificationListenerFiltered.
clauses
    onNewPlayerComplete(NotificationAgency,_This,_Any):-
        NotificationAgency:unSubscribeFiltered(onNewPlayerComplete),
        playerPropertiesDLG_V:=erroneous,
        refreshPlayersList(),
        Count=players_ctl:getCount(),
        Count>0,
        !,
        players_ctl:selectAt(Count-1).
    onNewPlayerComplete(_NotificationAgency,_This,_Any).

predicates
    onPlayerDblClick:notificationAgency::notificationListenerFiltered.
clauses
    onPlayerDblClick(_NotificationAgency,players_ctl,unsigned(_Index)):-
        !,
        modifyProperties().
    onPlayerDblClick(_NotificationAgency,_Any,_Value).

predicates
    modifyProperties:().
clauses
    modifyProperties():-
        HumanInterface=convert(humanInterface,getConsoleRoot()),
        Index=players_ctl:tryGetSelectedIndex(),
        !,
        Player=list::nth(Index, HumanInterface:logicProvider_V:competitors_V:players_V),
        if HumanInterface:logicProvider_V:language_V=polylineDomains::ru then
            playerPropertiesDLG_V:=playerProperties::new(This)
        else
            playerPropertiesDLG_V:=playerProperties::new(This)
        end if,
        playerPropertiesDLG_V:setModal(players_ctl),
        playerPropertiesDLG_V:setPlayer(Player),
        playerPropertiesDLG_V:subscribe(onNewPlayerComplete,string(consoleEventSource::closedEventID_C)),
        playerPropertiesDLG_V:show().
    modifyProperties().

predicates
    onMultiModeChanged:notificationAgency::notificationListenerFiltered.
clauses
    onMultiModeChanged(_NotificationAgency,_NotificationSource,boolean(Status)):-
        !,
        rounds_ctl:setEnabled(Status),
        externalEntry_ctl:setEnabled(Status),
        roundsTitle_ctl:setEnabled(Status),
        externalEntryTitle_ctl:setEnabled(Status),
        showStarterName(),
        HumanInterface=convert(humanInterface,getConsoleRoot()),
        HumanInterface:logicProvider_V:seniourJudge_V:multiMode_V:=Status.
    onMultiModeChanged(_NotificationAgency,_NotificationSource,_Status).

predicates
    onExternalEntryStateChanged:notificationAgency::notificationListenerFiltered.
clauses
    onExternalEntryStateChanged(_NotificationAgency,_NotificationSource, boolean(Status)):-
        !,
        HumanInterface=convert(humanInterface,getConsoleRoot()),
        HumanInterface:logicProvider_V:seniourJudge_V:externalFirstMove_V:=Status.
    onExternalEntryStateChanged(_NotificationAgency,_NotificationSource, _Any).

predicates
    onDeletePlayer:notificationAgency::notificationListenerFiltered.
clauses
    onDeletePlayer(_NotificationAgency,_NotificationSource,none):-
        HumanInterface=convert(humanInterface,getConsoleRoot()),
        Index=players_ctl:tryGetSelectedIndex(),
        Count=players_ctl:getCount(),
        players_ctl:delete(Index),
        HumanInterface:logicProvider_V:competitors_V:removePlayer(Index),
        refreshPlayersList(),
        showStarterName(),
        Count>0,
        !,
        if
            Index=Count-1
        then
            players_ctl:selectAt(Index-1)
        else
            players_ctl:selectAt(Index)
        end if,
        !.
    onDeletePlayer(_NotificationAgency,_NotificationSource,_Any).

predicates
    refreshPlayersList:().
clauses
    refreshPlayersList():-
        HumanInterface=convert(humanInterface,getConsoleRoot()),
        PlayersNameList = [ PlayerObj:name || PlayerObj = list::getMember_nd(HumanInterface:logicProvider_V:competitors_V:players_V) ],
        not(PlayersNameList=[]),
        !,
        players_ctl:clearAll(),
        players_ctl:addList(PlayersNameList).
    refreshPlayersList().

predicates
    onPlayerUp:notificationAgency::notificationListenerFiltered.
clauses
    onPlayerUp(_NotificationAgency,_NotificationSource,none):-
        Index=players_ctl:tryGetSelectedIndex(),
        Index>0,
        !,
        HumanInterface=convert(humanInterface,getConsoleRoot()),
        HumanInterface:logicProvider_V:competitors_V:shiftPlayer(Index,polylineDomains::up),
        refreshPlayersList(),
        players_ctl:selectAt(Index-1).
    onPlayerUp(_NotificationAgency,_NotificationSource,_Any).

predicates
    onPlayerDown:notificationAgency::notificationListenerFiltered.
clauses
    onPlayerDown(_NotificationAgency,_NotificationSource,none):-
        Index=players_ctl:tryGetSelectedIndex(),
        Index<list::length(players_ctl:getAll())-1,
        !,
        HumanInterface=convert(humanInterface,getConsoleRoot()),
        HumanInterface:logicProvider_V:competitors_V:shiftPlayer(Index,polylineDomains::down),
        refreshPlayersList(),
        players_ctl:selectAt(Index+1).
    onPlayerDown(_NotificationAgency,_NotificationSource,_Any).

predicates
    onSetStarter:notificationAgency::notificationListenerFiltered.
clauses
    onSetStarter(_NotificationAgency,_NotificationSource,none):-
        HumanInterface=convert(humanInterface,getConsoleRoot()),
        Index=players_ctl:tryGetSelectedIndex(),
        !,
        HumanInterface:logicProvider_V:seniourJudge_V:starter_V:=list::nth(Index, HumanInterface:logicProvider_V:competitors_V:players_V),
        showStarterName().
    onSetStarter(_NotificationAgency,_NotificationSource,_Any).

predicates
    onStart:notificationAgency::notificationListenerFiltered.
clauses
    onStart(_NotificationAgency,_NotificationSource,_AnyData):-
        not(isPositive(rounds_ctl)),
        consoleEventSource::messageBox("No of Rounds Must be Positive Value","Error",0),
        rounds_ctl:trySetFocus(),
        !.
    onStart(_NotificationAgency,_NotificationSource,_AnyData):-
        SJ=convert(humanInterface,getConsoleRoot()):logicProvider_V:seniourJudge_V,
        SJ:noOfRounds_V:=toTerm(rounds_ctl:getText()),
        fail.
    onStart(_NotificationAgency,_NotificationSource,none):-
        HumanInterface=convert(humanInterface,getConsoleRoot()),
        HumanInterface:logicProvider_V:seniourJudge_V:inProgress_V=false,
        !,
        HumanInterface:notify(This,string(polylineDomains::uiRequestRun_C),none). % informs regarding the Start of play.
    onStart(_NotificationAgency,_NotificationSource,_Any):-
        HumanInterface=convert(humanInterface,getConsoleRoot()),
        HumanInterface:notify(This,string(polylineDomains::uiRequestStop_C),none). % informs regarding the end of play.

end implement gameSettings

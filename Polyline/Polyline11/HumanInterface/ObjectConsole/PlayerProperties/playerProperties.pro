/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement playerProperties
    inherits consoleControl
    inherits consoleControlContainer
    open core, console, polylineDomains

clauses
    new(ConsoleControlContainer):-
        new(),
        setConsoleControlContainer(ConsoleControlContainer).

facts
    playerNameEC_ctl:consoleEditControl:=erroneous.
    players_ctl:consoleLIstViewControl:=erroneous.
    okPB_ctl:consoleButtonControl:=erroneous.
    cancelPB_ctl:consoleButtonControl:=erroneous.
    playerLegendEC_ctl:consoleEditControl:=erroneous.
    browseLegendPB_ctl:consoleButtonControl:=erroneous.
    playerNameTitleTC_ctl:consoleTextControl:=erroneous.
    playerLegendTitleTC_ctl:consoleTextControl:=erroneous.

clauses
    new():-
        setPosition(15,2),
        setWidth(30),
        setHeight(12),
        setText("Player Properties"),

        playerNameTitleTC_ctl:=consoleTextControl::new(This),
        playerNameTitleTC_ctl:setPosition(4,1),
        playerNameTitleTC_ctl:setWidth(8),
        playerNameTitleTC_ctl:setText("Name: "),

        playerNameEC_ctl:=consoleEditControl::new(This),
        playerNameEC_ctl:setPosition(13,1),
        playerNameEC_ctl:setWidth(15),

        playerLegendTitleTC_ctl:=consoleTextControl::new(This),
        playerLegendTitleTC_ctl:setPosition(4,2),
        playerLegendTitleTC_ctl:setWidth(10),
        playerLegendTitleTC_ctl:setText("Legend: "),

        playerLegendEC_ctl:=consoleEditControl::new(This),
        playerLegendEC_ctl:setPosition(13,2),
        playerLegendEC_ctl:setWidth(3),
        playerLegendEC_ctl:setText(" "),
        playerLegendEC_ctl:startFieldMark_V:=' ',
        playerLegendEC_ctl:endFieldMark_V:=' ',

        browseLegendPB_ctl:=consoleButtonControl::new(This),
        browseLegendPB_ctl:setPosition(17,2),
        browseLegendPB_ctl:setWidth(8),
        browseLegendPB_ctl:setText("Browse"),
        browseLegendPB_ctl:subscribe(onBrowseButton,string(consoleEventSource::buttonClickEventID_C)),

        players_ctl:=consoleLIstViewControl::new(This),
        players_ctl:setPosition(4,3),
        players_ctl:setWidth(20),
        players_ctl:setHeight(6),

        okPB_ctl:=consoleButtonControl::new(This),
        okPB_ctl:setPosition(4,10),
        okPB_ctl:setWidth(8),
        okPB_ctl:setText("Ok"),
        okPB_ctl:subscribe(onOkButton,string(consoleEventSource::buttonClickEventID_C)),

        cancelPB_ctl:=consoleButtonControl::new(This),
        cancelPB_ctl:setPosition(14,10),
        cancelPB_ctl:setWidth(8),
        cancelPB_ctl:setText("Cancel"),
        cancelPB_ctl:subscribe(onCancelButton,string(consoleEventSource::buttonClickEventID_C)),

        subscribe(onShow,string(consoleEventSource::showEventID_C)).

predicates
    onShow:notificationAgency::notificationListenerFiltered.
clauses
    onShow(_NotificationAgency,This,_Status):-
        Location=console::getLocation(),
        showControlFrame(),
        setModelList(),
        HumanInterface=convert(humanInterface,getConsoleRoot()),
        if not(model_F(0,_Player)),! then
            players_ctl:subscribe(onStrategyListLBSelectionChanged,string(consoleEventSource::listViewSelectionChangedID_C)),
            Count=players_ctl:getCount(),
            not(Count=0),
            players_ctl:selectAt(0),
            FirstPlayer=HumanInterface:logicProvider_V:competitors_V:createPlayerObject(players_ctl:getAt(0)),
            setPlayer(FirstPlayer)
        else
            model_F(0,Player),
            players_ctl:clearAll(),
            Attributes=Player:getAttributes(),
            Descriptor = namedValue::getNamed_string(Attributes,shortDescriptorID_C),
            players_ctl:add(Descriptor),
            players_ctl:setEnabled(false),
            players_ctl:selectAt(0)
        end if,
        !,
        console::setLocation(Location).
    onShow(_NotificationAgency,_NotificationSource,_Value).

predicates
    onStrategyListLBSelectionChanged:notificationAgency::notificationListenerFiltered.
clauses
    onStrategyListLBSelectionChanged(_NotificationAgency,_Any,_Value):-
        SelectedIndex=players_ctl:tryGetSelectedIndex(),
        !,
        HumanInterface=convert(humanInterface,getConsoleRoot()),
        if model_F(SelectedIndex,Player),! then
            ActualPlayer=Player
        else
            Name = players_ctl:getAt(SelectedIndex),
            ActualPlayer=HumanInterface:logicProvider_V:competitors_V:createPlayerObject(Name),
            assert(model_F(SelectedIndex,ActualPlayer))
        end if,
        setPlayer(ActualPlayer).
    onStrategyListLBSelectionChanged(_NotificationAgency,_Any,_Value).

facts
    getColorDlg_ctl:getColor:=erroneous.
predicates
    onBrowseButton:notificationAgency::notificationListenerFiltered.
clauses
    onBrowseButton(_NotificationAgency,_Any,none):-
        !,
        getColorDlg_ctl:=getColor::new(This),
        getColorDlg_ctl:subscribe(onColor,string(consoleEventSource::closedEventID_C)),
        getColorDlg_ctl:setModal(browseLegendPB_ctl),
        getColorDlg_ctl:show().
    onBrowseButton(_NotificationAgency,_Any,_Value).

predicates
    onColor:notificationAgency::notificationListenerFiltered.
clauses
    onColor(_NotificationAgency,_Any,unsigned(Color)):-
        playerLegendEC_ctl:setTextAttribute(Color,0x0000),
        !.
    onColor(_NotificationAgency,_Any,_AnyColor).

predicates
    onOkButton:notificationAgency::notificationListenerFiltered.
clauses
    onOkButton(_NotificationAgency,_Any,none):-
        convertLegend(Legend,playerLegendEC_ctl:getTextAttribute()),
        SelectedIndex=players_ctl:tryGetSelectedIndex(),
        model_F(SelectedIndex,Player),
        Name=playerNameEC_ctl:getText(),
        tryNameIsNotEmpty(Name),
        tryNameIsUnique(Player,Name),
        tryLegendIsUnique(Player,Legend),
        Player:legend_V:=Legend,
        Player:name:=Name,
        HumanInterface=convert(humanInterface,getConsoleRoot()),
        if not(list::isMember(Player,HumanInterface:logicProvider_V:competitors_V:players_V)) then
            HumanInterface:logicProvider_V:competitors_V:addPlayer(Player)
        end if,
        notify(This,string(consoleEventSource::closedEventID_C),none),
        destroy(),
        !.
    onOkButton(_NotificationAgency,_NotificationSource,_Value).

predicates
    onCancelButton:notificationAgency::notificationListenerFiltered.
clauses
    onCancelButton(_NotificationAgency,_Any,none):-
        destroy(),
        !.
    onCancelButton(_NotificationAgency,_NotificationSource,_Value).

predicates
    showControlFrame:().
clauses
    showControlFrame():-
        console_native::coord(X,Y)=geCtrlLocation(),
        setLocation(console_native::coord(X,Y)),
        HorisontalLine=string::create(convert(charCount,getWidth())-2,"*"),
        SpaceLine=string::create(convert(charCount,getWidth())-2," "),
        console::write("+",HorisontalLine,"+"),
        setLocation(console_native::coord(X,Y+getHeight()-1)),
        write("+",HorisontalLine,"+"),
        foreach Row = std::fromTo(1, getHeight()-2) do
            setLocation(console_native::coord(X,Y+Row)),
            write("*",SpaceLine,"*")
        end foreach.

clauses
    updateView():-
        showControlFrame().

predicates
    setModelList:().
clauses
    setModelList():-
        HumanInterface=convert(humanInterface,getConsoleRoot()),
        CandidatesList=HumanInterface:logicProvider_V:competitors_V:getCandidates(),
        players_ctl:addList(CandidatesList),
        players_ctl:selectAt(0).

facts
    model_F:(positive Index,player Player).

clauses
    setPlayer(PlayerObject):-
        not(model_F(0,_Player)),
        asserta(model_F(0,PlayerObject)),
        fail.
    setPlayer(PlayerObject):-
        playerNameEC_ctl:setText(PlayerObject:name),
        if convertLegend(PlayerObject:legend_V,Color),! then
            playerLegendEC_ctl:setTextAttribute(Color,0x0000)
        end if.

predicates
    tryNameIsNotEmpty:(string Name) determ.
clauses
    tryNameIsNotEmpty(Name):-
        string::trim(Name)="",
        !,
        consoleEventSource::messageBox("The Player's Name is Empty!","Error!",0),
        fail.
    tryNameIsNotEmpty(_Name).

predicates
    tryNameIsUnique:(player Player,string Name) determ.
clauses
    tryNameIsUnique(Player,Name):-
        HumanInterface=convert(humanInterface,getConsoleRoot()),
        Competitors=HumanInterface:logicProvider_V:competitors_V,
        Competitors:isNameUnique(Player,Name),
        !.
    tryNameIsUnique(_Player,Name):-
        consoleEventSource::messageBox(string::format("The Player's name \"%\" is not Unique!",Name),"Error",0),
        fail.

predicates
    tryLegendIsUnique:(player Player,integer Legend) determ.
clauses
    tryLegendIsUnique(Player,Legend):-
        HumanInterface=convert(humanInterface,getConsoleRoot()),
        Competitors=HumanInterface:logicProvider_V:competitors_V,
        Competitors:isLegendUnique(Player,Legend),
        !.
    tryLegendIsUnique(_Player,_Legend):-
        consoleEventSource::messageBox("The Legend is not Unique!","Error",0),
        fail.

predicates
    convertLegend:(integer,unsigned) determ (i,o) (o,i).
clauses
    convertLegend(0x00FF0000,0x0010).
    convertLegend(0x0000FF00, 0x0020).
    convertLegend(0x00FF00FF, 0x0030).
    convertLegend(0x000000FF,0x0040).
    convertLegend(0x00FFFF00,0x0050).
    convertLegend(0x0000FFFF, 0x0060).
    convertLegend(0x00FFFFFF,0x0070).
    convertLegend(0x00000000,0x0000).

end implement playerProperties

/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement gameSettings
    inherits userControlSupport
    open core, vpiDomains

clauses
    new(Parent):-
        new(),
        setContainer(Parent).

clauses
    new():-
        userControlSupport::new(),
        generatedInitialize().

clauses
    xSize()=GameForm:logicProvider_V:juniourJudge_V:maxColumn_P:-
        GameForm=convert(objectWinForm,getTopLevelContainerWindow()).
    ySize()=GameForm:logicProvider_V:juniourJudge_V:maxRow_P:-
        GameForm=convert(objectWinForm,getTopLevelContainerWindow()).

predicates
    onApplyPBClick : button::clickResponder.
clauses
    onApplyPBClick(_BtnSource) = button::defaultAction:-
        tryValidateWithErrorDialog(),
        !,
        GameForm=convert(objectWinForm,getTopLevelContainerWindow()),
        GameForm:logicProvider_V:juniourJudge_V:maxColumn_P:=xSizeIntControl_ctl:getInteger(),
        GameForm:logicProvider_V:juniourJudge_V:maxRow_P:=ySizeIntControl_ctl:getInteger(),
        GameForm:showStatus(polylineDomains::newSize).
    onApplyPBClick(_BtnSource) = button::defaultAction.

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
        gameModeGB_ctl:setEnabled(TrueIfEnable),
        listbox_ctl:setEnabled(TrueIfEnable),
        newPlayerPB_ctl:setEnabled(TrueIfEnable),
        applyPB_ctl:setEnabled(TrueIfEnable),
        xSizeIntControl_ctl:setEnabled(TrueIfEnable),
        ySizeIntControl_ctl:setEnabled(TrueIfEnable),
        playerUpPB_ctl:setEnabled(TrueIfEnable),
        playerDownPB_ctl:setEnabled(TrueIfEnable),
        removePB_ctl:setEnabled(TrueIfEnable),
        setStarterPB_ctl:setEnabled(TrueIfEnable),
        if TrueIfEnable=true then
            runPB_ctl:setText("Run")
        else
            runPB_ctl:setText("Stop")
        end if.

clauses
    showStarterName():-
            checkButton::checked()=multiGameCHB_ctl:getCheckedState(),
            !,
            GameForm=convert(objectWinForm,getTopLevelContainerWindow()),
            try
                StarterName=GameForm:logicProvider_V:seniourJudge_V:starter_V:name
            catch _TraceID do
                StarterName="Auto"
            end try,
            starterNameText_ctl:setText(string::concat("Starter: ",StarterName)),
            runPB_ctl:setEnabled(true()).
    showStarterName():-
        GameForm=convert(objectWinForm,getTopLevelContainerWindow()),
        try
            starterNameText_ctl:setText(string::concat("Starter: ",GameForm:logicProvider_V:seniourJudge_V:starter_V:name)),
            runPB_ctl:setEnabled(true())
        catch _TraceID do
            starterNameText_ctl:setText("Starter: Not Assigned"),
            runPB_ctl:setEnabled(false())
        end try.

predicates
    modifyProperties:().
clauses
    modifyProperties():-
        GameForm=convert(objectWinForm,getTopLevelContainerWindow()),
        Index=listbox_ctl:tryGetSelectedIndex(),
        !,
        Player=list::nth(Index, GameForm:logicProvider_V:competitors_V:players_V),
        PropertiesDialog=playerProperties_UI::new(This),
        PropertiesDialog:setPlayer(Player),
        PropertiesDialog:show(),
        refreshPlayersList(),
        showStarterName(),
        listbox_ctl:selectAt(Index,true).
    modifyProperties().

predicates
    onNewPlayerPBClick : button::clickResponder.
clauses
    onNewPlayerPBClick(_Source) = button::defaultAction:-
        _PropertiesDialog=playerProperties_UI::display(This),
        refreshPlayersList(),
        Count=listbox_ctl:getCount(),
        Count>0,
        !,
        listbox_ctl:selectAt(Count-1,true).
    onNewPlayerPBClick(_Source) = button::defaultAction.

predicates
    refreshPlayersList:().
clauses
    refreshPlayersList():-
        GameForm=convert(objectWinForm,getTopLevelContainerWindow()),
        PlayersNameList = [ PlayerObj:name || PlayerObj = list::getMember_nd(GameForm:logicProvider_V:competitors_V:players_V) ],
        not(PlayersNameList=[]),
        !,
        listbox_ctl:clearAll(),
        listbox_ctl:addList(PlayersNameList).
    refreshPlayersList().

predicates
    onRemovePBClick : button::clickResponder.
clauses
    onRemovePBClick(_Source) = button::defaultAction:-
        GameForm=convert(objectWinForm,getTopLevelContainerWindow()),
        Index=listbox_ctl:tryGetSelectedIndex(),
        Count=listbox_ctl:getCount(),
        listbox_ctl:delete(Index),
        GameForm:logicProvider_V:competitors_V:removePlayer(Index),
        refreshPlayersList(),
        showStarterName(),
        Count>1,
        !,
        if
            Index=Count-1
        then
            listbox_ctl:selectAt(Index-1,true)
        else
            listbox_ctl:selectAt(Index,true)
        end if.
    onRemovePBClick(_Source) = button::defaultAction.

predicates
    onSetStarterPBClick : button::clickResponder.
clauses
    onSetStarterPBClick(_Source) = button::defaultAction:-
        GameForm=convert(objectWinForm,getTopLevelContainerWindow()),
        Index=listbox_ctl:tryGetSelectedIndex(),
        !,
        GameForm:logicProvider_V:seniourJudge_V:starter_V:=list::nth(Index, GameForm:logicProvider_V:competitors_V:players_V),
        showStarterName().
    onSetStarterPBClick(_Source) = button::defaultAction.

predicates
    onShow : window::showListener.
clauses
    onShow(_Source, _Data):-
        showStarterName(),
        GameForm=convert(objectWinForm,getTopLevelContainerWindow()),
        roundsEC_ctl:setInteger(GameForm:logicProvider_V:seniourJudge_V:noOfRounds_V),
        xSizeIntControl_ctl:setInteger(xSize()),
        ySizeIntControl_ctl:setInteger(ySize()),
        if GameForm:logicProvider_V:seniourJudge_V:multiMode_V=false then
            multiGameCHB_ctl:setCheckedState(checkButton::unChecked()),
            roundsEC_ctl:setEnabled(false()),
            roundsLableST_ctl:setEnabled(false()),
            equilityFirstMoveCHB_ctl:setEnabled(false())
        else
            multiGameCHB_ctl:setCheckedState(checkButton::checked()),
            roundsEC_ctl:setEnabled(true()),
            roundsLableST_ctl:setEnabled(true()),
            equilityFirstMoveCHB_ctl:setEnabled(true())
        end if.

predicates
    onPlayerDownPBClick : button::clickResponder.
clauses
    onPlayerDownPBClick(_Source) = button::defaultAction:-
        Index=listbox_ctl:tryGetSelectedIndex(),
        Index<list::length(listbox_ctl:getAll())-1,
        !,
        GameForm=convert(objectWinForm,getTopLevelContainerWindow()),
        GameForm:logicProvider_V:competitors_V:shiftPlayer(Index,polylineDomains::down),
        refreshPlayersList(),
        listbox_ctl:selectAt(Index+1,true).
    onPlayerDownPBClick(_Source) = button::defaultAction.

predicates
    onPlayerUpPBClick : button::clickResponder.
clauses
    onPlayerUpPBClick(_Source) = button::defaultAction:-
        Index=listbox_ctl:tryGetSelectedIndex(),
        Index>0,
        !,
        GameForm=convert(objectWinForm,getTopLevelContainerWindow()),
        GameForm:logicProvider_V:competitors_V:shiftPlayer(Index,polylineDomains::up),
        refreshPlayersList(),
        listbox_ctl:selectAt(Index-1,true).
    onPlayerUpPBClick(_Source) = button::defaultAction.

predicates
    onRoundsECLoseFocus : window::loseFocusListener.
clauses
    onRoundsECLoseFocus(_Source):-
        contentsInvalid(_ErrorSource, FocusControl, ErrMsg)=validate(),
        !,
        if true=roundsEC_ctl:getEnabled() then
            vpiCommonDialogs::error(ErrMsg),
            FocusControl:setFocus()
        end if,
        GameForm=convert(objectWinForm,getTopLevelContainerWindow()),
        roundsEC_ctl:setInteger(GameForm:logicProvider_V:seniourJudge_V:noOfRounds_V).
    onRoundsECLoseFocus(_Source):-
        GameForm=convert(objectWinForm,getTopLevelContainerWindow()),
        GameForm:logicProvider_V:seniourJudge_V:noOfRounds_V:=roundsEC_ctl:getInteger().

predicates
    onRunPBClick : button::clickResponder.
clauses
    onRunPBClick(_Source) = button::defaultAction:-
        Container=getContainer(),
        GameForm=convert(objectWinForm,Container),
        GameForm:logicProvider_V:seniourJudge_V:inProgress_V=false,
        !,
        UI=convert(notificationAgency,Container),
        UI:notify(This,string(polylineDomains::uiRequestRun_C),none). % informs regarding the Start of play.
    onRunPBClick(_Source) = button::defaultAction:-
        Container=getContainer(),
        UI=convert(notificationAgency,Container),
        UI:notify(This,string(polylineDomains::uiRequestStop_C),none). % informs regarding the end of play.

predicates
    onPropertiesPBClick : button::clickResponder.
clauses
    onPropertiesPBClick(_Source) = button::defaultAction:-
        modifyProperties().

predicates
    onListboxDoubleClick : listBox::doubleClickListener.
clauses
    onListboxDoubleClick(_Source):-
        modifyProperties().

predicates
    onMultiGameCHBStateChanged : checkButton::stateChangedListener.
clauses
    onMultiGameCHBStateChanged(_Source, _OldState, checkButton::unChecked()):-
        !,
        roundsEC_ctl:setEnabled(false()),
        roundsLableST_ctl:setEnabled(false()),
        equilityFirstMoveCHB_ctl:setEnabled(false()),
        showStarterName(),
        GameForm=convert(objectWinForm,getTopLevelContainerWindow()),
        GameForm:logicProvider_V:seniourJudge_V:multiMode_V:=false.
    onMultiGameCHBStateChanged(_Source, _OldState, _Checked):-
        roundsEC_ctl:setEnabled(true()),
        roundsLableST_ctl:setEnabled(true()),
        equilityFirstMoveCHB_ctl:setEnabled(true()),
        showStarterName(),
        GameForm=convert(objectWinForm,getTopLevelContainerWindow()),
        GameForm:logicProvider_V:seniourJudge_V:multiMode_V:=true.

predicates
    onEquilityFirstMoveCHBStateChanged : checkButton::stateChangedListener.
clauses
    onEquilityFirstMoveCHBStateChanged(_Source, _OldState, checkButton::checked()):-
        !,
        GameForm=convert(objectWinForm,getTopLevelContainerWindow()),
        GameForm:logicProvider_V:seniourJudge_V:externalFirstMove_V:=true.
    onEquilityFirstMoveCHBStateChanged(_Source, _OldState, _Any):-
        GameForm=convert(objectWinForm,getTopLevelContainerWindow()),
        GameForm:logicProvider_V:seniourJudge_V:externalFirstMove_V:=false.

% This code is maintained automatically, do not update it manually. 22:15:25-25.4.2010
facts
    gameModeGB_ctl : groupBox.
    roundsLableST_ctl : textControl.
    roundsEC_ctl : integercontrol.
    applyPB_ctl : button.
    xSizeIntControl_ctl : integercontrol.
    ySizeIntControl_ctl : integercontrol.
    multiGameCHB_ctl : checkButton.
    equilityFirstMoveCHB_ctl : checkButton.
    starterNameText_ctl : textControl.
    runPB_ctl : button.
    newPlayerPB_ctl : button.
    removePB_ctl : button.
    playerUpPB_ctl : button.
    playerDownPB_ctl : button.
    setStarterPB_ctl : button.
    propertiesPB_ctl : button.
    listbox_ctl : listBox.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize():-
        setText("Game Settings"),
        This:setSize(148, 154),
        addShowListener(onShow),
        gameModeGB_ctl := groupBox::new(This),
        gameModeGB_ctl:setText("Game Settings"),
        gameModeGB_ctl:setPosition(4, 2),
        gameModeGB_ctl:setSize(140, 40),
        roundsLableST_ctl := textControl::new(gameModeGB_ctl),
        roundsLableST_ctl:setText("Rounds:"),
        roundsLableST_ctl:setPosition(39, 0),
        roundsLableST_ctl:setSize(28, 12),
        X_ctl = textControl::new(gameModeGB_ctl),
        X_ctl:setText("Y:"),
        X_ctl:setPosition(35, 16),
        X_ctl:setSize(12, 12),
        X_ctl:setAlignment(alignCenter),
        StaticText_ctl = textControl::new(gameModeGB_ctl),
        StaticText_ctl:setText("X:"),
        StaticText_ctl:setPosition(3, 16),
        StaticText_ctl:setSize(12, 12),
        multiGameCHB_ctl := checkButton::new(gameModeGB_ctl),
        multiGameCHB_ctl:setText("Mu&lti"),
        multiGameCHB_ctl:setPosition(3, 0),
        multiGameCHB_ctl:setWidth(32),
        multiGameCHB_ctl:addStateChangedListener(onMultiGameCHBStateChanged),
        roundsEC_ctl := integercontrol::new(gameModeGB_ctl),
        roundsEC_ctl:setPosition(67, 0),
        roundsEC_ctl:setSize(20, 12),
        roundsEC_ctl:addLoseFocusListener(onRoundsECLoseFocus),
        equilityFirstMoveCHB_ctl := checkButton::new(gameModeGB_ctl),
        equilityFirstMoveCHB_ctl:setText("Ext. Entry"),
        equilityFirstMoveCHB_ctl:setPosition(91, 0),
        equilityFirstMoveCHB_ctl:setWidth(44),
        equilityFirstMoveCHB_ctl:addStateChangedListener(onEquilityFirstMoveCHBStateChanged),
        xSizeIntControl_ctl := integercontrol::new(gameModeGB_ctl),
        xSizeIntControl_ctl:setPosition(15, 16),
        xSizeIntControl_ctl:setSize(16, 12),
        xSizeIntControl_ctl:setMandatory(true()),
        xSizeIntControl_ctl:setMinimum(4),
        ySizeIntControl_ctl := integercontrol::new(gameModeGB_ctl),
        ySizeIntControl_ctl:setPosition(47, 16),
        ySizeIntControl_ctl:setSize(16, 12),
        ySizeIntControl_ctl:setMandatory(true()),
        ySizeIntControl_ctl:setMinimum(4),
        applyPB_ctl := button::new(gameModeGB_ctl),
        applyPB_ctl:setText("A&pply"),
        applyPB_ctl:setPosition(75, 16),
        applyPB_ctl:setSize(60, 12),
        applyPB_ctl:defaultHeight := false(),
        applyPB_ctl:setClickResponder(onApplyPBClick),
        GroupBox_ctl = groupBox::new(This),
        GroupBox_ctl:setText("Players"),
        GroupBox_ctl:setPosition(4, 44),
        GroupBox_ctl:setSize(140, 82),
        newPlayerPB_ctl := button::new(GroupBox_ctl),
        newPlayerPB_ctl:setText("&Involve"),
        newPlayerPB_ctl:setPosition(3, 2),
        newPlayerPB_ctl:setSize(32, 12),
        newPlayerPB_ctl:defaultHeight := false(),
        newPlayerPB_ctl:setClickResponder(onNewPlayerPBClick),
        removePB_ctl := button::new(GroupBox_ctl),
        removePB_ctl:setText("Remo&ve"),
        removePB_ctl:setPosition(3, 20),
        removePB_ctl:setSize(32, 12),
        removePB_ctl:defaultHeight := false(),
        removePB_ctl:setClickResponder(onRemovePBClick),
        listbox_ctl := listBox::new(GroupBox_ctl),
        listbox_ctl:setPosition(39, 2),
        listbox_ctl:setSize(64, 56),
        listbox_ctl:setSort(false),
        listbox_ctl:addDoubleClickListener(onListboxDoubleClick),
        propertiesPB_ctl := button::new(GroupBox_ctl),
        propertiesPB_ctl:setText("&Properties"),
        propertiesPB_ctl:setPosition(39, 58),
        propertiesPB_ctl:setSize(64, 12),
        propertiesPB_ctl:defaultHeight := false(),
        propertiesPB_ctl:setClickResponder(onPropertiesPBClick),
        playerUpPB_ctl := button::new(GroupBox_ctl),
        playerUpPB_ctl:setText("&Up"),
        playerUpPB_ctl:setPosition(107, 2),
        playerUpPB_ctl:setSize(28, 12),
        playerUpPB_ctl:defaultHeight := false(),
        playerUpPB_ctl:setClickResponder(onPlayerUpPBClick),
        playerDownPB_ctl := button::new(GroupBox_ctl),
        playerDownPB_ctl:setText("&Down"),
        playerDownPB_ctl:setPosition(106, 20),
        playerDownPB_ctl:setSize(28, 12),
        playerDownPB_ctl:defaultHeight := false(),
        playerDownPB_ctl:setClickResponder(onPlayerDownPBClick),
        setStarterPB_ctl := button::new(GroupBox_ctl),
        setStarterPB_ctl:setText("&Starter"),
        setStarterPB_ctl:setPosition(106, 38),
        setStarterPB_ctl:setSize(28, 12),
        setStarterPB_ctl:defaultHeight := false(),
        setStarterPB_ctl:setClickResponder(onSetStarterPBClick),
        GroupBox1_ctl = groupBox::new(This),
        GroupBox1_ctl:setText("Play"),
        GroupBox1_ctl:setPosition(4, 128),
        GroupBox1_ctl:setSize(140, 24),
        starterNameText_ctl := textControl::new(GroupBox1_ctl),
        starterNameText_ctl:setText("No Starter Selected"),
        starterNameText_ctl:setPosition(3, -2),
        starterNameText_ctl:setSize(88, 14),
        runPB_ctl := button::new(GroupBox1_ctl),
        runPB_ctl:setText("&Run"),
        runPB_ctl:setPosition(95, 0),
        runPB_ctl:setSize(32, 12),
        runPB_ctl:defaultHeight := false(),
        runPB_ctl:setClickResponder(onRunPBClick).
% end of automatic code
end implement gameSettings

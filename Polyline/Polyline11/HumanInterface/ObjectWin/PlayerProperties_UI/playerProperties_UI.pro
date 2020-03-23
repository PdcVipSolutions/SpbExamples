/*****************************************************************************
Copyright (c) Victor Yukhtenko
******************************************************************************/
implement playerProperties_UI
    inherits dialog
    open core, vpiDomains, polylineDomains

clauses
    display(Parent) = Dialog :-
        Dialog = new(Parent),
        Dialog:show().

clauses
    new(Parent) :-
        dialog::new(Parent),
        generatedInitialize(),
        setModelList(Parent).

predicates
    setModelList:(window).
clauses
    setModelList(Parent):-
        GameUI=convert(gameSettings,Parent),
        GameForm=convert(objectWinForm,GameUI:getTopLevelContainerWindow()),
        CandidatesList=GameForm:logicProvider_V:competitors_V:getCandidates(),
        strategyListLB_ctl:addList(CandidatesList).


predicates
    onBrowseLegendPBClick : button::clickResponder.
clauses
    onBrowseLegendPBClick(_Source) = button::defaultAction:-
        try OldColor=playerLegendIC_ctl:getInteger()
        catch _TraceID do
            OldColor=0x0000FF00
        end try,
        NewColor=vpiCommonDialogs::getColor(getVpiWindow(),convert(color,OldColor)),
        !,
        playerLegendIC_ctl:setInteger(convert(integer,NewColor)),
        legendDrawControl_ctl:setColor(NewColor),
        legendDrawControl_ctl:invalidate().
    onBrowseLegendPBClick(_Source) = button::defaultAction.

predicates
    onShow : window::showListener.
clauses
    onShow(_Source, _Data):-
        GameUI=convert(gameSettings,getParent()),
        GameForm=convert(objectWinForm,GameUI:getTopLevelContainerWindow()),
        if model_F(0,Player),! then
            strategyListLB_ctl:removeSelectionChangedListener(onStrategyListLBSelectionChanged),
            strategyListLB_ctl:clearAll(),
            Attributes=Player:getAttributes(),
            Descriptor = namedValue::getNamed_string(Attributes,shortDescriptorID_C),
            strategyListLB_ctl:add(Descriptor),
            strategyListLB_ctl:setEnabled(false),
            strategyListLB_ctl:selectAt(0,true)
        else
            Count=strategyListLB_ctl:getCount(),
            not(Count=0),
            strategyListLB_ctl:selectAt(0,true),
            Name = strategyListLB_ctl:getAt(0),
            FirstPlayer=GameForm:logicProvider_V:competitors_V:createPlayerObject(Name),
            setPlayer(FirstPlayer)
        end if,
        !,
        legendDrawControl_ctl:invalidate().
    onShow(_Source, _Data).

predicates
    setAttributeData:(namedValue Attribute).
clauses
    setAttributeData(namedValue(descriptorID_C,string(Descriptor))):-
        !,
        modelDescriptionTC_ctl:setText(Descriptor).
    setAttributeData(namedValue(maxDepthID_C,unsigned(Value))):-
        !,
        modelAttributeIC_ctl:setVisible(true),
        attributeNameTC_ctl : setVisible(true),
        attributeNameTC_ctl : setText("Max Depth"),
        modelAttributeIC_ctl:setInteger(convert(integer,Value)).
    setAttributeData(_NamedValue).

predicates
    onStrategyListLBSelectionChanged : listControl::selectionChangedListener.
clauses
    onStrategyListLBSelectionChanged(_Source):-
        SelectedIndex=strategyListLB_ctl:tryGetSelectedIndex(),
        !,
        GameUI=convert(gameSettings,getParent()),
        GameForm=convert(objectWinForm,GameUI:getTopLevelContainerWindow()),
        if model_F(SelectedIndex,Player),! then
            ActualPlayer=Player
        else
            Name = strategyListLB_ctl:getAt(SelectedIndex),
            ActualPlayer=GameForm:logicProvider_V:competitors_V:createPlayerObject(Name),
            assert(model_F(SelectedIndex,ActualPlayer))
        end if,
        setPlayer(ActualPlayer),
        legendDrawControl_ctl:invalidate().
    onStrategyListLBSelectionChanged(_Source).

facts
    model_F:(positive Index,player Player).
clauses
    setPlayer(PlayerObject):-
        not(model_F(0,_Player)),
        asserta(model_F(0,PlayerObject)),
        fail.
    setPlayer(PlayerObject):-
        playerNameEC_ctl:setText(PlayerObject:name),
        playerLegendIC_ctl:setInteger(PlayerObject:legend_V),
        legendDrawControl_ctl:setColor(convert(color,PlayerObject:legend_V)),
        Attributes=PlayerObject:getAttributes(),
        modelAttributeIC_ctl:setVisible(false),
        attributeNameTC_ctl : setVisible(false),
        foreach Attribute=list::getMember_nd(Attributes) do
            setAttributeData(Attribute)
        end foreach.

predicates
    onOkClick : button::clickResponder.
clauses
    onOkClick(_Source) = button::defaultAction:-
        SelectedIndex=strategyListLB_ctl:tryGetSelectedIndex(),
        model_F(SelectedIndex,Player),
        !,
        Player:legend_V:=playerLegendIC_ctl:getInteger(),
        Player:name:=playerNameEC_ctl:getText(),
        Player:setAttributes([namedValue(maxDepthID_C,unsigned(convert(unsigned,modelAttributeIC_ctl:getInteger())))]),
        GameUI=convert(gameSettings,getParent()),
        GameForm=convert(objectWinForm,GameUI:getTopLevelContainerWindow()),
        if not(list::isMember(Player,GameForm:logicProvider_V:competitors_V:players_V)) then
            GameForm:logicProvider_V:competitors_V:addPlayer(Player)
        end if.
    onOkClick(_Source) = button::defaultAction.

predicates
    onPlayerNameECValidate : control::validateResponder.
clauses
    onPlayerNameECValidate(Source) = FinalResult:- %control::contentsOk
        Name=Source:getText(),
        EmptyCheckResult=tryNameIsNotEmpty(Source,Name),
        FinalResult=tryNameIsUnique(Source,EmptyCheckResult,Name).

predicates
    tryNameIsNotEmpty:(control Source,string Name)->control::validateResult.
clauses
    tryNameIsNotEmpty(_Source,Name)=control::contentsOk:-
        not(string::trim(Name)=""),
        !.
    tryNameIsNotEmpty(Source,_Name) = control::contentsInvalid(Source,Source,"The Player's name is empty").

predicates
    tryNameIsUnique:(control Source,control::validateResult EmptyCheckResult,string Name)->control::validateResult.
clauses
    tryNameIsUnique(_Source,EmptyCheckResult,_Name)=EmptyCheckResult:-
        not(EmptyCheckResult=control::contentsOk),
        !.
    tryNameIsUnique(_Source,_EmptyCheckResult,Name)=control::contentsOk:-
        SelectedIndex=strategyListLB_ctl:tryGetSelectedIndex(),
        GameUI=convert(gameSettings,getParent()),
        GameForm=convert(objectWinForm,GameUI:getTopLevelContainerWindow()),
        if model_F(SelectedIndex,Player),! then
            GameForm:logicProvider_V:competitors_V:isNameUnique(Player,Name)
        else
            GameForm:logicProvider_V:competitors_V:isNameUnique(Name)
        end if,
        !.
    tryNameIsUnique(Source,_EmptyCheckResult,_Name) = control::contentsInvalid(Source,Source,"The Player's name is notUnique").


predicates
    onPlayerLegendICValidate : control::validateResponder.
clauses
    onPlayerLegendICValidate(Source) = control::contentsOk:-
        SelectedIndex=strategyListLB_ctl:tryGetSelectedIndex(),
        Legend=convert(integerControl,Source):getInteger(),
        GameUI=convert(gameSettings,getParent()),
        GameForm=convert(objectWinForm,GameUI:getTopLevelContainerWindow()),
        if model_F(SelectedIndex,Player),! then
            GameForm:logicProvider_V:competitors_V:isLegendUnique(Player,Legend)
        else
            GameForm:logicProvider_V:competitors_V:isLegendUnique(Legend)
        end if,
        !.
    onPlayerLegendICValidate(Source) = control::contentsInvalid(Source,Source,"The Player's Legend is NOT Unique").

% This code is maintained automatically, do not update it manually. 14:10:35-7.3.2008
facts
    ok_ctl : button.
    cancel_ctl : button.
    playerNameEC_ctl : editControl.
    browseLegendPB_ctl : button.
    attributeNameTC_ctl : textControl.
    modelAttributeIC_ctl : integercontrol.
    strategyListLB_ctl : listButton.
    modelDescriptionTC_ctl : textControl.
    legendDrawControl_ctl : legenddrawcontrol.
    playerLegendIC_ctl : integercontrol.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize():-
        setFont(vpi::fontCreateByName("MS Sans Serif", 8)),
        setText("Player Properties"),
        setRect(rct(50,40,214,158)),
        setModal(true),
        setDecoration(titlebar([closebutton()])),
        setState([wsf_NoClipSiblings]),
        addShowListener(onShow),
        playerNameEC_ctl := editControl::new(This),
        playerNameEC_ctl:setText(""),
        playerNameEC_ctl:setPosition(64, 4),
        playerNameEC_ctl:setWidth(96),
        playerNameEC_ctl:addValidateResponder(onPlayerNameECValidate),
        browseLegendPB_ctl := button::new(This),
        browseLegendPB_ctl:setText("Browse"),
        browseLegendPB_ctl:setPosition(132, 20),
        browseLegendPB_ctl:setSize(28, 12),
        browseLegendPB_ctl:setClickResponder(onBrowseLegendPBClick),
        strategyListLB_ctl := listButton::new(This),
        strategyListLB_ctl:setPosition(64, 36),
        strategyListLB_ctl:setWidth(96),
        strategyListLB_ctl:setMaxDropDownRows(7),
        strategyListLB_ctl:setSort(false),
        strategyListLB_ctl:addSelectionChangedListener(onStrategyListLBSelectionChanged),
        modelAttributeIC_ctl := integercontrol::new(This),
        modelAttributeIC_ctl:setPosition(64, 52),
        modelAttributeIC_ctl:setWidth(36),
        modelAttributeIC_ctl:setAutoHScroll(false),
        modelAttributeIC_ctl:setAlignBaseline(false),
        modelAttributeIC_ctl:setMandatory(true),
        modelAttributeIC_ctl:setMinimum(1),
        modelAttributeIC_ctl:setInteger(3),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&OK"),
        ok_ctl:setPosition(4, 102),
        ok_ctl:setSize(48, 12),
        ok_ctl:setAnchors([control::right,control::bottom]),
        ok_ctl:setClickResponder(onOkClick),
        cancel_ctl := button::newCancel(This),
        cancel_ctl:setText("Cancel"),
        cancel_ctl:setPosition(56, 102),
        cancel_ctl:setSize(48, 12),
        cancel_ctl:setAnchors([control::right,control::bottom]),
        StaticText_ctl = textControl::new(This),
        StaticText_ctl:setText("Player Name"),
        StaticText_ctl:setPosition(4, 4),
        StaticText_ctl:setSize(56, 12),
        StaticText1_ctl = textControl::new(This),
        StaticText1_ctl:setText("Player Legend"),
        StaticText1_ctl:setPosition(4, 20),
        StaticText1_ctl:setSize(56, 12),
        attributeNameTC_ctl := textControl::new(This),
        attributeNameTC_ctl:setText("Attribute"),
        attributeNameTC_ctl:setPosition(4, 52),
        attributeNameTC_ctl:setSize(56, 12),
        StaticText3_ctl = textControl::new(This),
        StaticText3_ctl:setText("Player Strategy"),
        StaticText3_ctl:setPosition(4, 36),
        StaticText3_ctl:setSize(56, 12),
        modelDescriptionTC_ctl := textControl::new(This),
        modelDescriptionTC_ctl:setText(""),
        modelDescriptionTC_ctl:setPosition(4, 68),
        modelDescriptionTC_ctl:setSize(156, 30),
        legendDrawControl_ctl := legenddrawcontrol::new(This),
        legendDrawControl_ctl:setPosition(108, 18),
        legendDrawControl_ctl:setSize(20, 14),
        legendDrawControl_ctl:setTabStop(false),
        legendDrawControl_ctl:setBorder(false),
        playerLegendIC_ctl := integercontrol::new(This),
        playerLegendIC_ctl:setPosition(64, 20),
        playerLegendIC_ctl:setWidth(40),
        playerLegendIC_ctl:setTabStop(false),
        playerLegendIC_ctl:setAutoHScroll(false),
        playerLegendIC_ctl:setAlignBaseline(false),
        playerLegendIC_ctl:setReadOnly(),
        playerLegendIC_ctl:setMandatory(true),
        playerLegendIC_ctl:setMinimum(0),
        playerLegendIC_ctl:addValidateResponder(onPlayerLegendICValidate),
        setDefaultButton(ok_ctl).
% end of automatic code
end implement playerProperties_UI

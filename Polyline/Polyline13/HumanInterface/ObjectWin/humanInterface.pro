/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement cHumanInterface
    inherits dialog
    inherits notificationAgency
    open core, vpiDomains


facts
    logicProvider_V:game:=erroneous.

clauses
    new(GameObj) :-
        logicProvider_V:=GameObj,
        VpiTaskWindow=vpi::getTaskWindow(),
        TaskWindow=window::convertVPIWin2Window(VpiTaskWindow),
        dialog::new(TaskWindow),
        generatedInitialize().

predicates
    onMessagePlayerWon:notificationListenerFiltered.
clauses
    onMessagePlayerWon(_NotificationAgency,_Source,string(Name)):-
        !,
        messageAreaTC_ctl:setText(string::format(localization_V:getText(polylineText::won_S),Name)).
    onMessagePlayerWon(_NotificationAgency,_Source,_Value).

clauses
    showUI():-
        logicProvider_V:seniourJudge_V:subscribe(onMessagePlayerWon,string(polylineDomains::playerWon_C)),
        show().

facts
    localization_V:polyLineText:=erroneous.
clauses
    setLanguage(Language):-
        if Language=polyLineDomains::en then
            localization_V:=polyLineTextEn::new()
        else
            localization_V:=polyLineTextRu::new()
        end if.

clauses
    showStatus(polylineDomains::initial):-
        messageAreaTC_ctl:setText(""),
        fail.
    showStatus(polylineDomains::interrupted):-
        messageAreaTC_ctl:setText("The Game is Interrupted!"),
        fail.
    showStatus(polylineDomains::humanMove(Player)):-
        messageAreaTC_ctl:setText(string::format("Player % is moving",Player:name)),
        fail.
    showStatus(polylineDomains::computerMove(Player)):-
        messageAreaTC_ctl:setText(string::format("Player % is moving",Player:name)),
        fail.
    showStatus(polylineDomains::newGame):-
        status
            (
            string::format(localization_V:getText(polylineText::round_S),
            toString(math::ceil(logicProvider_V:seniourJudge_V:gameCounter_V/list::length(logicProvider_V:competitors_V:players_V))))
            ),
            fail.
    showStatus(GameStatus):-
        gameView_ctl:showStatus(GameStatus),
        gameSettings_ctl:showStatus(GameStatus).

clauses
    canContinue():-
        logicProvider_V:seniourJudge_V:inProgress_V=false,
        !,
        fail.
    canContinue():-
        _Result=vpi::processEvents().

clauses
    inLoopPoint():-
        _Result=vpi::processEvents().

clauses
    getText(TextID)=localization_V:getText(TextID).

clauses
    announce(polylineText::errorWrongCell_S,InvalidData):-
        !,
        vpiCommonDialogs::error(string::format(localization_V:getText(polylineText::errorWrongCell_S),InvalidData)).
    announce(_Any,_Name).

clauses
    status(StatusText):-
        gameSettings_ctl:showStarterName(),
        statusTC_ctl:setText(StatusText).

% This code is maintained automatically, do not update it manually. 21:58:42-25.4.2010
facts
    messageAreaTC_ctl : editControl.
    statusTC_ctl : editControl.
    gameView_ctl : gameview.
    ok_ctl : button.
    help_ctl : button.
    gameSettings_ctl : gamesettings.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize():-
        setFont(vpi::fontCreateByName("MS Sans Serif", 8)),
        setText("Game Monitor"),
        setRect(rct(50,40,354,216)),
        setModal(false),
        setDecoration(titlebar([closebutton(),maximizebutton()])),
        setBorder(sizeBorder()),
        setState([wsf_NoClipSiblings]),
        messageAreaTC_ctl := editControl::new(This),
        messageAreaTC_ctl:setText(""),
        messageAreaTC_ctl:setPosition(108, 160),
        messageAreaTC_ctl:setWidth(144),
        messageAreaTC_ctl:setTabStop(false),
        messageAreaTC_ctl:setAnchors([control::left,control::right,control::bottom]),
        messageAreaTC_ctl:setAlignment(alignCenter),
        messageAreaTC_ctl:setReadOnly(),
        statusTC_ctl := editControl::new(This),
        statusTC_ctl:setText(""),
        statusTC_ctl:setPosition(256, 160),
        statusTC_ctl:setWidth(44),
        statusTC_ctl:setTabStop(false),
        statusTC_ctl:setAnchors([control::right,control::bottom]),
        statusTC_ctl:setAlignment(alignCenter),
        statusTC_ctl:setReadOnly(),
        gameSettings_ctl := gamesettings::new(This),
        gameSettings_ctl:setPosition(4, 2),
        gameSettings_ctl:setSize(148, 152),
        gameView_ctl := gameview::new(This),
        gameView_ctl:setPosition(156, 2),
        gameView_ctl:setSize(144, 152),
        gameView_ctl:setAnchors([control::left,control::top,control::right,control::bottom]),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&Close"),
        ok_ctl:setPosition(4, 160),
        ok_ctl:setSize(48, 12),
        ok_ctl:defaultHeight := false(),
        ok_ctl:setAnchors([control::left,control::bottom]),
        help_ctl := button::new(This),
        help_ctl:setText("&Help"),
        help_ctl:setPosition(56, 160),
        help_ctl:setSize(44, 12),
        help_ctl:defaultHeight := false(),
        help_ctl:setAnchors([control::left,control::bottom]),
        help_ctl:setEnabled(false),
        setDefaultButton(ok_ctl).
% end of automatic code
end implement cHumanInterface
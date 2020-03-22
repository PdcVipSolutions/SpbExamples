/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/

implement gameView
    inherits userControlSupport
    open core, vpiDomains

facts
    drawVertPos_V:integer:=erroneous.

clauses
    xSize()=GameForm:logicProvider_V:juniourJudge_V:maxColumn_P:-
        GameForm=convert(objectWinForm,getTopLevelContainerWindow()).
    ySize()=GameForm:logicProvider_V:juniourJudge_V:maxRow_P:-
        GameForm=convert(objectWinForm,getTopLevelContainerWindow()).

clauses
    new(Parent):-
        new(),
        setContainer(Parent).

clauses
    new():-
        userControlSupport::new(),
        generatedInitialize(),
        setEraseBackgroundResponder({ =  eraseBackground }),
        pnt(_X,Y)=gameBoard_ctl:getPosition(),
        drawVertPos_V:=Y.

clauses
    showStatus(GameStatus):-
        gameBoard_ctl:showStatus(GameStatus),
        fail.
    showStatus(polylineDomains::complete):-
        HumanInterface=convert(humanInterface,getTopLevelContainerWindow()),
        PlayerResultListList=HumanInterface:logicProvider_V:gameStatistics_V:getStatistics(),
        !,
        PlayerReportList =
            [ PlayerReport || hasDomain(string, Name),
                [Name, WinsTotal, WinsFirst, WinsNext] = list::getMember_nd(toTerm(PlayerResultListList)),
                PlayerReport =
                string::format(convert(objectWinForm, HumanInterface):localization_V:getText(polylineText::playerReport_S), Name, WinsTotal, WinsFirst, WinsNext)
            ],
        multiGameInformerEC_ctl : setText(string::concatList(PlayerReportList)).
    showStatus(_GameStatus).

predicates
    onViewModePBClick : button::clickResponder.
clauses
    onViewModePBClick(_Source) = button::defaultAction:-
        TrueIfBoard=gameBoard_ctl:getVisible(),
        TrueIfStatistics=multiGameInformerEC_ctl:getVisible(),
        multiGameInformerEC_ctl:setVisible(TrueIfBoard),
        cleareStatisticsPB_ctl:setVisible(TrueIfBoard),
        gameBoard_ctl:setVisible(TrueIfStatistics),
        if TrueIfBoard=true then
            viewModePB_ctl:setText("View Board")
        else
            viewModePB_ctl:setText("View Statistics")
        end if.

predicates
    onCleareStatisticsPBClick : button::clickResponder.
clauses
    onCleareStatisticsPBClick(_Source) = button::defaultAction:-
        UI=convert(notificationAgency,getTopLevelContainerWindow()),
        UI:notify(This,string(polylineDomains::uiRequestDatabase_C),string(polylineDomains::databaseClear_C)),
        multiGameInformerEC_ctl:setText("").

predicates
    onMultiGameInformerECModified : editControl::modifiedListener.
clauses
    onMultiGameInformerECModified(_Source).

% This code is maintained automatically, do not update it manually. 16:23:45-30.10.2008
facts
    cleareStatisticsPB_ctl : button.
    viewModePB_ctl : button.
    gameBoard_ctl : gameboard.
    multiGameInformerEC_ctl : editControl.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize():-
        setText("gameView"),
        This:setSize(148, 152),
        viewModePB_ctl := button::new(This),
        viewModePB_ctl:setText("Vie&w Statistics"),
        viewModePB_ctl:setPosition(4, 2),
        viewModePB_ctl:setSize(64, 12),
        viewModePB_ctl:setClickResponder(onViewModePBClick),
        gameBoard_ctl := gameboard::new(This),
        gameBoard_ctl:setPosition(0, 16),
        gameBoard_ctl:setSize(148, 136),
        cleareStatisticsPB_ctl := button::new(This),
        cleareStatisticsPB_ctl:setText("Cle&ar Statistics"),
        cleareStatisticsPB_ctl:setPosition(4, 136),
        cleareStatisticsPB_ctl:setSize(60, 14),
        cleareStatisticsPB_ctl:setAnchors([control::left,control::bottom]),
        cleareStatisticsPB_ctl:setVisible(false),
        cleareStatisticsPB_ctl:setClickResponder(onCleareStatisticsPBClick),
        multiGameInformerEC_ctl := editControl::new(This),
        multiGameInformerEC_ctl:setText(""),
        multiGameInformerEC_ctl:setPosition(0, 16),
        multiGameInformerEC_ctl:setWidth(148),
        multiGameInformerEC_ctl:setHeight(116),
        multiGameInformerEC_ctl:setAnchors([control::left,control::top,control::right,control::bottom]),
        multiGameInformerEC_ctl:setVisible(false),
        multiGameInformerEC_ctl:setMultiLine(),
        multiGameInformerEC_ctl:setAutoVScroll(true),
        multiGameInformerEC_ctl:setReadOnly(),
        multiGameInformerEC_ctl:addModifiedListener(onMultiGameInformerECModified).
% end of automatic code
end implement gameView

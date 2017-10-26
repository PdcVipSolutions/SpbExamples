/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement cHumanInterface
    inherits consoleEventSource
    inherits consoleControlContainer
    inherits notificationAgency

    open core

facts
    logicProvider_V:game:=erroneous.
    gameView_V:gameView:=erroneous.
    gameSettings_V:gameSettings:=erroneous.
    messageLine_V:consoleTextControl:=erroneous.
    statusLine_V:consoleTextControl:=erroneous.

clauses
    new(GameObj):-
        logicProvider_V:=convert(game,GameObj),
        gameSettings_V:=gameSettings::new(This),
        gameSettings_V:setPosition(0,0),
        gameSettings_V:setHeight(15),
        gameSettings_V:setWidth(50),

        messageLine_V:=consoleTextControl::new(This),
        messageLine_V:setPosition(0,16),
        messageLine_V:setWidth(35),
        messageLine_V:startFieldMark_V:='=',
        messageLine_V:endFieldMark_V:='=',

        statusLine_V:=consoleTextControl::new(This),
        statusLine_V:setPosition(37,16),
        statusLine_V:setWidth(15),
        statusLine_V:startFieldMark_V:='=',
        statusLine_V:endFieldMark_V:='=',

        gameView_V:=gameView::new(This),
        gameView_V:setPosition(0,17),
        gameView_V:setHeight(25),
        gameView_V:setWidth(80).

clauses
    showUI():-
        logicProvider_V:seniourJudge_V:subscribe(onMessagePlayerWon,string(polylineDomains::playerWon_C)),
        showControls(),
        run().


predicates
    onMessagePlayerWon:notificationListenerFiltered.
clauses
    onMessagePlayerWon(_NotificationAgency,_Source,string(Name)):-
        !,
        messageLine_V:setText(string::format(localization_V:getText(polylineText::won_S),Name)).
    onMessagePlayerWon(_NotificationAgency,_Source,_Value).

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
    canContinue():-
        logicProvider_V:seniourJudge_V:inProgress_V=false,
        !,
        fail.
    canContinue():-
        gameView_V:showProgress(),
        fail.
    canContinue():-
        processEvents().

    announce(polylineText::errorWrongCell_S,InvalidData):-
        !,
        consoleEventSource::messageBox(string::format(localization_V:getText(polylineText::errorWrongCell_S),InvalidData),"Error",0).
    announce(_Any,_Name).

clauses
    inLoopPoint():-
        processEvents().

domains
    textID_D=
        gameInterrupted_S;
        thinker_S;
        round_S.

predicates
    getTextI:(textID_D)->string.
clauses
    getTextI(thinker_S)="Player % is moving".
    getTextI(gameInterrupted_S)="The Game is Interrupted!".
    getTextI(round_S)="Round: %".

clauses
    showStatus(polylineDomains::initial):-
        messageLine_V:setText(""),
        fail.
    showStatus(polylineDomains::interrupted):-
        messageLine_V:setText
            (
            getTextI(gameInterrupted_S)
            ),
        fail.
    showStatus(polylineDomains::humanMove(Player)):-
        messageLine_V:setText
            (
            string::format(getTextI(thinker_S),Player:name)
            ),
        fail.
    showStatus(polylineDomains::computerMove(Player)):-
        messageLine_V:setText
            (
            string::format(getTextI(thinker_S),Player:name)
            ),
        fail.
    showStatus(polylineDomains::newGame):-
        status
            (
            string::format(getTextI(round_S),
            toString(math::ceil(logicProvider_V:seniourJudge_V:gameCounter_V/list::length(logicProvider_V:competitors_V:players_V))))
            ),
            fail.
    showStatus(GameStatus):-
        gameView_V:showStatus(GameStatus),
        gameSettings_V:showStatus(GameStatus).

predicates
    status:(string StatusText).
clauses
    status(StatusText):-
            gameSettings_V:showStarterName(),
            statusLine_V:setText(StatusText).

end implement cHumanInterface

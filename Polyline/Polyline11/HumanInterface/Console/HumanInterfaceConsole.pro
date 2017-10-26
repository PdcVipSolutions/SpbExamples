/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement cHumanInterface
    inherits notificationAgency

    open core

facts
    logicProvider_V:game:=erroneous.

constants
    cellMarkedInitial_C="#".
    cellMarkedWinner_C="O".
    cellMarkedOrdinary_C="*".

clauses
    new(GameObj):-
        logicProvider_V:=convert(game,GameObj).

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
    showUI():-
        logicProvider_V:juniourJudge_V:subscribe(onMove),
        logicProvider_V:seniourJudge_V:subscribe(onMessagePlayerWon,string(polylineDomains::playerWon_C)),
        defineBoardSize(),
        involvePlayers(1),
        logicProvider_V:seniourJudge_V:multiMode_V:=chooseSingleOrMultiGame(),
        performScenario().

predicates
    onMessagePlayerWon:notificationListenerFiltered.
clauses
    onMessagePlayerWon(_NotificationAgency,_Source,string(Name)):-
        !,
        announceInternal(polylineText::won_S,Name).
    onMessagePlayerWon(_NotificationAgency,_Source,_Value).

predicates
    performScenario:().
clauses
    performScenario():-
        defineNoOfRounds(),
        chooseExternalEntry(),
        reset(),
        setStarter(),
        notify(This,string(polylineDomains::uiRequestRun_C),none),
        if logicProvider_V:seniourJudge_V:multiMode_V=true then
            Statistics=logicProvider_V:gameStatistics_V:getStatistics(),
            announceInternal(polylineText::reportHeader_S,toString(list::length(logicProvider_V:competitors_V:players_V)*logicProvider_V:seniourJudge_V:noOfRounds_V)),
            announceInternal(polylineText::report_S,Statistics),
            waitOk()
        end if,
        ChoiceStr=getInput(polylineText::continueGame_S),
        ChoiceStr<>"", % stops the game
        !.
    performScenario():-
        reset(),
        logicProvider_V:seniourJudge_V:resetStarter(),
        performScenario().

/**************
Board drawing
**************/
domains
    boardSize_D=boardSize(positive X,positive Y).

constants % Position of Line
    starterLine_C=1.
    announceLine_C=starterLine_C+1.
    actionLine_C=announceLine_C+1.

constants
    verticalSpace_C=2.
    horizontalSpace_C=3.
    emptyLineLenght_C=80.

predicates
    showBoard:().
clauses
    showBoard():-
        console::clearOutput(),
        foreach I = std::fromTo(1, logicProvider_V:juniourJudge_V:maxColumn_P) do
            console::setLocation(console_native::coord(horizontalSpace_C*I, 0)),
            console::write(I)
        end foreach,
        foreach J = std::fromTo(1, logicProvider_V:juniourJudge_V:maxRow_P) do
            console::setLocation(console_native::coord(0, verticalSpace_C*J)),
            console::write(J)
        end foreach.

/**************
Define Board size
**************/
predicates
    defineBoardSize:().
clauses
    defineBoardSize():-
        InputString=getInput(polylineText::fieldSize_S,string::format("%s,%s",toString( logicProvider_V:juniourJudge_V:maxColumn_P),toString( logicProvider_V:juniourJudge_V:maxRow_P))),
        not(InputString=""),
        try
            hasDomain(boardSize_D,FieldSize),
            FieldSize=toTerm(string::format("boardSize(%s)",InputString)),
            FieldSize=boardSize(X,Y),
            if (X<6 or Y<6),! then
                exception::raise_User("Out of board!")
            end if,
            logicProvider_V:juniourJudge_V:maxColumn_P:=X,
            logicProvider_V:juniourJudge_V:maxRow_P:=Y
        catch _TraceID do
            announceInternal(polylineText::errorBoardSize_S,""),
            defineBoardSize()
        end try,
        !.
    defineBoardSize().

/*********************
Choose Single or Multi Game
**********************/
predicates
    chooseSingleOrMultiGame:()->boolean TrueIfMultiMode.
clauses
    chooseSingleOrMultiGame()=Choice:-
        ChoiceStr=getInput(polylineText::singleOrMulti_S),
        if string::equalIgnoreCase(ChoiceStr,"M") then
            Choice=true,% Multi
            !
        else
            Choice=false % Single
        end if.

/**************
Define No of rounds
**************/
predicates
    defineNoOfRounds:().
clauses
    defineNoOfRounds():-
        logicProvider_V:seniourJudge_V:multiMode_V=false,
        !.
    defineNoOfRounds():-
        InputString=getInput(polylineText::noOfRounds_S,toString(logicProvider_V:seniourJudge_V:noOfRounds_V)),
        not(InputString=""),
        try
            logicProvider_V:seniourJudge_V:noOfRounds_V:=toTerm(InputString)
        catch _TraceID do
            announceInternal(polylineText::errorNoOfRounds_S,""),
            defineNoOfRounds()
        end try,
        !.
    defineNoOfRounds().

/*********************
First entry alternative choice
*********************/
predicates
    chooseExternalEntry:().
clauses
    chooseExternalEntry():-
        logicProvider_V:seniourJudge_V:multiMode_V=false,
        !.
    chooseExternalEntry():-
        ChoiceStr=getInput(polylineText::multiGameExternalEntry_S),
        if string::equalIgnoreCase(ChoiceStr,"E") then
            logicProvider_V:seniourJudge_V:externalFirstMove_V:=true % ExternalEntry_Yes
        else
            logicProvider_V:seniourJudge_V:externalFirstMove_V:=false % ExternalEntry_Yes
        end if.

/*************
Involving players
**************/
predicates
    involvePlayers:(positive PlayerNo).
clauses
    involvePlayers(PlayerNo):-
        reset(),
        PlayerDescriptorList=logicProvider_V:competitors_V:getCandidates(),
        NumNameList = [ NumName || NumName = getNumberedPlayerName(PlayerDescriptorList) ],
        PlayersDescriptor=string::concatList(NumNameList),
        PlayerType=getInput(polylineText::playerType_S,toString([PlayersDescriptor,toString(PlayerNo)])),
        not(PlayerType=""),
        try
            Player=logicProvider_V:competitors_V:createPlayerObject(list::nth(toTerm(PlayerType)-1, PlayerDescriptorList)),
            setName(Player,PlayerType),
            logicProvider_V:competitors_V:addPlayer(Player),
            NewPlayerNo=PlayerNo+1
        catch _TraceID do
            announceInternal(polylineText::errorPlayerType_S,""),
            NewPlayerNo=PlayerNo
        end try,
        !,
        involvePlayers(NewPlayerNo).
    involvePlayers(_PlayerNo):-
        logicProvider_V:competitors_V:players_V=[_First,_Second|_],
        !.
    involvePlayers(PlayerNo):-
        announceInternal(polylineText::errorNoOfPlayers_S,""),
        involvePlayers(PlayerNo).

/**************
Set Player Name
**************/
predicates
    setName:(player,string ProposedId).
clauses
    setName(Player,ProposedId):-
        Player:name:=string::format("%s%s",Player:name,ProposedId),
        Name=getInput(polylineText::playerName_S,Player:name),
        if not(Name="") then
            Player:name:=Name
        end if.

facts
    counter_V:integer:=erroneous.
predicates
    getNumberedPlayerName:(string*)->string NumberedDescriptor nondeterm.
clauses
    getNumberedPlayerName(PlayerDescriptorList)=NumberedDescriptor:-
        counter_V:=0,
        PlayerDescriptor=list::getMember_nd(PlayerDescriptorList),
            counter_V:=counter_V+1,
            NumberedDescriptor=string::format("% - %\n",toString(counter_V),PlayerDescriptor).

/***************************
 Shoose Starting Player
***************************/
predicates
    setStarter:().
clauses
    setStarter():-
        if logicProvider_V:seniourJudge_V:multiMode_V=false then
            try
                logicProvider_V:seniourJudge_V:starter_V=_Starter
            catch _TraceID do
                logicProvider_V:seniourJudge_V:starter_V:=chooseStartingPlayer()
            end try
        end if,
        !.
    setStarter().

predicates
    chooseStartingPlayer:()->player StartingPlayer determ.
clauses
    chooseStartingPlayer()=Player:-
        not(logicProvider_V:competitors_V:players_V=[]) and not(logicProvider_V:competitors_V:players_V=[_SiglePlayer]),
        PlayList = [ PlayListMember || PlayListMember = playListMember() ],
        PlayListStr=string::concatList(PlayList),
        StartingPlayer=tryGetStartingPlayerInput(PlayListStr),
        Player=list::nth(StartingPlayer-1,logicProvider_V:competitors_V:players_V).

predicates
    playListMember:()->string nondeterm.
clauses
    playListMember()=PlayersListMember:-
        I = std::fromTo(1, list::length(logicProvider_V:competitors_V:players_V)),
            Player=list::nth(I-1,logicProvider_V:competitors_V:players_V),
            PlayersListMember=string::format("\n% - %",I,Player:name).

predicates
    tryGetStartingPlayerInput:(string PlayListStr)->positive StartingPlayerNo determ.
clauses
    tryGetStartingPlayerInput(PlayListStr)=StartingPlayer:-
        StartingPlayerStr=getInput(polylineText::startingPlayer_S,PlayListStr),
        if StartingPlayerStr<>"" then
            try
                StartingPlayer=toTerm(StartingPlayerStr)
            catch _TraceID1 do
                announceInternal(polylineText::errorMustBeNumber_S,""),
                fail
            end try,
            if StartingPlayer>list::length(logicProvider_V:competitors_V:players_V) then
                announceInternal(polylineText::errorStartingPlayer_S,""),
                fail
            end if,
            !
        else
            !,
            fail
        end if.
    tryGetStartingPlayerInput(PlayListStr)=StartingPlayer:-
        StartingPlayer=tryGetStartingPlayerInput(PlayListStr).
/*****************
Continue responder
******************/
clauses
    canContinue():-
        thinkCounter_V:=thinkCounter_V-1,
        thinkCounter_V<=0,
        clearMessageArea(actionLine_C),
        nextChar(char_V),
        thinkCounter_V:=thinkShowInterval_C,
        !,
        console::setLocation(console_native::coord(0,0)),
        console::write(char_V).
    canContinue().

/****************
Wait mark support
*****************/
constants
    thinkShowInterval_C:integer=3000.
facts
    thinkCounter_V:integer:=erroneous.

facts
    char_V:string:="-". % -\|/
predicates
    nextChar:(string CharIn) determ.
clauses
    nextChar("-"):-char_V:="\\".
    nextChar("\\"):-char_V:="|".
    nextChar("|"):-char_V:="/".
    nextChar("/"):-char_V:="-".

predicates
    clearWaitSignArea:().
clauses
    clearWaitSignArea():-
        Location=console::getLocation(),
        console::setLocation(console_native::coord(0,0)),
        console::write(" "),
        console::setLocation(Location).

clauses
    showStatus(polylineDomains::initial):-
        reset(),
        showBoard(),
        announceInternal(polylineText::starter_S,logicProvider_V:seniourJudge_V:starter_V:name),
        if logicProvider_V:seniourJudge_V:multiMode_V=true then
            RoundString=toString(math::ceil(logicProvider_V:seniourJudge_V:gameCounter_V/list::length(logicProvider_V:competitors_V:players_V))),
            announceInternal(polylineText::round_S,RoundString)
        end if,
        !.
    showStatus(polylineDomains::humanMove(Player)):-
        clearWaitSignArea(),
        move(Player),
        !.
    showStatus(polylineDomains::computerMove(Player)):-
        announceInternal(polylineText::thinker_S,Player:name),
        thinkCounter_V:=thinkShowInterval_C,
        fail.
    showStatus(polylineDomains::complete):-
        !,
        clearWaitSignArea().
    showStatus(_GameStatus).

predicates
    move:(player).
clauses
    move(Player):-
        InputString=getInput(polylineText::inviteHumanToMove_S),
        try
            notify(This,string(polylineDomains::humanMove_C),string(InputString))
        catch TraceID do
            handleException(TraceID),
            logicProvider_V:seniourJudge_V:notify(This,object(Player),none)  % Invite Player to repeat the Move
        end try.

predicates
    handleException:(exception::traceId TraceID).
clauses
    handleException(TraceID):-
        foreach Descriptor=exception::getDescriptor_nd(TraceID) do
            Descriptor = exception::descriptor
                (
                _ProgramPoint,
                _Eexception,
                _Kind,
                ExtraInfo,
                _GMTTime,
                _ThreadId
                ),
            if
                ExtraInfo=[namedValue(polylineDomains::wrongCellData_C,string(CellPointer))]
            then
                announce(polylineText::errorWrongCell_S,CellPointer)
            else
                announce(polylineText::error_S,"")
            end if
        end foreach.

predicates
    onMove:notificationAgency::notificationListener.
clauses
    onMove(_Request,_Agency,_PlayerObj,string(_MoveType),string(CellStr)):-
        polylineDomains::c(X,Y)=toTerm(CellStr),
        clearMessageArea(announceLine_C),
        console::setLocation(console_native::coord(horizontalSpace_C*X, verticalSpace_C*Y)),
        fail.
    onMove(_Request,_Agency,_PlayerObj,string(polylineDomains::initialExternalMove_C),string(_CellStr)):-
        !,
        console::write(cellMarkedInitial_C).
    onMove(_Request,_Agency,_PlayerObj,string(polylineDomains::ordinaryMove_C),string(_CellStr)):-
        !,
        console::write(cellMarkedOrdinary_C).
    onMove(_Request,_Agency,_PlayerObj,string(polylineDomains::winnerMove_C),string(_CellStr)):-
        !,
        console::write(cellMarkedWinner_C).
    onMove(_Request,_Agency,_Sender,_AnyType,_AnyCell).

/* Input support environment*/
predicates
    getInput:(polylineText::actionID_D,string StringParameter)->string InputString.
    getInput:(polylineText::actionID_D)->string InputString.
clauses
    getInput(InputType)=Input:-
        Input=getInput(InputType,"").

    getInput(InputType,StringParameter)=Input:-
        inputInvitation(InputType,StringParameter),
        !,
        Input = console::readLine(),
        console::clearInput().
    getInput(_InputType,_StringParameter)=_Input:-
        exception::raise_User("InternalException. Extra alternative").

predicates
    inputInvitation:(polylineText::actionID_D,string StringParameter) determ.
clauses
    inputInvitation(polylineText::inviteHumanToMove_S,_StringParameter):-
        clearMessageArea(actionLine_C),
        writeMessage(actionLine_C,"%",localization_V:getText(polylineText::inviteHumanToMove_S)).
    inputInvitation(polylineText::playerName_S,StringParameter):-
        console::writef(localization_V:getText(polylineText::playerName_S),StringParameter).
    inputInvitation(polylineText::playerType_S,StringParameter):-
        hasDomain(string,PlayersDescriptor),
        [PlayersDescriptor,PlayerNo]=toTerm(StringParameter),
        console::writef(localization_V:getText(polylineText::playerType_S),PlayersDescriptor,PlayerNo).
    inputInvitation(polylineText::startingPlayer_S,StringParameter):-
        console::write(StringParameter,localization_V:getText(polylineText::startingPlayer_S)).
    inputInvitation(polylineText::searchDepth_S,StringParameter):-
        console::writef(localization_V:getText(polylineText::searchDepth_S),StringParameter).
    inputInvitation(polylineText::fieldSize_S,StringParameter):-
        console::writef(localization_V:getText(polylineText::fieldSize_S),StringParameter).
    inputInvitation(polylineText::noOfRounds_S,StringParameter):-
        console::writef(localization_V:getText(polylineText::noOfRounds_S),StringParameter).
    inputInvitation(polylineText::continueGame_S,_StringParameter):-
        console::write(localization_V:getText(polylineText::continueGame_S)).
    inputInvitation(polylineText::singleOrMulti_S,_StringParameter):-
        console::write(localization_V:getText(polylineText::singleOrMultipleChoice_S)).
    inputInvitation(polylineText::multiGameExternalEntry_S,_StringParameter):-
        console::write(localization_V:getText(polylineText::multiGameExternalEntry_S)).

/* announcing environment*/
clauses
    announce(polylineText::errorWrongCell_S,InvalidData):-
        !,
        announceInternal(polylineText::errorWrongCell_S,InvalidData).
    announce(polylineText::error_S,InvalidData):-
        !,
        announceInternal(polylineText::error_S,InvalidData).
    announce(_Any,_Name).

predicates
    announceInternal:(polylineText::actionID_D AnnounceID,string AnnounceText).
clauses
    announceInternal(polylineText::errorNoOfPlayers_S,_DummyData):-
        !,
        console::write(localization_V:getText(polylineText::errorNoOfPlayers_S)),
        waitOk().
    announceInternal(polylineText::reportHeader_S,Parameter):-
        !,
        console::writef(localization_V:getText(polylineText::reportHeader_S),Parameter).
    announceInternal(polylineText::report_S,PlayerResultListList):-
        !,
        PlayerReportList = [ PlayerReport || hasDomain(string, Name),
        [Name, WinsTotal, WinsFirst, WinsNext] = list::getMember_nd(toTerm(PlayerResultListList)),
        PlayerReport = string::format(localization_V:getText(polylineText::playerReport_S), Name, WinsTotal, WinsFirst, WinsNext) ],
        console::write(string::concatList(PlayerReportList)).
    announceInternal(polylineText::round_S,RoundString):-
        !,
        clearMessageArea(announceLine_C),
        writeMessage(announceLine_C,localization_V:getText(polylineText::round_S),RoundString).
    announceInternal(polylineText::starter_S,Name):-
        !,
        clearMessageArea(starterLine_C),
        writeMessage(starterLine_C,localization_V:getText(polylineText::starter_S),Name).
    announceInternal(polylineText::errorPlayerType_S,_IgnoredText):-
        !,
        console::write(localization_V:getText(polylineText::errorPlayerType_S)),
        _=console::readLine().
    announceInternal(polylineText::errorMustBeNumber_S,_IgnoredText):-
        !,
        console::write(localization_V:getText(polylineText::errorMustBeNumber_S)).
    announceInternal(polylineText::errorStartingPlayer_S,_IgnoredText):-
        !,
        console::write(localization_V:getText(polylineText::errorStartingPlayer_S)).
    announceInternal(polylineText::errorBoardSize_S,_IgnoredText):-
        !,
        console::write(localization_V:getText(polylineText::errorBoardSize_S)).
    announceInternal(polylineText::errorNoOfRounds_S,_IgnoredText):-
        !,
        console::write(localization_V:getText(polylineText::errorNoOfRounds_S)).
    announceInternal(polylineText::error_S,ErrorText):-
        !,
        clearMessageArea(announceLine_C),
        writeMessage(announceLine_C,localization_V:getText(polylineText::error_S),ErrorText).
    announceInternal(polylineText::errorWrongCell_S,InvalidData):-
        !,
        clearMessageArea(announceLine_C),
        writeMessage(announceLine_C,localization_V:getText(polylineText::errorWrongCell_S),InvalidData).
    announceInternal(polylineText::won_S,Name):-
        !,
        clearMessageArea(announceLine_C),
        clearMessageArea(actionLine_C),
        writeMessage(announceLine_C,localization_V:getText(polylineText::won_S),Name),
        if logicProvider_V:seniourJudge_V:multiMode_V=false then
            _ = console::readLine()
        end if.
    announceInternal(polylineText::thinker_S,_Name):-
        logicProvider_V:seniourJudge_V:multiMode_V=true,
        !.
    announceInternal(polylineText::thinker_S,Name):-
        !,
        clearMessageArea(announceLine_C),
        clearMessageArea(actionLine_C),
        writeMessage(announceLine_C,localization_V:getText(polylineText::thinker_S),Name).
    announceInternal(_Any,_Name):-
        exception::raise_User("InternalException. Extra alternative").

predicates
    clearMessageArea:(positive AreaID).
clauses
    clearMessageArea(AreaID):-
        console::setLocation(console_native::coord(0,logicProvider_V:juniourJudge_V:maxRow_P*verticalSpace_C+AreaID)),
        console::write(string::create(emptyLineLenght_C," ")).

predicates
    writeMessage:(positive AreaID,string FormatString,string ParameterString).
clauses
    writeMessage(AreaID,FormatString,ParameterString):-
        console::setLocation(console_native::coord(0, logicProvider_V:juniourJudge_V:maxRow_P*verticalSpace_C+AreaID)),
        console::writef(FormatString,ParameterString).

predicates
    waitOK:().
clauses
    waitOK():-
        _=console::readLine().

predicates
    reset:().
clauses
    reset():-
        console::setLocation(console_native::coord(0,0)),
        console::write(string::create(3200," ")),
        console::clearOutput().

end implement cHumanInterface

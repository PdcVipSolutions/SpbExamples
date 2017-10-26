/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement humanInterface
    open core

constants
    cellMarkedOrdinary_C="*".
    cellMarkedWinner_C="O".

constants
    verticalSpace_C=2.
    horizontalSpace_C=3.
    emptyLineLenght_C=80.

constants % Position of Line
    starterLine_C=1.
    announceLine_C=starterLine_C+1.
    actionLine_C=announceLine_C+1.

facts
    game_V:game:=erroneous.

clauses
    new(GameObj):-
        game_V:=convert(game,GameObj).

facts
    language_V:polyLineText:=erroneous.

clauses
    setLanguage(Language):-
        if Language=polyLineDomains::en then
            language_V:=polyLineTextEn::new()
        else
            language_V:=polyLineTextRu::new()
        end if.

clauses
    getInput(InputType)=Input:-
        Input=getInput(InputType,"").

    getInput(InputType,StringParameter)=Input:-
        inputInvitation(InputType,StringParameter),
        !,
        Input = console::readLine(),
        console::clearInput().
    getInput(_InputType,_StringParameter)=_Input:-
        exception::raise_user("InternalException. Extra alternative").

predicates
    inputInvitation:(actionID_D,string StringParameter) determ.
clauses
    inputInvitation(playerStep_S,_StringParameter):-
        clearMessageArea(actionLine_C),
        writeMessage(actionLine_C,"%",language_V:getText(playerStep_S)).
    inputInvitation(playerName_S,StringParameter):-
        console::writef(language_V:getText(playerName_S),StringParameter).
    inputInvitation(playerType_S,StringParameter):-
        hasDomain(string,PlayersDescriptor),
        [PlayersDescriptor,PlayerNo]=toTerm(StringParameter),
        console::writef(language_V:getText(playerType_S),PlayersDescriptor,PlayerNo).
    inputInvitation(startingPlayer_S,StringParameter):-
        console::write(StringParameter,language_V:getText(startingPlayer_S)).
    inputInvitation(searchDepth_S,StringParameter):-
        console::writef(language_V:getText(searchDepth_S),StringParameter).
    inputInvitation(fieldSize_S,StringParameter):-
        console::writef(language_V:getText(fieldSize_S),StringParameter).
    inputInvitation(noOfRounds_S,StringParameter):-
        console::writef(language_V:getText(noOfRounds_S),StringParameter).
    inputInvitation(singleOrMulti_S,_StringParameter):-
        console::write(language_V:getText(singleOrMultipleChoice_S)).

clauses
    showStage():-
        game_V:multiMode_V=true,
        !.
    showStage():-
        console::clearOutput(),
        foreach I = std::fromTo(1, game_V:juniourJudge_V:maxColumn_P) do
            console::setLocation(console_native::coord(horizontalSpace_C*I, 0)),
            console::write(I)
        end foreach,
        foreach J = std::fromTo(1, game_V:juniourJudge_V:maxRow_P) do
            console::setLocation(console_native::coord(0, verticalSpace_C*J)),
            console::write(J)
        end foreach.

clauses
    showStep(_Cell,_Type):-
        game_V:multiMode_V=true,
        clearMessageArea(actionLine_C),
        nextChar(char_V),
        !,
        writeMessage(actionLine_C,"%",char_V).
    showStep(polyLineDomains::c(X,Y),_Type):-
        console::setLocation(console_native::coord(horizontalSpace_C*X, verticalSpace_C*Y)),
        fail.
    showStep(_Cell,humanInterface::ordinary_S):-
        console::write(cellMarkedOrdinary_C).
    showStep(_Cell,humanInterface::winner_S):-
        console::write(cellMarkedWinner_C).

facts
    char_V:string:="-". % -\|/
predicates
    nextChar:(string CharIn) determ.
clauses
    nextChar("-"):-char_V:="\\".
    nextChar("\\"):-char_V:="|".
    nextChar("|"):-char_V:="/".
    nextChar("/"):-char_V:="-".

clauses
    announceStartUp():-
        reset().

clauses
    announce(reportHeader_S,Parameter):-
        !,
        console::writef(language_V:getText(reportHeader_S),Parameter).
    announce(report_S,PlayerResultListList):-
        !,
        PlayerReportList = [ PlayerReport || hasDomain(string, Name),
        [Name, WinsTotal, WinsFirst, WinsNext] = list::getMember_nd(toTerm(PlayerResultListList)),
        PlayerReport = string::format(language_V:getText(playerReport_S), Name, WinsTotal, WinsFirst, WinsNext) ],
        console::write(string::concatList(PlayerReportList)).
    announce(round_S,RoundString):-
        !,
        clearMessageArea(announceLine_C),
        writeMessage(announceLine_C,language_V:getText(round_S),RoundString).
    announce(starter_S,Name):-
        !,
        clearMessageArea(starterLine_C),
        writeMessage(starterLine_C,language_V:getText(beginner_S),Name).
    announce(errorPlayerType_S,_IgnoredText):-
        !,
        console::write(language_V:getText(errorPlayerType_S)),
        _=console::readLine().
    announce(errorMustBeNumber_S,_IgnoredText):-
        !,
        console::write(language_V:getText(errorMustBeNumber_S)).
    announce(errorStartingPlayer_S,_IgnoredText):-
        !,
        console::write(language_V:getText(errorStartingPlayer_S)).
    announce(errorFieldSize_S,_IgnoredText):-
        !,
        console::write(language_V:getText(errorFieldSize_S)).
    announce(errorNoOfRounds_S,_IgnoredText):-
        !,
        console::write(language_V:getText(errorNoOfRounds_S)).
    announce(error_S,ErrorText):-
        !,
        clearMessageArea(announceLine_C),
        writeMessage(announceLine_C,language_V:getText(error_S),ErrorText).
    announce(errorWrongCell_S,InvalidData):-
        !,
        clearMessageArea(announceLine_C),
        writeMessage(announceLine_C,language_V:getText(errorWrongCell_S),InvalidData).
    announce(win_S,Name):-
        !,
        clearMessageArea(announceLine_C),
        clearMessageArea(actionLine_C),
        writeMessage(announceLine_C,language_V:getText(congratulation_S),Name),
        _ = console::readLine().
    announce(loss_S,Name):-
        !,
        clearMessageArea(announceLine_C),
        clearMessageArea(actionLine_C),
        writeMessage(announceLine_C,language_V:getText(sorryLoss_S),Name),
        _ = console::readLine().
    announce(thinker_S,_Name):-
        game_V:multiMode_V=true,
        !.
    announce(thinker_S,Name):-
        !,
        clearMessageArea(announceLine_C),
        clearMessageArea(actionLine_C),
        writeMessage(actionLine_C,language_V:getText(thinker_S),Name).
    announce(_Any,_Name):-
        exception::raise_user("InternalException. Extra alternative").

clauses
    waitOK():-
        _=console::readLine().

clauses
    reset():-
        console::setLocation(console_native::coord(0,0)),
        console::write(string::create(1600," ")),
        console::clearOutput().

predicates
    clearMessageArea:(positive AreaID).
clauses
    clearMessageArea(AreaID):-
        console::setLocation(console_native::coord(0,game_V:juniourJudge_V:maxRow_P*verticalSpace_C+AreaID)),
        console::write(string::create(emptyLineLenght_C," ")).

predicates
    writeMessage:(positive AreaID,string FormatString,string ParameterString).
clauses
    writeMessage(AreaID,FormatString,ParameterString):-
        console::setLocation(console_native::coord(0, game_V:juniourJudge_V:maxRow_P*verticalSpace_C+AreaID)),
        console::writef(FormatString,ParameterString).

end implement humanInterface

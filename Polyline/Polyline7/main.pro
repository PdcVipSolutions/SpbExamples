/***************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline

Predicates
    neighbour_nd,
    neighbourOutOfPolyLine_nd
based on solutions proposed by Elena Efimova
***************************************************************/

/*****************
  GOAL
*****************/
goal
    mainExe::run(main::run).

/*****************
  Class Main
*****************/
implement main
    open core

clauses
    run():-
        console::init(),
        game::run().

end implement main

class game
open core

domains
    language_D=
        en;
        ru.

properties
    language_V:language_D.
    players_V:player*.
    multiMode_V:boolean.

predicates
    run:().
    addPlayer:(player Player).

end class game

implement game
open core

class facts
    language_V:language_D:=en.
    multiMode_V:boolean:=false.

clauses
    run():-
        setLanguage(),
        humanInterface::setLanguage(language_V),
        Mode=chooseSingleOrMultiGame(),
        setGameProperties(),
        competitors::involvePlayers(),
        if Mode=single_S then
            playSingle()
        else
            multiMode_V:=true,
            seniourJudge::playMulti()
        end if.

domains
    mode_D=
        single_S;
        multi_S.

class predicates
    setLanguage:().
clauses
    setLanguage():-
        CommandLine = mainExe::getCommandLine(),
        if string::hasSuffix(CommandLine,"ru",_RestRu) then
            language_V:=ru
        end if,
        if string::hasSuffix(CommandLine,"en",_RestEn) then
            language_V:=en
        end if.

class predicates
    chooseSingleOrMultiGame:()->mode_D GameOrCompetition.
clauses
    chooseSingleOrMultiGame()=Choice:-
        ChoiceStr=humanInterface::getInput(humanInterface::singleOrMulti_S),
        if (string::equalIgnoreCase(ChoiceStr,"S") or ChoiceStr=""),! then
            Choice=single_S,
            !
        else
            Choice=multi_S
        end if.

class predicates
    playSingle:().
clauses
    playSingle():-
        StartingPlayer=chooseStartingPlayer(),
        seniourJudge::playSingle(StartingPlayer),
        !,
        playSingle().
    playSingle().

class predicates
    setGameProperties:().
clauses
    setGameProperties():-
        juniourJudge::defineStage().

/***************************
  Players
***************************/
class facts
    players_V:player*:=[].

clauses
    addPlayer(Player):-
        players_V:=list::append(players_V,[Player]).

/***************************
 Shoose Starting Player
***************************/
class predicates
    chooseStartingPlayer:()->player determ.
clauses
    chooseStartingPlayer()=Player:-
        not(players_V=[]) and not(players_V=[_SiglePlayer]),
        PlayList = [ PlayListMember || PlayListMember = playListMember() ],
        PlayListStr=string::concatList(PlayList),
        StartingPlayer=getStartingPlayerInput(PlayListStr),
        Player=list::nth(StartingPlayer-1,players_V).

class predicates
    playListMember:()->string nondeterm.
clauses
    playListMember()=PlayersListMember:-
        I = std::fromTo(1, list::length(game::players_V)),
            Player=list::nth(I-1,game::players_V),
            PlayersListMember=string::format("\n% - %",I,Player:name).

class predicates
    getStartingPlayerInput:(string PlayListStr)->positive StartingPlayerNo determ.
clauses
    getStartingPlayerInput(PlayListStr)=StartingPlayer:-
        StartingPlayerStr=humanInterface::getInput(humanInterface::startingPlayer_S,PlayListStr),
        if StartingPlayerStr="" then
            !,
            fail
        else
            try
                StartingPlayer=toTerm(StartingPlayerStr),
                !
            catch _TraceID1 do
                humanInterface::announce(humanInterface::errorMustBeNumber_S,""),
                fail
            end try,
            if StartingPlayer>list::length(players_V) then
                humanInterface::announce(humanInterface::errorStartingPlayer_S,""),
                fail
            end if
        end if.
    getStartingPlayerInput(PlayListStr)=StartingPlayer:-
        StartingPlayer=getStartingPlayerInput(PlayListStr).

end implement game

/************************
  Class seniorJudge
************************/
class seniourJudge
open core

properties
    inProgress_V:boolean.

predicates
    playSingle:(player CurrentPlayer).
    playMulti:().

end class seniourJudge

implement seniourJudge
open core, humanInterface

class facts
    inProgress_V:boolean:=false.

clauses
    playSingle(Player):-
        inProgress_V=false,
        humanInterface::showStage(),
        humanInterface::announce(humanInterface::starter_S,Player:name),
        inProgress_V:=true,
        Player:move(),
        playSingle(Player),
        !.
    playSingle(Player):-
        juniourJudge::isGameOver(),
        !,
        if game::multiMode_V=false then
            Player:announceWin(),
            foreach (Participant=list::getMember_nd(game::players_V) and not(Participant=Player)) do
                Participant:announceLoss()
            end foreach
        else
            addWinner(Player)
        end if,
        inProgress_V:=false,
        juniourJudge::reset().
    playSingle(Player):-
        NextPlayer=nextPlayer(Player),
        NextPlayer:move(),
        !,
        playSingle(NextPlayer).

class predicates
    nextPlayer:(player CurrentPlayer)->player NextPlayer.
clauses
    nextPlayer(Player)=NextPlayer:-
        Index=list::tryGetIndex(Player,game::players_V),
        NextPlayer=list::tryGetNth(Index+1,game::players_V),
        !.
    nextPlayer(_Player)=list::nth(0,game::players_V).

/************************
  Multi Mode Handle
************************/
class predicates
    defineNoOfRounds:().
clauses
    defineNoOfRounds():-
        InputString=humanInterface::getInput(humanInterface::noOfRounds_S,toString(noOfRounds_V)),
        not(InputString=""),
        try
            noOfRounds_V:=toTerm(InputString)
        catch _TraceID do
            humanInterface::announce(humanInterface::errorNoOfRounds_S,""),
            defineNoOfRounds()
        end try,
        !.
    defineNoOfRounds().

class facts
    starter_V:player:=erroneous.
    noOfRounds_V:positive:=10.
    statistics_F:(boolean TrueIfWon,player,positive Won).

clauses
    playMulti():-
        defineNoOfRounds(),
        Player=list::getMember_nd(game::players_V),
            starter_V:=Player,
            playRound(noOfRounds_V),
        fail().
    playMulti():-
        humanInterface::reset(),
        PlayersNo=list::length(game::players_V),
        humanInterface::announce(humanInterface::reportHeader_S,toString(PlayersNo*noOfRounds_V)),
        PlayerResultListList = [ PlayerResultList || Player = list::getMember_nd(game::players_V),
        WinsFirst = calculateWins(Player, true),
        WinsNext = calculateWins(Player, false),
        WnsTotal = WinsFirst + WinsNext,
        PlayerResultList = [Player:name, toString(WnsTotal), toString(WinsFirst), toString(WinsNext)] ],
        humanInterface::announce(humanInterface::report_S,toString(PlayerResultListList)),
        fail().
    playMulti():-
        humanInterface::waitOK().

class facts
    wins_V:integer:=0.
class predicates
    calculateWins:(player Player,boolean TrueIfFirst)->integer Sum.
clauses
    calculateWins(Player,TrueIfFirst)=_:-
        wins_V:=0,
        statistics_F(TrueIfFirst,Player,Won),
            try
            	wins_V := wins_V + Won
            catch _TraceID do
            	fail
            end try,
        fail.
    calculateWins(_Player,_TrueIfFirst)=wins_V.

class predicates
    playRound:(positive NoOfRounds).
clauses
    playRound(0):-!.
    playRound(NoOfRounds):-
        humanInterface::announce(round_S,toString(noOfRounds_V-NoOfRounds+1)),
        seniourJudge::playSingle(starter_V),
        playRound(NoOfRounds-1).

class predicates
    addWinner:(player).
clauses
    addWinner(Player):-
        if Player=starter_V then
            TrueIfStarted=true
        else
            TrueIfStarted=false
        end if,
        addWinner(TrueIfStarted,Player).

class predicates
    addWinner:(boolean TrueIfStarted,player Player).
clauses
    addWinner(TrueIfStarted,Player):-
        retract(statistics_F(TrueIfStarted,Player,Won)),
        !,
        assert(statistics_F(TrueIfStarted,Player,Won+1)).
    addWinner(TrueIfStarted,Player):-
        assert(statistics_F(TrueIfStarted,Player,1)).

end implement seniourJudge

/************************
  Class juniourJudge
************************/
class juniourJudge
open core

domains
    cell = c(positive,positive).
    stepType_D=
        ordinary_S;
        winner_S.

properties
    maxRow_P:positive.
    maxColumn_P:positive.
    polyline_P:cell*.

predicates
    defineStage:().
    neighbour_nd: (cell,cell) nondeterm (i,o) (i,i).
    neighbourOutOfPolyLine_nd:(cell,cell)->cell nondeterm.
    set: (string ).
    isGameOver:() determ.
    reset:().

end class juniourJudge

implement juniourJudge
open core, humanInterface

class facts
    maxRow_P:positive:=6.
    maxColumn_P:positive:=6.
    polyline_P:cell*:=[].
    endOfGame_V:boolean:=false.

domains
    fieldSize_D=tableSize(positive X,positive Y).

clauses
    defineStage():-
        defineFieldSize().

class predicates
    defineFieldSize:().
clauses
    defineFieldSize():-
        InputString=humanInterface::getInput(humanInterface::fieldSize_S,string::format("%s,%s",toString(maxColumn_P),toString(maxRow_P))),
        not(InputString=""),
        try
            hasDomain(fieldSize_D,FieldSize),
            FieldSize=toTerm(string::format("tableSize(%s)",InputString)),
            FieldSize=tableSize(X,Y),
            maxColumn_P:=X,
            maxRow_P:=Y
        catch _TraceID do
            humanInterface::announce(humanInterface::errorFieldSize_S,""),
            defineFieldSize()
        end try,
        !.
    defineFieldSize().

clauses
    isGameOver():-
        endOfGame_V=true.

clauses
    set(InputString):-
        Cell=convertToCell(InputString),
        handleInput (Cell).

class predicates
    convertToCell:(string InputString)->cell.
clauses
    convertToCell(InputString)=Cell:-
        try
        	Cell = toTerm(InputString)
        catch _TraceID do
        	fail
        end try,
        !.
    convertToCell(InputString)=Cell:-
        CellString=string::format("c(%s)",InputString),
        try
        	Cell = toTerm(CellString)
        catch _TraceID do
        	fail
        end try,
        !.
    convertToCell(InputString)=toTerm(InputString).

clauses
    reset():-
        juniourJudge:: polyline_P:=[],
        juniourJudge::endOfGame_V:=false.

class predicates
    handleInput:(juniourJudge::cell).
clauses
    handleInput(Cell):-
        list::isMember(Cell,polyline_P),
        try
            _=makePolyLine(Cell,polyline_P) % it will be an exception if wrong Cell, but we ignore it by failing
        catch _TraceID do
            fail
        end try,
        !,
        endOfGame_V:=true,
        humanInterface::showStep(Cell,winner_S).
    handleInput (Cell):-
        polyline_P:=makePolyLine(Cell,polyline_P),
        !,
        humanInterface::showStep(Cell,ordinary_S).

class predicates
    makePolyLine: (cell,cell*)-> cell* multi.
clauses
    makePolyLine(c(X,Y),[])=[c(X,Y)]:-
        X>0,X<=maxColumn_P,
        Y>0,Y<=maxRow_P,
        !.
    makePolyLine(NewCell,[SingleCell])=[NewCell,SingleCell]:-
        neighbour_nd(SingleCell, NewCell),
        !.
    makePolyLine(NewCell,[Left, RestrictingCell | PolyLineTail])=[NewCell, Left, RestrictingCell | PolyLineTail]:-
        NewCell=neighbourOutOfPolyLine_nd(Left,RestrictingCell).
    makePolyLine(NewCell,PolyLine)=list::reverse([NewCell,Left, RestrictingCell | PolyLineTail]):-
        [Left, RestrictingCell | PolyLineTail]= list::reverse(PolyLine),
        NewCell=neighbourOutOfPolyLine_nd(Left,RestrictingCell).
    makePolyLine(NewCell,_PolyLine)= _PolyLine1:-
        exception::raise_user("",[namedValue("data",string(toString(NewCell)))]).

clauses
    neighbourOutOfPolyLine_nd(Cell,RestrictingCell)=NewCell:-
        neighbour_nd(Cell,NewCell),
            not(NewCell = RestrictingCell).

clauses
    neighbour_nd(c(X, Y), c(X + 1, Y)):- X < maxColumn_P.
    neighbour_nd(c(X, Y), c(X, Y + 1)):- Y < maxrow_P.
    neighbour_nd(c(X, Y), c(X - 1, Y)):- X > 1.
    neighbour_nd(c(X, Y), c(X, Y - 1)):- Y > 1.

end implement juniourJudge

/******************************************
  Interface Player
******************************************/
interface player

predicates
    setName:(string).
    move:().
    announceWin:().
    announceLoss:().

properties
    name:string.

end interface player

/**************
  Text localization
**************/
interface polyLineText
open core

predicates
        getText:(humanInterface::actionID_D)->string Text.
end interface polyLineText

class polyLineTextRu:polyLineText
end class polyLineTextRu

implement polyLineTextRu
open core, humanInterface

clauses
    getText(TextID)=Text:-
        Text=getTextInt(TextID),
        !.
    getText(_TextID)="Текст не предусмотрен".

class predicates
    getTextInt:(humanInterface::actionID_D TextID)->string Text determ.
clauses
    getTextInt(thinker_S)="% думает ...".
    getTextInt(round_S)="Раунд: %".
    getTextInt(beginner_S)="Первый ход: %".
    getTextInt(congratulation_S)="Игрок % выиграл!".
    getTextInt(sorryLoss_S)="%,  к сожалению, Вы проиграли :-(".

    getTextInt(singleOrMultipleChoice_S)="Выберите режим (S или Enter - одиночная игра, другое - мульти):".
    getTextInt(fieldSize_S)="\nВведите размер игрового поля X,Y (по умолчанию %):".
    getTextInt(playerStep_S)="Введите координаты клетки как c(X,Y) или как X,Y: ".
    getTextInt(playerType_S)="\nВозможные типы игроков:\n%s\nИгрок #%s. Укажите тип (Enter - конец выбора игроков):".
    getTextInt(playerName_S)="\nВведите имя Игрока (предлагается %):".
    getTextInt(startingPlayer_S)="\nКто первый ходит (номер Игрока или Enter - конец игры)?:".
    getTextInt(searchDepth_S)="\nУкажите глубину поиска решения в шагах(% - по умолчанию): ".
    getTextInt(noOfRounds_S)="\nВведите число партий игры (по умолчанию %):".
    getTextInt(reportHeader_S)="\nРезультаты % игр:".
    getTextInt(playerReport_S)="\nИгрок %:\n\t Всего побед % из них:\n\t\tПри ходе первым - \t%\n\t\tПри ходе следующим - \t% ".

    getTextInt(error_S)="Ошибка, % ".
    getTextInt(errorPlayerType_S)="\nТакого ТИПА Игрока нет! Enter - для повторного ввода:".
    getTextInt(errorMustBeNumber_S)="\nДолжен быть номер! Повторите ввод:".
    getTextInt(errorstartingPlayer_S)="\nТакого Игрока нет! Повторите ввод:".
    getTextInt(errorFieldSize_S)="\nНеправильно указан размер игрового поля! Повторите ввод:".
    getTextInt(errorNoOfRounds_S)="\nНеправильно указано число партий! Повторите ввод:".
    getTextInt(errorWrongCell_S)="Ход % не может быть продолжением линии:".

end implement polyLineTextRu

class polyLineTextEn:polyLineText
end class polyLineTextEn

implement polyLineTextEn
open core, humanInterface

clauses
    getText(TextID)=Text:-
        Text=getTextInt(TextID),
        !.
    getText(_TextID)="No Text Exists".

class predicates
    getTextInt:(humanInterface::actionID_D TextID)->string Text determ.
clauses
    getTextInt(thinker_S)="% is thinking ...".
    getTextInt(round_S)="Round: %".
    getTextInt(beginner_S)="First move done by: %".
    getTextInt(congratulation_S)="Player % won!".
    getTextInt(sorryLoss_S)="%,  Sorry, you loss :-(".

    getTextInt(singleOrMultipleChoice_S)="Please choose the mode (S or Enter - single game, other - multiple):".
    getTextInt(fieldSize_S)="\nPlease enter the size of the gaimbling field X,Y (% by default):".
    getTextInt(playerStep_S)="Please enter your move as c(X,Y) or as X,Y: ".
    getTextInt(playerType_S)="\nPossible player types:\n%s\nPlayer #%s. Please enter the player type (Enter - end of list):".
    getTextInt(playerName_S)="\nPlease assign the name to the player (% proposed):".
    getTextInt(startingPlayer_S)="\nWho moves the first (PlayerNo or Enter - end of the game)?:".
    getTextInt(searchDepth_S)="\nChoose the depth of the prognosis (% - by default): ".
    getTextInt(noOfRounds_S)="\nPlease enter the number of games (% by default):".
    getTextInt(reportHeader_S)="\nResult of % games:".
    getTextInt(playerReport_S)="\nPlayer %:\n\t Wins Total % and:\n\t\tWhile first move - \t%\n\t\tWhile next move - \t% ".

    getTextInt(error_S)="Error, % ".
    getTextInt(errorPlayerType_S)="\nNo such player type exiasts! Enter - repeat input:".
    getTextInt(errorMustBeNumber_S)="\nMust be number! Please repeat input:".
    getTextInt(errorstartingPlayer_S)="\nNo such Player exiasts! Please repeat input:".
    getTextInt(errorFieldSize_S)="\nWrong size of the field entered! Please repeat input:".
    getTextInt(errorNoOfRounds_S)="\nWrong amount of games entered! Please repeat input:".
    getTextInt(errorWrongCell_S)="The Move % doesn't prolong the PolyLine:".

end implement polyLineTextEn

/******************************************
  Class HumanInterface
******************************************/
class humanInterface
open core

domains
    actionID_D=
        beginner_S;
        thinker_S;
        congratulation_S;
        sorryLoss_S;

        reportHeader_S;
        playerReport_S;
        report_S;

        round_S;
        starter_S;

        win_S;
        loss_S;

        singleOrMultipleChoice_S;
        fieldSize_S;
        playerStep_S;
        playerType_S;
        playerName_S;
        startingPlayer_S;
        searchDepth_S;
        noOfRounds_S;

        singleOrMulti_S;

        error_S;
        errorPlayerType_S;
        errorMustBeNumber_S;
        errorstartingPlayer_S;
        errorFieldSize_S;
        errorNoOfRounds_S;
        errorWrongCell_S.

predicates
   reset:().

predicates
    announceStartUp:().

predicates
    setLanguage:(game::language_D).
    waitOK:().
    showStage:().
    showStep:(juniourJudge::cell,juniourJudge::stepType_D).
    getInput:(actionID_D,string StringParameter)->string InputString.
    getInput:(actionID_D)->string InputString.
    announce:(actionID_D AnnounceID,string AnnounceText).

end class humanInterface

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

class facts
    language_V:polyLineText:=erroneous.

clauses
    setLanguage(Language):-
        if Language=game::en then
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

class predicates
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
        game::multiMode_V=true,
        !.
    showStage():-
        console::clearOutput(),
        foreach I = std::fromTo(1, juniourJudge::maxColumn_P) do
            console::setLocation(console_native::coord(horizontalSpace_C*I, 0)),
            console::write(I)
        end foreach,
        foreach J = std::fromTo(1, juniourJudge::maxRow_P) do
            console::setLocation(console_native::coord(0, verticalSpace_C*J)),
            console::write(J)
        end foreach.

clauses
    showStep(_Cell,_Type):-
        game::multiMode_V=true,
        clearMessageArea(actionLine_C),
        nextChar(char_V),
        !,
        writeMessage(actionLine_C,"%",char_V).
    showStep(juniourJudge::c(X,Y),_Type):-
        console::setLocation(console_native::coord(horizontalSpace_C*X, verticalSpace_C*Y)),
        fail.
    showStep(_Cell,juniourJudge::ordinary_S):-
        console::write(cellMarkedOrdinary_C).
    showStep(_Cell,juniourJudge::winner_S):-
        console::write(cellMarkedWinner_C).

class facts
    char_V:string:="-". % -\|/
class predicates
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
        game::multiMode_V=true,
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

class predicates
    clearMessageArea:(positive AreaID).
clauses
    clearMessageArea(AreaID):-
        console::setLocation(console_native::coord(0,juniourJudge::maxRow_P*verticalSpace_C+AreaID)),
        console::write(string::create(emptyLineLenght_C," ")).

class predicates
    writeMessage:(positive AreaID,string FormatString,string ParameterString).
clauses
    writeMessage(AreaID,FormatString,ParameterString):-
        console::setLocation(console_native::coord(0, juniourJudge::maxRow_P*verticalSpace_C+AreaID)),
        console::writef(FormatString,ParameterString).

end implement humanInterface

/******************
  Class Competitors
******************/
class competitors
open core

predicates
    involvePlayers:().

end class competitors

implement competitors
open core
clauses
    involvePlayers():-
        involvePlayers(1).

class predicates
    involvePlayers:(positive PlayerNo).
clauses
    involvePlayers(PlayerNo):-
        humanInterface::announceStartUp(),
        PlayerDescriptorList = [ PlayerDescriptor || playerDescriptor(No, PlayerDescriptorSrc),
        PlayerDescriptor = string::format("% - %\n", No, PlayerDescriptorSrc) ],
        PlayersDescriptor=string::concatList(PlayerDescriptorList),
        PlayerType=humanInterface::getInput(humanInterface::playerType_S,toString([PlayersDescriptor,toString(PlayerNo)])),
        not(PlayerType=""),
        try
            Player=createPlayerObject(toTerm(PlayerType)),
            Player:setName(toString(PlayerNo)),
            game::addPlayer(Player),
            NewPlayerNo=PlayerNo+1
        catch _TraceID do
            humanInterface::announce(humanInterface::errorPlayerType_S,""),
            NewPlayerNo=PlayerNo
        end try,
        !,
        involvePlayers(NewPlayerNo).
    involvePlayers(_PlayerNo).

class predicates
    playerDescriptor:(positive No [out],string PlayerDescriptorSrc [out]) multi.
clauses
    playerDescriptor(1,human::getPlayerDescriptor(game::language_V)).
    playerDescriptor(2,computer0::getPlayerDescriptor(game::language_V)).
    playerDescriptor(3,computer1::getPlayerDescriptor(game::language_V)).
    playerDescriptor(4,computer2::getPlayerDescriptor(game::language_V)).
/*Include here lines corresponding to the Player Class*/
%    playerDescriptor(5,computer3::getPlayerDescriptor(game::language_V)).

class predicates
    createPlayerObject:(positive)->player.
clauses
    createPlayerObject(1)=Player:-
        !,
        Player=human::new().
   createPlayerObject(2)=Player:-
        !,
        Player=computer0::new().
   createPlayerObject(3)=Player:-
        !,
        Player=computer1::new().
    createPlayerObject(4)=Player:-
        !,
        Player=computer2::new().
/*Include here lines corresponding to the Player Class*/
/*
    createPlayerObject(5)=Player:-
        !,
        Player=computer3::new().
*/
    createPlayerObject(_)=_Player:-
        exception::raise_user("Wrong player\'s ID").

end implement competitors

/******************************************************
Copyright (c) Victor Yukhtenko

Class human
******************************************/
class human:player
open core

predicates
    getPlayerDescriptor:(game::language_D)->string Descriptor.

end class human

implement human
open core

facts
    name:string:="Hum_".

clauses
   getPlayerDescriptor(game::en)="Human: Your strategy".
   getPlayerDescriptor(game::ru)="Человек: Ваша стратегия".

clauses
    setName(ProposedId):-
        name:=string::format("%s%s",name,ProposedId),
        Name=humanInterface::getInput(humanInterface::playerName_S,name),
        if not(Name="") then
            name:=Name
        end if.

clauses
    move():-
        InputString=humanInterface::getInput(humanInterface::playerStep_S),
        try
            juniourJudge::set(InputString)
        catch TraceID do
            handleException(TraceID),
            fail
        end try,
        !.
    move():-
        move().

clauses
    announceWin():-
        humanInterface::announce(humanInterface::win_S,name).

    announceLoss():-
        humanInterface::announce(humanInterface::loss_S,name).

class predicates
    handleException:(exception::traceId TraceID).
clauses
    handleException(TraceID):-
        foreach Descriptor=exception::getDescriptor_nd(TraceID) do
            Descriptor = exception::descriptor
                (
                _ProgramPoint,
                _Exception,
                _Kind,
                ExtraInfo,
                _GMTTime,
                _ThreadId
                ),
            if
                ExtraInfo=[namedValue("data",string(CellPointer))]
            then
                humanInterface::announce(humanInterface::errorWrongCell_S,CellPointer)
            else
                humanInterface::announce(humanInterface::error_S,"")
            end if
        end foreach.

end implement human

/******************************************************
Copyright (c) Victor Yukhtenko
*******************************************************/

/******************************************
  Interface polylineStrategy
******************************************/
interface polylineStrategy
open core

predicates
    setGenericComputer:(genericComputer).
    successfulStep: (juniourJudge::cell*)->juniourJudge::cell nondeterm.
    randomStep:()->juniourJudge::cell determ.

end interface polylineStrategy

/************************
  Class GenericComputer
************************/
interface genericComputer
    supports player
    supports polylineStrategy

predicates
    setpolylineStrategy:(polylineStrategy).
    stepCandidate: (juniourJudge::cell*,juniourJudge::cell* [out],juniourJudge::cell [out]) nondeterm.

end interface genericComputer

class genericComputer:genericComputer
open core, exception

end class genericComputer

implement genericComputer
open core

delegate interface polylineStrategy to polylineStrategy_V

facts
    name:string:="Cmp_".
    polylineStrategy_V:polylineStrategy:=erroneous.

clauses
    setName(ProposedId):-
        name:=string::format("%s%s",name,ProposedId),
        Name=humanInterface::getInput(humanInterface::playerName_S,name),
        if not(Name="") then
            name:=Name
        end if.

clauses
    setpolylineStrategy(PolylineStrategyObject):-
        polylineStrategy_V:=PolylineStrategyObject,
        polylineStrategy_V:setGenericComputer(This).

clauses
    move():-
        humanInterface::announce(humanInterface::thinker_S,name),
        Cell=resolveStep(),
        try
            juniourJudge::set(toString(Cell))
        catch _Trace_D do
            humanInterface::announce(humanInterface::error_S,"Internal Error in the computerStrategy\n"),
            humanInterface::waitOk()
        end try.

predicates
    resolveStep:()->juniourJudge::cell.
clauses
    resolveStep()=Cell:-
        Cell=successfulStep(juniourJudge::polyline_P),
        !.
    resolveStep()=Cell:-
        Cell=randomStep(),
        !.
    resolveStep()=juniourJudge::c(X+1,Y+1):-
        X=math::random(juniourJudge::maxColumn_P-1),
        Y=math::random(juniourJudge::maxRow_P-1).

clauses
    stepCandidate([Cell],[Cell,NewCell], NewCell):-
        juniourJudge::neighbour_nd(Cell, NewCell).
    stepCandidate([Left, RestrictingCell | PolyLine],[NewCell,Left, RestrictingCell| PolyLine], NewCell):-
        NewCell=juniourJudge::neighbourOutOfPolyLine_nd(Left,RestrictingCell).
    stepCandidate(PolyLine,list::reverse([NewCell,Left, RestrictingCell |PolyLineTail]),NewCell):-
        [Left, RestrictingCell |PolyLineTail] = list::reverse(PolyLine),
        NewCell=juniourJudge::neighbourOutOfPolyLine_nd(Left,RestrictingCell).

clauses
    announceWin():-
        humanInterface::announce(humanInterface::win_S,name).

clauses
    announceLoss():-
        humanInterface::announce(humanInterface::loss_S,name).

end implement genericComputer

/******************************************************
Copyright (c) Victor Yukhtenko

Copyright (c) Elena Efimova
predicate SuccessfullStep implementation

Class computer0
*******************************************************/
class computer0:player
open core

predicates
    getPlayerDescriptor:(game::language_D)->string Descriptor.

end class computer0

implement computer0
    inherits genericComputer
open core

clauses
    new():-
        PolyLineBraneObj=polylineStrategy0::new(),
        setpolylineStrategy(PolyLineBraneObj).

clauses
   getPlayerDescriptor(game::en)=polylineStrategy0::playerDescriptorEn_C.
   getPlayerDescriptor(game::ru)=polylineStrategy0::playerDescriptorRu_C.

end implement computer0

/******************************************
  Class polylineStrategy0
******************************************/
class polylineStrategy0:polylineStrategy
open core

constants
    playerDescriptorEn_C="Computer0: Unlimited Depth. Despair move - first possible in the list".
    playerDescriptorRu_C="Computer0: Неограниченный поиск. Ход отчаяния - по возможному правилу".

end class polylineStrategy0

implement polylineStrategy0
open core, exception

facts
    genericComputer_V:genericComputer:=erroneous.

clauses
    setGenericComputer(GenericComputerObj):-
        genericComputer_V:=GenericComputerObj.

clauses
    successfulStep(PolyLine)=BestMove:-
        BestMove=successfulStep1(PolyLine),
        !.
    successfulStep(PolyLine)=SomeMove:-
        genericComputer_V:stepCandidate(PolyLine, _PolyLine1,SomeMove),
        !.

predicates
    successfulStep1:(juniourJudge::cell* PolyLine)->juniourJudge::cell determ.
clauses
    successfulStep1(PolyLine)=BestMove:-
        genericComputer_V:stepCandidate(PolyLine, _PolyLine1,BestMove),
        list::isMember(BestMove, PolyLine),
        !.
    successfulStep1(PolyLine)=Cell:-
        genericComputer_V:stepCandidate(PolyLine, PolyLine1,Cell),
            not(_=successfulStep1(PolyLine1)),
            !.

clauses
    randomStep()=Cell:-
        CellCandidateListWithDuplicates = [ NewCell || genericComputer_V:stepCandidate(juniourJudge::polyline_P, _Polyline1, NewCell) ],
        CellCandidateList=list::removeDuplicates(CellCandidateListWithDuplicates),
        not(CellCandidateList=[]),
        NoOfVariants=list::length(CellCandidateList),
        ChoiceNo=math::random(NoOfVariants-1),
        Cell=list::nth(ChoiceNo+1,CellCandidateList).

end implement polylineStrategy0

/******************************************
Copyright (c) Victor Yukhtenko

Copyright (c) Elena Efimova
predicate SuccessfullStep implementation

Class computer1
******************************************/
class computer1:player
open core

predicates
    getPlayerDescriptor:(game::language_D)->string Descriptor.

end class computer1

implement computer1
    inherits genericComputer
open core

clauses
    new():-
        PolyLineBraneObj=polylineStrategy1::new(),
        setpolylineStrategy(PolyLineBraneObj).

clauses
   getPlayerDescriptor(game::en)=polylineStrategy1::playerDescriptorEn_C.
   getPlayerDescriptor(game::ru)=polylineStrategy1::playerDescriptorRu_C.

end implement computer1

/******************************************
  Class polylineStrategy1
******************************************/
class polylineStrategy1:polylineStrategy
open core

constants
    playerDescriptorEn_C="Computer1: Unlimited Depth. Despair move - random".
    playerDescriptorRu_C="Computer1: Неограниченный поиск. Ход отчаяния - случайный".

end class polylineStrategy1

implement polylineStrategy1
open core, exception

facts
    genericComputer_V:genericComputer:=erroneous.

clauses
    setGenericComputer(GenericComputerObj):-
        genericComputer_V:=GenericComputerObj.

clauses
    successfulStep(PolyLine)=BestMove:-
        genericComputer_V:stepCandidate(PolyLine, _PolyLine1,BestMove),
        list::isMember(BestMove, PolyLine),
        !.
    successfulStep(PolyLine)=Cell:-
        genericComputer_V:stepCandidate(PolyLine, PolyLine1,Cell),
            not(_=successfulStep(PolyLine1)).

clauses
    randomStep()=Cell:-
        CellCandidateListWithDuplicates = [ NewCell || genericComputer_V:stepCandidate(juniourJudge::polyline_P, _Polyline1, NewCell) ],
        CellCandidateList=list::removeDuplicates(CellCandidateListWithDuplicates),
        not(CellCandidateList=[]),
        NoOfVariants=list::length(CellCandidateList),
        ChoiceNo=math::random(NoOfVariants-1),
        Cell=list::nth(ChoiceNo+1,CellCandidateList).

end implement polylineStrategy1

/******************************************
Copyright (c) Victor Yukhtenko

Copyright (c) Elena Efimova
Predicate successfulStep

Class computer2
******************************************/
class computer2:player
open core

predicates
    getPlayerDescriptor:(game::language_D)->string Descriptor.

end class computer2

implement computer2
    inherits genericComputer
open core

clauses
    new():-
        PolyLineBraneObj=polylineStrategy2::new(),
        setpolylineStrategy(PolyLineBraneObj).

clauses
   getPlayerDescriptor(game::en)=polylineStrategy2::playerDescriptorEn_C.
   getPlayerDescriptor(game::ru)=polylineStrategy2::playerDescriptorRu_C.

end implement computer2

/******************************************
  Class polylineStrategy2
******************************************/
class polylineStrategy2:polylineStrategy
open core

constants
    playerDescriptorEn_C="Computer2: Limited Depth. Despair move - random".
    playerDescriptorRu_C="Computer2: Ограниченная глубина. Ход отчаяния - случайный".

end class polylineStrategy2

implement polylineStrategy2
open core, exception

facts
    maxDepth_V:positive:=5.
    genericComputer_V:genericComputer:=erroneous.

clauses
    new():-
        defineSearchDepth().

clauses
    setGenericComputer(GenericComputerObj):-
        genericComputer_V:=GenericComputerObj.

predicates
    defineSearchDepth:().
clauses
    defineSearchDepth():-
        DepthStr=humanInterface::getInput(humanInterface::searchDepth_S,toString(maxDepth_V)),
        not(DepthStr=""),
        !,
        try
            maxDepth_V:=toTerm(DepthStr),
            if maxDepth_V mod 2 = 0 then
                maxDepth_V:=maxDepth_V+1
            end if
        catch _TraceID1 do
            humanInterface::announce(humanInterface::errorMustBeNumber_S,""),
            defineSearchDepth()
        end try.
    defineSearchDepth().

clauses
    successfulStep(PolyLine)=BestMove:-
        BestMove=successfulStep(maxDepth_V,PolyLine).

predicates
    successfulStep: (integer Counter, juniourJudge::cell*)->juniourJudge::cell nondeterm.
clauses
    successfulStep(Counter,PolyLine)=BestMove:-
        genericComputer_V:stepCandidate(PolyLine,_PolyLine1,BestMove),
        isStepSuccessful(Counter,PolyLine,BestMove),
        !.
    successfulStep(Counter,PolyLine)=Cell:-
        genericComputer_V:stepCandidate(PolyLine, PolyLine1,Cell),
            not(_=successfulStep(Counter-1,PolyLine1)).

class predicates
    isStepSuccessful:(integer Counter,juniourJudge::cell* PolyLine,juniourJudge::cell BestMove) determ.
clauses
    isStepSuccessful(_Counter,PolyLine,BestMove):-
        list::isMember(BestMove, PolyLine),
        !.
    isStepSuccessful(Counter,_PolyLine,_BestMove):-
        Counter<=1.

clauses
    randomStep()=Cell:-
        CellCandidateListWithDuplicates = [ NewCell || genericComputer_V:stepCandidate(juniourJudge::polyline_P, _Polyline1, NewCell) ],
        CellCandidateList=list::removeDuplicates(CellCandidateListWithDuplicates),
        not(CellCandidateList=[]),
        NoOfVariants=list::length(CellCandidateList),
        ChoiceNo=math::random(NoOfVariants-1),
        Cell=list::nth(ChoiceNo+1,CellCandidateList).

end implement polylineStrategy2


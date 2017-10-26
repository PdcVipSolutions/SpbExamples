/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement gameBoard
    inherits consoleControl
    open core,polyLineDomains


domains
    cell_D=
        c(positive X,positive Y);
        none.

domains
    legendedMove_D=legendedMove(cell_D,unsigned MoveLegend).

constants
    verticalSpace_C=2.
    horizontalSpace_C=3.

predicates
    convertLegend:(integer,unsigned) determ (i,o).
clauses
    convertLegend(0x00FF0000,0x0001).
    convertLegend(0x0000FF00, 0x0002).
    convertLegend(0x00FF00FF, 0x0003).
    convertLegend(0x000000FF,0x0004).
    convertLegend(0x00FFFF00,0x0005).
    convertLegend(0x0000FFFF, 0x0006).
    convertLegend(0x00FFFFFF,0x0007).
    convertLegend(0x00000000,0x0000).

facts
    pointer_V:cell_D:=erroneous.
    move_F:(cell_D,unsigned MoveAttribute).
    lastMove_V:legendedMove_D:=erroneous.
    winnerMove_V:legendedMove_D:=erroneous.
    gameStatus_V:polylineDomains::gameStatus_D:=erroneous.

clauses
    new(ConsoleControlContainer):-
        new(),
        setConsoleControlContainer(ConsoleControlContainer).

clauses
    new():-
        subscribe(onMouseMove,string(consoleEventSource::mouseMoveEventID_C)),
        subscribe(onShow,string(consoleEventSource::showEventID_C)),
        subscribe(onMouseClick,string(consoleEventSource::mouseClickEventID_C)).

predicates
    onShow:notificationAgency::notificationListenerFiltered.
clauses
    onShow(_NotificationAgency,This,_Status):-
        !,
        HumanInterface=convert(humanInterface,getConsoleRoot()),
        HumanInterface:logicProvider_V:juniourJudge_V:subscribe(onMove),
        showBoard(),
        drawMoves(),
        setPointer(c(1,1)).
    onShow(_NotificationAgency,_NotificationSource,_Value).

predicates
    onMouseMove:notificationAgency::notificationListenerFiltered.
clauses
    onMouseMove(_NotificationAgency,This,string(MouseLocation)):-
        updatePointer(MouseLocation),
        !.
    onMouseMove(_NotificationAgency,_NotificationSource,_Value).

predicates
    onMouseClick:notificationAgency::notificationListenerFiltered.
clauses
    onMouseClick(_NotificationAgency,_NotificationSource,string(MouseLocation)):-
        !,
        updatePointer(MouseLocation),
        sendMove(pointer_V).
    onMouseClick(_NotificationAgency,_NotificationSource,_Value).

clauses
    handleChar(VirtualKey,_Char):-
        not(isErroneous(gameStatus_V)),
        gameStatus_V=polylineDomains::humanMove(_Player),
        JuniourJudge=convert(humanInterface,getConsoleRoot()):logicProvider_V:juniourJudge_V,
        c(CellX,CellY)=handleChar(VirtualKey,pointer_V,JuniourJudge:maxColumn_P,JuniourJudge:maxRow_P),
        not(pointer_V=c(CellX,CellY)),
        !,
        showPointerPosition(c(CellX,CellY)).
    handleChar(_VirtualKey,_Char).

clauses
    updateView():-
        (getEnabled()=false or getVisible()=false),
        !.
    updateView():-
        showBoard(),
        drawMoves(),
        if not(isErroneous(pointer_V)) then
            showCell(pointer_V)
        end if.

clauses
    trySetFocus():-
        ThisControlLocation=geCtrlLocation(),
        console::setLocation(ThisControlLocation).

/************************************************
Main Functionality
************************************************/
clauses
    onMove(_Request,_Agency,_PlayerObj,string(initialExternalMove_C),string(CellStr)):-
        convertLegend(juniourJudgeMove_C,ConsoleColor),
        lastMove_V:=legendedMove(toTerm(CellStr),ConsoleColor),
        !,
        showCell(toTerm(CellStr)).
    onMove(_Request,_Agency,PlayerObj,string(ordinaryMove_C),string(CellStr)):-
        Player=convert(player,PlayerObj),
        if not(isErroneous(lastMove_V)) then
            lastMove_V=legendedMove(PreviousMove,Color),
            addMove(PreviousMove,Color)
        else
            PreviousMove=none
        end if,
        convertLegend(Player:legend_V,ConsoleColor),
        lastMove_V:=legendedMove(toTerm(CellStr),ConsoleColor),
        showCell(PreviousMove),
        !,
        showCell(toTerm(CellStr)).
    onMove(_Request,_Agency,PlayerObj,string(winnerMove_C),string(CellStr)):-
        Player=convert(player,PlayerObj),
        convertLegend(Player:legend_V,ConsoleColor),
        winnerMove_V:=legendedMove(toTerm(CellStr),ConsoleColor),
        !,
        showCell(toTerm(CellStr)).
    onMove(_Request,_Agency,_Sender,_AnyType,_AnyCell).

clauses
    showStatus(Status):-
        Location=console::getLocation(),
        showStatusInternal(Status),
        console::setLocation(Location).

predicates
    showStatusInternal:(polylineDomains::gameStatus_D).
clauses
    showStatusInternal(polylineDomains::newSize):-
        showStatusInternal(polylineDomains::initial),
        JJ=convert(humanInterface,getConsoleRoot()):logicProvider_V:juniourJudge_V,
        Xsize_ctl=horizontalSpace_C*(JJ:maxColumn_P+1),
        Ysize_ctl=verticalSpace_C*(JJ:maxRow_P+1),
        setWidth(Xsize_ctl),
        setHeight(Ysize_ctl),
        !.
    showStatusInternal(Status):-
        gameStatus_V:=Status,
        fail.
    showStatusInternal(polylineDomains::initial):-
        !,
        retractAll(move_F(_,_)),
        lastMove_V:=erroneous,
        winnerMove_V:=erroneous,
        pointer_V:=c(1,1),
        refreshView().
    showStatusInternal(_Status):-
        if not(isErroneous(pointer_V)) then
            invalidateCell(pointer_V)
        end if.

predicates
    addMove:(cell_D,unsigned Attribute).
    addMoveToDatabase:(cell_D,unsigned Attribute).
clauses
    addMove(Cell,Attribute):-
        move_F(Cell,Attribute),
        !.
    addMove(Cell,Attribute):-
        addMoveToDatabase(Cell,Attribute),
        showCell(Cell).

    addMoveToDatabase(Cell,Attribute):-
        move_F(Cell,OldAttribute),
        retract(move_F(Cell,OldAttribute)),
        !,
        assert(move_F(Cell,Attribute)).
    addMoveToDatabase(Cell,Attribute):-
        assert(move_F(Cell,Attribute)).

predicates
    invalidateCell:(cell_D).
clauses
    invalidateCell(none):-!.
    invalidateCell(Cell):-
        showCell(Cell).

predicates
    updatePointer:(string AtLocation).
clauses
    updatePointer(AtLocation):-
        not(isErroneous(gameStatus_V)),
        gameStatus_V=polylineDomains::humanMove(_Player),
        console_native::coord(Xloc,Yloc)=toTerm(AtLocation),
        Xloc>=2,
        Xloc<=convert(humanInterface,getConsoleRoot()):logicProvider_V:juniourJudge_V:maxColumn_P*horizontalSpace_C+1,
        Yloc>=1,
        Yloc<=convert(humanInterface,getConsoleRoot()):logicProvider_V:juniourJudge_V:maxRow_P*verticalSpace_C,
        !,
        Xcell=math::floor((Xloc-2)/horizontalSpace_C)+1,
        Ycell=math::floor((Yloc-1)/verticalSpace_C)+1,
        showPointerPosition(c(Xcell,Ycell)).
    updatePointer(_MouseLocation).

predicates
    showPointerPosition:(cell_D).
clauses
    showPointerPosition(c(Xcell,Ycell)):-
        !,
        setPointer(c(Xcell,Ycell)),
        notify(This,string(humanInterfaceConsole::boardPosition_C),string(string::format("X:% Y:%",Xcell,Ycell))).
    showPointerPosition(_Cell).

clauses
    modifyLayout():-
        showBoard().

predicates
    showBoard:().
clauses
    showBoard():-
        console_native::coord(X,Y)=geCtrlLocation(),
        JJ=convert(humanInterface,getConsoleRoot()):logicProvider_V:juniourJudge_V,
        foreach I = std::fromTo(1, JJ:maxColumn_P) do
            console::setLocation(console_native::coord(X+horizontalSpace_C*I, Y)),
            console::write(I)
        end foreach,
        foreach J = std::fromTo(1, JJ:maxRow_P) do
            console::setLocation(console_native::coord(X, Y+verticalSpace_C*J)),
            console::write(J)
        end foreach.

predicates
    setPointer:(cell_D).
clauses
    setPointer(_Cell):-
        (
        isErroneous(gameStatus_V)
        or
        not(gameStatus_V=polylineDomains::humanMove(_Player))
        ),
        !.
    setPointer(_Cell):-
        isErroneous(pointer_V),
        pointer_V:=c(1,1),
        showCell(pointer_V),
        fail.
    setPointer(Cell):-
        not(pointer_V=Cell),
        pointer_V=OldCell,
        !,
        pointer_V:=Cell,
        showCell(OldCell),
        showCell(pointer_V).
    setPointer(_Cell).

constants
    winnerChar_C='o'.
    moveChar_C='*'.
    lastMoveChar_C='+'.

predicates
    drawMoves:().
clauses
    drawMoves():-
        getVisible()=false,
        !.
    drawMoves():-
        move_F(Cell,Color),
            drawCell(Cell,moveChar_C,Color,true,0x0000,false),
        fail.
    drawMoves():-
        not(isErroneous(winnerMove_V)),
        winnerMove_V=legendedMove(Cell,WinnerColor),
        (
        move_F(Cell,OldMoveColor)
        or
        lastMove_V=legendedMove(Cell,OldMoveColor)
        ),
        drawCell(Cell,winnerChar_C,WinnerColor,true,foreground2background(OldMoveColor),true),
        fail.
    drawMoves():-
        not(isErroneous(lastMove_V)),
        lastMove_V=legendedMove(Cell,Color),
        !,
        drawCell(Cell,lastMoveChar_C,Color,true,0x0000,false).
    drawMoves().

predicates
    showCell:(cell_D).
clauses
    showCell(Cell):-
        (Cell=none or getVisible()=false),
        !.
    showCell(Cell):-
        not(isErroneous(winnerMove_V)),
        winnerMove_V=legendedMove(Cell,WinnerColor),
        (
        move_F(Cell,OldMoveColor)
        or
        lastMove_V=legendedMove(Cell,OldMoveColor)
        ),
        drawCell(Cell,winnerChar_C,WinnerColor,true,foreground2background(OldMoveColor),true),
        !.
    showCell(Cell):-
        not(isErroneous(lastMove_V)),
        lastMove_V=legendedMove(Cell,Color),
        !,
        drawCell(Cell,lastMoveChar_C,Color,true,0x0000,false).
    showCell(Cell):-
        move_F(Cell,Color),
        !,
        drawCell(Cell,moveChar_C,Color,true,0x0000,false).
    showCell(Cell):-
        drawCell(Cell,' ',0x0000,false,0x0000,false).

predicates
    foreground2background:(unsigned OldMoveColor)->unsigned BackColor multi.
clauses
    foreground2background(0x0001)=0x0010.
    foreground2background(0x0002)=0x0020.
    foreground2background(0x0003)=0x0030.
    foreground2background(0x0004)=0x0040.
    foreground2background(0x0005)=0x0050.
    foreground2background(0x0006)=0x0060.
    foreground2background(0x0007)=0x0070.
    foreground2background(Color)=Color.

predicates
    drawCell:(cell_D,char CharToShow,unsigned CharColor,boolean TrueIfCharIntensive,unsigned BackGroundColor,boolean TrueIfBackIntensive).
clauses
    drawCell(c(Xcell,Ycell),CharToShow,CharColor,TrueIfCharIntensive,BackGroundColor,TrueIfBackIntensive):-
        !,
        OldLoc=console::getLocation(),
        console_native::coord(X,Y)=geCtrlLocation(),
        OldAttribute=console::getTextAttribute(),
        console::setLocation(console_native::coord((X+Xcell*horizontalSpace_C)-1,Y+Ycell*verticalSpace_C)),
        if
            not(isErroneous(pointer_V)),
            pointer_V=c(Xcell,Ycell),
            not(isErroneous(gameStatus_V)),
            gameStatus_V=polylineDomains::humanMove(Player0) ,
            convertLegend(Player0:legend_V,ConsoleColor)
        then
            console::setTextAttribute(foreground2background(ConsoleColor)),!
        end if,
        console::write(" "),
        if not(CharToShow=' ') then
            if TrueIfCharIntensive=true then
                CharIntencity=0x0008
            else
                CharIntencity=0x0000
            end if,
            if TrueIfBackIntensive=true then
                BackGroundIntencity=0x0080
            else
                BackGroundIntencity=0x0000
            end if,
            console::setTextAttribute(CharColor+CharIntencity+BackGroundColor+BackGroundIntencity)
        end if,
        console::write(CharToShow),
        if
            not(isErroneous(pointer_V)),
            pointer_V=c(Xcell,Ycell),
            not(isErroneous(gameStatus_V)),
            gameStatus_V=polylineDomains::humanMove(Player1),
            convertLegend(Player1:legend_V,ConsoleColor1)
        then
            console::setTextAttribute(foreground2background(ConsoleColor1)),!
        else
            console::setTextAttribute(0x0000)
        end if,
        console::write(" "),
        console::setTextAttribute(OldAttribute),
        console::setLocation(OldLoc).
    drawCell(_Cell,_CharToShow,_CharColor,_CharIntencity,_BackGroundColor,_BackGroundIntencity).

predicates
    handleChar:(unsigned VirtualKey,cell_D Cell,positive,positive)->cell_D multi.
clauses
    handleChar(38,c(X,Y),_XSize,_YSize)=c(X,Y-1):- %ArrowUp
        Y>1.
    handleChar(40,c(X,Y),_XSize,YSize)=c(X,Y+1):- %ArrowDown
        Y<YSize.
    handleChar(39,c(X,Y),XSize,_YSize)=c(X+1,Y):- %ArrowRight
        X<XSize.
    handleChar(37,c(X,Y),_XSize,_YSize)=c(X-1,Y):- %ArrowLeft
        X>1.
    handleChar(32,Cell,_XSize,_YSize)=pointer_V:- %Space
        sendMove(Cell).
    handleChar(_AnyOtherChar,_Cell,_XSize,_YSize)=none.

predicates
    sendMove:(cell_D Cell).
clauses
    sendMove(Cell):-
        not(isErroneous(gameStatus_V)),
        HumanInterface=convert(humanInterface,getConsoleRoot()),
        gameStatus_V=polylineDomains::humanMove(Player),
        !,
        try
            convert(humanInterface,getConsoleRoot()):notify(This,string(polylineDomains::humanMove_C),string(toString(Cell))) % Announces this Player's Move
        catch TraceID do
            handleException(TraceID),
            HumanInterface:logicProvider_V:seniourJudge_V=SeniourJudge,
            SeniourJudge:notify(SeniourJudge,object(Player),core::none)  % Invite Player to repeat the Move
        end try.
    sendMove(_Cell).

predicates
    handleException:(exception::traceId TraceID).
clauses
    handleException(TraceID):-
        HumanInterface=convert(humanInterfaceConsole,getConsoleRoot()),
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
                HumanInterface:announce(polylineText::errorWrongCell_S,CellPointer)
            else
                HumanInterface:announce(polylineText::error_S,"")
            end if
        end foreach.

end implement gameBoard

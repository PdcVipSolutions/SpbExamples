/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement gameBoard
    inherits userControlSupport

open core, vpiDomains, polyLineDomains, window

domains
    cell_D=
        c(positive X,positive Y);
        none.

clauses
    new(Parent):-
        new(),
        setContainer(Parent),
        Parent:addSizeListener(onSize).

clauses
    new():-
        userControlSupport::new(),
        generatedInitialize().

domains
    legendedMove_D=legendedMove(cell_D,vpiDomains::color MoveLegend).

facts
    pointer_V:cell_D:=c(1,1).
    move_F:(cell_D,vpiDomains::color).
    lastMove_V:legendedMove_D:=erroneous.
    winnerMove_V:legendedMove_D:=erroneous.
    gameStatus_V:polylineDomains::gameStatus_D:=erroneous.

clauses
    onMove(_Request,_Agency,_PlayerObj,string(initialExternalMove_C),string(CellStr)):-
        lastMove_V:=legendedMove(toTerm(CellStr),convert(color,juniourJudgeMove_C)),
        lastMove_V=legendedMove(c(CellX,CellY),_legendedMoveColor),
        !,
        getBoardDrawParameters(Step,_WidthPxl,_HeightPxl),
        invalidate(rct((CellX-1)*Step,(CellY-1)*Step,(CellX-1)*Step+Step,(CellY-1)*Step+Step)),
        _IsSuccessful = vpi::processEvents().
    onMove(_Request,_Agency,PlayerObj,string(ordinaryMove_C),string(CellStr)):-
        Player=convert(player,PlayerObj),
        if not(isErroneous(lastMove_V)) then
            lastMove_V=legendedMove(Move,Color),
            addMove(Move,Color)
        end if,
        lastMove_V:=legendedMove(toTerm(CellStr),convert(color,Player:legend_V)),
        lastMove_V=legendedMove(c(CellX,CellY),_legendedMoveColor),
        !,
        getBoardDrawParameters(Step,_WidthPxl,_HeightPxl),
        invalidate(rct((CellX-1)*Step,(CellY-1)*Step,(CellX-1)*Step+Step,(CellY-1)*Step+Step)),
        _IsSuccessful = vpi::processEvents().
    onMove(_Request,_Agency,PlayerObj,string(winnerMove_C),string(CellStr)):-
        Player=convert(player,PlayerObj),
        winnerMove_V:=legendedMove(toTerm(CellStr),convert(color,Player:legend_V)),
        winnerMove_V=legendedMove(c(CellX,CellY),_legendedMoveColor),
        !,
        getBoardDrawParameters(Step,_WidthPxl,_HeightPxl),
        invalidate(rct((CellX-1)*Step,(CellY-1)*Step,(CellX-1)*Step+Step,(CellY-1)*Step+Step)),
        _IsSuccessful = vpi::processEvents().
    onMove(_Request,_Agency,_Sender,_AnyType,_AnyCell).

predicates
    addMove:(cell_D,vpiDomains::color PlayerLegend).
clauses
    addMove(Cell,Color):-
        move_F(Cell,Color),
        !.
    addMove(Cell,NewColor):-
        move_F(Cell,OldColor),
        retract(move_F(Cell,OldColor)),
        assert(move_F(Cell,NewColor)),
        Cell=c(CellX,CellY),
        getBoardDrawParameters(Step,_WidthPxl,_HeightPxl),
        invalidate(rct((CellX-1)*Step,(CellY-1)*Step,(CellX-1)*Step+Step,(CellY-1)*Step+Step)),
        !.
    addMove(Cell,Color):-
        assert(move_F(Cell,Color)),
        Cell=c(CellX,CellY),
        !,
        getBoardDrawParameters(Step,_WidthPxl,_HeightPxl),
        invalidate(rct((CellX-1)*Step,(CellY-1)*Step,(CellX-1)*Step+Step,(CellY-1)*Step+Step)).
    addMove(_Cell,_Color).

clauses
    showStatus(polylineDomains::newSize):-
        modifyLayout(),
        showStatus(polylineDomains::initial),
        !.
    showStatus(Status):-
        gameStatus_V:=Status,
        fail.
    showStatus(polylineDomains::initial):-
        !,
        cursorSet(vpiDomains::cursor_Arrow),
        retractAll(move_F(_,_)),
        lastMove_V:=erroneous,
        winnerMove_V:=erroneous,
        pointer_V:=c(1,1),
        invalidate().
    showStatus(polylineDomains::computerMove((_Player))):-
        cursorSet(vpiDomains::cursor_Wait),
        fail.
    showStatus(Status):-
        (
        Status=polylineDomains::humanMove(_Player)
        or
        Status=polylineDomains::complete
        or
        Status=polylineDomains::interrupted
        ),
        cursorSet(vpiDomains::cursor_Arrow),
        fail.
    showStatus(_Status):-
        invalidateCell(pointer_V).

predicates
    invalidateCell:(cell_D).
clauses
    invalidateCell(none):-!.
    invalidateCell(c(X,Y)):-
        getBoardDrawParameters(Step,_WidthPxl,_HeightPxl),
        invalidate(rct(Step*(X-1),Step*(Y-1),Step*(X-1)+Step,Step*(Y-1)+Step)).

clauses
    modifyLayout():-
        Container=convert(gameView,getContainer()),
        Container:getSize(Width,Height),
        ActualWidth=Width-2,
        ActualHeight=Height-Container:drawVertPos_V-2,
        DlgContainer=getTopLevelContainerWindow(),
        pnt(WidthPxl,HeightPxl)=DlgContainer:pntUnit2Pixel(pnt(ActualWidth,ActualHeight)),
        CellHorSize=WidthPxl/Container:xSize(),
        CellVertSize=HeightPxl/Container:ySize(),
        CellSize=math::floor(math::min(CellHorSize,CellVertSize)),
        BoardWidth=CellSize*Container:xSize(),
        BoardHeight=CellSize*Container:ySize()+1,
        pnt(BoardWidthDlgbu,BoardHeightDlgbu)=DlgContainer:pntPixel2Unit(pnt(BoardWidth,BoardHeight)),
        NewHorPosition=math::ceil((Width-BoardWidthDlgbu)/2),
        NewVerPosition=math::ceil((Height-Container:drawVertPos_V-BoardHeightDlgbu)/2+Container:drawVertPos_V),
        setRect(rct(NewHorPosition,NewVerPosition,NewHorPosition+BoardWidthDlgbu,NewVerPosition+BoardHeightDlgbu)).

predicates
    onPaint :  paintResponder.
clauses
    onPaint(_Source, Rectangle, GDIObject):-
        getBoardDrawParameters(Step,WidthPxl,HeightPxl),
        GDIObject:clear(Rectangle,color_LtGray),
        GDIObject:setPen(pen(1,ps_Solid,vpiDomains::color_gray)),
        drawVerLines(GDIObject,WidthPxl,HeightPxl,Step),
        drawHorLines(GDIObject,HeightPxl,WidthPxl,Step),
        drawMoves(GDIObject,Rectangle,Step),
        drawPointer(GDIObject,Step).

predicates
    getBoardDrawParameters:(positive Step,integer WidthPxl,integer HeightPxl) procedure (o,o,o).
clauses
    getBoardDrawParameters(Step,WidthPxl,HeightPxl):-
        Width=getWidth(),
        Height=getHeight(),
        Container=convert(gameView,getContainer()),
        ParentDialog=getTopLevelContainerWindow(),
        pnt(WidthPxl,HeightPxl)=ParentDialog:pntUnit2Pixel(pnt(Width,Height)),
        Step=convert(positive,math::floor(WidthPxl/(Container:xSize()))). % <- round gives real, while fromToInStep needs positive

predicates
    drawVerLines:(windowGDI GDIObject,integer WidthPxl,integer HeightPxl,positive StepX).
clauses
    drawVerLines(GDIObject,WidthPxl,HeightPxl,StepX):-
        X = std::fromToInStep(StepX, WidthPxl, StepX),
            GDIObject:drawLine(vpiDomains::pnt(X,0),vpiDomains::pnt(X,HeightPxl)),
        fail.
    drawVerLines(_GDIObject,_WidthPxl,_HeightPxl,_StepX).

predicates
    drawHorLines:(windowGDI GDIObject,integer HeightPxl,integer WidthPxl,positive StepY).
clauses
    drawHorLines(GDIObject,HeightPxl,WidthPxl,StepY):-
        Y = std::fromToInStep(StepY, HeightPxl, StepY),
            GDIObject:drawLine(vpiDomains::pnt(0,Y),vpiDomains::pnt(WidthPxl,Y)),
        fail.
    drawHorLines(_GDIObject,_WidthPxl,_HeightPxl,_StepX).

predicates
    drawPointer:(windowGDI GDIObject,positive CellSize).
clauses
    drawPointer(_GDIObject,_CellSize):-
        not(isErroneous(gameStatus_V)),
        (
        gameStatus_V=polylineDomains::initial
        or
        gameStatus_V=polylineDomains::computerMove(_Player)
        ),
        !.
    drawPointer(GDIObject,CellSize):-
        GDIObject:setBrush(vpiDomains::brush (vpiDomains::pat_Hollow,vpiDomains::color_gray)),
        if not(isErroneous(gameStatus_V)) and gameStatus_V=polylineDomains::humanMove(Player) then
                GDIObject:setPen(pen(2,ps_Solid,convert(color,Player:legend_V)))
        else
            if focus_V=true then
                GDIObject:setPen(pen(2,ps_Solid,vpiDomains::color_black))
            else
                GDIObject:setPen(pen(2,ps_Solid,vpiDomains::color_gray))
            end if
        end if,
        pointer_V=c(X,Y),
        !,
        GDIObject:drawRect(rct(CellSize*(X-1)+2,CellSize*(Y-1)+2,CellSize*(X-1)+CellSize,CellSize*(Y-1)+CellSize)).
    drawPointer(_GDIObject,_CellSize).

predicates
    drawMoves:(windowGDI GDIObject,rct Rectangle,positive Step).
clauses
    drawMoves(GDIObject,Rectangle,CellSize):-
        not(isErroneous(winnerMove_V)),
        winnerMove_V=legendedMove(c(CellX,CellY),WinnerColor),
        move_F(c(CellX,CellY),OldMoveColor),
        CellRct=(rct((CellX-1)*CellSize,(CellY-1)*CellSize,CellX*CellSize,CellY*CellSize)),
        IntersectRectangle = gui::rectIntersect(Rectangle, CellRct),
        not(gui::rectIsEmpty(IntersectRectangle)),
        GDIObject:setPen(pen(2,ps_Solid,WinnerColor)),
        GDIObject:setBrush(vpiDomains::brush (vpiDomains::pat_Solid,WinnerColor)),
        GDIObject:drawRect(rct((CellX-1)*CellSize+2,(CellY-1)*CellSize+2,CellX*CellSize,CellY*CellSize)),
        GDIObject:setPen(pen(2,ps_Solid,color_Black)),
        GDIObject:setBrush(vpiDomains::brush (vpiDomains::pat_Solid,OldMoveColor)),
        GDIObject:drawEllipse(rct((CellX-1)*CellSize+2,(CellY-1)*CellSize+2,CellX*CellSize-2,CellY*CellSize-2)),
        fail.
    drawMoves(GDIObject,Rectangle,CellSize):-
        GDIObject:setPen(pen(2,ps_Solid,color_Black)),
        move_F(c(CellX,CellY),Color),
            CellRct=(rct((CellX-1)*CellSize,(CellY-1)*CellSize,CellX*CellSize,CellY*CellSize)),
            IntersectRectangle = gui::rectIntersect(Rectangle, CellRct),
            not(gui::rectIsEmpty(IntersectRectangle)),
            GDIObject:setBrush(vpiDomains::brush (vpiDomains::pat_Solid,Color)),
            GDIObject:drawEllipse(rct((CellX-1)*CellSize+2,(CellY-1)*CellSize+2,CellX*CellSize-2,CellY*CellSize-2)),
        fail.
    drawMoves(GDIObject,Rectangle,CellSize):-
        if not(isErroneous(lastMove_V)) then
            lastMove_V=legendedMove(c(CellX,CellY),Color),
            CellRct=(rct((CellX-1)*CellSize,(CellY-1)*CellSize,CellX*CellSize,CellY*CellSize)),
            IntersectRectangle = gui::rectIntersect(Rectangle, CellRct),
            not(gui::rectIsEmpty(IntersectRectangle)),
            GDIObject:setPen(pen(1,ps_Solid,vpiDomains::color_Red)),
            GDIObject:setBrush(vpiDomains::brush (vpiDomains::pat_Solid,Color)),
            GDIObject:drawEllipse(rct((CellX-1)*CellSize+2,(CellY-1)*CellSize+2,CellX*CellSize-2,CellY*CellSize-2))
        end if,
        !.
    drawMoves(_GDIObject,_Rectangle,_CellSize).

predicates
    onSize : window::sizeListener.
clauses
    onSize(_Source):-
        modifyLayout().

predicates
    onShow : window::showListener.
clauses
    onShow(_Source, _Data):-
        ParentDialog=getTopLevelContainerWindow(),
        Parent=convert(objectWinForm,ParentDialog),
        Parent:logicProvider_V:juniourJudge_V:subscribe(onMove),
        modifyLayout().

facts
    focus_V:boolean:=false.
predicates
    onGetFocus : window::getFocusListener.
clauses
    onGetFocus(_Source):-
        focus_V:=true,
        invalidate().

predicates
    onLoseFocus : window::loseFocusListener.
clauses
    onLoseFocus(_Source):-
        focus_V:=false,
        invalidate().

predicates
    onLocalSize : window::sizeListener.
clauses
    onLocalSize(_Source):-
        invalidate().

predicates
    onChar :  charResponder.
clauses
    onChar(_Source, Char, ShiftControlAlt) =  defaultCharHandling:-
        Container=convert(gameView,getContainer()),
        c(CellX,CellY)=handleChar(Char,ShiftControlAlt,pointer_V,Container:xSize(),Container:ySize()),
        not(pointer_V=c(CellX,CellY)),
        pointer_V=c(OldX,OldY),
        !,
        getBoardDrawParameters(Step,_WidthPxl,_HeightPxl),
        invalidate(rct(Step*(OldX-1),Step*(OldY-1),Step*(OldX-1)+Step,Step*(OldY-1)+Step)),
        pointer_V:=c(CellX,CellY),
        DlgContainer=convert(objectWinForm,getTopLevelContainerWindow()),
        DlgContainer:status(string::format("x:%   y:%",CellX,CellY)),
        invalidate(rct((CellX-1)*Step,(CellY-1)*Step,(CellX-1)*Step+Step,(CellY-1)*Step+Step)).
    onChar(_Source, _AnyOther, _ShiftControlAlt) =  defaultCharHandling.

predicates
    handleChar:(integer Char,vpiDomains::keyModifier ShiftControlAlt,cell_D Cell,positive,positive)->cell_D multi.
clauses
    handleChar(vpiDomains::k_Up,_ShiftControlAlt,c(X,Y),_XSize,_YSize)=c(X,Y-1):-
        Y>1.
    handleChar(vpiDomains::k_down,_ShiftControlAlt,c(X,Y),_XSize,YSize)=c(X,Y+1):-
        Y<YSize.
    handleChar(vpiDomains::k_right,_ShiftControlAlt,c(X,Y),XSize,_YSize)=c(X+1,Y):-
        X<XSize.
    handleChar(vpiDomains::k_left,_ShiftControlAlt,c(X,Y),_XSize,_YSize)=c(X-1,Y):-
        X>1.
    handleChar(vpiDomains::k_space,_ShiftControlAlt,Cell,_XSize,_YSize)=pointer_V:-
        not(isErroneous(gameStatus_V)),
        gameStatus_V=polylineDomains::humanMove(Player),
        UI=convert(humanInterface,getTopLevelContainerWindow()),
        try
            UI:notify(This,string(polylineDomains::humanMove_C),string(toString(Cell))) % Announces this Player's Move
        catch TraceID do
            handleException(TraceID),
            UI:logicProvider_V:seniourJudge_V=SeniourJudge,
            SeniourJudge:notify(SeniourJudge,object(Player),core::none)  % Invite Player to repeat the Move
        end try.
    handleChar(AnyOtherChar,ShiftControlAlt,_Cell,_XSize,_YSize)=none:-
        DlgContainer=convert(objectWinForm,getTopLevelContainerWindow()),
        _Result = DlgContainer:sendEvent(vpiDomains::e_Char(AnyOtherChar,ShiftControlAlt)).

predicates
    onMouseDown :  mouseDownListener.
clauses
    onMouseDown(_Source,pnt(Xmouse,Ymouse), _ShiftControlAlt, _Button):-
        not(isErroneous(gameStatus_V)),
        gameStatus_V=polylineDomains::humanMove(Player),
        !,
        setPointerByMouse(pnt(Xmouse,Ymouse)),
        UI=convert(objectWinForm,getTopLevelContainerWindow()),
        try
            UI:notify(This,string(polylineDomains::humanMove_C),string(toString(pointer_V))) % Announces this Player's Move
        catch TraceID do
            handleException(TraceID),
            UI:logicProvider_V:seniourJudge_V=SeniourJudge,
            SeniourJudge:notify(SeniourJudge,object(Player),core::none)  % Invite Player to repeat the Move
        end try.
    onMouseDown(_Source,_Pnt, _ShiftControlAlt, _Button).

predicates
    handleException:(exception::traceId TraceID).
clauses
    handleException(TraceID):-
        HumanInterface=convert(objectWinForm,getTopLevelContainerWindow()),
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
            end if
        end foreach.

predicates
    setPointerByMouse:(vpiDomains::pnt ClickedPoint).
clauses
    setPointerByMouse(pnt(Xmouse,Ymouse)):-
        getBoardDrawParameters(Step,_WidthPxl,_HeightPxl),
        CellX=math::floor(Xmouse/Step),
        CellY=math::floor(Ymouse/Step),
        not(pointer_V=c(CellX+1,CellY+1)),
        pointer_V=c(OldX,OldY),
        !,
        invalidate(rct(Step*(OldX-1),Step*(OldY-1),Step*(OldX-1)+Step,Step*(OldY-1)+Step)),
        pointer_V:=c(CellX+1,CellY+1),
        DlgContainer=convert(objectWinForm,getTopLevelContainerWindow()),
        DlgContainer:status(string::format("x:%   y:%",CellX+1,CellY+1)),
        invalidate(rct((CellX)*Step,(CellY)*Step,(CellX)*Step+Step,(CellY)*Step+Step)).
    setPointerByMouse(_Pnt).

predicates
    onMouseMove : mouseMoveListener.
clauses
    onMouseMove(_Source, pnt(Xmouse,Ymouse), _ShiftControlAlt, _Buttons):-
        setPointerByMouse(pnt(Xmouse,Ymouse)).

% This code is maintained automatically, do not update it manually. 14:15:40-15.10.2008
predicates
    generatedInitialize : ().
clauses
    generatedInitialize():-
        setText("gameBoard"),
        This:setSize(68, 44),
        addGetFocusListener(onGetFocus),
        addLoseFocusListener(onLoseFocus),
        addShowListener(onShow),
        addSizeListener(onLocalSize),
        addMouseDownListener(onMouseDown),
        addMouseMoveListener(onMouseMove),
        setCharResponder(onChar),
        setPaintResponder(onPaint).
% end of automatic code
end implement gameBoard

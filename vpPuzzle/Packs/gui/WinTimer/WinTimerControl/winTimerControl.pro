/*****************************************************************************
Copyright (c) 2008. Prolog Development Center Spb Ltd.

Author Victor Yukhtenko
******************************************************************************/
implement winTimerControl
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

facts
    color_V:vpiDomains::color:=vpiDomains::color_green.
    interval_V:positive:=100.
    thisTimerID_V:timerHandle:=erroneous.

clauses
    setColor(Color):-
        color_V:=Color,
        invalidate().

clauses
    setInterval(Interval):-
        interval_V:=Interval,
        if not(isErroneous(thisTimerID_V))  then
            timerKill(thisTimerID_V),
            thisTimerID_V:=timerSet(interval_V),
            invalidate()
        end if.

predicates
    onShow : window::showListener.
clauses
    onShow(_Source, _Data):-
        setFont(vpi::fontCreate(ff_Helvetica,[],8)),
        TimerID=timerSet(interval_V),
        thisTimerID_V:=TimerID.

predicates
    onPaint : window::paintResponder.
clauses
    onPaint(_Source, _Rectangle, GDIObject):-
        GDIObject:clear(color_white).

predicates
    onTimer : window::timerListener.
clauses
    onTimer(Source, _TimerId):-
        GDIObject=getWindowGDI(),
        Width=getWidth(),
        Height=getHeight(),
        not
        (
        (Width=0 or  Height=0)
        ),
        X=uncheckedConvert(integer,math::random(uncheckedConvert(unsigned,Width))),
        Y=uncheckedConvert(integer,math::random(uncheckedConvert(unsigned,Height))),
        GDIObject:setPen(pen(1,ps_Solid,color_V)),
        ParentDialog=Source:getTopLevelContainerWindow(),
        CenterRCT_pixel=ParentDialog:pntUnit2Pixel(pnt(Width div 2,Height div 2)),
        try
            EndOfLine_pixel=ParentDialog:pntUnit2Pixel(pnt(X,Y)),
            GDIObject:drawLine(CenterRCT_pixel,EndOfLine_pixel)
        catch _TraceID do
            fail
        end try,
        !.
    onTimer(_Source, _TimerId).

predicates
    onSize : window::sizeListener.
clauses
    onSize(_Source):-
        GDIObject=getWindowGDI(),
        GDIObject:clear(color_white).

% This code is maintained automatically, do not update it manually. 16:07:22-18.2.2010
facts

predicates
    generatedInitialize : ().
clauses
    generatedInitialize():-
        setText("winTimerControl"),
        This:setSize(148, 68),
        addShowListener(onShow),
        addSizeListener(onSize),
        addTimerListener(onTimer),
        setPaintResponder(onPaint).
% end of automatic code
end implement winTimerControl

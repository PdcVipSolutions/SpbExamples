/*****************************************************************************
Prolog Development Center SPb Ltd.

Written by Victor Yukhtenko
******************************************************************************/

implement winTimerContainer
    inherits dialog
    open core, vpiDomains

clauses
    display(Parent) = Dialog :-
        Dialog = new(Parent),
        Dialog:show().

facts
    winTimerMonitor_ctl:iPzlWinTimerMonitor:=erroneous.
    winTimerControl_ctl:iPzlWinTimerControl:=erroneous.
clauses
    new(Parent) :-
        dialog::new(Parent),
        generatedInitialize(),
        _ControlIDList = [ ControlID || getControl_nd(Control, ControlId),
        Label = Control:getLabel(),
        if Label = "TimerControlDraw" then
            winTimerControl_ctl := convert(iPzlWinTimerControl, Control)
        end if,
        if Label = "TimerControlMonitor" then
            winTimerMonitor_ctl := convert(iPzlWinTimerMonitor, Control)
        end if ],
        winTimerMonitor_ctl:winTimerControl_ctl:=winTimerControl_ctl.

% This code is maintained automatically, do not update it manually. 17:37:45-26.5.2010
facts
    ok_ctl : button.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize():-
        setFont(vpi::fontCreateByName("MS Sans Serif", 8)),
        setText("winTimerContainer"),
        setRect(rct(50,40,222,186)),
        setModal(false),
        setDecoration(titlebar([closebutton,maximizebutton,minimizebutton])),
        setBorder(sizeBorder()),
        setState([wsf_NoClipSiblings]),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&Close"),
        ok_ctl:setPosition(60, 132),
        ok_ctl:setSize(48, 12),
        ok_ctl:defaultHeight := false,
        ok_ctl:setAnchors([control::left,control::bottom]),
        PzlWinTimerControl_ctl = pzlwintimercontrol::new(This),
        PzlWinTimerControl_ctl:setPosition(4, 4),
        PzlWinTimerControl_ctl:setSize(164, 94),
        PzlWinTimerControl_ctl:setText("TimerControlDraw"),
        PzlWinTimerControl_ctl:setAnchors([control::left,control::top,control::right,control::bottom]),
        PzlWinTimerMonitor_ctl = pzlwintimermonitor::new(This),
        PzlWinTimerMonitor_ctl:setPosition(0, 98),
        PzlWinTimerMonitor_ctl:setSize(172, 34),
        PzlWinTimerMonitor_ctl:setText("TimerControlMonitor"),
        PzlWinTimerMonitor_ctl:setAnchors([control::left,control::bottom]).
% end of automatic code
end implement winTimerContainer

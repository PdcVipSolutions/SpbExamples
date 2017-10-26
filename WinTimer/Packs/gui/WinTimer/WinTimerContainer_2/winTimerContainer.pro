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

clauses
    new(Parent) :-
        dialog::new(Parent),
        generatedInitialize(),
        winTimerMonitor_ctl:winTimerControl_ctl:=winTimerControl_ctl.

% This code is maintained automatically, do not update it manually. 17:33:38-26.5.2010
facts
    ok_ctl : button.
    winTimerControl_ctl : wintimercontrol.
    winTimerMonitor_ctl : wintimermonitor.

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
        winTimerControl_ctl := wintimercontrol::new(This),
        winTimerControl_ctl:setPosition(4, 4),
        winTimerControl_ctl:setSize(164, 94),
        winTimerControl_ctl:setAnchors([control::left,control::top,control::right,control::bottom]),
        winTimerMonitor_ctl := wintimermonitor::new(This),
        winTimerMonitor_ctl:setPosition(0, 98),
        winTimerMonitor_ctl:setSize(172, 34),
        winTimerMonitor_ctl:setAnchors([control::left,control::bottom]).
% end of automatic code
end implement winTimerContainer

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
        winTimerMonitorProvider_ctl:winTimerControl_ctl:=winTimerControlProvider_ctl.

% This code is maintained automatically, do not update it manually. 16:07:44-18.2.2010
facts
    ok_ctl : button.
    winTimerControlProvider_ctl : wintimercontrolprovider.
    winTimerMonitorProvider_ctl : wintimermonitorprovider.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize():-
        setFont(vpi::fontCreateByName("MS Sans Serif", 8)),
        setText("winTimerContainer"),
        setRect(rct(50,40,222,186)),
        setModal(false),
        setDecoration(titlebar([closebutton(),maximizebutton(),minimizebutton()])),
        setBorder(sizeBorder()),
        setState([wsf_NoClipSiblings]),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&Close"),
        ok_ctl:setPosition(60, 132),
        ok_ctl:setSize(48, 12),
        ok_ctl:defaultHeight := false(),
        ok_ctl:setAnchors([control::left,control::bottom]),
        winTimerControlProvider_ctl := wintimercontrolprovider::new(This),
        winTimerControlProvider_ctl:setPosition(4, 4),
        winTimerControlProvider_ctl:setSize(164, 94),
        winTimerControlProvider_ctl:setAnchors([control::left,control::top,control::right,control::bottom]),
        winTimerMonitorProvider_ctl := wintimermonitorprovider::new(This),
        winTimerMonitorProvider_ctl:setPosition(0, 98),
        winTimerMonitorProvider_ctl:setSize(172, 34),
        winTimerMonitorProvider_ctl:setAnchors([control::left,control::bottom]).
% end of automatic code
end implement winTimerContainer

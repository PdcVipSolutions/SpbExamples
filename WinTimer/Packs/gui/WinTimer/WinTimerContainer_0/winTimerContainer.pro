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
        colorEdit_ctl:setText(toString(winTimerControl_ctl:color_V)),
        timerIntervalControl_ctl:setInteger(winTimerControl_ctl:interval_V).

predicates
    onBrowseColorButtonClick : button::clickResponder.
clauses
    onBrowseColorButtonClick(_Source) = button::defaultAction:-
        ParentWindow=vpi::getTaskWindow(),
        OldColor=winTimerControl_ctl:color_V,
        NewColor=vpiCommonDialogs::getColor(ParentWindow,OldColor),
        !,
        winTimerControl_ctl:setColor(NewColor),
        colorEdit_ctl:setText(toString(NewColor)).
    onBrowseColorButtonClick(_Source) = button::defaultAction.

predicates
    onApplyPushButtonClick : button::clickResponder.
clauses
    onApplyPushButtonClick(_SourceButton) = button::defaultAction:-
        control::contentsInvalid(_Source, FocusControl, ErrMsg)=validate(),
        !,
        vpiCommonDialogs::error(ErrMsg),
        FocusControl:setFocus().
    onApplyPushButtonClick(_Source) = button::defaultAction:-
        NewInterval=timerIntervalControl_ctl:getInteger(),
        winTimerControl_ctl:setInterval(NewInterval).

% This code is maintained automatically, do not update it manually. 20:24:07-13.1.2013
facts
    ok_ctl : button.
    colorEdit_ctl : editControl.
    browseColorButton_ctl : button.
    timerIntervalControl_ctl : integercontrol.
    applyPushButton_ctl : button.
    winTimerControl_ctl : wintimercontrol.
    myContainer_ctl : mycontainer.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize():-
        setFont(vpi::fontCreateByName("MS Sans Serif", 8)),
        setText("winTimerContainer"),
        setRect(rct(50,40,374,188)),
        setModal(false),
        setDecoration(titlebar([closebutton(),maximizebutton(),minimizebutton()])),
        setBorder(sizeBorder()),
        setState([wsf_NoClipSiblings]),
        StaticText_ctl = textControl::new(This),
        StaticText_ctl:setText("Timer Color"),
        StaticText_ctl:setPosition(4, 100),
        StaticText_ctl:setSize(48, 12),
        StaticText_ctl:setAnchors([control::left,control::bottom]),
        StaticText1_ctl = textControl::new(This),
        StaticText1_ctl:setText("Timer Interval"),
        StaticText1_ctl:setPosition(4, 116),
        StaticText1_ctl:setSize(48, 12),
        StaticText1_ctl:setAnchors([control::left,control::bottom]),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&Close"),
        ok_ctl:setPosition(60, 132),
        ok_ctl:setSize(48, 12),
        ok_ctl:defaultHeight := false(),
        ok_ctl:setAnchors([control::left,control::bottom]),
        colorEdit_ctl := editControl::new(This),
        colorEdit_ctl:setText(""),
        colorEdit_ctl:setPosition(56, 100),
        colorEdit_ctl:setWidth(60),
        colorEdit_ctl:setAnchors([control::left,control::bottom]),
        colorEdit_ctl:setEnabled(false),
        browseColorButton_ctl := button::new(This),
        browseColorButton_ctl:setText("Choose Color"),
        browseColorButton_ctl:setPosition(120, 100),
        browseColorButton_ctl:setSize(48, 12),
        browseColorButton_ctl:defaultHeight := false(),
        browseColorButton_ctl:setAnchors([control::left,control::bottom]),
        browseColorButton_ctl:setClickResponder(onBrowseColorButtonClick),
        timerIntervalControl_ctl := integercontrol::new(This),
        timerIntervalControl_ctl:setPosition(56, 116),
        timerIntervalControl_ctl:setSize(60, 12),
        timerIntervalControl_ctl:setAnchors([control::left,control::bottom]),
        timerIntervalControl_ctl:setMaximum(500),
        timerIntervalControl_ctl:setMinimum(1),
        applyPushButton_ctl := button::new(This),
        applyPushButton_ctl:setText("Apply"),
        applyPushButton_ctl:setPosition(120, 116),
        applyPushButton_ctl:setSize(48, 12),
        applyPushButton_ctl:defaultHeight := false(),
        applyPushButton_ctl:setAnchors([control::left,control::bottom]),
        applyPushButton_ctl:setClickResponder(onApplyPushButtonClick),
        winTimerControl_ctl := wintimercontrol::new(This),
        winTimerControl_ctl:setPosition(4, 4),
        winTimerControl_ctl:setSize(164, 92),
        winTimerControl_ctl:setAnchors([control::left,control::top,control::right,control::bottom]),
        myContainer_ctl := mycontainer::new(This),
        myContainer_ctl:setPosition(172, 4),
        myContainer_ctl:setSize(148, 90),
        myContainer_ctl:setAnchors([control::left,control::top,control::right,control::bottom]).
% end of automatic code
end implement winTimerContainer

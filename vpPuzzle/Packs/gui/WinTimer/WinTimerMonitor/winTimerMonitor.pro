/*****************************************************************************

Copyright (c) Victor Yukhtenko.

******************************************************************************/

implement winTimerMonitor
    inherits userControlSupport
    open core

clauses
    new(Parent):-
        new(),
        setContainer(Parent).

clauses
    new():-
        userControlSupport::new(),
        generatedInitialize().

facts
    winTimerControl_ctl:winTimerControl:=erroneous.

predicates
    onBrowseColorButtonClick : button::clickResponder.
clauses
    onBrowseColorButtonClick(_Source) = button::defaultAction:-
        ParentWindow=vpi::getTaskWindow(),
        OldColor=winTimerControl_ctl:color_V,
        NewColor=vpiCommonDialogs::getColor(ParentWindow, OldColor),
        !,
        winTimerControl_ctl:setColor(NewColor),
        colorEdit_ctl:setText(toString(NewColor)).
    onBrowseColorButtonClick(_Source) = button::defaultAction.

predicates
    onApplyPushButtonClick : button::clickResponder.
clauses
    onApplyPushButtonClick(_SourceButton) = button::defaultAction:-
        contentsInvalid(_Source, FocusControl, ErrMsg)=validate(),
        !,
        vpiCommonDialogs::error(ErrMsg),
        FocusControl:setFocus().
    onApplyPushButtonClick(_Source) = button::defaultAction:-
        NewInterval=timerIntervalControl_ctl:getInteger(),
        winTimerControl_ctl:setInterval(NewInterval).

predicates
    onShow : window::showListener.
clauses
    onShow(_Source, _Data):-
        apply().

clauses
    apply():-
        colorEdit_ctl:setText(toString(winTimerControl_ctl:color_V)),
        timerIntervalControl_ctl:setInteger(winTimerControl_ctl:interval_V).

% This code is maintained automatically, do not update it manually. 16:06:50-18.2.2010
facts
    colorEdit_ctl : editControl.
    browseColorButton_ctl : button.
    timerIntervalControl_ctl : integercontrol.
    applyPushButton_ctl : button.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize():-
        setText("winTimerMonitor"),
        This:setSize(172, 32),
        addShowListener(onShow),
        StaticText_ctl = textControl::new(This),
        StaticText_ctl:setText("Timer Color"),
        StaticText_ctl:setPosition(4, 2),
        StaticText_ctl:setSize(48, 12),
        StaticText1_ctl = textControl::new(This),
        StaticText1_ctl:setText("Timer Interval"),
        StaticText1_ctl:setPosition(4, 18),
        StaticText1_ctl:setSize(48, 12),
        colorEdit_ctl := editControl::new(This),
        colorEdit_ctl:setText(""),
        colorEdit_ctl:setPosition(56, 2),
        colorEdit_ctl:setWidth(60),
        colorEdit_ctl:setEnabled(false),
        browseColorButton_ctl := button::new(This),
        browseColorButton_ctl:setText("Choose Color"),
        browseColorButton_ctl:setPosition(120, 2),
        browseColorButton_ctl:setSize(48, 12),
        browseColorButton_ctl:defaultHeight := false(),
        browseColorButton_ctl:setClickResponder(onBrowseColorButtonClick),
        timerIntervalControl_ctl := integercontrol::new(This),
        timerIntervalControl_ctl:setPosition(56, 18),
        timerIntervalControl_ctl:setWidth(60),
        timerIntervalControl_ctl:setAutoHScroll(false),
        timerIntervalControl_ctl:setAlignBaseline(false),
        timerIntervalControl_ctl:setMaximum(400),
        timerIntervalControl_ctl:setMinimum(1),
        timerIntervalControl_ctl:setLabel("Timer Interval"),
        applyPushButton_ctl := button::new(This),
        applyPushButton_ctl:setText("Apply"),
        applyPushButton_ctl:setPosition(120, 18),
        applyPushButton_ctl:setSize(48, 12),
        applyPushButton_ctl:defaultHeight := false(),
        applyPushButton_ctl:setClickResponder(onApplyPushButtonClick).
% end of automatic code
end implement winTimerMonitor

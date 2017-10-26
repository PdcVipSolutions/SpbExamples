/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement getColor
    inherits consoleControl
    inherits consoleControlContainer

    open core, console

facts
        blue_ctl:consoleEditControl.
        green_ctl:consoleEditControl.
        ltBlue_ctl:consoleEditControl.
        red_ctl:consoleEditControl.
        cyan_ctl:consoleEditControl.
        yellow_ctl:consoleEditControl.
        white_ctl:consoleEditControl.

        okPB_ctl:consoleButtonControl.
        cancelPB_ctl:consoleButtonControl.

clauses
    new(ConsoleControlContainer):-
        new(),
        setConsoleControlContainer(ConsoleControlContainer).

clauses
    new():-
        setPosition(20,4),
        setWidth(13),
        setHeight(19),
        setText("Choose Color"),

        blue_ctl:=consoleEditControl::new(This),
        blue_ctl:setPosition(4,1),
        blue_ctl:setWidth(5),
        blue_ctl:setText("   "),
        blue_ctl:startFieldMark_V:=' ',
        blue_ctl:endFieldMark_V:=' ',
        blue_ctl:setTextAttribute(0x0010,0x0000),
        blue_ctl:subscribe(onColorChanged,string(consoleEventSource::getFocusID_C)),
        blue_ctl:subscribe(onDblClick,string(consoleEventSource::editorMouseDblClickEventID_C)),

        green_ctl:=consoleEditControl::new(This),
        green_ctl:setPosition(4,3),
        green_ctl:setWidth(5),
        green_ctl:setText("   "),
        green_ctl:startFieldMark_V:=' ',
        green_ctl:endFieldMark_V:=' ',
        green_ctl:setTextAttribute(0x0020,0x0000),
        green_ctl:subscribe(onColorChanged,string(consoleEventSource::getFocusID_C)),
        green_ctl:subscribe(onDblClick,string(consoleEventSource::editorMouseDblClickEventID_C)),

        ltBlue_ctl:=consoleEditControl::new(This),
        ltBlue_ctl:setPosition(4,5),
        ltBlue_ctl:setWidth(5),
        ltBlue_ctl:setText("   "),
        ltBlue_ctl:startFieldMark_V:=' ',
        ltBlue_ctl:endFieldMark_V:=' ',
        ltBlue_ctl:setTextAttribute(0x0030,0x0000),
        ltBlue_ctl:subscribe(onColorChanged,string(consoleEventSource::getFocusID_C)),
        ltBlue_ctl:subscribe(onDblClick,string(consoleEventSource::editorMouseDblClickEventID_C)),

        red_ctl:=consoleEditControl::new(This),
        red_ctl:setPosition(4,7),
        red_ctl:setWidth(5),
        red_ctl:setText("   "),
        red_ctl:startFieldMark_V:=' ',
        red_ctl:endFieldMark_V:=' ',
        red_ctl:setTextAttribute(0x0040,0x0000),
        red_ctl:subscribe(onColorChanged,string(consoleEventSource::getFocusID_C)),
        red_ctl:subscribe(onDblClick,string(consoleEventSource::editorMouseDblClickEventID_C)),

        cyan_ctl:=consoleEditControl::new(This),
        cyan_ctl:setPosition(4,9),
        cyan_ctl:setWidth(5),
        cyan_ctl:setText("   "),
        cyan_ctl:startFieldMark_V:=' ',
        cyan_ctl:endFieldMark_V:=' ',
        cyan_ctl:setTextAttribute(0x0050,0x0000),
        cyan_ctl:subscribe(onColorChanged,string(consoleEventSource::getFocusID_C)),
        cyan_ctl:subscribe(onDblClick,string(consoleEventSource::editorMouseDblClickEventID_C)),

        yellow_ctl:=consoleEditControl::new(This),
        yellow_ctl:setPosition(4,11),
        yellow_ctl:setWidth(5),
        yellow_ctl:setText("   "),
        yellow_ctl:startFieldMark_V:=' ',
        yellow_ctl:endFieldMark_V:=' ',
        yellow_ctl:setTextAttribute(0x0060,0x0000),
        yellow_ctl:subscribe(onColorChanged,string(consoleEventSource::getFocusID_C)),
        yellow_ctl:subscribe(onDblClick,string(consoleEventSource::editorMouseDblClickEventID_C)),

        white_ctl:=consoleEditControl::new(This),
        white_ctl:setPosition(4,13),
        white_ctl:setWidth(5),
        white_ctl:setText("   "),
        white_ctl:startFieldMark_V:=' ',
        white_ctl:endFieldMark_V:=' ',
        white_ctl:setTextAttribute(0x0070,0x0000),
        white_ctl:subscribe(onColorChanged,string(consoleEventSource::getFocusID_C)),
        white_ctl:subscribe(onDblClick,string(consoleEventSource::editorMouseDblClickEventID_C)),

        okPB_ctl:=consoleButtonControl::new(This),
        okPB_ctl:setPosition(2,15),
        okPB_ctl:setWidth(8),
        okPB_ctl:setText("Ok"),
        okPB_ctl:subscribe(onOkButton,string(consoleEventSource::buttonClickEventID_C)),

        cancelPB_ctl:=consoleButtonControl::new(This),
        cancelPB_ctl:setPosition(2,17),
        cancelPB_ctl:setWidth(8),
        cancelPB_ctl:setText("Cancel"),
        cancelPB_ctl:subscribe(onCancelButton,string(consoleEventSource::buttonClickEventID_C)),

        subscribe(onShow,string(consoleEventSource::showEventID_C)).

predicates
    onColorChanged:notificationAgency::notificationListenerFiltered.
clauses
    onColorChanged(_NotificationAgency,Source,none):-
        !,
        Color=convert(consoleControl,Source):getTextAttribute(),
        currentColor_V:=Color.
    onColorChanged(_NotificationAgency,_AnySource,_Value).

facts
    currentColor_V:unsigned:=erroneous.

predicates
    onShow:notificationAgency::notificationListenerFiltered.
clauses
    onShow(_NotificationAgency,This,_Status):-
        !,
        Location=console::getLocation(),
        showControlFrame(),
        console::setLocation(Location).
    onShow(_NotificationAgency,_NotificationSource,_Value).

predicates
    onOkButton:notificationAgency::notificationListenerFiltered.
clauses
    onOkButton(_NotificationAgency,_Any,none):-
        notify(This,string(consoleEventSource::closedEventID_C),unsigned(currentColor_V)),
        destroy(),
        !.
    onOkButton(_NotificationAgency,_NotificationSource,_Value).

predicates
    onDblClick:notificationAgency::notificationListenerFiltered.
clauses
    onDblClick(_NotificationAgency,_Any,_Pos):-
        notify(This,string(consoleEventSource::closedEventID_C),unsigned(currentColor_V)),
        destroy().

predicates
    onCancelButton:notificationAgency::notificationListenerFiltered.
clauses
    onCancelButton(_NotificationAgency,_Any,none):-
        destroy(),
        !.
    onCancelButton(_NotificationAgency,_NotificationSource,_Value).

predicates
    showControlFrame:().
clauses
    showControlFrame():-
        console_native::coord(X,Y)=geCtrlLocation(),
        setLocation(console_native::coord(X,Y)),
        HorisontalLine=string::create(convert(charCount,getWidth())-2,"*"),
        SpaceLine=string::create(convert(charCount,getWidth())-2," "),
        console::write("+",HorisontalLine,"+"),
        setLocation(console_native::coord(X,Y+getHeight()-1)),
        write("+",HorisontalLine,"+"),
        foreach Row = std::fromTo(1, getHeight()-2) do
            setLocation(console_native::coord(X,Y+Row)),
            write("*",SpaceLine,"*")
        end foreach.

end implement getColor

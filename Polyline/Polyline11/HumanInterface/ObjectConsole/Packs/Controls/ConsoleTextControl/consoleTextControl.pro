/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/

implement consoleTextControl
    inherits consoleControl
    open core

clauses
    new(ConsoleControlContainer):-
        new(),
        setConsoleControlContainer(ConsoleControlContainer).

clauses
    new():-
        subscribe(onShow).

facts
    startFieldMark_V:char:=' '.
    endFieldMark_V:char:=' '.
    fillSpaceChar_V:char:=' '.

clauses
    updateView():-
        showText().

predicates
    onShow:notificationAgency::notificationListener.
clauses
    onShow(_Request,_NotificationAgency,This,string(consoleEventSource::showEventID_C),_Status):-
        !,
        showText().
    onShow(_Request,_NotificationAgency,_NotificationSource,_EventID,_Value).

predicates
    showText:().
clauses
    showText():-
        getViewParameters(WriteLocation,TextToShow,_InputLocation),
        write(WriteLocation,TextToShow).

predicates
    getViewParameters:(console_native::coord WriteLocation [out],string TextToShow [out],console_native::coord InputLocation [out]).
clauses
    getViewParameters(Location,TextToShow,Location):-
        false=getVisible(),
        !,
        Location=geCtrlLocation(),
        TextToShow=string::create(convert(charCount,getWidth())," ").
    getViewParameters(Location,TextToShow,Location):-
        Location=geCtrlLocation(),
        if getText() ="" then
            TextToShow=string::create(convert(charCount,getWidth())-2,string::charToString(fillSpaceChar_V))
        else
            if string::length(getText())<getWidth()-2 then
                FrontSpace=(getWidth()-2-string::length(getText())) div 2,
                TextToShow=string::concat(string::create(FrontSpace,string::charToString(fillSpaceChar_V)),getText(),string::create((getWidth()-2-string::length(getText())-FrontSpace),string::charToString(fillSpaceChar_V)))
            else
                string::front(getText(),convert(charCount,getWidth()-2),TextToShow,_Rest)
            end if
        end if.

predicates
    write:(console_native::coord WriteLocation,string TextToShow).
clauses
    write(console_native::coord(X,Y),TextToShow):-
        console::setLocation(console_native::coord(X,Y)),
        Attribute=getTextAttribute(),
        if getEnabled()=false then
            console::setTextAttribute(0x0000,0x0008)
        else
            TextColor=getTextAttribute(),
            console::setTextAttribute(TextColor)
        end if,
        if true=getVisible() then
            console::write(startFieldMark_V,TextToShow,endFieldMark_V)
        end if,
        console::setTextAttribute(Attribute).

end implement consoleTextControl

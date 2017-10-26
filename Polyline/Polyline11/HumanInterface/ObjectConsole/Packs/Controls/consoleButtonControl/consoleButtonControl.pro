/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement consoleButtonControl
    inherits consoleControl
    open core

clauses
    new(ConsoleControlContainer):-
        new(),
        setConsoleControlContainer(ConsoleControlContainer).

clauses
    new():-
        subscribe(onEvent).

facts
    startFieldMark_V:char:='['.
    endFieldMark_V:char:=']'.
    fillSpaceChar_V:char:=' '.

clauses
    updateView():-
        getViewParameters(WriteLocation,TextToShow,_InputLocation),
        write(WriteLocation,TextToShow).

predicates
    onEvent:notificationAgency::notificationListener.
clauses
    onEvent(_Request,_NotificationAgency,This,string(consoleEventSource::showEventID_C),_Status):-
        !,
        getViewParameters(WriteLocation,TextToShow,_InputLocation),
        write(WriteLocation,TextToShow).
    onEvent(_Request,_NotificationAgency,This,_Any,_Status):-
        getEnabled()=false,
        !.
    onEvent(_Request,_NotificationAgency,This,string(consoleEventSource::mouseClickEventID_C),_Status):-
        !,
        notify(This,string(consoleEventSource::buttonClickEventID_C),none).
    onEvent(_Request,_NotificationAgency,This,string(consoleEventSource::mouseDblClickEventID_C),_Status):-
        !,
        notify(This,string(consoleEventSource::buttonClickEventID_C),none).
    onEvent(_Request,_NotificationAgency,_NotificationSource,_EventID,_Value).

clauses
    handleChar(_VirtualKey,Char):-
        (Char='\r' or Char=' '),
        getEnabled()=true,
        notify(This,string(consoleEventSource::buttonClickEventID_C),none),
        !.
    handleChar(_VirtualKey,_Char).

clauses
    trySetFocus():-
        getViewParameters(_WriteLocation,_TextToShow,InputLocation),
        console::setLocation(InputLocation).

predicates
    getViewParameters:(console_native::coord WriteLocation [out],string TextToShow [out],console_native::coord InputLocation [out]).
clauses
    getViewParameters(console_native::coord(X,Y),TextToShow,console_native::coord(X+1,Y)):-
        false=getVisible(),
        !,
        console_native::coord(X,Y)=geCtrlLocation(),
        TextToShow=string::create(convert(charCount,getWidth()-2)," ").
    getViewParameters(console_native::coord(X,Y),TextToShow,console_native::coord(X+1,Y)):-
        console_native::coord(X,Y)=geCtrlLocation(),
        if getText() ="" then
            TextToShow=string::create(convert(charCount,getWidth()-2),string::charToString(fillSpaceChar_V))
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
        Attribute=console::getTextAttribute(),
        if getEnabled()=true then
            console::setTextAttribute(getTextAttribute())
        else
            console::setTextAttribute(0x0000,0x0008)
        end if,
        if true=getVisible() then
            console::write(startFieldMark_V,TextToShow,endFieldMark_V)
        end if,
        console::setTextAttribute(Attribute).

end implement consoleButtonControl

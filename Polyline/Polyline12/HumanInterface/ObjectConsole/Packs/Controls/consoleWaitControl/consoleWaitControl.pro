/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement consoleWaitControl
    inherits consoleControl
    open core

clauses
    new(ConsoleControlContainer):-
        new(),
        setConsoleControlContainer(ConsoleControlContainer).

clauses
    new():-
        subscribe(onShow,string(consoleEventSource::showEventID_C)),
        subscribe(onTic,ticEventID_C).

predicates
    onShow:notificationAgency::notificationListenerFiltered.
clauses
    onShow(_NotificationAgency,_NotificationSource,_Value):-
        !,
        thinkCounter_V:=thinkShowInterval_C,
        updateView().

predicates
    onTic:notificationAgency::notificationListenerFiltered.
clauses
    onTic(_NotificationAgency,_NotificationSource,_Value):-
        !,
        updateView().

clauses
    tic():-
        updateView().

clauses
    updateView():-
        true=getVisible(),
        getViewParameters(WriteLocation,TextToShow),
        !,
        write(WriteLocation,TextToShow).
    updateView().

predicates
    getViewParameters:(console_native::coord WriteLocation [out],string TextToShow [out]) determ.
clauses
    getViewParameters(getCtrlLocation(),char_V):-
        thinkCounter_V:=thinkCounter_V-1,
        thinkCounter_V<=0,
        nextChar(char_V),
        thinkCounter_V:=thinkShowInterval_C.

predicates
    write:(console_native::coord WriteLocation,string TextToShow).
clauses
    write(console_native::coord(X,Y),TextToShow):-
        Location=console::getLocation(),
        Attribute=console::getTextAttribute(),
        console::setLocation(console_native::coord(X,Y)),
        if getEnabled()=true then
            console::setTextAttribute(getTextAttribute())
        else
            console::setTextAttribute(0x0000,0x0008)
        end if,
        if true=getVisible() then
            console::write(TextToShow)
        end if,
        console::setTextAttribute(Attribute),
        console::setLocation(Location).

/****************
Wait mark support
*****************/
constants
    thinkShowInterval_C:integer=3000.
facts
    thinkCounter_V:integer:=erroneous.

facts
    char_V:string:="-". % -\|/
predicates
    nextChar:(string CharIn) determ.
clauses
    nextChar("-"):-char_V:="\\".
    nextChar("\\"):-char_V:="|".
    nextChar("|"):-char_V:="/".
    nextChar("/"):-char_V:="-".

end implement consoleWaitControl

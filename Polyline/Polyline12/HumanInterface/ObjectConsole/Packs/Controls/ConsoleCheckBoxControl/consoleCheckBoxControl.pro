/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement consoleCheckBoxControl
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
    startFieldMark_V:char:='|'.
    endFieldMark_V:char:='|'.

facts
    status_V:boolean:=false.

clauses
    setChecked(Checked):-
        status_V:=Checked,
        if showOccured_V=true then
            updateView()
        end if.

clauses
    getChecked()=status_V.

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
    onEvent(_Request,_NotificationAgency,This,string(consoleEventSource::mouseClickEventID_C),_Status):-
        !,
        changeStatus().
    onEvent(_Request,_NotificationAgency,This,string(consoleEventSource::mouseDblClickEventID_C),_Status):-
        !,
        changeStatus().
    onEvent(_Request,_NotificationAgency,_NotificationSource,_EventID,_Value).

clauses
    handleChar(_VirtualKey,Char):-
        (Char='\r' or Char=' '),
        changeStatus(),
        !.
    handleChar(_VirtualKey,_Char).

predicates
    changeStatus:().
clauses
    changeStatus():-
        if getEnabled()=true then
            invertStatus(),
            getViewParameters(WriteLocation,TextToShow,InputLocation),
            write(WriteLocation,TextToShow),
            console::setLocation(InputLocation),
            notify(This,string(consoleEventSource::checkBoxStatusChangedEventID_C),boolean(status_V))
        end if.

predicates
    invertStatus:().
clauses
    invertStatus():-
        status_V=true,
        !,
        status_V:=false.
    invertStatus():-
        status_V:=true.

clauses
    trySetFocus():-
        console_native::coord(X,Y)=getCtrlLocation(),
        console::setLocation(console_native::coord(X+1,Y)).

predicates
    getViewParameters:(console_native::coord WriteLocation [out],string TextToShow [out],console_native::coord InputLocation [out]).
clauses
    getViewParameters(console_native::coord(X,Y),"   ",console_native::coord(X+1,Y)):-
        false=getVisible(),
        !,
        console_native::coord(X,Y)=getCtrlLocation().
    getViewParameters(console_native::coord(X,Y),TextToShow,console_native::coord(X+1,Y)):-
        console_native::coord(X,Y)=getCtrlLocation(),
        if status_V = true then
            TextToShow="X"
        else
            TextToShow=" "
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

end implement consoleCheckBoxControl

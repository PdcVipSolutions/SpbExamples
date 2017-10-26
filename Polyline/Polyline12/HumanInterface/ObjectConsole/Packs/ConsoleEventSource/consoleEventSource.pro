/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement consoleEventSource
    open core

clauses
    run():-
        console::setModeLine(false),
        console::setModeProcessed(false),
        focus_V:=convert(consoleControlContainer,This):tryDefineFocus(uncheckedConvert(consoleControl,0)),
        HumanInterface=convert(humanInterface,This),
        std::repeat(),
            try
                update(),
                Events = console::readEvents(),
                handleEvents(HumanInterface,Events)
            catch TraceID do
                ConsoleWindow=console_native::getConsoleWindow(),
                console_native::messageBox(ConsoleWindow,"Error Appeared","Unexpected Error",0),
                TraceInfo=exception::getTraceInfo(TraceID),
                console_native::messageBox(ConsoleWindow,toString(TraceInfo),"TraceInfo",0),
                fail
            end try.
    run().

predicates
    handleEvents:(humanInterface HumanInterface,console::event* EventList) failure.
clauses
    handleEvents(HumanInterface,EventList):-
            Event=list::getMember_nd(EventList),
                if Event=console::mouse(X,Y,0x0001,_MouseKeyStateClick,0x0000) then
                    tryFitsToModal(console_native::coord(X,Y)),
                    try
                    	HumanInterface:notify(This, string(mouseClickEventID_C), string(toString(console_native::coord(X, Y))))
                    catch TraceID do
                    	handleException(TraceID)
                    end try
                end if,
                if Event=console::mouse(X1,Y1,0x0001,_MouseKeyStateDblClick,0x0002) then
                    tryFitsToModal(console_native::coord(X1,Y1)),
                    try
                    	HumanInterface:notify(This, string(mouseDblClickEventID_C), string(toString(console_native::coord(X1, Y1))))
                    catch TraceID1 do
                    	handleException(TraceID1)
                    end try
                end if,
                if Event=console::mouse(X2,Y2,0x0000,_MouseKeyStateMove,0x0001) then
                    HumanInterface:notify(This,string(mouseMoveEventID_C),string(toString(console_native::coord(X2,Y2))))
                end if,
                if Event=console::key(0,_RepeatCount,VirtualKeyCode,_VirtualScanCode,UnicodeChar,_ControlKeyState) then
                    handleChar(VirtualKeyCode,UnicodeChar)
                end if,
        fail.

predicates
    handleException:(exception::traceID) failure.
clauses
    handleException(_TraceID):-
        !,
        fail.

clauses
    processEvents():-
        EventList = console::getEventQueue(),
        HumanInterface=convert(humanInterface,This),
        handleEvents(HumanInterface,EventList).
    processEvents().

/*
predicates
    debug:(DataItem).
clauses
    debug(DataItem):-
        Location=console::getCtrlLocation(),
        console::setLocation(console_native::coord(0,0)),
        console::clearInput(),
        console::write("      "),
        console::setLocation(console_native::coord(0,0)),
        console::write(DataItem),
        console::setLocation(Location).
*/
predicates
    tryFitsToModal:(console_native::coord) determ.
clauses
    tryFitsToModal(_Location):-
        isErroneous(modal_V),
        !.
    tryFitsToModal(console_native::coord(X,Y)):-
        console_native::coord(Xctl,Yctl)=modal_V:getCtrlLocation(),
        ControlWidth=modal_V:getWidth(),
        ControlHeight=modal_V:getHeight(),
        X>=Xctl,X<Xctl+ControlWidth,
        Y>=Yctl,Y<Yctl+ControlHeight.

clauses
    setModality(ModalControl):-
        !,
        modal_V:=ModalControl.

clauses
    unSetModality():-
        modal_V:=erroneous.

facts
    focus_V:consoleControl:=erroneous.
    modal_V:consoleControl:=erroneous.

predicates
    handleChar:(unsigned VirtualKey,char UnicodeChar).
clauses
    handleChar(18,_Any):-
        !.
    handleChar(16,_Any):-
        !.
    handleChar(27,_Any):-
        !.
    handleChar(_VirtualKey,'\t'):-
        ActiveControl=focus_V:getConsoleControlContainer():tryDefineFocus(focus_V),
        focus_V:notify(This,string(consoleEventSource::loseFocusID_C),none),
        focus_V:=ActiveControl,
        !.
    handleChar(_VirtualKey,'\t'):-
        ActiveControl=convert(consoleControlContainer,This):tryDefineFocus(uncheckedConvert(consoleControl,0)),
        focus_V:notify(This,string(consoleEventSource::loseFocusID_C),none),
        focus_V:=ActiveControl,
        !.
    handleChar(VirtualKey,UnicodeChar):-
        focus_V:handleChar(VirtualKey,UnicodeChar).

facts
    needsUpdate_V:boolean:=false.
clauses
    updateView():-
        needsUpdate_V:=true.

predicates
    update:().
clauses
    update():-
        needsUpdate_V=true,
        needsUpdate_V:=false,
        ControlContainer=tryConvert(consoleControlContainer,This),
        !,
        Location=console::getLocation(),
        console::clearOutput(),
        ControlContainer:invalidate(),
        console::setLocation(Location).
    update().

clauses
    messageBox(Text,MessageTitle,Type ):-
        ConsoleWindow=console_Native::getConsoleWindow(),
        console_native::messageBox(ConsoleWindow,Text,MessageTitle,Type).

end implement consoleEventSource

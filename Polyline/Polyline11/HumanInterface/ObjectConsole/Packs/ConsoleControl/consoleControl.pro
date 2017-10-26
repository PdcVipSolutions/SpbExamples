/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement consoleControl
    inherits notificationAgency
    open core

clauses
    destroy():-
        Thiscontainer=tryConvert(consoleControlContainer,This),
        Thiscontainer:removeAll(),
        Location=console::getLocation(),
        clearView(),
        console::setLocation(Location),
        fail.
    destroy():-
        modalMode_V=true,
        EventSource=convert(consoleEventSource,getConsoleRoot1(This)),
        if
            tryConvert(consoleControl,consoleControlContainer_V):getModalMode()=true
        then
            EventSource:setModality(convert(consoleControl,consoleControlContainer_V))
        else
            EventSource:unSetModality()
        end if,
        fail.
    destroy():-
        notify(This,string(consoleEventSource::destroyedEventID_C),none),
        HIC=convert(humanInterfaceConsole,getConsoleRoot1(This)),
        HIC:unSubscribe(onSystemEvent),
        unSubscribeAll(),
        consoleControlContainer_V:remove(This),
        if not(isErroneous(backFocus_V)) then
            convert(consoleEventSource,HIC):focus_V:=backFocus_V,
            backFocus_V:trySetFocus()
        end if,
        !,
        if modalMode_V=true then
            modalMode_V:=false
        end if.
    destroy().

facts
    consoleControlContainer_V:consolecontrolContainer:=erroneous.

clauses
    setConsoleControlContainer(ConsoleControlContainer):-
        consoleControlContainer_V:=ConsoleControlContainer,
        ConsoleControlContainer:addControl(This).

clauses
    getConsoleControlContainer()=consoleControlContainer_V.

facts
    location_V:console_native::coord:=console_native::coord(0,0).
    controlWidth_V:charCount:=3.
    controlHeight_V:charCount:=1.
    visible_V:boolean:=true.
    enabled_V:boolean:=true.
    modalMode_V:boolean:=false.
    backFocus_V:consoleControl:=erroneous.
    showOccured_V:boolean:=false.
    textAttribute_V:unsigned:=0x0007.

clauses
    setEnabled(TrueIfEnabled):-
        enabled_V:=TrueIfEnabled,
        refreshView().

clauses
    refreshView():-
        if showOccured_V=true then
            Location=console::getLocation(),
            if visible_V=true then
                clearView(),
                This:updateView()
            end if,
            console::setLocation(Location)
        end if.

clauses
    getEnabled()=enabled_V.

clauses
    getTextAttribute()=textAttribute_V.

clauses
    setTextAttribute(Color,Intensity):-
        textAttribute_V:=Color+Intensity,
        refreshView().

clauses
    setModal(BackFocusControl):-
        showOccured_V=false,
        ConsoleRoot=getConsoleRoot1(This),
        backFocus_V:=BackFocusControl,
        EventSource=convert(consoleEventSource,ConsoleRoot),
        EventSource:setModality(This),
        FocusCandidate=This:tryGetFocus(uncheckedConvert(consoleControl,0)),
        !,
        modalMode_V:=true,
        EventSource:focus_V:=FocusCandidate.
    setModal(_BackFocusControl):-
        exception::raise_error("Wrong Modal").

clauses
    getModalMode()=modalMode_V.

clauses
    setVisible(TrueIfVisible):-
        visible_V:=TrueIfVisible,
        if showOccured_V=true then
            Location=console::getLocation(),
            if visible_V=true then
                clearView(),
                This:updateView()
            else
                clearView()
            end if,
            console::setLocation(Location)
        end if.

predicates
    clearView:().
clauses
    clearView():-
        console_native::coord(X,Y)=geCtrlLocation(),
        EmptyString=string::create(convert(charCount,getWidth())," "),
        foreach I = std::fromTo(0, getHeight()-1) do
            console::setLocation(console_native::coord(X,Y+I)),
            console::write(EmptyString)
        end foreach.

clauses
    getVisible()=visible_V.

clauses
    setPosition(X,Y):-
        location_V:=console_native::coord(convert(unsigned16,X),convert(unsigned16,Y)),
        refreshView().

clauses
    getPosition(X,Y):-
        location_V=console_native::coord(Xctl,Yctl),
        X=convert(positive,Xctl),
        Y=convert(positive,Yctl).

clauses
    geCtrlLocation()=console_native::coord(Xcont+Xctl,Ycont+Yctl):-
        location_V=console_native::coord(Xctl,Yctl),
        try
            Container=getConsoleControlContainer(),
            ContainerControl=convert(consoleControl,Container),
            console_native::coord(Xcont,Ycont)=ContainerControl:geCtrlLocation()
        catch _TraceID do
            Xcont=0,
            Ycont=0
        end try.

clauses
    setWidth(Width):-
        if showOccured_V=true then
            if visible_V=true then
                Location=console::getLocation(),
                clearView(),
                controlWidth_V:=convert(charCount,Width),
                This:updateView(),
                console::setLocation(Location)
            else
                controlWidth_V:=convert(charCount,Width)
            end if
        else
            controlWidth_V:=convert(charCount,Width)
        end if.

clauses
    getWidth()=convert(positive,controlWidth_V).

clauses
    setHeight(Height):-
        if showOccured_V=true then
            if visible_V=true then
                Location=console::getLocation(),
                clearView(),
                controlHeight_V:=convert(charCount,Height),
                This:updateView(),
                console::setLocation(Location)
            else
                controlHeight_V:=convert(charCount,Height)
            end if
        else
            controlHeight_V:=convert(charCount,Height)
        end if.

clauses
    getHeight()=convert(positive,controlHeight_V).

facts
    text_V:string:="".
clauses
    setText(Text):-
        text_V:=Text,
        refreshView(),
        notify(This,string(consoleEventSource::editorModifiedEventID_C),none).

clauses
    getText()=text_V.

clauses
    show():-
        subscribeForEvents(This),
        fail.
    show():-
        Location=console::getLocation(),
        try
            showOccured_V:=true,
            if visible_V=true then
                notify(This,string(consoleEventSource::showEventID_C),none)
            end if,
            convert(consoleControlContainer,This):showControls()
        catch _TraceID do
            console::setLocation(Location)
        end try.

predicates
    subscribeForEvents:(consoleControl IntermediateControl).
clauses
    subscribeForEvents(Control):-
        ControlContainerRoot=getConsoleRoot1(Control),
        convert(notificationAgency,ControlContainerRoot):subscribeA(onSystemEvent).

clauses
    getConsoleRoot()=getConsoleRoot1(This).

class predicates
    getConsoleRoot1:(consoleControl ThisControl)->consoleControlContainer ConsoleRoot.
clauses
    getConsoleRoot1(Control)=ControlContainerRoot:-
        ControlContainerRoot=Control:getConsoleControlContainer(),
        _ControlContainerEventSource=tryConvert(consoleEventSource,ControlContainerRoot),
        !.
    getConsoleRoot1(Control)=ControlContainerRoot:-
        ControlContainer=Control:getConsoleControlContainer(),
        UpperControl=convert(consoleControl,ControlContainer),
        !,
        ControlContainerRoot=getConsoleRoot1(UpperControl).

predicates
    onSystemEvent:notificationAgency::notificationListener.
clauses
    onSystemEvent(_Request,_NotiAgency,_AnyEventCousedObject,_EventID,_EventData):-
        (visible_V=false or enabled_V=false),
        !.
    onSystemEvent(_Request,_NotiAgency,EventCousedObject,string(consoleEventSource::mouseDblClickEventID_C),string(EventData)):-
        Location=handleMouseClick(EventCousedObject,EventData),
        !,
        notify(This,string(consoleEventSource::mouseDblClickEventID_C),string(toString(Location))),
        exception::raise_User("").
    onSystemEvent(_Request,_NotiAgency,EventCousedObject,string(consoleEventSource::mouseClickEventID_C),string(EventData)):-
        Location=handleMouseClick(EventCousedObject,EventData),
        !,
        notify(This,string(consoleEventSource::mouseClickEventID_C),string(toString(Location))),
        exception::raise_User("").
    onSystemEvent(_Request,_NotiAgency,_EventCousedObject,string(consoleEventSource::mouseMoveEventID_C),string(EventData)):-
        Location=handleMouseMove(EventData),
        !,
        notify(This,string(consoleEventSource::mouseMoveEventID_C),string(toString(Location))).
    onSystemEvent(_Request,_NotiAgency,_EventCousedObject,_EventID,_EventData).


predicates
    handleMouseClick:(object EventCousedObject,string EventData)->console_native::coord determ.
clauses
    handleMouseClick(EventCousedObject,EventData)=console_native::coord(Xclick,Yclick):-
        console_native::coord(X,Y)=toTerm(EventData),
        console_native::coord(Xctl,Yctl)=geCtrlLocation(),
        X>=Xctl,X<Xctl+controlWidth_V,
        Y>=Yctl,Y<Yctl+controlHeight_V,
        FocusCandidate=tryGetFocus(uncheckedConvert(consoleControl,0)),
        EventSource=convert(consoleEventSource,EventCousedObject),
        EventSource:focus_V:=FocusCandidate,
        Xclick=X-Xctl,
        Yclick=Y-Yctl.

predicates
    handleMouseMove:(string EventData)->console_native::coord determ.
clauses
    handleMouseMove(EventData)=console_native::coord(Xmove,Ymove):-
        console_native::coord(X,Y)=toTerm(EventData),
        console_native::coord(Xctl,Yctl)=geCtrlLocation(),
        X>=Xctl,
        X<=Xctl+controlWidth_V,
        Y>=Yctl,Y
        <=Yctl+controlHeight_V,
        Xmove=X-Xctl,
        Ymove=Y-Yctl.

clauses
    tryGetFocus(_ActiveControl)=_This:-
        (visible_V=false or enabled_V=false),
        !,
        fail.
    tryGetFocus(ActiveControl)=This:-
        not(ActiveControl=This),
        This:trySetFocus(),
        notify(This,string(consoleEventSource::getFocusID_C),none),
        !.
    tryGetFocus(_ActiveControl)=NextActiveControl:-
        try
        	NextActiveControl = convert(consoleControlContainer, This):tryDefineFocus(uncheckedConvert(consoleControl, 0))
        catch _TraceID0 do
        	fail
        end try.

clauses
    trySetFocus():-fail.

clauses
    handleChar(_VirtualKey,_Char).

/* Dummy facts and clauses*/
facts
    startFieldMark_V:char:='['.
    endFieldMark_V:char:=']'.
    fillSpaceChar_V:char:='_'.

clauses
    updateView().

end implement consoleControl

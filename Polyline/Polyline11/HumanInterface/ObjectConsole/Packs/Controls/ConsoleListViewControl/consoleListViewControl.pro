/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement consoleListViewControl
    inherits consoleControl
    open core

clauses
    new(ConsoleControlContainer):-
        new(),
        setConsoleControlContainer(ConsoleControlContainer).

clauses
    new():-
        subscribe(onShow,string(consoleEventSource::showEventID_C)),
        subscribe(onMouseDblClick,string(consoleEventSource::mouseDblClickEventID_C)),
        subscribe(onMouseClick,string(consoleEventSource::mouseClickEventID_C)).

facts
    itemList_V:string*:=[].
    selection_V:positive:=erroneous.
    firstItem_V:positive:=0.
    cursorPosition_V:console_native::coord:=erroneous.

clauses
    add(Item):-
        itemList_V:=list::append(itemList_V,[Item]),
        updateView().

clauses
    addList(ItemList):-
        itemList_V:=list::append(itemList_V,ItemList),
        if showOccured_V=true then
            updateView()
        end if.

clauses
    delete(Index):-
        list::split(Index, itemList_V, LeftList, RightList),
        RightList=[_Indexed|Tail],
        !,
        itemList_V:=list::append(LeftList,Tail),
        updateView().
    delete(_Index).

clauses
    clearAll():-
        itemList_V:=[],
        updateView().

clauses
    getCount()=list::length(itemList_V).

clauses
    getAt(Index)=ItemString:-
        ItemString=list::tryGetNth(Index,itemList_V),
        !.
    getAt(_Index)=_ItemString:-
        exception::raise_User("an attempt to get the out of range Item").

clauses
    getAll()=itemList_V.

clauses
    tryGetSelectedIndex()=SelectedIndex:-
        try SelectedIndex=selection_V
        catch _TraceID do
            fail
        end try.

clauses
    selectAt(Index):-
        Index<=list::length(itemList_V),
        !,
        selection_V:=Index,
        if selection_V+1-firstItem_V>getHeight()-2 then
            firstItem_V:=selection_V+1-getHeight()+2
        end if,
        if showOccured_V=true then
            updateView()
        end if.
    selectAt(_Index):-
        exception::raise_User("an attempt to set the out of range selection").

clauses
    updateView():-
        showControlFrame(),
        showControlItems().

predicates
    onShow:notificationAgency::notificationListenerFiltered.
clauses
    onShow(_NotificationAgency,This,_EventData):-
        !,
        updateView().
    onShow(_NotificationAgency,_This,_EventData).

predicates
    onMouseDblClick:notificationAgency::notificationListenerFiltered.
clauses
    onMouseDblClick(_NotificationAgency,This,string(Location)):-
        toTerm(Location)=console_native::coord(_X,Y),
        Y>0,
        Y<getHeight()-1,
        _ItemString=list::tryGetNth(firstItem_V+Y-1,itemList_V),
        selection_V:=firstItem_V+Y-1,
        updateView(),
        trySetFocus(),
        notify(This,string(consoleEventSource::mouseDblClickEventID_C),unsigned(firstItem_V+Y-1)),
        !.
    onMouseDblClick(_NotificationAgency,_This,_EventData).

predicates
    onMouseClick:notificationAgency::notificationListenerFiltered.
clauses
    onMouseClick(_NotificationAgency,This,string(Location)):-
        toTerm(Location)=console_native::coord(_X,Y),
        Y>0,
        Y<getHeight()-1,
        _ItemString=list::tryGetNth(firstItem_V+Y-1,itemList_V),
        selection_V:=firstItem_V+Y-1,
        updateView(),
        trySetFocus(),
        notify(This,string(consoleEventSource::listViewSelectionChangedID_C),unsigned(firstItem_V+Y-1)),
        !.
    onMouseClick(_NotificationAgency,_NotificationSource,_Value).

predicates
    showControlFrame:().
clauses
    showControlFrame():-
        console_native::coord(X,Y)=geCtrlLocation(),
        console::setLocation(console_native::coord(X,Y)),
        HorisontalLine=string::create(convert(charCount,getWidth())-2,"-"),
        SpaceLine=string::create(convert(charCount,getWidth())-2," "),
        Attribute=getTextAttribute(),
        if getEnabled()=false then
            console::setTextAttribute(0x0000,0x0008)
        else
            TextColor=getTextAttribute(),
            console::setTextAttribute(TextColor)
        end if,
        console::write("+",HorisontalLine,"+"),
        console::setLocation(console_native::coord(X,Y+getHeight()-1)),
        console::write("+",HorisontalLine,"+"),
        foreach Row = std::fromTo(1, getHeight()-2) do
            console::setLocation(console_native::coord(X,Y+Row)),
            console::write("|",SpaceLine,"|")
        end foreach,
        console::setTextAttribute(Attribute).

predicates
    showControlItems:().
clauses
    showControlItems():-
        false=getVisible(),
        !.
    showControlItems():-
        cursorPosition_V:=erroneous,
        list::split(firstItem_V, itemList_V, _LeftList, RightList),
        list::split(getHeight()-2, RightList, ListToShow, _Tail),
        console_native::coord(X,Y)=geCtrlLocation(),
        console::setLocation(console_native::coord(X,Y)),
        Attribute=getTextAttribute(),
        if getEnabled()=false then
            console::setTextAttribute(0x0000,0x0008)
        else
            TextColor=getTextAttribute(),
            console::setTextAttribute(TextColor)
        end if,
        foreach Row = std::fromTo(1, list::length(ListToShow)) do
            if not(isErroneous(selection_V)), firstItem_V+Row-1=selection_V then
                ItemSelectionMark=">",
                cursorPosition_V:=console_native::coord(X+1,Y+Row)
            else
                ItemSelectionMark=" "
            end if,
            console::setLocation(console_native::coord(X+1,Y+Row)),
            console::write(ItemSelectionMark," ",list::nth(Row-1,ListToShow))
        end foreach,
        console::setTextAttribute(Attribute).

clauses
    trySetFocus():-
        not(isErroneous(cursorPosition_V)),
        !,
        console::setLocation(cursorPosition_V).
    trySetFocus():-
        console_native::coord(X,Y)=geCtrlLocation(),
        console::setLocation(console_native::coord(X,Y)).

clauses
    handleChar(_VirtualKey,_Char):-
        getEnabled()=false,
        !.
    handleChar(_VirtualKey,'\r'):-
        if not(isErroneous(selection_V)) then
            notify(This,string(consoleEventSource::mouseDblClickEventID_C),unsigned(firstItem_V+0+selection_V))
        end if,
        !.
    handleChar(VirtualKey,_Char):-
        (VirtualKey=38 or VirtualKey=40),
        isErroneous(selection_V),
        selection_V:=0,
        firstItem_V:=0,
        updateView(),
        trySetFocus(),
        notify(This,string(consoleEventSource::listViewSelectionChangedID_C),unsigned(0)),
        !.
    handleChar(40,_Char):-
        selection_V+1<=list::length(itemList_V)-1,
        if selection_V+1-firstItem_V>=getHeight()-2 then
            firstItem_V:=firstItem_V+1
        end if,
        selection_V:=selection_V+1,
        updateView(),
        trySetFocus(),
        notify(This,string(consoleEventSource::listViewSelectionChangedID_C),unsigned(convert(unsigned,firstItem_V+selection_V))),
        !.
    handleChar(38,_Char):-
        selection_V-1>=0,
        if selection_V-1<firstItem_V  then
            firstItem_V:=firstItem_V-1
        end if,
        selection_V:=selection_V-1,
        updateView(),
        trySetFocus(),
        notify(This,string(consoleEventSource::listViewSelectionChangedID_C),unsigned(convert(unsigned,firstItem_V+selection_V))),
        !.
    handleChar(_VirtualKey,_Any).

end implement consoleListViewControl

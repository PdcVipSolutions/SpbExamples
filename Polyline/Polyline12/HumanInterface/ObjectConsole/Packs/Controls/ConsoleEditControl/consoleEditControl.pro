/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement consoleEditControl
    inherits consoleControl
    open core

clauses
    new(ConsoleControlContainer):-
        new(),
        setConsoleControlContainer(ConsoleControlContainer).

clauses
    new():-
        subscribe(onShow,string(consoleEventSource::showEventID_C)),
        subscribe(onDblClick,string(consoleEventSource::mouseDblClickEventID_C)).

facts
    startFieldMark_V:char:='`'.
    endFieldMark_V:char:='`'.
    fillSpaceChar_V:char:='.'.

facts
    textLengthLimited_V:boolean:=true.

clauses
    setTextLengthLimited(TrueIfLimited):-
        textLengthLimited_V:=TrueIfLimited.

clauses
    updateView():-
        write(getCtrlLocation(),getTextToShow()).

predicates
    onDblClick:notificationAgency::notificationListenerFiltered.
clauses
    onDblClick(_NotificationAgency,This,_Status):-
        !,
        notify(This,string(consoleEventSource::editorMouseDblClickEventID_C),none).
    onDblClick(_NotificationAgency,_NotificationSource,_Value).

predicates
    onShow:notificationAgency::notificationListenerFiltered.
clauses
    onShow(_NotificationAgency,This,_Status):-
        !,
        updateView().
    onShow(_NotificationAgency,_NotificationSource,_Value).

clauses
    handleChar(_VirtualKey,_Char):-
        getEnabled()=false,
        !.
    handleChar(_VirtualKey,'\r'):-
        !.
    handleChar(38,_Char):- %ArrowUp
        !.
    handleChar(40,_Char):- %ArrowDown
        !.
    handleChar(36,_Char):- %Home
        firstChar_V:=0,
        cursorPosition_V:=0,
        updateView(),
        setFocus(),
        !.
    handleChar(35,_Char):- %End
        TextLength=string::length(getText()),
        EditFieldLength=getWidth()-2,
        if TextLength<EditFieldLength-1 then
            firstChar_V:=0,
            try
                cursorPosition_V:=TextLength
            catch _TraceID do
                cursorPosition_V:=0
            end try
        else
            if textLengthLimited_V=false then
                firstChar_V:=TextLength-EditFieldLength+1
            end if,
            cursorPosition_V:=EditFieldLength-1
        end if,
        updateView(),
        setFocus,
        !.
    handleChar(37,_Char):- %ArrowLeft
        try cursorPosition_V:=cursorPosition_V-1
        catch _TraceID do
            if firstChar_V>0 then
                firstChar_V:=firstChar_V-1,
                updateView()
            end if
        end try,
        !,
        setFocus().
    handleChar(39,_Char):- %ArrowRight
        if textLengthLimited_V=true then
            FieldLen=getWidth()-2
        else
            FieldLen=getWidth()-3
        end if,
        NewPosition=cursorPosition_V+1,
        if
            NewPosition<getWidth()-2,
            NewPosition<=string::length(getText())-firstChar_V
        then
            cursorPosition_V:=NewPosition
        else
            if string::length(getText())>FieldLen then
                if firstChar_V+FieldLen<string::length(getText()) then
                    firstChar_V:=firstChar_V+1,
                    updateView()
                end if
            end if
        end if,
        setFocus(),
        !.
    handleChar(8,_Char):-%BackSpace
        try
        	string::tryFront(getText(), firstChar_V + cursorPosition_V - 1, Prefix, Suffix)
        catch _Err1 do
        	fail
        end try,
        try
        	string::frontChar(Suffix, _First, NewSuffix)
        catch _Err2 do
        	fail
        end try,
        if not(firstChar_V>0) then
            try
            	cursorPosition_V := cursorPosition_V - 1
            catch _Err4 do
            	succeed
            end try
        else
            try
            	firstChar_V := firstChar_V - 1
            catch _Err3 do
            	succeed
            end try
        end if,
        setText(string::concat(Prefix,NewSuffix)),
        setFocus(),
        !.
    handleChar(8,_Char):-%BackSpace
        !.
    handleChar(46,_Char):-%Del
        string::tryFront(getText(), firstChar_V+cursorPosition_V, Prefix, Suffix),
        string::frontChar(Suffix, _First, NewSuffix),
        setText(string::concat(Prefix,NewSuffix)),
        !.
    handleChar(46,_Char):-% Failed Del
        !.
    handleChar(_VirtualKey,_Char):-
        textLengthLimited_V=true,
        string::length(getText())>=getWidth()-2,
        !.
    handleChar(_VirtualKey,Char):-
        if textLengthLimited_V=true then
            FieldLen=getWidth()-2
        else
            FieldLen=getWidth()-3
        end if,
        CharAsString = string::charToString(Char),
        if getText()="" then
            NewText=CharAsString
        else
            string::front(getText(), firstChar_V+cursorPosition_V, Prefix, Suffix),
            NewText=string::concat(Prefix,CharAsString,Suffix)
        end if,
        if string::length(NewText)>FieldLen then
            firstChar_V:=firstChar_V+1
        end if,
        NewPosition=cursorPosition_V+1,
        if
            not(cursorPosition_V=getWidth()-2),
            string::length(NewText)<=FieldLen
        then
            cursorPosition_V:=NewPosition
        end if,
        setText(NewText),
        setFocus().

predicates
    setFocus:().
clauses
    setFocus():-
        trySetFocus(),
        !.
    setFocus().

clauses
    trySetFocus():-
        console_native::coord(X,Y)=getCtrlLocation(),
        console::setLocation(console_native::coord(X+1+cursorPosition_V,Y)),
        notify(This,string(consoleEventSource::getFocusID_C),none).

facts
    cursorPosition_V:charCount:=0.
    firstChar_V:charCount:=0.

predicates
    getTextToShow:()->string TextToShow.
clauses
    getTextToShow()=StringToShow:-
        if getText() ="" then
            StringToShow=string::create(convert(charCount,getWidth()-2),string::charToString(fillSpaceChar_V))
        else
            string::front(getText(), firstChar_V, _Prefix, Suffix),
            if string::length(Suffix)<getWidth()-2 then
                StringToShow=string::concat(Suffix,string::create(getWidth()-2-string::length(Suffix),string::charToString(fillSpaceChar_V)))
            else
                string::front(Suffix, getWidth()-2,StringToShow, _Suffix)
            end if
        end if.

predicates
    write:(console_native::coord WriteLocation,string TextToShow).
clauses
    write(console_native::coord(X,Y),TextToShow):-
        console::setLocation(console_native::coord(X,Y)),
        Attribute=console::getTextAttribute(),
        if getEnabled()=false then
            console::setTextAttribute(0x0000,0x0008)
        else
            console::setTextAttribute(getTextAttribute())
        end if,
        if true=getVisible() then
            console::write(startFieldMark_V,TextToShow,endFieldMark_V)
        end if,
        console::setTextAttribute(Attribute).

end implement consoleEditControl

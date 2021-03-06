/*****************************************************************************

                         Prolog Development Center A/S

******************************************************************************/
implement consoleEditControl
    inherits consoleControl
    open core

constants
    className = "SpbSolutions/ConsoleEditControl/consoleEditControl".
    classVersion = "".

clauses
    classInfo(className, classVersion).

clauses
    new(ConsoleControlContainer):-
        new(),
        setConsoleControlContainer(ConsoleControlContainer).

clauses
    new():-
        subscribe(onShow).

facts
    startFieldMark_V:char:='`'.
    endFieldMark_V:char:='`'.
    fillSpaceChar_V:char:='.'.

clauses
    updateView():-
        getViewParameters(WriteLocation,TextToShow,_InputLocation),
        write(WriteLocation,TextToShow).
        
predicates
    onShow:notificationAgency::notificationListener.
clauses
    onShow(_Request,_NotificationAgency,This,string("show"),_Status):-
        !,
        updateView().
    onShow(_Request,_NotificationAgency,_NotificationSource,_EventID,_Value).
        
clauses
    handleChar(_VirtualKey,'\r'):-
        !.
    handleChar(37,_Char):- %ArrowLeft
        !.
    handleChar(39,_Char):- %ArrowRight
        !.
    handleChar(8,_Char):-%BackSpace
        !.
    handleChar(46,_Char):-%Del
        !.
    handleChar(_VirtualKey,Char):-
        CharAsString = string::charToString(Char),
        setText(string::concat(getText(),CharAsString)),
        getViewParameters(_WriteLocation,_TextToShow,InputLocation),
        console::setLocation(InputLocation).

clauses
    trySetFocus():-
        getViewParameters(_WriteLocation,_TextToShow,InputLocation),
        console::setLocation(InputLocation).

facts
    cursorPosition_V:positive:=0.
    firstChar_V:positive:=0.

predicates
    getViewParameters:(console::location WriteLocation [out],string TextToShow [out],console::location InputLocation [out]).
clauses
    getViewParameters(Location,TextToShow,Location):-
        false=getVisible(),
        !,
        Location=getLocation(),
        TextToShow=string::create(convert(charCount,getWidth())," ").
    getViewParameters(console::location(X,Y),TextToShow,InputLocation):-
        console::location(X,Y)=getLocation(),
        if getText() ="" then
            TextToShow=string::create(convert(charCount,getWidth()-2),string::charToString(fillSpaceChar_V)),
            InputLocation=console::location(X+1,Y)
        else
            if string::length(getText())<getWidth()-2 then
                InputLocation=console::location(X+1+string::length(getText()),Y),
                TextToShow=string::concat(getText(),string::create(getWidth()-2-string::length(getText()),string::charToString(fillSpaceChar_V)))
            else
                InputLocation=console::location(X+getWidth()-2,Y),
                string::front(getText(),string::length(getText())-(getWidth()-2),_Front,TextToShow)
            end if
        end if.

/*
    getViewParameters(StringToShow):-
        string::front(getText(), firstChar_V, _Prefix, Suffix),
        string::front(Suffix, getWidth()-2,Prefix, _Suffix).
*/

predicates
    write:(console::location WriteLocation,string TextToShow).
clauses
    write(console::location(X,Y),TextToShow):-
        console::setLocation(console::location(X,Y)),
        if true=getVisible() then
            console::write(startFieldMark_V,TextToShow,endFieldMark_V)
        else
            console::write(" ",TextToShow," ")
        end if.

end implement consoleEditControl

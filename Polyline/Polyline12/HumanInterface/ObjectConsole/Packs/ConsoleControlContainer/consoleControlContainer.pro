/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement consoleControlContainer
    open core

facts
    controls_V:consoleControl*:=[].

clauses
    addControl(ConsoleControl):-
        controls_V:=list::append(controls_V,[ConsoleControl]).

clauses
    showControls():-
        foreach Control=list::getMember_nd(controls_V) do
            Control:show()
        end foreach.

clauses
    invalidate():-
        foreach Control=list::getMember_nd(controls_V) do
            Control:updateView(),
            if Container=tryConvert(consolecontrolcontainer,Control) then
               Container:invalidate()
            end if
        end foreach.

clauses
    invalidateAll():-
        EventSource=tryConvert(consoleEventsource,This),
        !,
        EventSource:updateView().
    invalidateAll():-
        ConsoleRoot=convert(consoleControl,This):getConsoleRoot(),
        EventSource=convert(consoleEventsource,ConsoleRoot),
        EventSource:updateView().

clauses
    remove(Control):-
        controls_V:= list::remove(controls_V, Control),
        invalidateAll(),
        Control:getModalMode()=false,
        ConsoleRoot=Control:getConsoleRoot(),
        EventSource=convert(consoleEventsource,ConsoleRoot),
        EventSource:focus_V=Control,
        FocusedControl=tryDefineFocus(uncheckedConvert(consoleControl,0)),
        EventSource:focus_V:=FocusedControl,
        FocusedControl:trySetFocus(),
        !.
    remove(_Control).

clauses
    removeAll():-
        foreach Control=list::getMember_nd(controls_V) do
            Control:destroy()
        end foreach,
        invalidateAll().

clauses
    tryDefineFocus(uncheckedConvert(consoleControl,0))=FocusedControl:-
        Control=list::getMember_nd(controls_V),
            FocusedControl=Control:tryGetFocus(uncheckedConvert(consoleControl,0)),
            !.
    tryDefineFocus(ActiveControl)=NextActiveControl:-
        Index=list::tryGetIndex(ActiveControl,controls_V),
        list::split(Index,controls_V,_FrontList,RestList),
        RestList=[_Control|RestListTail],
        NextControl=list::getMember_nd(RestListTail),
            NextActiveControl=NextControl:tryGetFocus(ActiveControl),
            !.
    tryDefineFocus(_ActiveControl)=NextActiveControl:-
        true=convert(consoleControl,This):getModalMode(),
        not(controls_V=[]),
        NextActiveControl=tryDefineFocus(uncheckedConvert(consoleControl,0)),
        !.
    tryDefineFocus(_ActiveControl)=NextActiveControl:-
        try
        	NextActiveControl = convert(consoleControl, This):getConsoleControlContainer():tryDefineFocus(convert(consoleControl, This))
        catch _TraceID1 do
        	fail
        end try.

end implement consoleControlContainer

/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
interface consoleControl
    supports notificationAgency
    open core

properties
    startFieldMark_V:char.
    endFieldMark_V:char.
    fillSpaceChar_V:char.
    showOccured_V:boolean.

predicates
    getConsoleRoot:()->consoleControlContainer ConsoleRoot.

predicates
    setTextAttribute:(unsigned Color,unsigned Intensity).

predicates
    getTextAttribute:()->unsigned Attribute.

predicates
    destroy:().

predicates
    setConsoleControlContainer:(consoleControlcontainer ConsoleControlContainer).

predicates
    getConsoleControlContainer:()->consoleControlcontainer ConsoleControlContainer.

predicates
    setVisible:(boolean TrueIfVisible).

predicates
    getVisible:()->boolean TrueIfVisible.

predicates
    setEnabled:(boolean TrueIfEnabled).

predicates
    getEnabled:()->boolean TrueIfEnabled.

predicates
    setPosition:(positive X,positive Y).

predicates
    getPosition:(positive X [out],positive Y [out]).

predicates
    geCtrlLocation:()->console_native::coord.

predicates
    setWidth:(positive ValueLength).

predicates
    getWidth:()->  positive ValueLength.

predicates
    setHeight:(positive ValueLength).

predicates
    getHeight:()-> positive ValueLength.

predicates
    setText:(string Text).

predicates
    getText:()->string Text.
    
predicates
    show:().

predicates
    tryGetFocus:(consoleControl ActiveControl)->consoleControl NewActiveControl determ.

predicates
    trySetFocus:() determ.

predicates
    setModal:(consoleControl ActiveControl).

predicates
    getModalMode:()->boolean TrueIfModal.

predicates
    handleChar:(unsigned VirtualKey,char Char).

predicates
    refreshView:().

predicates
    updateView:().

end interface consoleControl
/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
interface consoleEventSource
    open core

constants
    getFocusID_C="getFocus".
    loseFocusID_C="loseFocus".

    showEventID_C="show".
    destroyedEventID_C="destroyed".
    mouseMoveEventID_C="mouseMove".
    mouseClickEventID_C="mouseClick".
    mouseDblClickEventID_C="mouseDblClick".

    buttonClickEventID_C="buttonClick".

    editorModifiedEventID_C="modified".
    editorMouseDblClickEventID_C="editorMouseDblClick_ec".

    checkBoxStatusChangedEventID_C="statusChanged".

    listViewSelectionChangedID_C="selectionChanged".

    closedEventID_C="closed".

properties
    focus_V:consoleControl.

predicates
    run:().

predicates
    setModality:(consoleControl ModalControl).

predicates
    unSetModality:().

predicates
    updateView:().

predicates
    processEvents:().

end interface consoleEventSource
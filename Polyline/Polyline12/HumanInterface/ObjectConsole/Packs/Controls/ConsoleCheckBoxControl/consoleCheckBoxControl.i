/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
interface consoleCheckBoxControl
    supports consoleControl
    open core

predicates
    setChecked : (boolean Checked).

predicates
    getChecked : () -> boolean Checked.

end interface consoleCheckBoxControl
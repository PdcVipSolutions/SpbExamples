/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
interface consoleEditControl
    supports consoleControl
    open core

predicates
    setTextLengthLimited:(boolean TrueIfLimited). % Limited by default

end interface consoleEditControl
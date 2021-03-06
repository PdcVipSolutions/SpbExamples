/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
interface consoleListViewControl
    supports consoleControl
    open core

predicates
    add:(string InitialValue).

predicates
    addList:(string* ItemList).

predicates
    delete:(positive Index).

predicates
    clearAll:().

predicates
    getCount : () -> integer Number.

predicates
    getAt : (positive Index) -> string Item.

predicates
    getAll : () -> string* ItemList.

predicates
    tryGetSelectedIndex : () -> positive SelectedIndex determ.

predicates
    selectAt : (positive Index).

end interface consoleListViewControl
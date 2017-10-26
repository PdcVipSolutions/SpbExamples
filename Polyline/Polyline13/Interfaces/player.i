/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
interface player
    supports notificationAgency
    open core

predicates
    onNotification:notificationAgency::notificationListener.

predicates
    setHumanInterface:(humanInterface PersonalHumanIterface).

properties
    name:string.
    legend_V:integer.

predicates
    setAttributes:(namedValue*).
    getAttributes:()->namedValue*.

predicates
    stopGame:().

end interface player
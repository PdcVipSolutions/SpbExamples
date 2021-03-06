/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
interface player
    supports notificationAgency
    open core

predicates
    setName:(string).
    onNotification:notificationAgency::notificationListener.
 
properties
    name:string.

end interface player
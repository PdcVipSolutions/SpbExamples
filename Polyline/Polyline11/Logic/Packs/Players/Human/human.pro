/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement human
    inherits notificationAgency

    open core

facts
    game_V:game:=erroneous.
    humanInterface_V:humanInterface:=erroneous.

facts
    legend_V:integer:=0x00FFFFFF.

clauses
    new(GameObject):-
        game_V:=convert(game,GameObject),
        name:=string::concat(name,toString(This)).

clauses
    setHumanInterface(HumanInterface):-
        humanInterface_V:=HumanInterface.

clauses
    stopGame():-
        try
        	humanInterface_V:unsubscribe(moveListener)
        catch _TraceID do
        	succeed
        end try.

facts
    name:string:="Hum_".

clauses
    setAttributes(_NamedValue).
    getAttributes()=
        [
        namedValue("descriptor",string(getPlayerDescriptor(game_V:language_V))),
        namedValue("shortDescriptor",string(getPlayerShortDescriptor(game_V:language_V)))
        ].

clauses
   getPlayerShortDescriptor(polyLineDomains::en)="Human".
   getPlayerShortDescriptor(polyLineDomains::ru)="Человек".

class predicates
   getPlayerDescriptor:(polyLineDomains::language_D)->string DetailedDescription.
clauses
   getPlayerDescriptor(polyLineDomains::en)="Your strategy is defied by your moves".
   getPlayerDescriptor(polyLineDomains::ru)="Ваша стратегия, определяется Вашими ходами".

predicates
    moveListener:notificationAgency::notificationListener.
clauses
    moveListener(_Object1,_Object2,_Object3,string(polylineDomains::humanMove_C),string(Move)):- % Gets Move and passes it
        !,
        humanInterface_V:unsubscribe(moveListener),
        notify(This,string(polylineDomains::playerMove_C),string(Move)).
    moveListener(_Object1,_Object2,_Object3,_None,_Move).

clauses
    onNotification(_Object1,_Object2,_Object3,object(This),none):- % Invites to make Move
        humanInterface_V:subscribe(moveListener),
        humanInterface_V:showStatus(polylineDomains::humanMove(This)),
        !.
    onNotification(_Object1,_Object2,_Object3,string(polylineDomains::playerWon_C),string(Name)):-
        !,
        notify(This,string(polylineDomains::playerWon_C),string(Name)).
    onNotification(_Object1,_Object2,_Object3,_Value1,_Value2).


end implement human

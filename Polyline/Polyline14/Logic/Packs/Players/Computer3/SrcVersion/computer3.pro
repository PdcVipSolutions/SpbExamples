/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/

implement computer3
    inherits genericComputer
    open core, polylineDomains

facts
    legend_V:integer:=0x00FF00FF.

clauses
    new(GameObject):-
        game_V:=convert(game,GameObject),
        genericComputer::new(game_V),
        setDaughter(This),
        PolyLineBraneObj=polylineStrategy3::new(),
        setpolylineStrategy(PolyLineBraneObj).

clauses
    setAttributes([NamedValue]):-
        !,
        setStrategyAttribute(NamedValue).
    setAttributes(_NamedValues).

clauses
    getAttributes()=
        [
        namedValue("descriptor",string(getPlayerDescriptor(game_V:language_V))),
        namedValue("shortDescriptor",string(getPlayerShortDescriptor(game_V:language_V))),
        getStrategyAttribute()
        ].

clauses
   getPlayerShortDescriptor(polyLineDomains::en)=polylineStrategy3::playerShortDescriptorEn_C.
   getPlayerShortDescriptor(polyLineDomains::ru)=polylineStrategy3::playerShortDescriptorRu_C.

class predicates
   getPlayerDescriptor:(polyLineDomains::language_D)->string DetailedDescription.
clauses
   getPlayerDescriptor(polyLineDomains::en)=polylineStrategy3::playerDescriptorEn_C.
   getPlayerDescriptor(polyLineDomains::ru)=polylineStrategy3::playerDescriptorRu_C.

end implement computer3

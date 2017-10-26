/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement computer2
    inherits genericComputer
    open core, polylineDomains

facts
    legend_V:integer:=0x00FFFF00.
%    attribute_V:namedValue*:=erroneous.

facts
    game_V:game:=erroneous.

clauses
    new(GameObject):-
        game_V:=convert(game,GameObject),
        genericComputer::new(game_V),
        setDaughter(This),
        PolyLineBraneObj=polylineStrategy2::new(),
        setpolylineStrategy(PolyLineBraneObj).

clauses
    setAttributes([NamedValue]):-
        !,
        setStrategyAttribute(NamedValue).
    setAttributes(_NamedValues).

clauses
    getAttributes()=
        [
        namedValue(descriptorID_C,string(getPlayerDescriptor(game_V:language_V))),
        namedValue(shortDescriptorID_C,string(getPlayerShortDescriptor(game_V:language_V))),
        getStrategyAttribute()
        ].

clauses
   getPlayerShortDescriptor(polyLineDomains::en)=polylineStrategy2::playerShortDescriptorEn_C.
   getPlayerShortDescriptor(polyLineDomains::ru)=polylineStrategy2::playerShortDescriptorRu_C.

class predicates
   getPlayerDescriptor:(polyLineDomains::language_D)->string DetailedDescription.
clauses
   getPlayerDescriptor(polyLineDomains::en)=polylineStrategy2::playerDescriptorEn_C.
   getPlayerDescriptor(polyLineDomains::ru)=polylineStrategy2::playerDescriptorRu_C.

end implement computer2

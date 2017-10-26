/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement computer1
    inherits genericComputer
    open core,polylineDomains

facts
    legend_V:integer:=0x00FF0000.

clauses
    new(GameObject):-
        game_V:=convert(game,GameObject),
        genericComputer::new(game_V),
        setDaughter(This),
        PolyLineBraneObj=polylineStrategy1::new(),
        setpolylineStrategy(PolyLineBraneObj).

clauses
    setAttributes(_NamedValue).
    getAttributes()=
        [
        namedValue(descriptorID_C,string(getPlayerDescriptor(game_V:language_V))),
        namedValue(shortDescriptorID_C,string(getPlayerShortDescriptor(game_V:language_V)))
        ].

clauses
   getPlayerShortDescriptor(polyLineDomains::en)=polylineStrategy1::playerShortDescriptorEn_C.
   getPlayerShortDescriptor(polyLineDomains::ru)=polylineStrategy1::playerShortDescriptorRu_C.

class predicates
   getPlayerDescriptor:(polyLineDomains::language_D)->string DetailedDescription.
clauses
   getPlayerDescriptor(polyLineDomains::en)=polylineStrategy1::playerDescriptorEn_C.
   getPlayerDescriptor(polyLineDomains::ru)=polylineStrategy1::playerDescriptorRu_C.

end implement computer1

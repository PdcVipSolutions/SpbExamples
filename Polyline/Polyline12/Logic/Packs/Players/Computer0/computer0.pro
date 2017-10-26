/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/

implement computer0
    inherits genericComputer

    open core, polylineDomains

facts
    game_V:game:=erroneous.

facts
    legend_V:integer:=0x0000FF00.
%    attribute_V:namedValue:=erroneous.

clauses
    new(GameObject):-
        game_V:=convert(game,GameObject),
        genericComputer::new(game_V),
        setDaughter(This),
        PolyLineBraneObj=polylineStrategy0::new(),
        setpolylineStrategy(PolyLineBraneObj).

clauses
    setAttributes(_NamedValue).
    getAttributes()=
        [
        namedValue(descriptorID_C,string(getPlayerDescriptor(game_V:language_V))),
        namedValue(shortDescriptorID_C,string(getPlayerShortDescriptor(game_V:language_V)))
        ].

clauses
   getPlayerShortDescriptor(polyLineDomains::en)=polylineStrategy0::playerShortDescriptorEn_C.
   getPlayerShortDescriptor(polyLineDomains::ru)=polylineStrategy0::playerShortDescriptorRu_C.

class predicates
   getPlayerDescriptor:(polyLineDomains::language_D)->string DetailedDescription.
clauses
   getPlayerDescriptor(polyLineDomains::en)=polylineStrategy0::playerDescriptorEn_C.
   getPlayerDescriptor(polyLineDomains::ru)=polylineStrategy0::playerDescriptorRu_C.

end implement computer0

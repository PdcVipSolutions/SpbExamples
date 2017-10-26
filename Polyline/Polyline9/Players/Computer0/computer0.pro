/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/

implement computer0
    inherits genericComputer

    open core

facts
    game_V:game:=erroneous.

clauses
    new(GameObject):-
        game_V:=convert(game,GameObject),
        genericComputer::new(game_V),
        PolyLineBraneObj=polylineStrategy0::new(),
        setpolylineStrategy(PolyLineBraneObj).

clauses
   getPlayerDescriptor(polyLineDomains::en)=polylineStrategy0::playerDescriptorEn_C.
   getPlayerDescriptor(polyLineDomains::ru)=polylineStrategy0::playerDescriptorRu_C.

end implement computer0

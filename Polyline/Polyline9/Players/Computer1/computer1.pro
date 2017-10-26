/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/

implement computer1
    inherits genericComputer
    open core

clauses
    new(GameObject):-
        game_V:=convert(game,GameObject),
        genericComputer::new(game_V),
        PolyLineBraneObj=polylineStrategy1::new(),
        setpolylineStrategy(PolyLineBraneObj).

clauses
   getPlayerDescriptor(polyLineDomains::en)=polylineStrategy1::playerDescriptorEn_C.
   getPlayerDescriptor(polyLineDomains::ru)=polylineStrategy1::playerDescriptorRu_C.

end implement computer1

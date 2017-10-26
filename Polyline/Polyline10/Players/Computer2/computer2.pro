/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement computer2
    inherits genericComputer
    open core

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
   getPlayerDescriptor(polyLineDomains::en)=polylineStrategy2::playerDescriptorEn_C.
   getPlayerDescriptor(polyLineDomains::ru)=polylineStrategy2::playerDescriptorRu_C.

end implement computer2

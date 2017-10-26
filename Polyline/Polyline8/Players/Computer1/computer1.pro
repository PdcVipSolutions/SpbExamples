/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/

implement computer1
    inherits genericComputer
    open core

clauses
    new():-
        PolyLineBraneObj=polylineStrategy1::new(),
        setpolylineStrategy(PolyLineBraneObj).

clauses
   getPlayerDescriptor(game::en)=polylineStrategy1::playerDescriptorEn_C.
   getPlayerDescriptor(game::ru)=polylineStrategy1::playerDescriptorRu_C.

end implement computer1

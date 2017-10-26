/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement computer2
    inherits genericComputer
    open core

clauses
    new():-
        PolyLineBraneObj=polylineStrategy2::new(),
        setpolylineStrategy(PolyLineBraneObj).

clauses
   getPlayerDescriptor(game::en)=polylineStrategy2::playerDescriptorEn_C.
   getPlayerDescriptor(game::ru)=polylineStrategy2::playerDescriptorRu_C.

end implement computer2

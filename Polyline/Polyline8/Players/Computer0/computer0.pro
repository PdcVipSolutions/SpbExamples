/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/

implement computer0
    inherits genericComputer

    open core

clauses
    new():-
        PolyLineBraneObj=polylineStrategy0::new(),
        setpolylineStrategy(PolyLineBraneObj).

clauses
   getPlayerDescriptor(game::en)=polylineStrategy0::playerDescriptorEn_C.
   getPlayerDescriptor(game::ru)=polylineStrategy0::playerDescriptorRu_C.

end implement computer0

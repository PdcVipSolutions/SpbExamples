/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/


#export export
implement export
    open core

clauses
    new(Game)=cHumanInterface::new(Game).
    % predicate, which is exported by DLL

end implement export

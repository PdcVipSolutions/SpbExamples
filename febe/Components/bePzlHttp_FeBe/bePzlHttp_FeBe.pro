/*****************************************************************************
Copyright (c)  PDCSPB

Author: Victor Yukhtenko
******************************************************************************/
implement bePzlHttp_Febe
    inherits pzlComponent
    inherits appHead

    open core, pfc\log

clauses
    new(_Container).

clauses
    pzlInit(_):-
        log::write(log::info,"Component bePzlHttp_Febe: ","Initiated").

    pzlRun(_).
    pzlComplete().

end implement bePzlHttp_Febe

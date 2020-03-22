/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
interface iPzlGame
    supports pzlComponent
    supports game
    supports pzlRun

open core

constants
    componentDescriptor_C:pzlDomains::pzlComponentInfo_D=pzlDomains::pzlComponentInfo
                (
                componentAlias_C,
                componentID_C,
                componentRunAble_C,
                componentMetaInfo_C
                ).
    componentID_C:pzlDomains::entityUID_D=pzlDomains::str("PzlGameID").
    componentAlias_C="PzlGame".
    componentRunAble_C=b_True.
    componentVersion_C="1.0".
    componentPublicName_C="My Component".
    componentMetaInfo_C:namedValue_List=[].

end interface iPzlGame
/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
interface iPzlComputer0
    supports pzlComponent
    supports player

open core

constants
    componentDescriptor_C:pzlDomains::pzlComponentInfo_D=pzlDomains::pzlComponentInfo
                (
                componentAlias_C,
                componentID_C,
                componentRunAble_C,
                componentMetaInfo_C
                ).
    componentID_C:pzlDomains::entityUID_D=pzlDomains::str("PzlComputer0ID").
    componentAlias_C="PzlComputer0".
    componentRunAble_C=b_False.
    componentVersion_C="1.0".
    componentPublicName_C="Computer0".
    componentMetaInfo_C:namedValue_List=
        [
        namedValue("type",string("player")),
        namedValue("title",string(componentPublicName_C))
        ].

end interface iPzlComputer0
/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
interface iPzlHumanInterface
    supports pzlComponent
    supports humanInterface

open core

constants
    componentDescriptor_C:pzlDomains::pzlComponentInfo_D=pzlDomains::pzlComponentInfo
                (
                componentAlias_C,
                componentID_C,
                componentRunAble_C,
                componentMetaInfo_C
                ).
    componentID_C:pzlDomains::entityUID_D=pzlDomains::str("HumanInterfaceID").
    componentAlias_C="HumanInterface".
    componentRunAble_C=b_False.
    componentVersion_C="1.0".
    componentPublicName_C="Polyline Human Interface".
    componentMetaInfo_C:namedValue_List=[].

end interface iPzlHumanInterface

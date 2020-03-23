/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
interface iPzlJuniourJudge
    supports pzlComponent
    supports juniourJudge
    

open core

constants
    componentDescriptor_C:pzlDomains::pzlComponentInfo_D=pzlDomains::pzlComponentInfo
                (
                componentAlias_C,
                componentID_C,
                componentRunAble_C,
                componentMetaInfo_C
                ).
    componentID_C:pzlDomains::entityUID_D=pzlDomains::str("PzlJuniourJudgeID").
    componentAlias_C="PzlJuniourJudge".
    componentRunAble_C=b_False.
    componentVersion_C="1.0".
    componentPublicName_C="My Component".
    componentMetaInfo_C:namedValue_List=[].

end interface iPzlJuniourJudge
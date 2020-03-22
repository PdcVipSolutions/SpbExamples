/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
#requires @"JuniourJudge\PzlJuniourJudge.pack"

#include @"pfc\core.ph"

#include @"packs\logic\pzlSystem\openPzl\packs\pzlComponent\pzlComponent.ph"


% exported interfaces
#include @"JuniourJudge\PzlJuniourJudge.i"
#include @"Interfaces\PolyLineInterfaces.ph"

#if iPzlConfig::usepzlJuniourJudgeOriginal_C=true #then
% publicly used packages

% exported classes
    #include @"JuniourJudge\PzlJuniourJudge.cl"
#else
    #include @"JuniourJudge\PzlJuniourJudgeProxy.cl"
#endif

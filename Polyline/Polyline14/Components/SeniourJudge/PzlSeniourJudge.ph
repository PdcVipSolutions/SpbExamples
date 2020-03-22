/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
#requires @"SeniourJudge\PzlSeniourJudge.pack"

#include @"pfc\core.ph"

#include @"packs\logic\pzlSystem\openPzl\packs\pzlComponent\pzlComponent.ph"


% exported interfaces
#include @"SeniourJudge\PzlSeniourJudge.i"
#include @"Interfaces\PolyLineInterfaces.ph"

#if iPzlConfig::usepzlSeniourJudgeOriginal_C=true #then
% publicly used packages

% exported classes
    #include @"SeniourJudge\PzlSeniourJudge.cl"
#else
    #include @"SeniourJudge\PzlSeniourJudgeProxy.cl"
#endif

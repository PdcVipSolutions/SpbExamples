/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
#requires @"Competitors\PzlCompetitors.pack"

#include @"pfc\core.ph"

#include @"packs\logic\pzlSystem\openPzl\packs\pzlComponent\pzlComponent.ph"


% exported interfaces
#include @"Competitors\PzlCompetitors.i"
#include @"Interfaces\PolyLineInterfaces.ph"

#if iPzlConfig::usepzlCompetitorsOriginal_C=true #then
% publicly used packages

% exported classes
    #include @"Competitors\PzlCompetitors.cl"
#else
    #include @"Competitors\PzlCompetitorsProxy.cl"
#endif

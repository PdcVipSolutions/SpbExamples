/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
#requires @"GameStatistics\PzlGameStatistics.pack"

#include @"pfc\core.ph"

#include @"packs\logic\pzlSystem\openPzl\packs\pzlComponent\pzlComponent.ph"


% exported interfaces
#include @"GameStatistics\PzlGameStatistics.i"
#include @"Interfaces\PolyLineInterfaces.ph"

#if iPzlConfig::usepzlGameStatisticsOriginal_C=true #then
% publicly used packages

% exported classes
    #include @"GameStatistics\PzlGameStatistics.cl"
#else
    #include @"GameStatistics\PzlGameStatisticsProxy.cl"
#endif

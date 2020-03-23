/*****************************************************************************
Copyright (c) PDCSPB

Author: Victor Yukhtenko
******************************************************************************/
#requires @"..\components\bePzlHttp_Febe\bePzlHttp_Febe.pack"

#include @"pfc\core.ph"
#include @"packs\logic\pzlSystem\openPzl\packs\pzlComponent\pzlComponent.ph"

% exported interfaces
#include @"..\components\bePzlHttp_Febe\bePzlHttp_Febe.i"
#include @"Interfaces\logic\PzlRun.i"

#if iPzlConfig::usebePzlHttp_FebeOriginal_C=true #then
% publicly used packages
#include @"appHead\appHead.ph"
% exported classes
    #include @"..\components\bePzlHttp_Febe\bePzlHttp_Febe.cl"
#else
    #include @"..\components\bePzlHttp_Febe\bePzlHttp_FebeProxy.cl"
#endif

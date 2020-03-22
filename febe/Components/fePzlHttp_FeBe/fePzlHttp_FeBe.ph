/*****************************************************************************
Copyright (c) 2006-2016 PDCSPB

Author: Виктор Юхтенко/WIN-5L3MH3V6R7Q
******************************************************************************/
#requires @"..\Components\fePzlHttp_FeBe\fePzlHttp_Febe.pack"

#include @"pfc\core.ph"
#include @"pfc\gui\gui.ph"
#include @"packs\logic\pzlSystem\openPzl\packs\pzlComponent\pzlComponent.ph"
#include @"Interfaces\logic\PzlRun.i"

% exported interfaces
#include @"..\Components\fePzlHttp_FeBe\fePzlHttp_Febe.i"

#if iPzlConfig::usefePzlHttp_FebeOriginal_C=true #then
% publicly used packages
#include @"appHead\appHead.ph"
#include @"pfc\log\Log.ph"

% exported classes
    #include @"..\Components\fePzlHttp_FeBe\fePzlHttp_Febe.cl"
#else
    #include @"..\Components\fePzlHttp_FeBe\fePzlHttp_FebeProxy.cl"
#endif

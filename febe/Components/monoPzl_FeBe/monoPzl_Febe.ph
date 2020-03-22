/*****************************************************************************
Copyright (c) 2006-2016 PDCSPB

Author: Виктор Юхтенко/WIN-5L3MH3V6R7Q
******************************************************************************/
#requires @"..\components\monoPzl_Febe\monoPzl_Febe.pack"

#include @"pfc\core.ph"
#include @"pfc\gui\gui.ph"
#include @"packs\logic\pzlSystem\openPzl\packs\pzlComponent\pzlComponent.ph"
#include @"Interfaces\logic\PzlRun.i"

% exported interfaces
#include @"..\components\monoPzl_Febe\monoPzl_Febe.i"

#if iPzlConfig::useMonoPzl_FebeOriginal_C=true #then
% publicly used packages

% exported classes
    #include @"..\components\monoPzl_Febe\monoPzl_Febe.cl"
#else
    #include @"..\components\monoPzl_Febe\monoPzl_FebeProxy.cl"
#endif

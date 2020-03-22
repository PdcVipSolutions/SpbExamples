/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
#requires @"Players\Human\PzlHuman.pack"

#include @"pfc\core.ph"

#include @"packs\logic\pzlSystem\openPzl\packs\pzlComponent\pzlComponent.ph"
#include @"Interfaces\PolyLineInterfaces.ph"


% exported interfaces
#include @"Players\Human\PzlHuman.i"

#if iPzlConfig::usepzlHumanOriginal_C=true #then
% publicly used packages

% exported classes
    #include @"Players\Human\PzlHuman.cl"
#else
    #include @"Players\Human\PzlHumanProxy.cl"
#endif

/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
#requires @"Players\Computer1\PzlComputer1.pack"

#include @"pfc\core.ph"

#include @"packs\logic\pzlSystem\openPzl\packs\pzlComponent\pzlComponent.ph"
#include @"Interfaces\PolyLineInterfaces.ph"


% exported interfaces
#include @"Players\Computer1\PzlComputer1.i"

#if iPzlConfig::usepzlComputer1Original_C=true #then
% publicly used packages
#include @"Interfaces\PolyLineInterfaces.ph"

% exported classes
    #include @"Players\Computer1\PzlComputer1.cl"
#else
    #include @"Players\Computer1\PzlComputer1Proxy.cl"
#endif

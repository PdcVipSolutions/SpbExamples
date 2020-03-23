/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
#requires @"Players\Computer0\PzlComputer0.pack"

#include @"pfc\core.ph"

#include @"packs\logic\pzlSystem\openPzl\packs\pzlComponent\pzlComponent.ph"
#include @"Interfaces\PolyLineInterfaces.ph"

% exported interfaces
#include @"Players\Computer0\PzlComputer0.i"

#if iPzlConfig::usepzlComputer0Original_C=true #then
% publicly used packages

% exported classes
    #include @"Players\Computer0\PzlComputer0.cl"
#else
    #include @"Players\Computer0\PzlComputer0Proxy.cl"
#endif

/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
#requires @"Players\Computer2\PzlComputer2.pack"

#include @"pfc\core.ph"

#include @"packs\logic\pzlSystem\openPzl\packs\pzlComponent\pzlComponent.ph"
#include @"Interfaces\PolyLineInterfaces.ph"


% exported interfaces
#include @"Players\Computer2\PzlComputer2.i"

#if iPzlConfig::usepzlComputer2Original_C=true #then
% publicly used packages

% exported classes
    #include @"Players\Computer2\PzlComputer2.cl"
#else
    #include @"Players\Computer2\PzlComputer2Proxy.cl"
#endif

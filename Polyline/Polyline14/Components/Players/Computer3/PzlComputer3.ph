/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
#requires @"Players\Computer3\PzlComputer3.pack"

#include @"pfc\core.ph"

#include @"packs\logic\pzlSystem\openPzl\packs\pzlComponent\pzlComponent.ph"
#include @"Interfaces\PolyLineInterfaces.ph"


% exported interfaces
#include @"Players\Computer3\PzlComputer3.i"

#if iPzlConfig::usepzlComputer3Original_C=true #then
% publicly used packages

% exported classes
    #include @"Players\Computer3\PzlComputer3.cl"
#else
    #include @"Players\Computer3\PzlComputer3Proxy.cl"
#endif

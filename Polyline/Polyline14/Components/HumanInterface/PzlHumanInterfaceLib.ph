/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
#requires @"HumanInterface\PzlHumanInterface.pack"

#include @"pfc\core.ph"
#include @"packs\logic\pzlSystem\openPzl\packs\pzlComponent\pzlComponent.ph"
#include @"Interfaces\polyLineInterfaces.ph"


% exported interfaces
#include @"HumanInterface\PzlHumanInterface.i"

#if iPzlConfig::usePzlHumanInterfaceOriginal_C=true #then
% publicly used packages

% exported classes
    #include @"HumanInterface\PzlHumanInterface.cl"
#else
    #include @"HumanInterface\PzlHumanInterfaceProxy.cl"
#endif

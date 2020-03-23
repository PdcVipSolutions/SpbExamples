/*****************************************************************************
Copyright (c) Victor Yukhtenko
SpbSolutions/Examples/Polyline
******************************************************************************/
#requires @"Game\PzlGame.pack"

#include @"pfc\core.ph"

#include @"packs\logic\pzlSystem\openPzl\packs\pzlComponent\pzlComponent.ph"
#include @"Interfaces\logic\PzlRun.i"

% exported interfaces
#include @"Game\PzlGame.i"
#include @"Interfaces\polyLineInterfaces.ph"

#if iPzlConfig::usepzlGameOriginal_C=true #then
% publicly used packages

% exported classes
    #include @"Game\PzlGame.cl"
#else
    #include @"Game\PzlGameProxy.cl"
#endif

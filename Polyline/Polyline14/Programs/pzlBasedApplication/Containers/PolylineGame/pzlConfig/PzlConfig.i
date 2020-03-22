/*****************************************************************************
Copyright (c) Victor Yukhtenko
******************************************************************************/
interface iPzlConfig

constants
    pzlContainerVersion_C="1.0".

 % Container Configuration
constants
	usePzlCompetitorsOriginal_C:boolean=false.
	usePzlGameStatisticsOriginal_C:boolean=false.
	usePzlSeniourJudgeOriginal_C:boolean=false.
	usePzlJuniourJudgeOriginal_C:boolean=false.
	usePzlHumanInterfaceOriginal_C:boolean=false.
	usePzlGameOriginal_C:boolean=true.

end interface iPzlConfig

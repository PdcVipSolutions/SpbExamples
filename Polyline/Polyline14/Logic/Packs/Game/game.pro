/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement game
    open core

facts % Application Components
    seniourJudge_V:seniourJudge:=erroneous.
    juniourJudge_V:juniourJudge:=erroneous.
    humanInterface_V:humanInterface:=erroneous.
    competitors_V:competitors:=erroneous.
    gameStatistics_V:gameStatistics:=erroneous.

facts % Game Properties
    language_V:polyLineDomains::language_D:=polyLineDomains::en.

clauses
    run():-
        Game=game::new(),
        Game:play().

clauses
    new():-
        humanInterface_V:=pzlHumanInterface::new(This),
        juniourJudge_V:=pzlJuniourJudge::new(This),
        seniourJudge_V:=pzlSeniourJudge::new(This),
        competitors_V:=pzlCompetitors::new(This),
        gameStatistics_V:=pzlGameStatistics::new(This).

clauses
    play():-
        setLanguage(),
        humanInterface_V:showUI().
clauses
    complete():-
        humanInterface_V:=erroneous.

predicates
    setLanguage:().
clauses
    setLanguage():-
        CommandLine = exe_native::getCommandLine(),
        if string::hasSuffix(CommandLine,"ru",_RestRu) then
            language_V:=polyLineDomains::ru
        end if,
        if string::hasSuffix(CommandLine,"en",_RestEn) then
            language_V:=polyLineDomains::en
        end if,
        humanInterface_V:setLanguage(language_V).

end implement game


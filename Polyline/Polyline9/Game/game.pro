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

facts % Game Properties
    language_V:polyLineDomains::language_D:=polyLineDomains::en.
    multiMode_V:boolean:=false.

clauses
    new():-
        seniourJudge_V:=seniourJudge::new(This),
        juniourJudge_V:=juniourJudge::new(This),
        humanInterface_V:=humanInterface::new(This),
        competitors_V:=competitors::new(This).

clauses
    play():-
        setGameProperties(),
        if multiMode_V=false then
            seniourJudge_V:playSingle()
        else
            seniourJudge_V:playMulti()
        end if.

clauses
    run():-
        Game=game::new(),
        Game:play().

predicates
    setGameProperties:().
clauses
    setGameProperties():-
        setLanguage(),
        multiMode_V:=chooseSingleOrMultiGame(),
        juniourJudge_V:defineStage(),
        competitors_V:involvePlayers().

predicates
    chooseSingleOrMultiGame:()->boolean TrueIfMultiMode.
clauses
    chooseSingleOrMultiGame()=Choice:-
        ChoiceStr=humanInterface_V:getInput(humanInterface::singleOrMulti_S),
        if (string::equalIgnoreCase(ChoiceStr,"S") or ChoiceStr=""),! then
            Choice=false, % Single
            !
        else
            Choice=true % Multi
        end if.

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

/***************************
  Players
***************************/
facts
    players_V:player*:=[].

clauses
    addPlayer(Player):-
        players_V:=list::append(players_V,[Player]).

end implement game

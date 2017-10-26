/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline

The strategy based on solutions proposed by Elena Efimova
******************************************************************************/
implement polyLineStrategy00

open core, exception

facts
    genericComputer_V:genericComputer:=erroneous.

clauses
    setGenericComputer(GenericComputerObj):-
        genericComputer_V:=GenericComputerObj.

clauses
    getStrategyAttribute()=namedValue("none",core::none).
    setStrategyAttribute(_NamedValue).

clauses
    successfulStep(PolyLine)=BestMove:-
        BestMove=successfulStep1(PolyLine).

predicates
    successfulStep1:(polyLineDomains::cell* PolyLine)->polyLineDomains::cell.
clauses
    successfulStep1(_PolyLine)=_BestMove:-
        genericComputer_V:isInterrupted(),
        !,
        exception::raise_User("Interrupted!").
    successfulStep1(_PolyLine)=polylineDomains::c(999,999).

clauses
    randomStep()=Cell:-
        CellCandidateListWithDuplicates = [ NewCell || genericComputer_V:stepCandidate(genericComputer_V:game_V:juniourJudge_V:polyline_P, _Polyline1, NewCell) ],
        CellCandidateList=list::removeDuplicates(CellCandidateListWithDuplicates),
        not(CellCandidateList=[]),
        NoOfVariants=list::length(CellCandidateList),
        ChoiceNo=math::random(NoOfVariants-1),
        Cell=list::nth(ChoiceNo+1,CellCandidateList).

end implement polyLineStrategy00


/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline

The strategy based on solutions proposed by Elena Efimova
******************************************************************************/
implement polyLineStrategy0

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
        BestMove=successfulStep1(PolyLine),
        !.
    successfulStep(PolyLine)=SomeMove:-
        genericComputer_V:stepCandidate(PolyLine, _PolyLine1,SomeMove),
        !.

predicates
    successfulStep1:(polyLineDomains::cell* PolyLine)->polyLineDomains::cell determ.
clauses
    successfulStep1(_PolyLine)=_BestMove:-
        genericComputer_V:isInterrupted(),
        !,
        exception::raise_User("Player Interrupted!").
    successfulStep1(PolyLine)=BestMove:-
        genericComputer_V:stepCandidate(PolyLine, _PolyLine1,BestMove),
        list::isMember(BestMove, PolyLine),
        !.
    successfulStep1(PolyLine)=Cell:-
        genericComputer_V:stepCandidate(PolyLine, PolyLine1,Cell),
            not(_=successfulStep1(PolyLine1)),
            !.

clauses
    randomStep()=Cell:-
        CellCandidateListWithDuplicates = [ NewCell || genericComputer_V:stepCandidate(genericComputer_V:game_V:juniourJudge_V:polyline_P, _Polyline1, NewCell) ],
        CellCandidateList=list::removeDuplicates(CellCandidateListWithDuplicates),
        not(CellCandidateList=[]),
        NoOfVariants=list::length(CellCandidateList),
        ChoiceNo=math::random(NoOfVariants-1),
        Cell=list::nth(ChoiceNo+1,CellCandidateList).

end implement polyLineStrategy0

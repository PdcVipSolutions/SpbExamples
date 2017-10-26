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
    successfulStep(PolyLine)=BestMove:-
        BestMove=successfulStep1(PolyLine),
        !.
    successfulStep(PolyLine)=SomeMove:-
        genericComputer_V:stepCandidate(PolyLine, _PolyLine1,SomeMove),
        !.

predicates
    successfulStep1:(juniourJudge::cell* PolyLine)->juniourJudge::cell determ.
clauses
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
        CellCandidateListWithDuplicates = [ NewCell || genericComputer_V:stepCandidate(juniourJudge::polyline_P, _Polyline1, NewCell) ],
        CellCandidateList=list::removeDuplicates(CellCandidateListWithDuplicates),
        not(CellCandidateList=[]),
        NoOfVariants=list::length(CellCandidateList),
        ChoiceNo=math::random(NoOfVariants-1),
        Cell=list::nth(ChoiceNo+1,CellCandidateList).

end implement polyLineStrategy0

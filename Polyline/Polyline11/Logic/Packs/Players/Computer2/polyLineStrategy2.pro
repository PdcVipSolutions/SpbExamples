/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement polyLineStrategy2
    open core, polylineDomains

facts
    maxDepth_V:positive:=3.
    genericComputer_V:genericComputer:=erroneous.

clauses
    setGenericComputer(GenericComputerObj):-
        genericComputer_V:=GenericComputerObj.

clauses
    setStrategyAttribute(namedValue(maxDepthID_C,unsigned(Value))):-
        maxDepth_V:=tryConvert(positive,Value),
        !.
    setStrategyAttribute(_Value):-
        exception::raise_User("Wrong Attribute").

clauses
    getStrategyAttribute()=namedValue(maxDepthID_C,unsigned(convert(unsigned,maxDepth_V))).
clauses
    successfulStep(PolyLine)=BestMove:-
        BestMove=successfulStep(maxDepth_V,PolyLine).

predicates
    successfulStep: (integer Counter, polyLineDomains::cell*)->polyLineDomains::cell nondeterm.
clauses
    successfulStep(_Counter,_PolyLine)=_BestMove:-
        genericComputer_V:isInterrupted(),
        !,
        exception::raise_User("Player Interrupted").
    successfulStep(Counter,PolyLine)=BestMove:-
        genericComputer_V:stepCandidate(PolyLine,_PolyLine1,BestMove),
        isStepSuccessful(Counter,PolyLine,BestMove),
        !.
    successfulStep(Counter,PolyLine)=Cell:-
        genericComputer_V:stepCandidate(PolyLine, PolyLine1,Cell),
            not(_=successfulStep(Counter-1,PolyLine1)).

class predicates
    isStepSuccessful:(integer Counter,polyLineDomains::cell* PolyLine,polyLineDomains::cell BestMove) determ.
clauses
    isStepSuccessful(_Counter,PolyLine,BestMove):-
        list::isMember(BestMove, PolyLine),
        !.
    isStepSuccessful(Counter,_PolyLine,_BestMove):-
        Counter<=1.

clauses
    randomStep()=Cell:-
        CellCandidateListWithDuplicates = [ NewCell || genericComputer_V:stepCandidate(genericComputer_V:game_V:juniourJudge_V:polyline_P, _Polyline1, NewCell) ],
        CellCandidateList=list::removeDuplicates(CellCandidateListWithDuplicates),
        not(CellCandidateList=[]),
        NoOfVariants=list::length(CellCandidateList),
        ChoiceNo=math::random(NoOfVariants-1),
        Cell=list::nth(ChoiceNo+1,CellCandidateList).

end implement polyLineStrategy2

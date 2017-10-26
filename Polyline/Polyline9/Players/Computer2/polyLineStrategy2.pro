/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/

implement polyLineStrategy2
    open core

facts
    maxDepth_V:positive:=5.
    genericComputer_V:genericComputer:=erroneous.

clauses
    setGenericComputer(GenericComputerObj):-
        genericComputer_V:=GenericComputerObj,
        defineSearchDepth().

predicates
    defineSearchDepth:().
clauses
    defineSearchDepth():-
        DepthStr=genericComputer_V:game_V:humanInterface_V:getInput(humanInterface::searchDepth_S,toString(maxDepth_V)),
        not(DepthStr=""),
        !,
        try
            maxDepth_V:=toTerm(DepthStr),
            if maxDepth_V mod 2 = 0 then
                maxDepth_V:=maxDepth_V+1
            end if
        catch _TraceID1 do
            genericComputer_V:game_V:humanInterface_V:announce(humanInterface::errorMustBeNumber_S,""),
            defineSearchDepth()
        end try.
    defineSearchDepth().

clauses
    successfulStep(PolyLine)=BestMove:-
        BestMove=successfulStep(maxDepth_V,PolyLine).


predicates
    successfulStep: (integer Counter, polyLineDomains::cell*)->polyLineDomains::cell nondeterm.
clauses
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

/*

predicates
    successfulStep: (positive Depth, polyLineDomains::cell*)->polyLineDomains::cell BestMove determ.
clauses
    successfulStep(Depth,PolyLine)=SafeMove:-
        genericComputer_V:stepCandidate(PolyLine,PolyLine1,SafeMove),
            isSafeMove(Depth,PolyLine,SafeMove,PolyLine1),
            !.

predicates
    isSafeMove:(positive Depth,polyLineDomains::cell* PolyLine,polyLineDomains::cell Move,polyLineDomains::cell* PolyLineAfterMove) determ.
clauses
    isSafeMove(_Depth,PolyLine,Move,_PolyLine1):-  %this move wins
        list::isMember(Move, PolyLine),
        !.
    isSafeMove(Depth,_PolyLine,_Move,_PolyLine1):-  %it is safe until that depth
        Depth>=maxDepth_V,
        !.
    isSafeMove(Depth,_PolyLine,_MoveIn,PolyLine1):-  %it is not loss move till the end of the depth limit
        not(_MoveOut=successfulStep(Depth+1,PolyLine1)).
*/

clauses
    randomStep()=Cell:-
        CellCandidateListWithDuplicates = [ NewCell || genericComputer_V:stepCandidate(genericComputer_V:game_V:juniourJudge_V:polyline_P, _Polyline1, NewCell) ],
        CellCandidateList=list::removeDuplicates(CellCandidateListWithDuplicates),
        not(CellCandidateList=[]),
        NoOfVariants=list::length(CellCandidateList),
        ChoiceNo=math::random(NoOfVariants-1),
        Cell=list::nth(ChoiceNo+1,CellCandidateList).

end implement polyLineStrategy2

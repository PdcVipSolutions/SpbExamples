/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement polyLineStrategy3
    open core, exception, polylineDomains

facts
    maxDepth_V:positive:=3.
    genericComputer_V:genericComputer:=erroneous.

clauses
    setGenericComputer(GenericComputerObj):-
        genericComputer_V:=GenericComputerObj.

clauses
    setStrategyAttribute(namedValue("MaxDepth",unsigned(Value))):-
        maxDepth_V:=tryConvert(positive,Value),
        !.
    setStrategyAttribute(_Value):-
        exception::raise_User("Wrong Attribute Exception").

clauses
    getStrategyAttribute()=namedValue("MaxDepth",unsigned(convert(unsigned,maxDepth_V))).

domains
    move_D=move(polyLineDomains::cell,positive).

clauses
    successfulStep(PolyLine)=BestMove:-
        successfulStep(1,PolyLine,BestMove,_Estimate).

predicates
    successfulStep: (positive Depth, polyLineDomains::cell*,polyLineDomains::cell BestMove [out],positive Estimate [out]) determ.
clauses
    successfulStep(_Depth,_PolyLine,_SafeMove,_Result):-
        genericComputer_V:isInterrupted(),
        !,
        exception::raise_User("Player Interrupted!").
    successfulStep(Depth,PolyLine,SafeMove,Result):-
        genericComputer_V:stepCandidate(PolyLine,PolyLine1,SafeMove),
            Result=isSafeMove(Depth,PolyLine,SafeMove,PolyLine1),
            !.
    successfulStep(Depth,PolyLine,BestMove,BestMoveEstimate):-
        PrognosisList = [ move(MoveCandidate, Estimate) || genericComputer_V:stepCandidate(PolyLine, PolyLine1, MoveCandidate),
        successfulStep(Depth + 1, PolyLine1, _BestMove, Estimate) ],
            ListLength=list::length(PrognosisList),
            ListLength>=1,
            move(BestMove,BestMoveEstimate)=list::maximumBy(compairMoveCandidate,PrognosisList).

class predicates
    compairMoveCandidate:comparator{move_D Element}.
clauses
    compairMoveCandidate(move(_Cell1,Depth1),move(_Cell2,Depth2))=Result:-
        if
            Depth1>Depth2
        then
            Result=greater
        else
            if Depth1<Depth2 then
                Result=less
            else
                Result=equal
            end if
        end if.

predicates
    isSafeMove:(positive Depth,polyLineDomains::cell* PolyLine,polyLineDomains::cell Move,polyLineDomains::cell* PolyLineAfterMove)->positive determ.
clauses
    isSafeMove(Depth,PolyLine,Move,_PolyLine1)=Depth:-  %this move wins
        list::isMember(Move, PolyLine),
        !.
    isSafeMove(Depth,_PolyLine,_Move,_PolyLine1)=Depth:-  %it is safe until that depth
        Depth>maxDepth_V+1,
        !.
    isSafeMove(Depth,_PolyLine,_MoveIn,PolyLine1)=Depth:-  %it is not loss move till the end of the depth limit
        not(successfulStep(Depth+1,PolyLine1,_MoveOut,_MoveQuality)).

clauses
    randomStep()=Cell:-
        CellCandidateListWithDuplicates = [ NewCell || genericComputer_V:stepCandidate(genericComputer_V:game_V:juniourJudge_V:polyline_P, _Polyline1, NewCell) ],
        CellCandidateList=list::removeDuplicates(CellCandidateListWithDuplicates),
        not(CellCandidateList=[]),
        NoOfVariants=list::length(CellCandidateList),
        ChoiceNo=math::random(NoOfVariants-1),
        Cell=list::nth(ChoiceNo+1,CellCandidateList).

end implement polyLineStrategy3

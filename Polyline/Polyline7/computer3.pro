/***************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
***************************************************************/
class computer3:player
open core

predicates
    getPlayerDescriptor:(game::language_D)->string Descriptor.

end class computer3
 
implement computer3
    inherits genericComputer
open core
 
clauses
    new():-
        PolyLineBraneObj=polylineStrategy3::new(),
        setpolylineStrategy(PolyLineBraneObj).

clauses
   getPlayerDescriptor(game::en)=polylineStrategy3::playerDescriptorEn_C.
   getPlayerDescriptor(game::ru)=polylineStrategy3::playerDescriptorRu_C.

end implement computer3
 
/******************************************
  Class polylineStrategy3
******************************************/
class polylineStrategy3:polylineStrategy
open core
predicates
    classInfo : core::classInfo.

constants
    playerDescriptorRu_C="Computer3: Минимизация риска. Глубина ограничена. Ход отчаяния - случайный".
    playerDescriptorEn_C="Computer3 Minimized risk.  Restricted Depth. Despair move - random".

end class polylineStrategy3

implement polylineStrategy3
open core, exception

constants
    className = "polylineStrategy3".
    classVersion = "1.0".

clauses
    classInfo(className, classVersion).

facts
    maxDepth_V:positive:=5.
    genericComputer_V:genericComputer:=erroneous.

clauses
    new():-
        defineSearchDepth().

clauses
    setGenericComputer(GenericComputerObj):-
        genericComputer_V:=GenericComputerObj.

predicates
    defineSearchDepth:().
clauses
    defineSearchDepth():-
        DepthStr=humanInterface::getInput(humanInterface::searchDepth_S,toString(maxDepth_V)),
        not(DepthStr=""),
        !,
        try
            maxDepth_V:=toTerm(DepthStr),
            if maxDepth_V div 2 = 0 then
                maxDepth_V:=maxDepth_V+1
            end if    
        catch _TraceID1 do
            humanInterface::announce(humanInterface::errorMustBeNumber_S,""),
            defineSearchDepth()
        end try.
    defineSearchDepth().

domains
    move_D=move(juniourJudge::cell,positive).

clauses
    successfulStep(PolyLine)=BestMove:-
        successfulStep(1,PolyLine,BestMove,_Estimate).

predicates
    successfulStep: (positive Depth, juniourJudge::cell*,juniourJudge::cell BestMove [out],positive Estimate [out]) determ.
clauses
    successfulStep(Depth,PolyLine,SafeMove,Result):-
        genericComputer_V:stepCandidate(PolyLine,PolyLine1,SafeMove),
            Result=isSafeMove(Depth,PolyLine,SafeMove,PolyLine1),
            !.
    successfulStep(Depth,PolyLine,BestMove,BestMoveEstimate):-
        findAll
            (
            move(MoveCandidate,Estimate),
            (
            genericComputer_V:stepCandidate(PolyLine,PolyLine1,MoveCandidate),
                successfulStep(Depth+1,PolyLine1,_BestMove,Estimate)
            ),
            PrognosisList
            ),
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
    isSafeMove:(positive Depth,juniourJudge::cell* PolyLine,juniourJudge::cell Move,juniourJudge::cell* PolyLineAfterMove)->positive determ.
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
        findAll(NewCell,genericComputer_V:stepCandidate(juniourJudge::polyline_P,_Polyline1, NewCell),CellCandidateListWithDuplicates),
        CellCandidateList=list::removeDuplicates(CellCandidateListWithDuplicates),
        not(CellCandidateList=[]),
        NoOfVariants=list::length(CellCandidateList),
        ChoiceNo=math::random(NoOfVariants-1),
        Cell=list::nth(ChoiceNo+1,CellCandidateList).

end implement polylineStrategy3

/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement competitors
    open core

facts
    game_V:game:=erroneous.

clauses
    new(GameObj):-
        game_V:=convert(game,GameObj).

clauses
    getCandidates()=PlayerDescriptorList:-
        PlayerDescriptorList = [ PlayerDescriptor || playerShortDescriptor(PlayerDescriptor) ].

/***************************
  Players
***************************/
facts
    players_V:player*:=[].

clauses
    addPlayer(Player):-
        players_V:=list::append(players_V,[Player]),
        game_V:seniourJudge_V:subscribe(Player:onNotification),
        Player:subscribe(game_V:juniourJudge_V:onMoveDone),
        Player:setHumanInterface(game_V:humanInterface_V).

clauses
   removePlayer(PlayerIndex):-
        list::split(PlayerIndex, players_V, LeftList, RightList),
        RightList=[IndexedPlayer|Tail],
        !,
        players_V:= list::append(LeftList, Tail),
        game_V:seniourJudge_V:unsubscribe(IndexedPlayer:onNotification),
        IndexedPlayer:unsubscribe(game_V:juniourJudge_V:onMoveDone),
        try % starter_V (at seniourJudge_V) may be erroneous and we can not check it here, just the exception signals
            Starter=game_V:seniourJudge_V:starter_V,
            if Starter=IndexedPlayer then
                game_V:seniourJudge_V:resetStarter()
            end if
        catch _TraceID do
            succeed
        end try.
   removePlayer(_PlayerIndex).

clauses
    shiftPlayer(PlayerIndex,polyLineDomains::up):-
        PlayerIndex>0,
        list::split(PlayerIndex-1, players_V, LeftList, RightList),
        RightList=[PreviousPlayer,IndexedPlayer|Tail],
        !,
        players_V:= list::append(LeftList,[IndexedPlayer,PreviousPlayer|Tail]).
   shiftPlayer(PlayerIndex,polyLineDomains::down):-
        list::split(PlayerIndex, players_V, LeftList, RightList),
        RightList=[IndexedPlayer,NextPlayer|Tail],
        !,
        players_V:= list::append(LeftList,[NextPlayer,IndexedPlayer|Tail]).
   shiftPlayer(_PlayerIndex,_Direction).

clauses
    isNameUnique(Name):-
        Player=list::getMember_nd(players_V),
        Player:name=Name,
        !,
        fail.
    isNameUnique(_Any).

clauses
    isNameUnique(PlayerObject,Name):-
        Player=list::getMember_nd(players_V),
        not(Player=PlayerObject),
        Player:name=Name,
        !,
        fail.
    isNameUnique(_PlayerObject,_Any).

clauses
    isLegendUnique(Legend):-
        Player=list::getMember_nd(players_V),
        Player:legend_V=Legend,
        !,
        fail.
    isLegendUnique(_Any).

clauses
    isLegendUnique(PlayerObject,Legend):-
        Player=list::getMember_nd(players_V),
        not(Player=PlayerObject),
        Player:legend_V=Legend,
        !,
        fail.
    isLegendUnique(_PlayerObject,_Any).

clauses
    stopPlayers():-
        Player=list::getMember_nd(players_V),
            Player:stopGame(),
        fail.
    stopPlayers().

predicates
    playerShortDescriptor:(namedValue PlayerDescriptorSrc [out]) multi.
clauses
    playerShortDescriptor(ModelTitle):-
            try
                ModelName=human::getPlayerShortDescriptor(game_V:language_V),
                ModelTitle=namedValue(ModelName,string(ModelName))
            catch _TraceID do
                ModelTitle=namedValue(playersDefinitions::human_C,string(string::concat(playersDefinitions::human_C,":invalid")))
            end try.
    playerShortDescriptor(ModelTitle):-
            try
                ModelName=computer0::getModelTitle(game_V:language_V),
                ModelTitle=namedValue(ModelName,string(ModelName))
            catch _TraceID do
                ModelTitle=namedValue(playersDefinitions::computer0_C,string(string::concat(playersDefinitions::computer0_C,": invalid")))
            end try.
    playerShortDescriptor(ModelTitle):-
            try
                ModelName=computer1::getModelTitle(game_V:language_V),
                ModelTitle=namedValue(ModelName,string(ModelName))
            catch _TraceID do
                ModelTitle=namedValue(playersDefinitions::computer1_C,string(string::concat(playersDefinitions::computer1_C,": invalid")))
            end try.
    playerShortDescriptor(ModelTitle):-
            try
                ModelName=computer2::getModelTitle(game_V:language_V),
                ModelTitle=namedValue(ModelName,string(ModelName))
            catch _TraceID do
                ModelTitle=namedValue(playersDefinitions::computer2_C,string(string::concat(playersDefinitions::computer2_C,": invalid")))
            end try.
    playerShortDescriptor(ModelTitle):-
            try
                ModelName=computer3::getModelTitle(game_V:language_V),
                ModelTitle=namedValue(ModelName,string(ModelName))
            catch _TraceID do
                ModelTitle=namedValue(playersDefinitions::computer3_C,string(string::concat(playersDefinitions::computer3_C,": invalid")))
            end try.

clauses
    createPlayerObject(ModelTitle)=Player:-
        try
        	ModelTitle = human::getPlayerShortDescriptor(game_V:language_V)
        catch _TraceID do
        	fail
        end try,
        !,
        Player=human::new(game_V).
    createPlayerObject(ModelTitle)=Player:-
        try
        	ModelTitle = computer0::getModelTitle(game_V:language_V)
        catch _TraceID do
        	fail
        end try,
        !,
        Player=computer0::new(game_V).
    createPlayerObject(ModelTitle)=Player:-
        try
        	ModelTitle = computer1::getModelTitle(game_V:language_V)
        catch _TraceID do
        	fail
        end try,
        !,
        Player=computer1::new(game_V).
    createPlayerObject(ModelTitle)=Player:-
        try
        	ModelTitle = computer2::getModelTitle(game_V:language_V)
        catch _TraceID do
        	fail
        end try,
        !,
        Player=computer2::new(game_V).
    createPlayerObject(ModelTitle)=Player:-
        try
        	ModelTitle = computer3::getModelTitle(game_V:language_V)
        catch _TraceID do
        	fail
        end try,
        !,
        Player=computer3::new(game_V).
    createPlayerObject(playersDefinitions::human_C)=Player:-
        _ModelTitle=human::getPlayerShortDescriptor(game_V:language_V),
        !,
        Player=human::new(game_V).
    createPlayerObject(playersDefinitions::computer0_C)=Player:-
        _ModelTitle=computer0::getModelTitle(game_V:language_V),
        !,
        Player=computer0::new(game_V).
    createPlayerObject(playersDefinitions::computer1_C)=Player:-
        _ModelTitle=computer1::getModelTitle(game_V:language_V),
        !,
        Player=computer1::new(game_V).
    createPlayerObject(playersDefinitions::computer2_C)=Player:-
        _ModelTitle=computer2::getModelTitle(game_V:language_V),
        !,
        Player=computer2::new(game_V).
    createPlayerObject(playersDefinitions::computer3_C)=Player:-
        _ModelTitle=computer3::getModelTitle(game_V:language_V),
        !,
        Player=computer3::new(game_V).
    createPlayerObject(ModelTitle)=_Player:-
        exception::raise_User("Wrong Player Index Exception!",[namedValue("ModelTitle",string(ModelTitle))]).

end implement competitors

interface playersDefinitions
open core
constants
    playersDll_C="..\\DLL\\ModelsDll".
    computer3Dll_C="..\\DLL\\Computer3Dll".
    human_C="Human".
    computer0_C="computer0".
    computer1_C="computer1".
    computer2_C="computer2".
    computer3_C="computer3".
    computer0TitleOrdinal_C:core::unsigned16=1.
    computer1TitleOrdinal_C:core::unsigned16=2.
    computer2TitleOrdinal_C:unsigned16=3.
end interface playersDefinitions

/*******************
Class dllHandlingExceptions
*******************/
class dllHandlingExceptions
open core

predicates
    handleNoDll_Exception:(exception::traceID TraceID,string CallingPredicate,string DllFileName) erroneous.
    handleNoPredicate_Exception:(exception::traceID TraceID,string CallingPredicate,string DllFileName,string DllPredicateName) erroneous.
    handleNoPredicateOrdinal_Exception:(exception::traceID TraceID,string CallingPredicate,string DllFileName,string DllPredicateName,unsigned16 Ordinal) erroneous.
    handleNoPredicateClass_Exception:(exception::traceID TraceID,string CallingPredicate,string DllFileName,string DllPredicateName) erroneous.
    handleNoPredicateClassOrdinal_Exception:(exception::traceID TraceID,string CallingPredicate,string DllFileName,string DllPredicateName,unsigned16 Ordinal) erroneous.
    invalidCallingConvention_Exception:(exception::traceID TraceID,string CallingPredicate,string DllFileName,string DllPredicateName) erroneous.

end class dllHandlingExceptions

implement dllHandlingExceptions
open core

clauses
    handleNoDll_Exception(TraceID,PredicateName,DllFileName):-
        exception::continue_user(TraceID,askedDllNotFound_Exception_C,[namedValue("callingPredicate",string(PredicateName)),namedValue("DllFileName",string(DllFileName))]).
    handleNoPredicate_Exception(TraceID,PredicateName,DllFileName,DllPredicateName):-
        exception::continue_user(TraceID,askedPredicateNotFound_Exception_C,[namedValue("callingPredicate",string(PredicateName)),namedValue("DllFileName",string(DllFileName)),namedValue("DllPredicateName",string(DllPredicateName))]).
    handleNoPredicateOrdinal_Exception(TraceID,PredicateName,DllFileName,DllPredicateName,Ordinal):-
        exception::continue_user(TraceID,askedPredicateOrdinalNotFound_Exception_C,[namedValue("callingPredicate",string(PredicateName)),namedValue("DllFileName",string(DllFileName)),namedValue("DllPredicateName",string(DllPredicateName)),namedValue("Ordinal",unsigned(Ordinal))]).
    handleNoPredicateClass_Exception(TraceID,PredicateName,DllFileName,DllPredicateName):-
        exception::continue_user(TraceID,askedClassPredicateNotFound_Exception_C,[namedValue("callingPredicate",string(PredicateName)),namedValue("DllFileName",string(DllFileName)),namedValue("DllPredicateName",string(DllPredicateName))]).
    handleNoPredicateClassOrdinal_Exception(TraceID,PredicateName,DllFileName,DllPredicateName,Ordinal):-
        exception::continue_user(TraceID,askedClassPredicateOrdinalNotFound_Exception_C,[namedValue("callingPredicate",string(PredicateName)),namedValue("DllFileName",string(DllFileName)),namedValue("DllPredicateName",string(DllPredicateName)),namedValue("Ordinal",unsigned(Ordinal))]).
    invalidCallingConvention_Exception(TraceID,PredicateName,DllFileName,DllPredicateName):-
        exception::continue_user(TraceID,invalidCallingConvention_Exception_C,[namedValue("callingPredicate",string(PredicateName)),namedValue("DllFileName",string(DllFileName)),namedValue("DllPredicateName",string(DllPredicateName))]).

constants
    askedDllNotFound_Exception_C="The Dll containing the player model not found.".
    askedPredicateNotFound_Exception_C="The technical error: The Asked Predicate Not Found".
    askedPredicateOrdinalNotFound_Exception_C="The technical error: Asked Predicate Ordinal Not Found".
    askedClassPredicateNotFound_Exception_C="The technical error: Asked Class PredicateNot Found".
    askedClassPredicateOrdinalNotFound_Exception_C="The technical error: Asked Class Predicate Ordinal Not Found".
    invalidCallingConvention_Exception_C="The technical error: Invalid Calling Convention".

end implement dllHandlingExceptions

/**************
Class Computer0
**************/
class computer0
    open core

predicates
    new : (game) -> player Computer0Player.
    getModelTitle:(polyLineDomains::language_D)->string ModelTitle.

end class computer0

implement computer0
open core

domains
    newPlayer = (game) -> player language stdcall.
    getModelTitle = (polyLineDomains::language_D)->string GetModelTitle language stdcall.
clauses
    new(Game)=Player:-
        try
        	DllObjectHandle = useDll::load(playersDefinitions::playersDll_C)
        catch TraceID1 do
        	dllHandlingExceptions::handleNoDll_Exception(TraceID1, predicate_Name(), playersDefinitions::playersDll_C)
        end try,
        try
        	Computer0PredicateHandle = DllObjectHandle:getPredicateHandle(playersDefinitions::computer0_C)
        catch TraceID2 do
        	dllHandlingExceptions::handleNoPredicate_Exception(TraceID2, predicate_Name(), playersDefinitions::playersDll_C, playersDefinitions::computer0_C)
        end try,
        NewPlayer=uncheckedConvert(newPlayer,Computer0PredicateHandle),
        try
        	Player = NewPlayer(Game)
        catch TraceID3 do
        	dllHandlingExceptions::invalidCallingConvention_Exception(TraceID3, predicate_Name(), playersDefinitions::playersDll_C,
            playersDefinitions::computer0_C)
        end try.

    getModelTitle(Language)=ModelTitle:-
        try
            DllObjectHandle=useDll::load(playersDefinitions::playersDll_C)
        catch TraceID1 do
            dllHandlingExceptions::handleNoDll_Exception(TraceID1,predicate_Name(),playersDefinitions::playersDll_C)
        end try,
        try
            GetModelTitleHandle=DllObjectHandle:getPredicateHandle_ordinal(playersDefinitions::computer0TitleOrdinal_C)
        catch TraceID2 do
            dllHandlingExceptions::handleNoPredicateOrdinal_Exception(TraceID2,predicate_Name(),playersDefinitions::playersDll_C,playersDefinitions::computer0_C,playersDefinitions::computer0TitleOrdinal_C)
        end try,
        try
            (
            GetModelTitle=uncheckedConvert(getModelTitle,GetModelTitleHandle),
            ModelTitle=GetModelTitle(Language)
            )
        catch TraceID3 do
            dllHandlingExceptions::invalidCallingConvention_Exception(TraceID3,predicate_Name(),playersDefinitions::playersDll_C,playersDefinitions::computer0_C)
        end try.
end implement computer0

/**************
Class Computer1
**************/
class computer1
    open core

predicates
    new : (game) -> player Computer1Player.
    getModelTitle:(polyLineDomains::language_D)->string ModelTitle.

end class computer1

implement computer1
    open core

domains
    newPlayer = (game) -> player.
    getModelTitle = (polyLineDomains::language_D)->string ShortDescription.
clauses
    new(Game)=Player:-
        try
        	DllObjectHandle = useDll::load(playersDefinitions::playersDll_C)
        catch TraceID1 do
        	dllHandlingExceptions::handleNoDll_Exception(TraceID1, predicate_Name(), playersDefinitions::playersDll_C)
        end try,
        try
        	Computer0NewHandle = DllObjectHandle:getPredicateClassHandle(playersDefinitions::computer1_C)
        catch TraceID2 do
        	dllHandlingExceptions::handleNoPredicate_Exception(TraceID2, predicate_Name(), playersDefinitions::playersDll_C, playersDefinitions::computer1_C)
        end try,
        NewPlayer=uncheckedConvert(newPlayer,Computer0NewHandle),
        try
        	Player = NewPlayer(Game)
        catch TraceID3 do
        	dllHandlingExceptions::invalidCallingConvention_Exception(TraceID3, predicate_Name(), playersDefinitions::playersDll_C,
            playersDefinitions::computer1_C)
        end try.

    getModelTitle(Language)=ModelTitle:-
        try
        	DllObjectHandle = useDll::load(playersDefinitions::playersDll_C)
        catch TraceID1 do
        	dllHandlingExceptions::handleNoDll_Exception(TraceID1, predicate_Name(), playersDefinitions::playersDll_C)
        end try,
        try
        	GetGetModelTitleHandle = DllObjectHandle:getPredicateClassHandle_ordinal(playersDefinitions::computer1TitleOrdinal_C)
        catch TraceID2 do
        	dllHandlingExceptions::handleNoPredicateOrdinal_Exception(TraceID2, predicate_Name(), playersDefinitions::playersDll_C,
            playersDefinitions::computer1_C, playersDefinitions::computer1TitleOrdinal_C)
        end try,
        GetModelTitle=uncheckedConvert(getModelTitle,GetGetModelTitleHandle),
        try
        	ModelTitle = GetModelTitle(Language)
        catch TraceID3 do
        	dllHandlingExceptions::invalidCallingConvention_Exception(TraceID3, predicate_Name(), playersDefinitions::playersDll_C,
            playersDefinitions::computer1_C)
        end try.
end implement computer1

/**************
Class Computer2
**************/
class computer2
    open core
predicates
    new : (game) -> player Computer2Player procedure (i) language prolog as playersDefinitions::computer2_C.
    getModelTitle:(polyLineDomains::language_D)->string ModelTitle  procedure (i) language prolog as "modelTitle2".
end class computer2
implement computer2
    resolve new externally from playersDefinitions::playersDll_C
    resolve getModelTitle externally from playersDefinitions::playersDll_C
end implement computer2

/**************
Class Computer3
**************/
class computer3
    open core
predicates
    new : (game) -> player Computer3Player procedure (i) language stdcall as playersDefinitions::computer3_C.
    getModelTitle:(polyLineDomains::language_D)->string ModelTitle  procedure (i) language stdcall as "modelTitle3".
end class computer3
implement computer3
    resolve new externally from playersDefinitions::computer3Dll_C
    resolve getModelTitle externally from playersDefinitions::computer3Dll_C
end implement computer3

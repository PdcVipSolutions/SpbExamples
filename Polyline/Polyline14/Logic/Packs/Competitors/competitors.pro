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
        PlayerDescriptorListSrc = [ PlayerDescriptor || playerShortDescriptor(PlayerDescriptor) ],
        PlayerDescriptorList = list::removeDuplicates(PlayerDescriptorListSrc).

/***************************
  Players
***************************/
facts
    players_V:player*:=[].

clauses
    addPlayer(Player):-
        players_V:=list::append(players_V,[Player]),
        game_V:seniourJudge_V:subscribe(Player:onNotification),
        Player:subscribe(game_V:juniourJudge_V:onMoveDone).

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
    playerShortDescriptor:(namedValue PlayerDescriptorSrc [out]) nondeterm.
clauses
    playerShortDescriptor(Name):-
        ContentList=pzl::getContainerContentList("pzlPort"),
        extractName(ContentList)=Name.
    playerShortDescriptor(Name):-
        DirectoryCandidateOne=@"..\..\SpbExamples\Polyline\Polyline14\Programs\pzlBasedApplication\PZL",
        DirectoryCandidateTwo=@"..\Polyline14\Programs\pzlBasedApplication\PZL",
        DirectoryCandidateThree=@"..\..\Polyline\Polyline14\Programs\pzlBasedApplication\PZL",
        if directory::existExactDirectory(DirectoryCandidateOne) then
            Directory=DirectoryCandidateOne
        elseif directory::existExactDirectory(DirectoryCandidateTwo) then
            Directory=DirectoryCandidateTwo
        else
            Directory=DirectoryCandidateThree
        end if,
        CurrentDir=directory::getCurrentDirectory(),
        ReducedFileName=directory::getFilesInDirectoryAndSub_nd(Directory,"*.pzl"),
            FullFileName=fileName::createPath(CurrentDir,ReducedFileName),
            ContentList=pzl::getContainerContentList(FullFileName),
            extractName(ContentList)=Name.

predicates
    extractName:(pzlDomains::pzlContainerContentInfo_D ContentList)->namedValue nondeterm.
clauses
    extractName(ContentList)=namedValue(Alias,string(Title)):-
        Content=list::getMember_nd(ContentList),
            Content=pzlDomains::pzlComponentInfo(Alias,_ComponentID,_Runable,UserDefinedInfo),
            "player" = namedValue::tryGetNamed_string(UserDefinedInfo,"type"),
            Title = namedValue::tryGetNamed_string(UserDefinedInfo,"title").

clauses
    createPlayerObject(Name)=convert(player,Player):-
            Player = pzl::newByName(Name,game_V)
.

end implement competitors


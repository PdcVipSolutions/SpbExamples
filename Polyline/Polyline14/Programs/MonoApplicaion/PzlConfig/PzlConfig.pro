/*****************************************************************************
Copyright (c) Victor Yukhtenko
******************************************************************************/
implement pzlConfig

clauses
    init().

clauses
    getContainerVersion()=iPzlConfig::pzlContainerVersion_C.

clauses
    getComponentIDInfo()=
        [
		iPzlSeniourJudge::componentDescriptor_C,
		iPzlGameStatistics::componentDescriptor_C,
		iPzlCompetitors::componentDescriptor_C,
		iPzlComputer3::componentDescriptor_C,
		iPzlComputer2::componentDescriptor_C,
		iPzlComputer1::componentDescriptor_C,
		iPzlComputer0::componentDescriptor_C,
		iPzlHuman::componentDescriptor_C,
		iPzlJuniourJudge::componentDescriptor_C,
		iPzlHumanInterface::componentDescriptor_C,
		iPzlGame::componentDescriptor_C
        ].

% put here ONLY clauses related to the visible pzlComponents implemented  into this pzlContainer.
clauses
	new(iPzlSeniourJudge::componentID_C,Container)=Object:-
		!,
		Object = pzlSeniourJudge::new(Container).
	new(iPzlGameStatistics::componentID_C,Container)=Object:-
		!,
		Object = pzlGameStatistics::new(Container).
	new(iPzlCompetitors::componentID_C,Container)=Object:-
		!,
		Object = pzlCompetitors::new(Container).
	new(iPzlComputer3::componentID_C,Container)=Object:-
		!,
		Object = pzlComputer3::new(Container).
	new(iPzlComputer2::componentID_C,Container)=Object:-
		!,
		Object = pzlComputer2::new(Container).
	new(iPzlComputer1::componentID_C,Container)=Object:-
		!,
		Object = pzlComputer1::new(Container).
	new(iPzlComputer0::componentID_C,Container)=Object:-
		!,
		Object = pzlComputer0::new(Container).
	new(iPzlHuman::componentID_C,Container)=Object:-
		!,
		Object = pzlHuman::new(Container).
	new(iPzlJuniourJudge::componentID_C,Container)=Object:-
		!,
		Object = pzlJuniourJudge::new(Container).
	new(iPzlHumanInterface::componentID_C,Container)=Object:-
		!,
		Object = pzlHumanInterface::new(Container).
	new(iPzlGame::componentID_C,Container)=Object:-
		!,
		Object = pzlGame::new(Container).
    new(ClassUID,_Container)=pzlDomains::nullObject_C:-
        if not(ClassUID=pzlDomains::str("DummyX")) then
            MSG=string::format("The pzlComponent \"%\" is not supported in the pzlContainer \"%\", ver. \"%\"",ClassUID,pzl::getContainerName(),getContainerVersion()),
            exception::raise_User(Msg)
        end if.

end implement pzlConfig

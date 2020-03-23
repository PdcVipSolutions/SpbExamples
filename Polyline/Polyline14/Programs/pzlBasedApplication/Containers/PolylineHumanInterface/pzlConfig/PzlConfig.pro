﻿/*****************************************************************************
Copyright (c) Victor Yukhtenko
******************************************************************************/
implement pzlConfig

clauses
    init():-
        vpi::init().

clauses
    getContainerVersion()=iPzlConfig::pzlContainerVersion_C.

clauses
    getComponentIDInfo()=
        [
		iPzlHumanInterface::componentDescriptor_C
        ].

% put here ONLY clauses related to the visible pzlComponents implemented  into this pzlContainer.
clauses
	new(iPzlHumanInterface::componentID_C,Container)=Object:-
		!,
		Object = pzlHumanInterface::new(Container).
    new(ClassUID,_Container)=pzlDomains::nullObject_C:-
        if not(ClassUID=pzlDomains::str("DummyX")) then
            MSG=string::format("The pzlComponent \"%\" is not supported in the pzlContainer \"%\", ver. \"%\"",ClassUID,pzl::getContainerName(),getContainerVersion()),
            exception::raise_User(Msg)
        end if.

end implement pzlConfig

﻿/*****************************************************************************
                                        Visual Prolog PuZzLe Studio
                        Copyright (c) 2003-2004, Prolog Development Center Spb Ltd.

Created by: Visual Prolog PuZzLe Studio

Container: Copyright (c) 2008, Prolog Development Center SPb Ltd
Used by: Victor Yukhtenko
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
		iPzlWinTimerContainer::componentDescriptor_C
        ].

% put here ONLY clauses related to the visible pzlComponents implemented  into this pzlContainer.
clauses
	new(iPzlWinTimerContainer::componentID_C,Container)=Object:-
		!,
		Object = pzlWinTimerContainer::new(Container).
    new(ClassUID,_Container)=pzlDomains::nullObject_C:-
        if not(ClassUID=pzlDomains::str("DummyX")) then
            MSG=string::format("The pzlComponent \"%\" is not supported in the pzlContainer \"%\", ver. \"%\"",ClassUID,pzl::getContainerName(),getContainerVersion()),
            exception::raise_User(Msg)
        end if.

end implement pzlConfig

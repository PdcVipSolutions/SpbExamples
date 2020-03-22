/*****************************************************************************

 Studio
Copyright (c) Victor Yukhtenko

Created by: Visual Prolog PuZzLe Studio

Container:
Copyright (c) Victor Yukhtenko
Used by: Victor Yukhtenko
******************************************************************************/
implement pzlConfig

clauses
    init().

clauses
    getContainerVersion()=iPzlConfig::pzlContainerVersion_C.

clauses
    getComponentIDInfo()=
        [
		iPzlHuman::componentDescriptor_C,
		iPzlComputer2::componentDescriptor_C,
		iPzlComputer1::componentDescriptor_C,
		iPzlComputer0::componentDescriptor_C
        ].

% put here ONLY clauses related to the visible pzlComponents implemented  into this pzlContainer.
clauses
	new(iPzlHuman::componentID_C,Container)=Object:-
		!,
		Object = pzlHuman::new(Container).
	new(iPzlComputer2::componentID_C,Container)=Object:-
		!,
		Object = pzlComputer2::new(Container).
	new(iPzlComputer1::componentID_C,Container)=Object:-
		!,
		Object = pzlComputer1::new(Container).
	new(iPzlComputer0::componentID_C,Container)=Object:-
		!,
		Object = pzlComputer0::new(Container).
    new(ClassUID,_Container)=pzlDomains::nullObject_C:-
        if not(ClassUID=pzlDomains::str("DummyX")) then
            MSG=string::format("The pzlComponent \"%\" is not supported in the pzlContainer \"%\", ver. \"%\"",ClassUID,pzl::getContainerName(),getContainerVersion()),
            exception::raise_User(Msg)
        end if.

end implement pzlConfig

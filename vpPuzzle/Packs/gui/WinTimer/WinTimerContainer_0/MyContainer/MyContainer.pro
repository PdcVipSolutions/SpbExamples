/*****************************************************************************

                         Prolog Development Center A/S

******************************************************************************/

implement myContainer
    inherits userControlSupport
    open core

clauses
    new(Parent):-
        new(),
        setContainer(Parent).

clauses
    new():-
        userControlSupport::new(),
        generatedInitialize(),
        setEraseBackgroundResponder({ = window::eraseBackground }).

% This code is maintained automatically, do not update it manually. 17:34:27-24.5.2010
facts
    winTimerControl_ctl : wintimercontrol.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize():-
        setText("MyContainer"),
        This:setSize(148, 92),
        winTimerControl_ctl := wintimercontrol::new(This),
        winTimerControl_ctl:setPosition(68, 30),
        winTimerControl_ctl:setSize(72, 56),
        winTimerControl_ctl:setAnchors([control::right,control::bottom]).
% end of automatic code
end implement myContainer

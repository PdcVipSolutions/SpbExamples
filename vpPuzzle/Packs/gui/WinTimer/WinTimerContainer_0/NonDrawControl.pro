/*****************************************************************************

                         Prolog Development Center A/S

******************************************************************************/

implement nonDrawControl
    open core

constants
    className = "WinTimerContainer_0/nonDrawControl".
    classVersion = "".

clauses
    classInfo(className, classVersion).

% This code is maintained automatically, do not update it manually. 16:55:09-24.5.2010
facts
    winTimerControl_ctl : wintimercontrol.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize():-
        setText("NonDrawControl"),
        This:setSize(152, 132),
        winTimerControl_ctl := wintimercontrol::new(This),
        winTimerControl_ctl:setPosition(44, 30),
        winTimerControl_ctl:setSize(68, 56),
        winTimerControl_ctl:setAnchors([control::right,control::bottom]).
% end of automatic code
end implement nonDrawControl

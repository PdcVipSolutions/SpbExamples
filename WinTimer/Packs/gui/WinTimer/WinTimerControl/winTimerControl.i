/*****************************************************************************

                         Prolog Development Center A/S

******************************************************************************/

interface winTimerControl supports userControlSupport
    open core

properties
    color_V:vpiDomains::color.
    interval_V:positive.

predicates
    setColor:(vpiDomains::color).

predicates
    setInterval:(positive Interval).

end interface winTimerControl
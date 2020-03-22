/*****************************************************************************

                         Prolog Development Center A/S

******************************************************************************/

implement statusLine
    open core, vpiToolbar, resourceIdentifiers

clauses
    create(Parent):-
        _ = vpiToolbar::create(style, Parent, controlList).

% This code is maintained automatically, do not update it manually. 12:59:08-24.1.2008
constants
    style : vpiToolbar::style = tb_bottom().
    controlList : vpiToolbar::control_list =
        [
        tb_text(idt_help_line,tb_context(),452,0,4,10,0x0,"")
        ].
% end of automatic code
end implement statusLine

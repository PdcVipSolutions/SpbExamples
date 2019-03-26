/*****************************************************************************

                        Copyright (c) 2013 My Company

******************************************************************************/

implement statusLine
    open core, vpiToolbar, resourceIdentifiers


clauses
    create(Parent):-
        _ = vpiToolbar::create(style, Parent, controlList).

% This code is maintained automatically, do not update it manually. 01:06:18-7.1.2013
constants
    style : vpiToolbar::style = tb_bottom().
    controlList : vpiToolbar::control_list =
        [
        tb_text(idt_help_line,tb_context(),452,0,4,10,0x0,"")
        ].
% end of automatic code
end implement statusLine
/*****************************************************************************
Copyright (c) Victor Yukhtenko

******************************************************************************/

implement taskWindow
    inherits applicationWindow
    open core, vpiDomains

constants
    mdiProperty : boolean = true.
clauses
    new():-
        applicationWindow::new(),
        generatedInitialize().

predicates
    onShow : window::showListener.
clauses
    onShow(_, _CreationData):-
        _MessageForm = messageForm::display(This).

predicates
    onDestroy : window::destroyListener.
clauses
    onDestroy(_).

predicates
    onHelpAbout : window::menuItemListener.
clauses
    onHelpAbout(TaskWin, _MenuTag):-
        _AboutDialog = aboutDialog::display(TaskWin).

predicates
    onFileExit : window::menuItemListener.
clauses
    onFileExit(_, _MenuTag):-
        close().

predicates
    onSizeChanged : window::sizeListener.
clauses
    onSizeChanged(_):-
        vpiToolbar::resize(getVPIWindow()).

facts
    pzlGame_V:iPzlGame:=erroneous.
predicates
    onFileNew : window::menuItemListener.
clauses
    onFileNew(_Source, _MenuTag):-
        pzlGame_V:=pzlGame::new(This),
        pzlGame_V:pzlRun("").


% This code is maintained automatically, do not update it manually. 21:00:05-29.10.2016

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("Polyline14"),
        setDecoration(titlebar([closeButton, maximizeButton, minimizeButton])),
        setBorder(sizeBorder()),
        setState([wsf_ClipSiblings]),
        whenCreated(
            {  :-
                projectToolbar::create(getVpiWindow()),
                statusLine::create(getVpiWindow())
            }),
        addSizeListener({  :- vpiToolbar::resize(getVpiWindow()) }),
        setMdiProperty(mdiProperty),
        menuSet(resMenu(resourceIdentifiers::idr_taskmenu)),
        addShowListener(onShow),
        addSizeListener(onSizeChanged),
        addDestroyListener(onDestroy),
        addMenuItemListener(resourceIdentifiers::id_help_about, onHelpAbout),
        addMenuItemListener(resourceIdentifiers::id_file_exit, onFileExit),
        addMenuItemListener(resourceIdentifiers::id_file_new, onFileNew).
% end of automatic code
end implement taskWindow

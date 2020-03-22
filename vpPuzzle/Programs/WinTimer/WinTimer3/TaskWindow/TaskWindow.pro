/*****************************************************************************

                         Prolog Development Center A/S

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
        _MessageForm = messageForm::display(This),
        pzl::register("TaskWindow",This).

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

predicates
    onFileNew : window::menuItemListener.
clauses
    onFileNew(_Source, _MenuTag):-
        WinTimerContainer=pzlWinTimerContainer::new(This),
        WinTimerContainer:show().

predicates
    onFileOpen : window::menuItemListener.
clauses
    onFileOpen(_Source, _MenuTag):-
        StatusViewObj=pzl::newByName("PzlStatusView",This),
        StatusView=convert(pzlRun,StatusViewObj),
        StatusView:pzlRun("NoData"),
        succeed().

% This code is maintained automatically, do not update it manually.
%  21:47:19-17.1.2019

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("WinTimer3"),
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
        menuSet(resMenu(resourceIdentifiers::id_TaskMenu)),
        addShowListener(onShow),
        addSizeListener(onSizeChanged),
        addDestroyListener(onDestroy),
        addMenuItemListener(resourceIdentifiers::id_help_about, onHelpAbout),
        addMenuItemListener(resourceIdentifiers::id_file_exit, onFileExit),
        addMenuItemListener(resourceIdentifiers::id_file_new, onFileNew),
        addMenuItemListener(resourceIdentifiers::id_file_open, onFileOpen).
% end of automatic code
end implement taskWindow

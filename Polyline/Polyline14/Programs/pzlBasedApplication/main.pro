/*****************************************************************************
Copyright (c) Victor Yukhtenko

SpbSolutions/Examples/Polyline
******************************************************************************/
implement main
    open core, pfc\log

constants
    xmlFilename = @"LogConfig.xml".

clauses
    run():-
        LogConfigName="Common",
        try
            logconfig::loadConfig(xmlFilename, LogConfigName),
            log::write(log::info, string::format("Start logging [%]",LogConfigName)),
            log::writef(log::debug, "Current directory: '%s'", directory::getCurrentDirectory())
        catch Err do
            exception::continue_User(Err, string::format("No LogConfig [%] Found",LogConfigName))
        end try,
		pzlPort::init(),
        pzlPort::setComponentRegisterFileName("PzlRegistry.pzr"),
        TaskWindow = taskWindow::new(),
        TaskWindow:show().

end implement main

goal
    mainExe::run(main::run).

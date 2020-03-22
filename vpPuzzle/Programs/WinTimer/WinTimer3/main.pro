/*****************************************************************************

                         Prolog Development Center A/S

******************************************************************************/

implement main
    open core, pfc\log

constants
    xmlFilename = @"log\LogConfig.xml".

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
        TaskWindow = taskWindow::new(),
        TaskWindow:show().

end implement main

goal
    mainExe::run(main::run).

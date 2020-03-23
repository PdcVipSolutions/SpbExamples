%

class fe_RibbonDefault : fe_RibbonDefault
    open core

constants
    optionsIcon32_C:binary=#bininclude(@"..\Common\AppFrontEnd\FE_Icons\gear_2-512.png").
    helpIcon32_C:binary=#bininclude( @"..\bin\febeAppData\pdcVipIcons\_license-cc\actions\help-contents.ico").
    aboutIcon32_C:binary=#bininclude(@"..\bin\febeAppData\pdcVipIcons\_license-cc\actions\help-about.ico").
    designIcon32_C:binary=#bininclude(@"..\Common\AppFrontEnd\FE_Icons\if_tools-70px_510859.png").
    reloadIcon32_C:binary=#bininclude(@"..\bin\febeAppData\pdcVipIcons\actions\arrow-blue-left.ico").
    expandIcon32_C:binary=#bininclude(@"..\bin\febeAppData\pdcVipIcons\actions\horizontal-rule-add.ico").

constructors
    new : (frontEnd FrontEnd).

end class fe_RibbonDefault

-- https://wiki.hypr.land/Configuring/Basics/Binds/
-- open or toggle apps with Main_Mod + key
hl.bind(
    Main_Mod .. " + RETURN",
    hl.dsp.exec_cmd(Terminal_0),
    {
        description = "open favourite terminal 0",
    }
)
hl.bind(
    Main_Mod .. " + KP_ENTER",
    hl.dsp.exec_cmd(Terminal_0),
    {
        description = "open favourite terminal 0",
    }
)
hl.bind(
    Main_Mod .. " + T",
    hl.dsp.exec_cmd(Terminal_1),
    {
        description = "open favourite terminal 1",
    }
)
hl.bind(
    Main_Mod .. " + D",
    hl.dsp.exec_cmd(App_Menu),
    {
        description = "open app launcher menu",
    }
)
hl.bind(
    Main_Mod .. " + E",
    hl.dsp.exec_cmd(File_Manager),
    {
        description = "open favourite file manager",
    }
)
hl.bind(
    Main_Mod .. " + SHIFT + E",
    hl.dsp.exec_cmd(File_Editor),
    {
        description = "open favourite file manager",
    }
)
hl.bind(
    Main_Mod .. " + R",
    hl.dsp.exec_cmd("hyprland-run"),
    {
        description = "hyprland run",
    }
)
hl.bind(
    Main_Mod .. " + G",
    hl.dsp.exec_cmd(Browser),
    {
        description = "open favourite internet browser",
    }
)
hl.bind(
    Main_Mod .. " + W",
    hl.dsp.exec_cmd(Status_Bar),
    {
        description = "toggle on/off status bar",
    }
)
hl.bind(
    Main_Mod .. " + I",
    hl.dsp.exec_cmd(Idle),
    {
        description = "toggle on/off display idle mode",
    }
)
hl.bind(
    Main_Mod .. " + O",
    hl.dsp.exec_cmd(Whiteboard),
    {
        description = "toggle on/off favourite whiteboard app",
    }
)

-- launching apps with laptop multimedia_keys
hl.bind(
    "XF86WLAN",
    hl.dsp.exec_cmd(Wifi_Bt),
    {
        description = "toggle on/off wifi and bluetooth",
    }
)
hl.bind(
    "XF86Display",
    hl.dsp.exec_cmd(Display),
    {
        description = "open display settings",
    }
)
hl.bind(
    "XF86LaunchA",
    hl.dsp.exec_cmd(Terminal_0),
    {
        description = "open the favourite terminal 0",
    }
)
hl.bind(
    "XF86Search",
    hl.dsp.exec_cmd(Browser),
    {
        description = "open app launcher menu",
    }
)
hl.bind(
    "XF86Explorer",
    hl.dsp.exec_cmd(App_Menu),
    {
        description = "open app launcher menu",
    }
)
hl.bind(
    "XF86Tools",
    hl.dsp.exec_cmd(Tool),
    {
        description = "open the favourite tool",
    }
)

-- https://wiki.hypr.land/Configuring/Basics/Binds/
-- control window with Main_Mod + key
hl.bind(
    Main_Mod .. " + C",
    hl.dsp.window.close(),
    {
        description = "close focused window",
    }
)
hl.bind(
    Main_Mod .. " + SHIFT + C",
    hl.dsp.window.kill(),
    {
        description = "kill focused window",
    }
)
hl.bind(
    Main_Mod .. " + Q",
    hl.dsp.window.close(),
    {
        description = "close focused window",
    }
)
hl.bind(
    Main_Mod .. " + SHIFT + Q",
    hl.dsp.window.kill(),
    {
        description = "kill focused window",
    }
)
hl.bind(
    Main_Mod .. " + V",
    hl.dsp.window.float({ action = "toggle" }),
    {
        description = "floating focused window",
    }
)
hl.bind(
    Main_Mod .. " + P",
    hl.dsp.window.pseudo(),
    {
        description = "pseudo focused window",
    }
)
hl.bind(
    Main_Mod .. " + X",
    hl.dsp.layout("togglesplit"),
    {
        description = "split window vertical/horizontal",
    }
)
hl.bind(
    Main_Mod .. " + F",
    hl.dsp.window.fullscreen({
        mode = "maximized",
        action = "toggle",
    }),
    {
        description = "toggle maximize window",
    }
)
hl.bind(
    "F11",
    hl.dsp.window.fullscreen({
        mode = "fullscreen",
        action = "toggle",
    }),
    {
        description = "toggle fullscreen window",
    }
)

-- move focus with Main_Mod + arrow_keys
hl.bind(
    Main_Mod .. " + left",
    hl.dsp.focus({ direction = "left" }),
    {
        description = "focus to left window",
    }
)
hl.bind(
    Main_Mod .. " + right",
    hl.dsp.focus({ direction = "right" }),
    {
        description = "focus to right window",
    }
)
hl.bind(
    Main_Mod .. " + up",
    hl.dsp.focus({ direction = "up" }),
    {
        description = "focus to up window",
    }
)
hl.bind(
    Main_Mod .. " + down",
    hl.dsp.focus({ direction = "down" }),
    {
        description = "focus to down window",
    }
)

-- move focus with Main_Mod + vim_keys
hl.bind(
    Main_Mod .. " + H",
    hl.dsp.focus({ direction = "left" }),
    {
        description = "focus to left window",
    }
)
hl.bind(
    Main_Mod .. " + L",
    hl.dsp.focus({ direction = "right" }),
    {
        description = "focus to right window",
    }
)
hl.bind(
    Main_Mod .. " + K",
    hl.dsp.focus({ direction = "up" }),
    {
        description = "focus to up window",
    }
)
hl.bind(
    Main_Mod .. " + J",
    hl.dsp.focus({ direction = "down" }),
    {
        description = "focus to down window",
    }
)


-- move window with Main_Mod + shift + arrow_keys
hl.bind(
    Main_Mod .. " + SHIFT + left",
    hl.dsp.window.move({
        x = -30,
        y = 0,
        relative = true,
    }),
    {
        repeating = true,
        description = "move window to left",
    }
)
hl.bind(
    Main_Mod .. " + SHIFT + right",
    hl.dsp.window.move({
        x = 30,
        y = 0,
        relative = true,
    }),
    {
        repeating = true,
        description = "move window to right",
    }
)
hl.bind(
    Main_Mod .. " + SHIFT + up",
    hl.dsp.window.move({
        x = 0,
        y = -30,
        relative = true,
    }),
    {
        repeating = true,
        description = "move window to up",
    }
)
hl.bind(
    Main_Mod .. " + SHIFT + down",
    hl.dsp.window.move({
        x = 0,
        y = 30,
        relative = true,
    }),
    {
        repeating = true,
        description = "move window to down",
    }
)

-- move window with Main_Mod + shift + vim_keys
hl.bind(
    Main_Mod .. " + SHIFT + H",
    hl.dsp.window.move({
        x = -30,
        y = 0,
        relative = true,
    }),
    {
        repeating = true,
        description = "move window to left",
    }
)
hl.bind(
    Main_Mod .. " + SHIFT + L",
    hl.dsp.window.move({
        x = 30,
        y = 0,
        relative = true,
    }),
    {
        repeating = true,
        description = "move window to right",
    }
)
hl.bind(
    Main_Mod .. " + SHIFT + K",
    hl.dsp.window.move({
        x = 0,
        y = -30,
        relative = true,
    }),
    {
        repeating = true,
        description = "move window to up",
    }
)
hl.bind(
    Main_Mod .. " + SHIFT + J",
    hl.dsp.window.move({
        x = 0,
        y = 30,
        relative = true,
    }),
    {
        repeating = true,
        description = "move window to down",
    }
)

-- resize window with Main_Mod + ctrl + arrow_keys
hl.bind(
    Main_Mod .. " + CTRL + left",
    hl.dsp.window.resize({
        x = -10,
        y = 0,
        relative = true,
    }),
    {
        repeating = true,
        description = "lower vertical window size",
    }
)
hl.bind(
    Main_Mod .. " + CTRL + right",
    hl.dsp.window.resize({
        x = 10,
        y = 0,
        relative = true,
    }),
    {
        repeating = true,
        description = "raise vertical window size",
    }
)
hl.bind(
    Main_Mod .. " + CTRL + up",
    hl.dsp.window.resize({
        x = 0,
        y = -10,
        relative = true,
    }),
    {
        repeating = true,
        description = "lower horizontal window size",
    }
)
hl.bind(
    Main_Mod .. " + CTRL + down",
    hl.dsp.window.resize({
        x = 0,
        y = 10,
        relative = true,
    }),
    {
        repeating = true,
        description = "raise horizontal window size",
    }
)

-- resize window with Main_Mod + ctrl + vim_keys
hl.bind(
    Main_Mod .. " + CTRL + H",
    hl.dsp.window.resize({
        x = -10,
        y = 0,
        relative = true,
    }),
    {
        repeating = true,
        description = "lower vertical window size",
    }
)
hl.bind(
    Main_Mod .. " + CTRL + L",
    hl.dsp.window.resize({
        x = 10,
        y = 0,
        relative = true,
    }),
    {
        repeating = true,
        description = "raise vertical window size",
    }
)
hl.bind(
    Main_Mod .. " + CTRL + K",
    hl.dsp.window.resize({
        x = 0,
        y = -10,
        relative = true,
    }),
    {
        repeating = true,
        description = "lower horizontal window size",
    }
)
hl.bind(
    Main_Mod .. " + CTRL + J",
    hl.dsp.window.resize({
        x = 0,
        y = 10,
        relative = true,
    }),
    {
        repeating = true,
        description = "raise horizontal window size",
    }
)

-- move/resize windows with Main_Mod + mouse_keys and dragging
hl.bind(
    Main_Mod .. " + mouse:272",
    hl.dsp.window.drag(),
    {
        mouse = true,
        description = "dragging window",
    }
)
hl.bind(
    Main_Mod .. " + mouse:273",
    hl.dsp.window.resize(),
    {
        mouse = true,
        description = "resizing window",
    }
)

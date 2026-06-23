-- change and move to workspace with Main_Mod + number and Main_Mod + shift + number
for i = 1, 10 do
    local key = i % 10
    hl.bind(
        Main_Mod .. " + " .. key,
        hl.dsp.focus({
            workspace = i,
        }),
        {
            description = "change workspace focus",
        }
    )
    hl.bind(
        Main_Mod .. " + SHIFT + " .. key,
        hl.dsp.window.move({
            workspace = i,
        }),
        {
            description = "move window to other workspace",
        }
    )
end

-- change workspaces with Main_Mod + mouse_scroll
hl.bind(
    Main_Mod .. " + mouse_down",
    hl.dsp.focus({ workspace = "e+1" }),
    {
        description = "scroll to next workspace",
    }
)
hl.bind(
    Main_Mod .. " + mouse:276",
    hl.dsp.focus({ workspace = "e+1" }),
    {
        description = "scroll to next workspace",
    }
)
hl.bind(
    Main_Mod .. " + mouse_up",
    hl.dsp.focus({ workspace = "e-1" }),
    {
        description = "scroll to previous workspace",
    }
)
hl.bind(
    Main_Mod .. " + mouse:275",
    hl.dsp.focus({ workspace = "e-1" }),
    {
        description = "scroll to previous workspace",
    }
)

-- toggle and move window to special workspace with Main_Mod + s and Main_Mod + shift + s
hl.bind(
    Main_Mod .. " + S",
    hl.dsp.workspace.toggle_special("magic"),
    {
        description = "toggle special workspace",
    }
)
hl.bind(
    Main_Mod .. " + SHIFT + S",
    hl.dsp.window.move({ workspace = "special:magic" }),
    {
        description = "move window to special workspace",
    }
)

-- scroll through scrolling layout with Main_Mod + '.'/','
hl.bind(
    Main_Mod .. " + period",
    hl.dsp.layout("move +col"),
    {
        description = "scroll to next window",
    }
)
hl.bind(
    Main_Mod .. " + comma",
    hl.dsp.layout("move -col"),
    {
        description = "scroll to previous window",
    }
)
hl.bind(
    Main_Mod .. " + SHIFT + period",
    hl.dsp.layout("swapcol r"),
    {
        description = "move window to next scroll layout",
    }
)
hl.bind(
    Main_Mod .. " + SHIFT + comma",
    hl.dsp.layout("swapcol l"),
    {
        description = "move to previous scroll layout",
    }
)

-- scroll through scrolling layout with Main_Mod + mouse_scroll
hl.bind(
    Main_Mod .. " + SHIFT + ",
    hl.dsp.layout("move +col")
)
hl.bind(
    Main_Mod .. " + SHIFT + ",
    hl.dsp.layout("move -col")
)
hl.bind(
    Main_Mod .. " + period",
    hl.dsp.layout("move +col")
)
hl.bind(
    Main_Mod .. " + comma",
    hl.dsp.layout("move -col")
)

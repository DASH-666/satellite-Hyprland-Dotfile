-- https://wiki.hypr.land/Configuring/Basics/Binds/
-- plugins keybinds
hl.bind(
    Main_Mod .. " + A",
    function()
        hl.plugin.hyprexpo.expo("toggle")
    end,
    {
        description = "open hyprexpo menu",
    }
)

-- https://wiki.hypr.land/Configuring/Basics/Binds/
--Screenshot
hl.bind(
    "Print",
    hl.dsp.exec_cmd(Screenshot .. " -a"),
    {
        description = "print full screen(saved on ~/Pictures/)",
    }
)
hl.bind(
    "SHIFT + Print",
    hl.dsp.exec_cmd(Screenshot),
    {
        description = "pring screen with given file adress and screen size",
    }
)

-- system keybinds(exit, suspend, change layout) with Main_Mod + key
hl.bind(
    Main_Mod .. " + M",
    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"),
    {
        description = "exit hyprland",
    }
)
hl.bind(
    Main_Mod .. " + N",
    hl.dsp.exec_cmd("systemctl suspend"),
    {
        description = "suspend the system",
    }
)
hl.bind(
    Main_Mod .. " + SHIFT + N",
    hl.dsp.exec_cmd("systemctl suspend && hyprlock"),
    {
        description = "suspend and lock the system",
    }
)
hl.bind(
    "INSERT",
    hl.dsp.exec_cmd("hyprctl switchxkblayout at-translated-set-2-keyboard next"),
    {
        description = "changing the keyboard layout",
    }
)
hl.bind(
    "ALT + less",
    hl.dsp.exec_cmd("hyprctl switchxkblayout at-translated-set-2-keyboard next"),
    {
        description = "changing the keyboard layout",
    }
)
hl.bind(
    "CTRL + less",
    hl.dsp.exec_cmd("hyprctl switchxkblayout at-translated-set-2-keyboard next"),
    {
        description = "changing the keyboard layout",
    }
)

-- cursor zoom function
local MAX_ZOOM = 10
local MIN_ZOOM = 1
local ZOOM_TOGGLE_FACTOR = 2.0

---@param offset number
---@return nil
local function zoom(offset)
    local current = hl.get_config("cursor.zoom_factor")
    if offset ~= nil then
        current = current + offset
    elseif current ~= MIN_ZOOM then
        current = MIN_ZOOM
    else
        current = ZOOM_TOGGLE_FACTOR
    end
    current = math.max(MIN_ZOOM, math.min(MAX_ZOOM, current))
    hl.config({ cursor = { zoom_factor = current } })
end

hl.bind(
    Main_Mod .. " + Z",
    zoom,
    {
        description = "toggle 2x zoom",
    }
)

-- cursor zoom with Main_Mod + ctrl + "="/"-"
hl.bind(
    Main_Mod .. " + CTRL + equal",
    function()
        zoom(0.5)
    end,
    {
        repeating = true,
        description = "zoom in to cursor",
    }
)
hl.bind(
    Main_Mod .. " + CTRL + minus",
    function()
        zoom(-0.5)
    end,
    {
        repeating = true,
        description = "zoom out to cursor",
    }
)

-- cursor zoom with Main_Mod + ctrl + mouse_scroll
hl.bind(
    Main_Mod .. " + CTRL + mouse_down",
    function()
        zoom(0.5)
    end,
    {
        description = "zoom in to cursor",
    }
)
hl.bind(
    Main_Mod .. " + CTRL + mouse:275",
    function()
        zoom(0.5)
    end,
    {
        description = "zoom in to cursor",
    }
)
hl.bind(
    Main_Mod .. " + CTRL + mouse_up",
    function()
        zoom(-0.5)
    end,
    {
        description = "zoom out to cursor",
    }
)
hl.bind(
    Main_Mod .. " + CTRL + mouse:276",
    function()
        zoom(-0.5)
    end,
    {
        description = "zoom out to cursor",
    }
)

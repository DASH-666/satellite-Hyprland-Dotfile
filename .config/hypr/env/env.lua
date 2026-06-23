-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
-- environment variables
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("GTK_THEME", "adwaita-dark-amoled")
hl.env("GTK_ICON_THEME", "beautyline")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct,qt6ct")
hl.env("HYPRCURSOR_THEME", "Bibata-Original-Classic")
hl.env("HYPRCURSOR_SIZE", "24")

local function has_nvidia()
    local f = io.popen("lspci | grep -i nvidia")
    if not f then return false end

    local r = f:read("*a") or ""
    f:close()

    return r ~= ""
end
if has_nvidia() then
    hl.env("__NV_PRIME_RENDER_OFFLOAD", "1")
    hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
    hl.env("__VK_LAYER_NV_optimus", "NVIDIA_only")
end

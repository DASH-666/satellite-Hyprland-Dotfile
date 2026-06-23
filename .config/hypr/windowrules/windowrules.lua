-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- window rule
hl.window_rule({
    match = {
        class = "(pinentry-)(.*)",
    },
    stay_focused = true,
})
hl.layer_rule({
    match = {
        class = "hyprland-run",
    },
})

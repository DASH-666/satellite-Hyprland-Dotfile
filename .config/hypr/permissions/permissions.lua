
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- permissions
hl.permission({
    binary = "/usr/(bin|local/bin)/grim",
    type = "screencopy",
    mode = "allow",
})
hl.permission({
    binary = "/usr/(bin|local/bin)/obs",
    type = "screencopy",
    mode = "allow",
})
hl.permission({
    binary = "/usr/(bin|local/bin)/hyprpm",
    type = "plugin",
    mode = "allow",
})
hl.permission({
    binary = "/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland",
    type = "screencopy",
    mode = "allow",
})
hl.permission({
    binary = "/usr/(bin|local/bin)/hyprlock",
    type = "screencopy",
    mode = "allow",
})

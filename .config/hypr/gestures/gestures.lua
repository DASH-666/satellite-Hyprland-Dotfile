-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
hl.gesture({
   fingers   = 3,
   direction = "horizontal",
   action    = "workspace"
})
hl.gesture({
   fingers   = 3,
   direction = "vertical",
   action    = "special"
})
hl.gesture({
    fingers   = 4,
    direction = "up",
    action    = function()
        hl.exec_cmd(App_Menu)
    end
})
hl.gesture({
   fingers   = 4,
   direction = "down",
   action    = "close",
})
hl.gesture({
    fingers = 2,
    direction = "pinch",
    action = "cursorZoom",
    zoom_level = 1,
    mode = "live",
})


-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
-- curves
hl.curve("from_bottom_curve",
    {
        type = "bezier",
        points = {
            {0.05, 0.9},
            {0.1, 1.05},
        }
    }
)
hl.curve("punchy_window_curve",
    {
        type = "bezier",
        points = {
            {0.2, 1.2},
            {0.3, 1.0},
        }
    }
)

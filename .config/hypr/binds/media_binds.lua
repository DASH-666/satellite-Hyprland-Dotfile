-- https://wiki.hypr.land/Configuring/Basics/Binds/
-- change volume and toggle mute with Main_Mod + multimedia_keys
hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    {
        locked = true,
        repeating = true,
        description = "raise the audio volume",
    }
)
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    {
        locked = true,
        repeating = true,
        description = "lower the audio volume",
    }
)
hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    {
        locked = true,
        repeating = true,
        description = "mute the audio",
    }
)
hl.bind(
    "XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    {
        locked = true,
        repeating = true,
        description = "mute the microphone",
    }
)

-- controling audio/video with xf86_keys
hl.bind(
    "XF86AudioNext",
    hl.dsp.exec_cmd("playerctl next"),
    {
        locked = true,
        description = "play next audio/video",
    }
)
hl.bind(
    Main_Mod .. " + XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("playerctl next"),
    {
        locked = true,
        description = "play next audio/video",
    }
)
hl.bind(
    "XF86AudioPause",
    hl.dsp.exec_cmd("playerctl play-pause"),
    {
        locked = true,
        description = "toggle play/pause",
    }
)
hl.bind(
    "XF86AudioPlay",
    hl.dsp.exec_cmd("playerctl play-pause"),
    {
        locked = true,
        description = "toggle play/pause",
    }
)
hl.bind(
    Main_Mod .. " + XF86AudioMute",
    hl.dsp.exec_cmd("playerctl play-pause"),
    {
        locked = true,
        description = "toggle play/pause",
    }
)
hl.bind(
    "XF86AudioStop",
    hl.dsp.exec_cmd("playerctl stop"),
    {
        locked = true,
        description = "stop played audio/video",
    }
)
hl.bind(
    Main_Mod .. " + XF86AudioMicMute",
    hl.dsp.exec_cmd("playerctl stop"),
    {
        locked = true,
        description = "stop played audio/video",
    }
)
hl.bind(
    "XF86AudioPrev",
    hl.dsp.exec_cmd("playerctl previous"),
    {
        locked = true,
        description = "play previous audio/video",
    }
)
hl.bind(
    Main_Mod .. " + XF86AudioLowerVolume",
    hl.dsp.exec_cmd("playerctl previous"),
    {
        locked = true,
        description = "play previous audio/video",
    }
)
hl.bind(
    Main_Mod .. " + CTRL + XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("playerctl position 5+"),
    {
        locked = true,
        description = "raise the position of audio/video",
    }
)
hl.bind(
    Main_Mod .. " + CTRL + XF86AudioLowerVolume",
    hl.dsp.exec_cmd("playerctl position 5-"),
    {
        locked = true,
        description = "lower the position of audio/video",
    }
)

-- controling audio/video with Main_Mod + keys
hl.bind(
    Main_Mod .. " + P",
    hl.dsp.exec_cmd("playerctl play-pause"),
    {
        locked = true,
        description = "toggle play/pause",
    }
)
hl.bind(
    Main_Mod .. " + SHIFT + P",
    hl.dsp.exec_cmd("playerctl next"),
    {
        locked = true,
        description = "play next audio/video",
    }
)
hl.bind(
    Main_Mod .. " + CTRL + P",
    hl.dsp.exec_cmd("playerctl previous"),
    {
        locked = true,
        description = "play previous audio/video",
    }
)
hl.bind(
    Main_Mod .. " + SHIFT + CTRL + P",
    hl.dsp.exec_cmd("playerctl stop"),
    {
        locked = true,
        description = "stop played audio/video",
    }
)

-- changing brightness with laptop function keys
hl.bind(
    "XF86MonBrightnessUp",
    hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),
    {
        locked = true,
        repeating = true,
        description = "raise the brightness level",
    }
)
hl.bind(
    "XF86MonBrightnessDown",
    hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),
    {
        locked = true,
        repeating = true,
        description = "lower the brightness level",
    }
)

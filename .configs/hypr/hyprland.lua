

local main_mod = "SUPER"
local terminal_0 = "ghostty"
local terminal_1 = "foot"
local file_manager = "ghostty -e spf"
local browser = "librewolf"
local file_editor = "ghostty -e nvim"
local display_manager = "nwg_displays"
local whiteboard_manager = "wayscriber --daemon"
local music_daemon = " mpd && until mpc status >/dev/null 2>&1; do sleep 1; done; mpd-mpris"
local soundeffect_manager = "easyeffects --gapplication-service"
local wifi_bt = "/home/$USER/.config/hypr/wifi_bt_toggle.sh"
local app_menu = "killall rofi || rofi -show run -theme /home/dash-/.config/rofi/theme.rasi"
local status_bar = "killall waybar || waybar"
local wallpaper = "swaybg -m fill -i /home/$USER/.config/hypr/epic-cat.jpg"
local idle_manager = "hypridle"
local polkit = "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"

-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct,qt6ct")

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

-- https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function ()
  hl.exec_cmd(terminal_0)
  hl.exec_cmd("hyprpm reload")
  hl.exec_cmd(status_bar)
  hl.exec_cmd(wallpaper)
  hl.exec_cmd(idle_manager)
  hl.exec_cmd("mako")
  hl.exec_cmd(polkit)
  hl.exec_cmd(music_daemon)
  hl.exec_cmd(soundeffect_manager)
  hl.exec_cmd(whiteboard_manager)
  hl.exec_cmd("xhost +local:")
end)

-- https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
  output = "VGA-1",
  mode = "1440x900@74.98",
  position = "0x0",
  scale = 1,
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        border_size = 0,
        gaps_in = 1,
        gaps_out = 0,
        float_gaps = 0,
        gaps_workspaces = 0,
        col = {
            active_border = {
                colors = {
                    0xffffffff,
                    angle = 0,
                },
            },
            inactive_border = {
                colors = {
                    0x00000000,
                    angle = 0,
                },
            },
            nogroup_border = {
                colors = {
                    0xffffaaff,
                    angle = 0,
                },
            },
            nogroup_border_active = {
                colors = {
                    0xffff00ff,
                    angle = 0,
                },
            },
        },
        layout = "dwindle",
        no_focus_fallback = false,
        resize_on_border = true,
        extend_border_grab_area = 15,
        hover_icon_on_border = true,
        allow_tearing = false,
        resize_corner = 0,
        modal_parent_blocking = false,
        locale = "en_US",
        snap = {
            enabled = true,
            window_gap = 10,
            monitor_gap = 10,
            border_overlap = false,
            respect_gaps = false,
        },
    },
    decoration = {
        rounding = 4,
        rounding_power = 10.0,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        fullscreen_opacity = 1.0,
        dim_modal = true,
        dim_inactive = true,
        dim_strength = 0.2,
        dim_special = 0.2,
        dim_around = 0.4,
        screen_shader = "",
        border_part_of_window = true,
        blur = {
            enabled = false,
            size = 2,
            passes = 3,
            ignore_opacity = true,
            new_optimizations = true,
            xray = false,
            noise = 0.0,
            contrast = 0.8916,
            brightness = 1.0,
            vibrancy = 0.1696,
            vibrancy_darkness = 0.0,
            special = false,
            popups = false,
            popups_ignorealpha = 0.2,
            input_methods = false,
            input_methods_ignorealpha = 0.2,
        },
        shadow = {
            enabled = false,
            range = 5,
            render_power = 3,
            sharp = false,
            color = 0x000000aa,
            color_inactive = 0x000000aa,
            offset = {
                0,
                0,
            },
            scale = 1.0,
        },
        glow = {
            enabled = false,
            range = 4,
            render_power = 2,
            color = 0xeeffffff,
            color_inactive = 0xeeffff88,
        },
    },
    animations = {
        enabled = true,
        workspace_wraparound = false,
    },
    input = {
        kb_model = "",
        kb_layout = "us, ir",
        kb_variant = "",
        kb_options = "grp:rwin_toggle, grp:win_space_toggle, ctrl:nocaps, grp_led:scroll, shift:both_capslock",
        kb_rules = "",
        kb_file = "",
        numlock_by_default = true,
        resolve_binds_by_sym = false,
        repeat_rate = 40,
        repeat_delay = 400,
        sensitivity = 0.0,
        accel_profile = "adaptive",
        force_no_accel = false,
        rotation = 0,
        left_handed = false,
        scroll_points = "",
        scroll_method = "2fg",
        scroll_button = 0,
        scroll_button_lock = false,
        scroll_factor = 1.0,
        natural_scroll = false,
        follow_mouse = 1,
        follow_mouse_shrink = 0,
        follow_mouse_threshold = 0.0,
        focus_on_close = 1,
        mouse_refocus = true,
        float_switch_override_focus = 2,
        special_fallthrough = false,
        off_window_axis_events = false,
        emulate_discrete_scroll = 1,
        touchpad = {
            disable_while_typing = false,
            natural_scroll = true,
            scroll_factor = 1.0,
            middle_button_emulation = false,
            tap_button_map = "lrm",
            clickfinger_behavior = true,
            tap_to_click = true,
            drag_lock = 1,
            tap_and_drag = true,
            flip_x = false,
            flip_y = false,
            drag_3fg = 0,
        },
        touchdevice = {
            transform = -1,
            output = "auto",
            enabled = true,
        },
        virtualkeyboard = {
            share_states = 2,
            release_pressed_on_close = false,
        },
        tablet = {
            transform = -1,
            output = "",
            region_position = {
                0,
                0,
            },
            absolute_region_position = false,
            region_size = {
                0,
                0,
            },
            relative_input = false,
            left_handed = false,
            active_area_size = {
                0,
                0,
            },
            active_area_position = {
                0,
                0,
            },
        },
    },
    gestures = {
        workspace_swipe_distance = 300,
        workspace_swipe_touch = false,
        workspace_swipe_invert = true,
        workspace_swipe_touch_invert = false,
        workspace_swipe_min_speed_to_force = 30,
        workspace_swipe_cancel_ratio = 0.5,
        workspace_swipe_create_new = true,
        workspace_swipe_direction_lock = true,
        workspace_swipe_direction_lock_threshold = 10,
        workspace_swipe_forever = false,
        workspace_swipe_use_r = false,
        close_max_timeout = 1000,
    },
    group = {
        auto_group = true,
        insert_after_current = true,
        focus_removed_window = true,
        drag_into_group = 1,
        merge_groups_on_drag = true,
        merge_groups_on_groupbar = true,
        merge_floated_into_tiled_on_groupbar = false,
        group_on_movetoworkspace = false,
        col = {
            border_active = {
                colors = {
                    0x66ffff00,
                    angle = 0,
                },
            },
            border_inactive = {
                colors = {
                    0x66777700,
                    angle = 0,
                },
            },
            border_locked_active = {
                colors = {
                    0x66ff5500,
                    angle = 0,
                },
            },
            border_locked_inactive = {
                colors = {
                    0x66775500,
                    angle = 0,
                },
            },
        },
        groupbar = {
            enabled = true,
            font_family = "",
            font_size = 8,
            font_weight_active = "normal",
            font_weight_inactive = "normal",
            gradients = false,
            height = 14,
            indicator_gap = 0,
            indicator_height = 3,
            stacked = false,
            priority = 3,
            render_titles = true,
            text_offset = 0,
            text_padding = 0,
            scrolling = true,
            rounding = 1,
            rounding_power = 2.0,
            gradient_rounding = 2,
            gradient_rounding_power = 2.0,
            round_only_edges = true,
            gradient_round_only_edges = true,
            text_color = 0xffffffff,
            text_color_inactive = 0xffffffff,
            text_color_locked_active = 0xffffffff,
            text_color_locked_inactive = 0xffffffff,
            col = {
                active = {
                    colors = {
                        0x66ffff00,
                        angle = 0,
                    },
                },
                inactive = {
                    colors = {
                        0x66777700,
                        angle = 0,
                    },
                },
                locked_active = {
                    colors = {
                        0x66ff5500,
                        angle = 0,
                    },
                },
                locked_inactive = {
                    colors = {
                        0x66775500,
                        angle = 0,
                    },
                },
            },
            gaps_in = 2,
            gaps_out = 2,
            keep_upper_gap = true,
            middle_click_close = true,
            blur = false,
        },
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        disable_scale_notification = false,
        col = {
            splash = 0xffffffff,
        },
        font_family = "Fira Code Nerd Font Propo",
        splash_font_family = "Fira Code Nerd Font Propo",
        force_default_wallpaper = -1,
        vrr = 1,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
        name_vk_after_proc = true,
        always_follow_on_dnd = true,
        layers_hog_keyboard_focus = true,
        animate_manual_resizes = true,
        animate_mouse_windowdragging = false,
        disable_autoreload = false,
        enable_swallow = false,
        swallow_regex = "",
        focus_on_activate = false,
        mouse_move_focuses_monitor = true,
        allow_session_lock_restore = false,
        session_lock_xray = false,
        background_color = 0x000000ff,
        close_special_on_empty = true,
        on_focus_under_fullscreen = 2,
        exit_window_retains_fullscreen = false,
        initial_workspace_tracking = 0,
        middle_click_paste = true,
        render_unfocused_fps = 30,
        disable_xdg_env_checks = false,
        -- disable_hyprland_qtutils_check = false,
        lockdead_screen_delay = 3000,
        enable_anr_dialog = true,
        anr_missed_pings = 10,
        size_limits_tiled = false,
        disable_watchdog_warning = true,
    },
    layout = {
        single_window_aspect_ratio = {
            0,
            0,
        },
        single_window_aspect_ratio_tolerance = 0.1,
    },
    binds = {
        pass_mouse_when_bound = false,
        scroll_event_delay = 100,
        workspace_back_and_forth = false,
        hide_special_on_workspace_change = true,
        allow_workspace_cycles = true,
        workspace_center_on = 0,
        focus_preferred_method = 0,
        ignore_group_lock = false,
        movefocus_cycles_fullscreen = true,
        window_direction_monitor_fallback = true,
        disable_keybind_grabbing = true,
        allow_pin_fullscreen = false,
        drag_threshold = 0,
    },
    xwayland = {
        enabled = true,
        use_nearest_neighbor = true,
        force_zero_scaling = false,
        create_abstract_socket = false,
    },
    opengl = {
        nvidia_anti_flicker = true,
    },
    render = {
        direct_scanout = 2,
        expand_undersized_textures = true,
        xp_mode = false,
        ctm_animation = 2,
        cm_enabled = true,
        send_content_type = true,
        cm_auto_hdr = 1,
        new_render_scheduling = true,
        non_shader_cm = 2,
        non_shader_cm_interop = 2,
        cm_sdr_eotf = "default",
        commit_timing_enabled = true,
        use_fp16 = 1,
        keep_unmodified_copy = 2,
        use_shader_blur_blend = false,
    },
    cursor = {
        invisible = false,
        sync_gsettings_theme = true,
        no_hardware_cursors = 2,
        no_break_fs_vrr = 2,
        min_refresh_rate = 60,
        hotspot_padding = 1,
        inactive_timeout = 10,
        no_warps = false,
        persistent_warps = false,
        warp_on_change_workspace = 0,
        warp_on_toggle_special = 0,
        default_monitor = "",
        zoom_factor = 1.0,
        zoom_rigid = false,
        zoom_detached_camera = false,
        enable_hyprcursor = true,
        hide_on_key_press = false,
        hide_on_touch = true,
        hide_on_tablet = true,
        use_cpu_buffer = 2,
        warp_back_after_non_mouse_input = false,
        zoom_disable_aa = true,
    },
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
        enforce_permissions = false,
    },
    quirks = {
        prefer_hdr = 0,
    },
})

-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
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
hl.animation({
    leaf = "global",
    enabled = true,
    speed = 10,
    bezier = "default",
})
hl.animation({
    leaf = "border",
    enabled = true,
    speed = 1,
    bezier = "default",
})
hl.animation({
    leaf = "borderangle",
    enabled = true,
    speed = 10,
    bezier = "default",
})
hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 4,
    bezier = "default",
})
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 7,
    bezier = "punchy_window_curve",
})
hl.animation({
    leaf = "zoomFactor",
    enabled = true,
    speed = 4,
    bezier = "default",
})
hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 4,
    bezier = "default",
})
hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 7,
    bezier = "from_bottom_curve",
    style = "slide bottom",
})
hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 10,
    bezier = "from_bottom_curve",
    style = "slide bottom",
})
hl.animation({
    leaf = "specialWorkspaceIn",
    enabled = true,
    speed = 6,
    bezier = "from_bottom_curve",
    style = "slide top",
})
hl.animation({
    leaf = "specialWorkspaceIn",
    enabled = true,
    speed = 10,
    bezier = "from_bottom_curve",
    style = "slide bottom",
})

-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
hl.gesture({
   fingers = 3,
   direction = "horizontal",
   action = "workspace"
})
hl.gesture({
   fingers = 3,
   direction = "vertical",
   action = "special"
})
hl.gesture({
    fingers = 4,
    direction = "up",
    action = function()
        hl.exec_cmd(app_menu)
    end
})
hl.gesture({
   fingers = 4,
   direction = "down",
   action = "close",
})

-- https://wiki.hypr.land/Configuring/Basics/Binds/
-- apps
hl.bind(
    main_mod .. " + RETURN",
    hl.dsp.exec_cmd(terminal_0)
)
hl.bind(
    main_mod .. " + KP_ENTER",
    hl.dsp.exec_cmd(terminal_0)
)
hl.bind(
    main_mod .. " + Q",
    hl.dsp.exec_cmd(terminal_1)
)
hl.bind(
    main_mod .. " + D",
    hl.dsp.exec_cmd(app_menu)
)
hl.bind(
    "XF86Explorer",
    hl.dsp.exec_cmd(app_menu)
)
hl.bind(
    main_mod .. " + E",
    hl.dsp.exec_cmd(file_manager)
)
hl.bind(
    main_mod .. " + R",
    hl.dsp.exec_cmd(file_editor)
)
hl.bind(
    main_mod .. " + G",
    hl.dsp.exec_cmd(browser)
)

-- window control
hl.bind(
    main_mod .. " + C",
    hl.dsp.window.close()
)
hl.bind(
    main_mod .. " + V",
    hl.dsp.window.float({ action = "toggle" })
)
hl.bind(
    main_mod .. " + P",
    hl.dsp.window.pseudo()
)
hl.bind(
    main_mod .. " + J",
    hl.dsp.layout("togglesplit")
)

-- Move focus with mainMod + arrow keys
hl.bind(
    main_mod .. " + left",
    hl.dsp.focus({ direction = "left" })
)
hl.bind(
    main_mod .. " + right",
    hl.dsp.focus({ direction = "right" })
)
hl.bind(
    main_mod .. " + up",
    hl.dsp.focus({ direction = "up" })
)
hl.bind(
    main_mod .. " + down",
    hl.dsp.focus({ direction = "down" })
)

-- zoom
local MAX_ZOOM = 10
local MIN_ZOOM = 1
local ZOOM_TOGGLE_FACTOR = 1.5

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

hl.bind("SUPER + Z", zoom)
hl.bind("SUPER + equal", function()
    zoom(0.5)
end, {repeating = true})
hl.bind("SUPER + minus", function()
    zoom(-0.5)
end, {repeating = true})


-- workspace
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(
        main_mod .. " + " .. key,
        hl.dsp.focus({
            workspace = i,
        })
    )
    hl.bind(
        main_mod .. " + SHIFT + " .. key,
        hl.dsp.window.move({
            workspace = i,
        })
    )
end

-- special workspace
hl.bind(
    main_mod .. " + S",
    hl.dsp.workspace.toggle_special("magic")
)
hl.bind(
    main_mod .. " + SHIFT + S",
    hl.dsp.window.move({ workspace = "special:magic" })
)

-- Scroll through existing workspace
hl.bind(
    main_mod .. " + mouse_down",
    hl.dsp.focus({ workspace = "e+1" })
)
hl.bind(
    main_mod .. " + mouse_up",
    hl.dsp.focus({ workspace = "e-1" })
)

-- system
hl.bind(
    main_mod .. " + M",
    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
hl.bind(
    main_mod .. " + N",
    hl.dsp.exec_cmd("systemctl suspend")
)
hl.bind(
    main_mod .. " + SHIFT + N",
    hl.dsp.exec_cmd("systemctl suspend && hyprlock")
)
hl.bind(
    "INSERT",
    hl.dsp.exec_cmd("hyprctl switchxkblayout at-translated-set-2-keyboard next")
)
hl.bind(
    "ALT + less",
    hl.dsp.exec_cmd("switchxkblayout at-translated-set-2-keyboard next")
)
hl.bind(
    "CTRL + less",
    hl.dsp.exec_cmd("switchxkblayout at-translated-set-2-keyboard next")
)


-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    {
        locked = true,
        repeating = true,
    }
)
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    {
        locked = true,
        repeating = true,
    }
)
hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    {
        locked = true,
        repeating = true,
    }
)
hl.bind(
    "XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    {
        locked = true,
        repeating = true,
    }
    )
hl.bind(
    "XF86MonBrightnessUp",
    hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),
    {
        locked = true,
        repeating = true,
    }
)
hl.bind(
    "XF86MonBrightnessDown",
    hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),
    {
        locked = true,
        repeating = true,
    }
)
hl.bind(
    "XF86WLAN",
    hl.dsp.exec_cmd(wifi_bt)
)
hl.bind(
    "XF86Display",
    hl.dsp.exec_cmd(display_manager)
)
hl.bind(
    "XF86LaunchA",
    hl.dsp.exec_cmd(terminal_0)
)


-- Requires playerctl
hl.bind(
    "XF86AudioNext",
    hl.dsp.exec_cmd("playerctl next"),
    {
        locked = true,
    }
)
hl.bind(
    "XF86AudioPause",
    hl.dsp.exec_cmd("playerctl play-pause"),
    {
        locked = true,
    }
)
hl.bind(
    "XF86AudioPlay",
    hl.dsp.exec_cmd("playerctl play-pause"),
    {
        locked = true,
    }
)
hl.bind(
    "XF86AudioPrev",
    hl.dsp.exec_cmd("playerctl previous"),
    {
        locked = true,
    }
)

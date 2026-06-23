-- https://wiki.hypr.land/
-- default variables
local main_mod     = "SUPER"
local terminal_0   = "ghostty"
local terminal_1   = "foot"
local file_manager = "ghostty -e spf"
local browser      = "librewolf"
local file_editor  = "ghostty -e nvim"
local display      = "killall nwg-displays || nwg-displays"
local whiteboard   = "wayscriber --daemon-toggle"
local music        = " mpd && until mpc status >/dev/null 2>&1; do sleep 1; done; mpd-mpris"
local soundeffect  = "easyeffects --gapplication-service"
local wifi_bt      = "~/.config/hypr/wifi-bt-toggle.sh"
local app_menu     = "killall rofi || rofi -show run -theme /home/dash-/.config/rofi/theme.rasi"
local status_bar   = "killall waybar || waybar"
local wallpaper    = "swaybg -m fill -i /home/$USER/.config/hypr/epic-cat.jpg"
local idle         = "(killall hypridle && notify-send 'stop hypridle') || (notify-send 'start hypridle' && hypridle)"
local polkit       = "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
local tool         = "foot -e btop"
local screenshot   = "~/.config/hypr/screenshot.sh"

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

-- https://wiki.hypr.land/Configuring/Basics/Autostart/
-- autostart
hl.on("hyprland.start", function ()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    -- hl.exec_cmd(terminal_0)
    hl.exec_cmd("hyprpm reload")
    hl.exec_cmd(status_bar)
    hl.exec_cmd(wallpaper)
    hl.exec_cmd(idle)
    hl.exec_cmd("mako")
    hl.exec_cmd(polkit)
    hl.exec_cmd(music)
    hl.exec_cmd(soundeffect)
    hl.exec_cmd("wayscriber --daemon")
end)

-- https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
  output   = "VGA-1",
  mode     = "1440x900@74.98",
  position = "0x0",
  scale    = 1,
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        border_size     = 0,
        gaps_in         = 1,
        gaps_out        = 0,
        float_gaps      = 0,
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
        layout                  = "dwindle",
        no_focus_fallback       = false,
        resize_on_border        = true,
        extend_border_grab_area = 15,
        hover_icon_on_border    = true,
        allow_tearing           = false,
        resize_corner           = 0,
        modal_parent_blocking   = false,
        locale                  = "en_US",
        snap = {
            enabled        = true,
            window_gap     = 10,
            monitor_gap    = 10,
            border_overlap = false,
            respect_gaps   = false,
        },
    },
    decoration                = {
        rounding              = 4,
        rounding_power        = 10.0,
        active_opacity        = 1.0,
        inactive_opacity      = 1.0,
        fullscreen_opacity    = 1.0,
        dim_modal             = true,
        dim_inactive          = true,
        dim_strength          = 0.2,
        dim_special           = 0.2,
        dim_around            = 0.4,
        screen_shader         = "",
        border_part_of_window = true,
        blur = {
            enabled                   = false,
            size                      = 2,
            passes                    = 3,
            ignore_opacity            = true,
            new_optimizations         = true,
            xray                      = false,
            noise                     = 0.0,
            contrast                  = 0.8916,
            brightness                = 1.0,
            vibrancy                  = 0.1696,
            vibrancy_darkness         = 0.0,
            special                   = false,
            popups                    = false,
            popups_ignorealpha        = 0.2,
            input_methods             = false,
            input_methods_ignorealpha = 0.2,
        },
        shadow = {
            enabled        = false,
            range          = 5,
            render_power   = 3,
            sharp          = false,
            color          = 0x000000aa,
            color_inactive = 0x000000aa,
            offset = {
                0,
                0,
            },
            scale          = 1.0,
        },
        glow = {
            enabled        = false,
            range          = 4,
            render_power   = 2,
            color          = 0xeeffffff,
            color_inactive = 0xeeffff88,
        },
    },
    animations = {
        enabled              = true,
        workspace_wraparound = false,
    },
    input = {
        kb_model                    = "",
        kb_layout                   = "us, ir",
        kb_variant                  = "",
        kb_options                  = "grp:rwin_toggle, grp:win_space_toggle, ctrl:nocaps, grp_led:scroll, shift:both_capslock",
        kb_rules                    = "",
        kb_file                     = "",
        numlock_by_default          = true,
        resolve_binds_by_sym        = false,
        repeat_rate                 = 40,
        repeat_delay                = 400,
        sensitivity                 = 0.0,
        accel_profile               = "adaptive",
        force_no_accel              = false,
        rotation                    = 0,
        left_handed                 = false,
        scroll_points               = "",
        scroll_method               = "2fg",
        scroll_button               = 0,
        scroll_button_lock          = false,
        scroll_factor               = 1.0,
        natural_scroll              = false,
        follow_mouse                = 1,
        follow_mouse_shrink         = 0,
        follow_mouse_threshold      = 0.0,
        focus_on_close              = 1,
        mouse_refocus               = true,
        float_switch_override_focus = 2,
        special_fallthrough         = false,
        off_window_axis_events      = false,
        emulate_discrete_scroll     = 1,
        touchpad = {
            disable_while_typing    = false,
            natural_scroll          = true,
            scroll_factor           = 1.0,
            middle_button_emulation = false,
            tap_button_map          = "lrm",
            clickfinger_behavior    = true,
            tap_to_click            = true,
            drag_lock               = 1,
            tap_and_drag            = true,
            flip_x                  = false,
            flip_y                  = false,
            drag_3fg                = 0,
        },
        touchdevice = {
            transform = -1,
            output    = "auto",
            enabled   = true,
        },
        virtualkeyboard = {
            share_states             = 2,
            release_pressed_on_close = false,
        },
        tablet = {
            transform                = -1,
            output                   = "",
            region_position          = {0, 0},
            absolute_region_position = false,
            region_size              = {0, 0},
            relative_input           = false,
            left_handed              = false,
            active_area_size         = {0, 0},
            active_area_position     = {0, 0},
        },
    },
    gestures = {
        workspace_swipe_distance                 = 300,
        workspace_swipe_touch                    = false,
        workspace_swipe_invert                   = true,
        workspace_swipe_touch_invert             = false,
        workspace_swipe_min_speed_to_force       = 30,
        workspace_swipe_cancel_ratio             = 0.5,
        workspace_swipe_create_new               = true,
        workspace_swipe_direction_lock           = true,
        workspace_swipe_direction_lock_threshold = 10,
        workspace_swipe_forever                  = false,
        workspace_swipe_use_r                    = false,
        close_max_timeout                        = 1000,
    },
    group = {
        auto_group                           = true,
        insert_after_current                 = true,
        focus_removed_window                 = true,
        drag_into_group                      = 1,
        merge_groups_on_drag                 = true,
        merge_groups_on_groupbar             = true,
        merge_floated_into_tiled_on_groupbar = false,
        group_on_movetoworkspace             = false,
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
            enabled                    = true,
            font_family                = "",
            font_size                  = 8,
            font_weight_active         = "normal",
            font_weight_inactive       = "normal",
            gradients                  = false,
            height                     = 14,
            indicator_gap              = 0,
            indicator_height           = 3,
            stacked                    = false,
            priority                   = 3,
            render_titles              = true,
            text_offset                = 0,
            text_padding               = 0,
            scrolling                  = true,
            rounding                   = 1,
            rounding_power             = 2.0,
            gradient_rounding          = 2,
            gradient_rounding_power    = 2.0,
            round_only_edges           = true,
            gradient_round_only_edges  = true,
            text_color                 = 0xffffffff,
            text_color_inactive        = 0xffffffff,
            text_color_locked_active   = 0xffffffff,
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
            gaps_in            = 2,
            gaps_out           = 2,
            keep_upper_gap     = true,
            middle_click_close = true,
            blur               = false,
        },
    },
    misc = {
        disable_hyprland_logo          = true,
        disable_splash_rendering       = true,
        disable_scale_notification     = false,
        col = {
            splash = 0xffffffff,
        },
        font_family                    = "Fira Code Nerd Font Propo",
        splash_font_family             = "Fira Code Nerd Font Propo",
        force_default_wallpaper        = -1,
        vrr                            = 1,
        mouse_move_enables_dpms        = true,
        key_press_enables_dpms         = true,
        name_vk_after_proc             = true,
        always_follow_on_dnd           = true,
        layers_hog_keyboard_focus      = true,
        animate_manual_resizes         = true,
        animate_mouse_windowdragging   = false,
        disable_autoreload             = false,
        enable_swallow                 = false,
        swallow_regex                  = "",
        focus_on_activate              = false,
        mouse_move_focuses_monitor     = true,
        allow_session_lock_restore     = false,
        session_lock_xray              = false,
        background_color               = 0x000000ff,
        close_special_on_empty         = true,
        on_focus_under_fullscreen      = 2,
        exit_window_retains_fullscreen = false,
        initial_workspace_tracking     = 0,
        middle_click_paste             = true,
        render_unfocused_fps           = 30,
        disable_xdg_env_checks         = false,
        lockdead_screen_delay          = 3000,
        enable_anr_dialog              = true,
        anr_missed_pings               = 10,
        size_limits_tiled              = false,
        disable_watchdog_warning       = true,
    },
    layout = {
        single_window_aspect_ratio           = {0, 0},
        single_window_aspect_ratio_tolerance = 0.1,
    },
    dwindle = {
        force_split                  = 0,
        preserve_split               = true,
        smart_split                  = false,
        smart_resizing               = true,
        permanent_direction_override = false,
        special_scale_factor         = 1,
        split_width_multiplier       = 1.0,
        use_active_for_splits        = true,
        default_split_ratio          = 1.0,
        split_bias                   = 0,
        precise_mouse_move           = false,
    },
    scrolling = {
        fullscreen_on_one_column = true,
        column_width = 0.5,
        focus_fit_method = 1,
        follow_focus = true,
        follow_min_visible = 0.4,
        explicit_column_widths = "0.333, 0.5, 0.667, 1.0",
        wrap_focus = true,
        wrap_swapcol = true,
        direction = "right",
    },
    binds = {
        pass_mouse_when_bound             = false,
        scroll_event_delay                = 50,
        workspace_back_and_forth          = false,
        hide_special_on_workspace_change  = true,
        allow_workspace_cycles            = true,
        workspace_center_on               = 0,
        focus_preferred_method            = 0,
        ignore_group_lock                 = false,
        movefocus_cycles_fullscreen       = true,
        window_direction_monitor_fallback = true,
        disable_keybind_grabbing          = true,
        allow_pin_fullscreen              = false,
        drag_threshold                    = 0,
    },
    xwayland = {
        enabled                = true,
        use_nearest_neighbor   = true,
        force_zero_scaling     = false,
        create_abstract_socket = false,
    },
    opengl = {
        nvidia_anti_flicker = true,
    },
    render = {
        direct_scanout             = 2,
        expand_undersized_textures = true,
        xp_mode                    = false,
        ctm_animation              = 2,
        cm_enabled                 = true,
        send_content_type          = true,
        cm_auto_hdr                = 1,
        new_render_scheduling      = true,
        non_shader_cm              = 2,
        non_shader_cm_interop      = 2,
        cm_sdr_eotf                = "default",
        commit_timing_enabled      = true,
        use_fp16                   = 1,
        keep_unmodified_copy       = 2,
        use_shader_blur_blend      = false,
    },
    cursor = {
        invisible                       = false,
        sync_gsettings_theme            = true,
        no_hardware_cursors             = 2,
        no_break_fs_vrr                 = 2,
        min_refresh_rate                = 60,
        hotspot_padding                 = 1,
        inactive_timeout                = 10,
        no_warps                        = false,
        persistent_warps                = false,
        warp_on_change_workspace        = 0,
        warp_on_toggle_special          = 0,
        default_monitor                 = "",
        zoom_factor                     = 1.0,
        zoom_rigid                      = false,
        zoom_detached_camera            = false,
        enable_hyprcursor               = true,
        hide_on_key_press               = false,
        hide_on_touch                   = true,
        hide_on_tablet                  = true,
        use_cpu_buffer                  = 2,
        warp_back_after_non_mouse_input = false,
        zoom_disable_aa                 = true,
    },
    ecosystem = {
        no_update_news      = true,
        no_donation_nag     = true,
        enforce_permissions = true,
    },
    quirks = {
        prefer_hdr = 0,
    },
    plugin = {
        hyprexpo = {
            columns = 3,
            gaps_in = 0,
            gaps_out = 0,
            bg_col = 0xffffffff,
            workspace_method = "center current",
            skip_empty = 9,
            max_workspace = 0,
            gesture_distance = 200,
            cancel_key = "escape",
            show_cursor = 1,
            show_pinned_windows = 0,
        },
        dynamic_cursors = {
            enabled = true,
            mode = "tilt",
            threshold = 2,
            rotate = {
                length = 24,
                offset = 0.0,
            },
            tilt = {
                limit = 2000,
                activation = "negative_quadratic",
                window = 200,
                full = 60,
            },
            stretch = {
                limit = 800,
                activation = "negative_quadratic",
                window = 200,
            },
            shake = {
                enabled = true,
                threshold = 4.0,
                base = 1.0,
                speed = 2.0,
                influence = 0.0,
                limit = 5.0,
                timeout = 1000,
                effects = true,
                ipc = false,
            },
            hyprcursor = {
                nearest = 1,
                enabled = true,
                resolution = -1,
                fallback = "clientside",
            },
        },
    },
})

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

-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- workspace rule
hl.workspace_rule({
    workspace = "1",
    persistent = false,
    layout = "dwindle",
})
hl.workspace_rule({
    workspace = "2",
    persistent = false,
    layout = "dwindle",
})
hl.workspace_rule({
    workspace = "3",
    persistent = false,
    layout = "dwindle",
})
hl.workspace_rule({
    workspace = "4",
    persistent = false,
    layout = "dwindle",
})
hl.workspace_rule({
    workspace = "5",
    persistent = false,
    layout = "dwindle",
})
hl.workspace_rule({
    workspace = "6",
    persistent = false,
    layout = "dwindle",
})
hl.workspace_rule({
    workspace = "7",
    persistent = false,
    layout = "dwindle",
})
hl.workspace_rule({
    workspace = "8",
    persistent = false,
    layout = "dwindle",
})
hl.workspace_rule({
    workspace = "9",
    persistent = false,
    layout = "dwindle",
})
hl.workspace_rule({
    workspace = "10",
    persistent = false,
    layout = "dwindle",
})

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

-- animations
hl.animation({
    leaf    = "global",
    enabled = true,
    speed   = 10,
    bezier  = "default",
})
hl.animation({
    leaf    = "border",
    enabled = true,
    speed   = 1,
    bezier  = "default",
})
hl.animation({
    leaf    = "borderangle",
    enabled = true,
    speed   = 10,
    bezier  = "default",
})
hl.animation({
    leaf    = "fade",
    enabled = true,
    speed   = 4,
    bezier  = "default",
})
hl.animation({
    leaf    = "workspaces",
    enabled = true,
    speed   = 7,
    bezier  = "punchy_window_curve",
})
hl.animation({
    leaf    = "zoomFactor",
    enabled = true,
    speed   = 4,
    bezier  = "default",
})
hl.animation({
    leaf    = "windows",
    enabled = true,
    speed   = 4,
    bezier  = "default",
})
hl.animation({
    leaf    = "windowsIn",
    enabled = true,
    speed   = 7,
    bezier  = "from_bottom_curve",
    style   = "slide bottom",
})
hl.animation({
    leaf    = "windowsOut",
    enabled = true,
    speed   = 10,
    bezier  = "from_bottom_curve",
    style   = "slide bottom",
})
hl.animation({
    leaf    = "specialWorkspaceIn",
    enabled = true,
    speed   = 6,
    bezier  = "from_bottom_curve",
    style   = "slide top",
})
hl.animation({
    leaf    = "specialWorkspaceOut",
    enabled = true,
    speed   = 10,
    bezier  = "from_bottom_curve",
    style   = "slide bottom",
})

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
        hl.exec_cmd(app_menu)
    end
})
hl.gesture({
   fingers   = 4,
   direction = "down",
   action    = "close",
})

-- https://wiki.hypr.land/Configuring/Basics/Binds/
-- open or toggle apps with main_mod + key
hl.bind(
    main_mod .. " + RETURN",
    hl.dsp.exec_cmd(terminal_0),
    {
        description = "open favourite terminal 0",
    }
)
hl.bind(
    main_mod .. " + KP_ENTER",
    hl.dsp.exec_cmd(terminal_0),
    {
        description = "open favourite terminal 0",
    }
)
hl.bind(
    main_mod .. " + T",
    hl.dsp.exec_cmd(terminal_1),
    {
        description = "open favourite terminal 1",
    }
)
hl.bind(
    main_mod .. " + D",
    hl.dsp.exec_cmd(app_menu),
    {
        description = "open app launcher menu",
    }
)
hl.bind(
    main_mod .. " + E",
    hl.dsp.exec_cmd(file_manager),
    {
        description = "open favourite file manager",
    }
)
hl.bind(
    main_mod .. " + SHIFT + E",
    hl.dsp.exec_cmd(file_editor),
    {
        description = "open favourite file manager",
    }
)
hl.bind(
    main_mod .. " + R",
    hl.dsp.exec_cmd("hyprland-run"),
    {
        description = "hyprland run",
    }
)
hl.bind(
    main_mod .. " + G",
    hl.dsp.exec_cmd(browser),
    {
        description = "open favourite internet browser",
    }
)
hl.bind(
    main_mod .. " + W",
    hl.dsp.exec_cmd(status_bar),
    {
        description = "toggle on/off status bar",
    }
)
hl.bind(
    main_mod .. " + I",
    hl.dsp.exec_cmd(idle),
    {
        description = "toggle on/off display idle mode",
    }
)
hl.bind(
    main_mod .. " + O",
    hl.dsp.exec_cmd(whiteboard),
    {
        description = "toggle on/off favourite whiteboard app",
    }
)

--Screenshot
hl.bind(
    "Print",
    hl.dsp.exec_cmd(screenshot .. " -a"),
    {
        description = "print full screen(saved on ~/Pictures/)",
    }
)
hl.bind(
    "SHIFT + Print",
    hl.dsp.exec_cmd(screenshot),
    {
        description = "pring screen with given file adress and screen size",
    }
)

-- control window with main_mod + key
hl.bind(
    main_mod .. " + C",
    hl.dsp.window.close(),
    {
        description = "close focused window",
    }
)
hl.bind(
    main_mod .. " + SHIFT + C",
    hl.dsp.window.kill(),
    {
        description = "kill focused window",
    }
)
hl.bind(
    main_mod .. " + Q",
    hl.dsp.window.close(),
    {
        description = "close focused window",
    }
)
hl.bind(
    main_mod .. " + SHIFT + Q",
    hl.dsp.window.kill(),
    {
        description = "kill focused window",
    }
)
hl.bind(
    main_mod .. " + V",
    hl.dsp.window.float({ action = "toggle" }),
    {
        description = "floating focused window",
    }
)
hl.bind(
    main_mod .. " + P",
    hl.dsp.window.pseudo(),
    {
        description = "pseudo focused window",
    }
)
hl.bind(
    main_mod .. " + X",
    hl.dsp.layout("togglesplit"),
    {
        description = "split window vertical/horizontal",
    }
)
hl.bind(
    main_mod .. " + F",
    hl.dsp.window.fullscreen({
        mode = "maximized",
        action = "toggle",
    }),
    {
        description = "toggle maximize window",
    }
)
hl.bind(
    "F11",
    hl.dsp.window.fullscreen({
        mode = "fullscreen",
        action = "toggle",
    }),
    {
        description = "toggle fullscreen window",
    }
)

-- move focus with main_mod + arrow_keys
hl.bind(
    main_mod .. " + left",
    hl.dsp.focus({ direction = "left" }),
    {
        description = "focus to left window",
    }
)
hl.bind(
    main_mod .. " + right",
    hl.dsp.focus({ direction = "right" }),
    {
        description = "focus to right window",
    }
)
hl.bind(
    main_mod .. " + up",
    hl.dsp.focus({ direction = "up" }),
    {
        description = "focus to up window",
    }
)
hl.bind(
    main_mod .. " + down",
    hl.dsp.focus({ direction = "down" }),
    {
        description = "focus to down window",
    }
)

-- move focus with main_mod + vim_keys
hl.bind(
    main_mod .. " + H",
    hl.dsp.focus({ direction = "left" }),
    {
        description = "focus to left window",
    }
)
hl.bind(
    main_mod .. " + L",
    hl.dsp.focus({ direction = "right" }),
    {
        description = "focus to right window",
    }
)
hl.bind(
    main_mod .. " + K",
    hl.dsp.focus({ direction = "up" }),
    {
        description = "focus to up window",
    }
)
hl.bind(
    main_mod .. " + J",
    hl.dsp.focus({ direction = "down" }),
    {
        description = "focus to down window",
    }
)


-- move window with main_mod + shift + arrow_keys
hl.bind(
    main_mod .. " + SHIFT + left",
    hl.dsp.window.move({
        x = -30,
        y = 0,
        relative = true,
    }),
    {
        repeating = true,
        description = "move window to left",
    }
)
hl.bind(
    main_mod .. " + SHIFT + right",
    hl.dsp.window.move({
        x = 30,
        y = 0,
        relative = true,
    }),
    {
        repeating = true,
        description = "move window to right",
    }
)
hl.bind(
    main_mod .. " + SHIFT + up",
    hl.dsp.window.move({
        x = 0,
        y = -30,
        relative = true,
    }),
    {
        repeating = true,
        description = "move window to up",
    }
)
hl.bind(
    main_mod .. " + SHIFT + down",
    hl.dsp.window.move({
        x = 0,
        y = 30,
        relative = true,
    }),
    {
        repeating = true,
        description = "move window to down",
    }
)

-- move window with main_mod + shift + vim_keys
hl.bind(
    main_mod .. " + SHIFT + H",
    hl.dsp.window.move({
        x = -30,
        y = 0,
        relative = true,
    }),
    {
        repeating = true,
        description = "move window to left",
    }
)
hl.bind(
    main_mod .. " + SHIFT + L",
    hl.dsp.window.move({
        x = 30,
        y = 0,
        relative = true,
    }),
    {
        repeating = true,
        description = "move window to right",
    }
)
hl.bind(
    main_mod .. " + SHIFT + K",
    hl.dsp.window.move({
        x = 0,
        y = -30,
        relative = true,
    }),
    {
        repeating = true,
        description = "move window to up",
    }
)
hl.bind(
    main_mod .. " + SHIFT + J",
    hl.dsp.window.move({
        x = 0,
        y = 30,
        relative = true,
    }),
    {
        repeating = true,
        description = "move window to down",
    }
)

-- resize window with main_mod + ctrl + arrow_keys
hl.bind(
    main_mod .. " + CTRL + left",
    hl.dsp.window.resize({
        x = -10,
        y = 0,
        relative = true,
    }),
    {
        repeating = true,
        description = "lower vertical window size",
    }
)
hl.bind(
    main_mod .. " + CTRL + right",
    hl.dsp.window.resize({
        x = 10,
        y = 0,
        relative = true,
    }),
    {
        repeating = true,
        description = "raise vertical window size",
    }
)
hl.bind(
    main_mod .. " + CTRL + up",
    hl.dsp.window.resize({
        x = 0,
        y = -10,
        relative = true,
    }),
    {
        repeating = true,
        description = "lower horizontal window size",
    }
)
hl.bind(
    main_mod .. " + CTRL + down",
    hl.dsp.window.resize({
        x = 0,
        y = 10,
        relative = true,
    }),
    {
        repeating = true,
        description = "raise horizontal window size",
    }
)

-- resize window with main_mod + ctrl + vim_keys
hl.bind(
    main_mod .. " + CTRL + H",
    hl.dsp.window.resize({
        x = -10,
        y = 0,
        relative = true,
    }),
    {
        repeating = true,
        description = "lower vertical window size",
    }
)
hl.bind(
    main_mod .. " + CTRL + L",
    hl.dsp.window.resize({
        x = 10,
        y = 0,
        relative = true,
    }),
    {
        repeating = true,
        description = "raise vertical window size",
    }
)
hl.bind(
    main_mod .. " + CTRL + K",
    hl.dsp.window.resize({
        x = 0,
        y = -10,
        relative = true,
    }),
    {
        repeating = true,
        description = "lower horizontal window size",
    }
)
hl.bind(
    main_mod .. " + CTRL + J",
    hl.dsp.window.resize({
        x = 0,
        y = 10,
        relative = true,
    }),
    {
        repeating = true,
        description = "raise horizontal window size",
    }
)

-- move/resize windows with main_mod + mouse_keys and dragging
hl.bind(
    main_mod .. " + mouse:272",
    hl.dsp.window.drag(),
    {
        mouse = true,
        description = "dragging window",
    }
)
hl.bind(
    main_mod .. " + mouse:273",
    hl.dsp.window.resize(),
    {
        mouse = true,
        description = "resizing window",
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
    main_mod .. " + Z",
    zoom,
    {
        description = "toggle 2x zoom",
    }
)

-- cursor zoom with main_mod + ctrl + "="/"-"
hl.bind(
    main_mod .. " + CTRL + equal",
    function()
        zoom(0.5)
    end,
    {
        repeating = true,
        description = "zoom in to cursor",
    }
)
hl.bind(
    main_mod .. " + CTRL + minus",
    function()
        zoom(-0.5)
    end,
    {
        repeating = true,
        description = "zoom out to cursor",
    }
)

-- cursor zoom with main_mod + ctrl + mouse_scroll
hl.bind(
    main_mod .. " + CTRL + mouse_down",
    function()
        zoom(0.5)
    end,
    {
        description = "zoom in to cursor",
    }
)
hl.bind(
    main_mod .. " + CTRL + mouse:275",
    function()
        zoom(0.5)
    end,
    {
        description = "zoom in to cursor",
    }
)
hl.bind(
    main_mod .. " + CTRL + mouse_up",
    function()
        zoom(-0.5)
    end,
    {
        description = "zoom out to cursor",
    }
)
hl.bind(
    main_mod .. " + CTRL + mouse:276",
    function()
        zoom(-0.5)
    end,
    {
        description = "zoom out to cursor",
    }
)

-- change and move to workspace with main_mod + number and main_mod + shift + number
for i = 1, 10 do
    local key = i % 10
    hl.bind(
        main_mod .. " + " .. key,
        hl.dsp.focus({
            workspace = i,
        }),
        {
            description = "change workspace focus",
        }
    )
    hl.bind(
        main_mod .. " + SHIFT + " .. key,
        hl.dsp.window.move({
            workspace = i,
        }),
        {
            description = "move window to other workspace",
        }
    )
end

-- change workspaces with main_mod + mouse_scroll
hl.bind(
    main_mod .. " + mouse_down",
    hl.dsp.focus({ workspace = "e+1" }),
    {
        description = "scroll to next workspace",
    }
)
hl.bind(
    main_mod .. " + mouse:276",
    hl.dsp.focus({ workspace = "e+1" }),
    {
        description = "scroll to next workspace",
    }
)
hl.bind(
    main_mod .. " + mouse_up",
    hl.dsp.focus({ workspace = "e-1" }),
    {
        description = "scroll to previous workspace",
    }
)
hl.bind(
    main_mod .. " + mouse:275",
    hl.dsp.focus({ workspace = "e-1" }),
    {
        description = "scroll to previous workspace",
    }
)

-- scroll through scrolling layout with main_mod + '.'/','
hl.bind(
    main_mod .. " + period",
    hl.dsp.layout("move +col"),
    {
        description = "scroll to next window",
    }
)
hl.bind(
    main_mod .. " + comma",
    hl.dsp.layout("move -col"),
    {
        description = "scroll to previous window",
    }
)
hl.bind(
    main_mod .. " + SHIFT + period",
    hl.dsp.layout("swapcol r"),
    {
        description = "move window to next scroll layout",
    }
)
hl.bind(
    main_mod .. " + SHIFT + comma",
    hl.dsp.layout("swapcol l"),
    {
        description = "move to previous scroll layout",
    }
)

-- scroll through scrolling layout with main_mod + mouse_scroll
hl.bind(
    main_mod .. " + SHIFT + ",
    hl.dsp.layout("move +col")
)
hl.bind(
    main_mod .. " + SHIFT + ",
    hl.dsp.layout("move -col")
)
hl.bind(
    main_mod .. " + period",
    hl.dsp.layout("move +col")
)
hl.bind(
    main_mod .. " + comma",
    hl.dsp.layout("move -col")
)

-- toggle and move window to special workspace with main_mod + s and main_mod + shift + s
hl.bind(
    main_mod .. " + S",
    hl.dsp.workspace.toggle_special("magic"),
    {
        description = "toggle special workspace",
    }
)
hl.bind(
    main_mod .. " + SHIFT + S",
    hl.dsp.window.move({ workspace = "special:magic" }),
    {
        description = "move window to special workspace",
    }
)

-- system keybinds(exit, suspend, change layout) with main_mod + key
hl.bind(
    main_mod .. " + M",
    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"),
    {
        description = "exit hyprland",
    }
)
hl.bind(
    main_mod .. " + N",
    hl.dsp.exec_cmd("systemctl suspend"),
    {
        description = "suspend the system",
    }
)
hl.bind(
    main_mod .. " + SHIFT + N",
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


-- change volume and toggle mute with main_mod + multimedia_keys
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

-- launching apps with laptop multimedia_keys
hl.bind(
    "XF86WLAN",
    hl.dsp.exec_cmd(wifi_bt),
    {
        description = "toggle on/off wifi and bluetooth",
    }
)
hl.bind(
    "XF86Display",
    hl.dsp.exec_cmd(display),
    {
        description = "open display settings",
    }
)
hl.bind(
    "XF86LaunchA",
    hl.dsp.exec_cmd(terminal_0),
    {
        description = "open the favourite terminal 0",
    }
)
hl.bind(
    "XF86Search",
    hl.dsp.exec_cmd(browser),
    {
        description = "open app launcher menu",
    }
)
hl.bind(
    "XF86Explorer",
    hl.dsp.exec_cmd(app_menu),
    {
        description = "open app launcher menu",
    }
)
hl.bind(
    "XF86Tools",
    hl.dsp.exec_cmd(tool),
    {
        description = "open the favourite tool",
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
    main_mod .. " + XF86AudioRaiseVolume",
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
    main_mod .. " + XF86AudioMute",
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
    main_mod .. " + XF86AudioMicMute",
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
    main_mod .. " + XF86AudioLowerVolume",
    hl.dsp.exec_cmd("playerctl previous"),
    {
        locked = true,
        description = "play previous audio/video",
    }
)
hl.bind(
    main_mod .. " + CTRL + XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("playerctl position 5+"),
    {
        locked = true,
        description = "raise the position of audio/video",
    }
)
hl.bind(
    main_mod .. " + CTRL + XF86AudioLowerVolume",
    hl.dsp.exec_cmd("playerctl position 5-"),
    {
        locked = true,
        description = "lower the position of audio/video",
    }
)

-- controling audio/video with main_mod + keys
hl.bind(
    main_mod .. " + P",
    hl.dsp.exec_cmd("playerctl play-pause"),
    {
        locked = true,
        description = "toggle play/pause",
    }
)
hl.bind(
    main_mod .. " + SHIFT + P",
    hl.dsp.exec_cmd("playerctl next"),
    {
        locked = true,
        description = "play next audio/video",
    }
)
hl.bind(
    main_mod .. " + CTRL + P",
    hl.dsp.exec_cmd("playerctl previous"),
    {
        locked = true,
        description = "play previous audio/video",
    }
)
hl.bind(
    main_mod .. " + SHIFT + CTRL + P",
    hl.dsp.exec_cmd("playerctl stop"),
    {
        locked = true,
        description = "stop played audio/video",
    }
)

-- plugins keybinds
hl.bind(
    main_mod .. " + A",
    function()
        hl.plugin.hyprexpo.expo("toggle")
    end,
    {
        description = "open hyprexpo menu",
    }
)

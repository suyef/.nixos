require("noctalia")

hl.monitor({
    output   = "eDP-1",
    mode     = "3840x2400@60",
    position = "auto",
    scale    = "2",
})


----------------------
-- Default programs --
----------------------

local terminal    = "alacritty"
local fileManager = "dolphin"
local menu        = "vicinae open"
local browser     = "zen"

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("GDK_SCALE", "1")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("XCURSOR_SIZE", "24")
hl.env("APPIMAGELAUNCHER_DISABLE", "1")
hl.env("OZONE_PLATFORM", "wayland")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("__GL_VRR_ALLOWED", "1")
hl.env("WLR_DRM_NO_ATOMIC", "1")
hl.env("XCURSOR_THEME","macOS")


-----------------------
-------autostart-------
-----------------------

hl.on("hyprland.start", function ()
	hl.exec_cmd("noctalia &")
	hl.exec_cmd("vicinae server")
end)

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in          = 0,
        gaps_out         = 0,
        border_size      = 0,

        col              = {
            active_border   = { colors = { "rgba(d4be98ee)", "rgba(d4be98ee)" }, angle = 45 },
            inactive_border = "rgba(2828284f)",
        },

        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    cursor = { enable_hyprcursor = false, no_hardware_cursors = true, },

    decoration = {
        rounding         = 0,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        blur             = {
            enabled  = true,
            size     = 8,
            passes   = 2,
            vibrancy = 0.1696,
        },
    },
    animations = {
        enabled = false,
    },
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })
hl.animation({ leaf = "global", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 2.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 2.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 0.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 0.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 0.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 2.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 2.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 2, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 0.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 0.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 0.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 0.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 0.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 0.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 3.4, bezier = "quick" })

hl.window_rule({
    name      = "zen-on-ws1",
    match     = { class = "^(zen)$" },
    workspace = "1 silent"
})

hl.config({
    dwindle = {
        preserve_split = true, 
	force_split = 2,
    },
})

hl.config({
    master = {
	-- kanye
        new_status = "slave",
	new_on_top = false,
	special_scale_factor = 0.95,
    },
})

hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
	--explicit_column_widths = "0.5, 0.6, 1.0",
	column_width = 0.6,
	follow_min_visible = 1.0,
	focus_fit_method = 0,
    },
})

hl.config({
    misc = {
        force_default_wallpaper = 1,
        disable_hyprland_logo   = true, 
	focus_on_activate = true,
	vrr = 0,
	disable_splash_rendering = true,
    },
})



hl.config({
    input = {
        kb_layout    = "us",
        kb_variant   = "",
        kb_model     = "",
        kb_options   = "",
        kb_rules     = "",

        repeat_rate  = 35,
        repeat_delay = 200,
        follow_mouse = 1,
        sensitivity  = 0,
        touchpad     = {
            natural_scroll = true,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})


---------------------
---- KEYBINDINGS ----
---------------------

local main_mod = "SUPER" 

hl.bind(main_mod .. " + SPACE", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + SHIFT + F23", hl.dsp.exec_cmd(menu))
hl.bind(main_mod .. " + Q", hl.dsp.window.close())
hl.bind(main_mod .. " + SHIFT + M",
hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(main_mod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(main_mod .. " + O", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + X", hl.dsp.exec_cmd(menu))
hl.bind(main_mod .. " + P", hl.dsp.window.pseudo())
hl.bind(main_mod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(main_mod .. " + SHIFT + CTRL + L", hl.dsp.exec_cmd("swaylock"))

-- Move focus with main_mod + arrow keys
hl.bind(main_mod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(main_mod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(main_mod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Move workspaces around
hl.bind(main_mod .. " + SHIFT + H", hl.dsp.window.swap({ direction = "left" }))
hl.bind(main_mod .. " + SHIFT + L", hl.dsp.window.swap({ direction = "right" }))
hl.bind(main_mod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "up" }))
hl.bind(main_mod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "down" }))

hl.bind(main_mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(main_mod .. " + SHIFT + I", hl.dsp.layout("togglesplit"))

hl.bind(main_mod .. " + SHIFT + U", hl.dsp.window.move({ workspace = "special" }))
hl.bind(main_mod .. " + U", hl.dsp.workspace.toggle_special("special"))

-- Switch workspaces with main_mod + [0-9]
-- Move active window to a workspace with main_mod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces with main_mod + scroll
hl.bind(main_mod .. " + TAB", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(main_mod .. " + SHIFT + TAB", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with main_mod + LMB/RMB and dragging
--hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
--hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + CTRL + L", hl.dsp.window.drag(), { mouse = true })

hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("SUPER + ALT + L", hl.dsp.window.resize(), { mouse = true })



-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86WLAN", hl.dsp.exec_cmd("nmcli radio wifi toggle"), { locked = true })
hl.bind("XF86Refresh", hl.dsp.exec_cmd("xdotool key F5"), { locked = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------


-- Define layouts
local layouts = { "dwindle", "master", "scrolling" }
local current_layout_index = 1

-- Cycle function
local function cycle_layouts()
    current_layout_index = (current_layout_index % #layouts) + 1
    local new_layout = layouts[current_layout_index]
    
    -- Update the global layout setting
    hl.config({
        general = {
            layout = new_layout
        }
    })
    
    -- wip notification
    --hl.exec("notify-send 'Layout switched to: " .. new_layout .. "'")
end

hl.bind(main_mod .. "+ CTRL + TAB", cycle_layouts)

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name           = "suppress-maximize-events",
    match          = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name     = "fix-xwayland-drags",
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})


-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})


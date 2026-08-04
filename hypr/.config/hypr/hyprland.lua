-- https://wiki.hypr.land/Configuring/Start/

local active_border_color = "rgb(7c6f64)" -- dark_bg4
local inactive_border_color = "rgb(504945)" -- dark_bg2
local dark_bg4 = "rgb(7c6f64)" -- used for the shadow color below

---- MONITORS ----
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
hl.monitor({ output = "DP-1", mode = "2560x1440@170", position = "0x0", scale = 1 })
hl.monitor({ output = "DP-2", mode = "1920x1080@144", position = "-1920x0", scale = 1 })

-- Workspace-to-monitor assignment
hl.workspace_rule({ workspace = "1", monitor = "DP-1", default = true })
hl.workspace_rule({ workspace = "2", monitor = "DP-1" })
hl.workspace_rule({ workspace = "3", monitor = "DP-1" })
hl.workspace_rule({ workspace = "4", monitor = "DP-1" })
hl.workspace_rule({ workspace = "5", monitor = "DP-1" })
hl.workspace_rule({ workspace = "6", monitor = "DP-2", default = true })
hl.workspace_rule({ workspace = "7", monitor = "DP-2" })
hl.workspace_rule({ workspace = "8", monitor = "DP-2" })
hl.workspace_rule({ workspace = "9", monitor = "DP-2" })

-- Smart gaps / no gaps when only one window (pattern from Hyprland's own example config)
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({
    name = "no-gaps-wtv1",
    match = { float = false, workspace = "w[tv1]" },
    border_size = 0,
    rounding = 0,
})
hl.window_rule({
    name = "no-gaps-f1",
    match = { float = false, workspace = "f[1]" },
    border_size = 0,
    rounding = 0,
})

---- PROGRAMS ----
local terminal = "ghostty"
local fileManager = "nautilus"
local menu = "rofi -show drun"
local browser = "firefox"

---- AUTOSTART ----
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("bash -c '[[ $(hostnamectl hostname) == \"MADVILLAIN\" ]] && hyprctl keyword input:kb_options caps:escape'")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("bash -c '[[ $(hostnamectl hostname) == \"DANGERDOOM\" ]] && hyprctl keyword env LIBVA_DRIVER_NAME,nvidia && hyprctl keyword env GBM_BACKEND,nvidia-drm && hyprctl keyword env __GLX_VENDOR_LIBRARY_NAME,nvidia'")
    hl.exec_cmd(browser, { workspace = "1 silent" })
    hl.exec_cmd(terminal, { workspace = "2 silent" })
    hl.exec_cmd("discord", { workspace = "6 silent" })
    hl.exec_cmd("obsidian", { workspace = "8 silent" })
end)

---- ENVIRONMENT VARIABLES ----
hl.env("XCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct") -- change to qt6ct if you have that
hl.env("XDG_SESSION_TYPE", "wayland")

---- INPUT ----
hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.device({ name = "logitech-pro-x-1", sensitivity = -0.6 })
hl.device({ name = "epic-mouse-v1", sensitivity = -0.5 })
hl.device({ name = "logitech-usb-receiver", sensitivity = -0.8 })

---- LOOK AND FEEL ----
hl.config({
    general = {
        gaps_in = 4,
        gaps_out = 4,
        border_size = 2,
        col = {
            active_border = active_border_color,
            inactive_border = inactive_border_color,
        },
        layout = "dwindle",
        allow_tearing = false,
    },
    decoration = {
        rounding = 10,
        blur = {
            enabled = false,
            size = 3,
            passes = 1,
        },
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = dark_bg4,
        },
    },
    animations = {
        enabled = false,
    },
})

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

hl.config({
    dwindle = {
        preserve_split = true,
    },
    master = {
        -- UNCONFIRMED: original had `new_on_active = true`. The 0.55 example
        -- config only shows `new_status = "master"` (a string enum, not a
        -- bool), so this isn't a direct 1:1 swap — check the Master Layout
        -- wiki page for the value that matches your old behavior.
        new_status = "master",
    },
    misc = {
        force_default_wallpaper = 0,
    },
})

---- WINDOW RULES ----
hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- UNCONFIRMED: assigning a window to a workspace via window_rule effect
-- fields isn't shown in any 0.55 doc I could find — this mirrors the old
-- `workspace = N` windowrule keyword by analogy. Verify against the wiki.
hl.window_rule({ name = "discord-workspace", match = { class = "^(discord)$" }, workspace = "6" })
hl.window_rule({ name = "Discord-workspace", match = { class = "^(Discord)$" }, workspace = "6" })
hl.window_rule({ name = "dbeaver-workspace", match = { class = "^(DBeaver)$" }, workspace = "3" })
hl.window_rule({ name = "obsidian-workspace", match = { class = "^(obsidian)$" }, workspace = "8" })

hl.window_rule({
    name = "meet-popup-size",
    match = { class = "^(chromium)$", float = true },
    max_size = "480 270",
})

---- KEYBINDINGS ----
local mainMod = "SUPER"

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal), { locked = true })
hl.bind(mainMod .. " + W", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager), { locked = true })
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu), { locked = true })
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd('grim -g "$(slurp -o)" ~/screenshots/$(date +\'%s_grim.png\')'), { locked = true })
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("grim ~/screenshots/$(date +'%s_grim.png')"), { locked = true })
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd('wf-recorder -g "$(slurp)" -f ~/Videos/$(date +\'%Y-%m-%d-%H%M%S\').mp4'), { locked = true })
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("chatterino"), { locked = true })
-- UNCONFIRMED exact call shape for the fullscreen dispatcher in 0.55; check wiki if this errors.
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal .. " -e btop"), { locked = true })
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprlock"), { locked = true })
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("networkmanager_dmenu"), { locked = true })
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t"), { locked = true })

-- Move focus with mainMod + HJKL (vim-style, as in the original)
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))

-- Switch workspaces with mainMod + [0-9], move window with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })

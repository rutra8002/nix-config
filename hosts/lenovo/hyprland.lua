hl.monitor({
    output   = "DP-2",
    mode     = "3440x1440@180",
    position = "0x0",
    scale    = 1.25,
})

hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@60",
    position = "2752x0",
    scale    = 1.0,
})

local terminal = "kitty"

-- Autostart
hl.on("hyprland.start", function ()
  hl.exec_cmd("noctalia")
end)

hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Force Firefox-based browsers (Zen) to run as native Wayland clients,
-- otherwise they fall back to XWayland and screen-share/PipeWire capture breaks.
hl.env("MOZ_ENABLE_WAYLAND", "1")

-- Force Electron apps (Discord, VSCode, etc.) onto native Wayland + Ozone,
-- same reasoning: XWayland Electron apps can't use the PipeWire portal properly.
hl.env("NIXOS_OZONE_WL", "1")

hl.config({
  general = {
    gaps_in  = 5,
    gaps_out = 10,
  },
  decoration = {
    rounding       = 20,
    rounding_power = 2,
    shadow = {
      enabled      = true,
      range        = 4,
      render_power = 3,
      color        = 0xee1a1a1a,
    },
    blur = {
      enabled  = true,
      size     = 3,
      passes   = 2,
      vibrancy = 0.1696,
    },
  },
  input = {
    kb_layout  = "pl",
    kb_variant = "",
    kb_model   = "",
    kb_options = "",
    accel_profile  = "flat",
    sensitivity    = 0.0,
  },
  xwayland = {
    force_zero_scaling = true,
  },
})

-- Keybinds
local mainMod = "SUPER"
local ipc = "noctalia msg "

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())

for i = 1, 10 do
  local key = i % 10
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center"))
hl.bind(mainMod .. " + Comma", hl.dsp.exec_cmd(ipc .. "settings-toggle"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(ipc .. "panel-toggle clipboard"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(ipc .. "session lock"))

hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())

hl.bind("ALT + Tab", hl.dsp.exec_cmd(ipc .. "window-switcher"))

hl.bind("XF86AudioRaiseVolume",   hl.dsp.exec_cmd(ipc .. "volume-up"))
hl.bind("XF86AudioLowerVolume",   hl.dsp.exec_cmd(ipc .. "volume-down"))
hl.bind("XF86AudioMute",          hl.dsp.exec_cmd(ipc .. "volume-mute"))
hl.bind("XF86MonBrightnessUp",    hl.dsp.exec_cmd(ipc .. "brightness-up"))
hl.bind("XF86MonBrightnessDown",  hl.dsp.exec_cmd(ipc .. "brightness-down"))

-- Media playback 
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioStop",  hl.dsp.exec_cmd("playerctl stop"))

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd(ipc .. "screenshot-region"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(ipc .. "screenshot-fullscreen pick"))
hl.bind(mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd(ipc .. "screenshot-fullscreen all"))

hl.window_rule({
    match = { class = "dev.noctalia.Noctalia" },
    float = true,
    size  = { 1080, 920 },
})

hl.layer_rule({
  name = "noctalia",
  match = {
    namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
  },
  no_anim      = true,
  ignore_alpha = 0.5,
  blur         = true,
  blur_popups  = true,
})
{ pkgs, ... }:

{
  home.username = "ruter";
  home.homeDirectory = "/home/ruter";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "ruternix";
    userEmail = "arturkummer08@gmail.com";
  };

  home.packages = with pkgs; [
    noctalia-shell
  ];


  programs.vscode = {
    enable = true;
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";

    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };

  services.ssh-agent.enable = true;

  home.file.".config/hypr/hyprland.lua".text = ''
    hl.monitor({
        output   = "DP-2",
        mode     = "3440x1440@60",
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

    hl.env("XCURSOR_SIZE", "24")
    hl.env("HYPRCURSOR_SIZE", "24")

    -- Compositor look & feel
    hl.config({

      input = {
        kb_layout  = "pl",
      },

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
    })

    -- Keybinds
    local mainMod = "SUPER"
    local ipc = "noctalia msg "

    hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
    hl.bind(mainMod .. " + C", hl.dsp.window.close())

    -- Switch workspace: mod + [1-9,0]
    -- Move focused window to workspace: mod + shift + [1-9,0]
    for i = 1, 10 do
      local key = i % 10 -- 10 -> 0
      hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
      hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
    end

    -- Move window by holding mod + left click drag
    hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })

    hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
    hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center"))
    hl.bind(mainMod .. " + Comma", hl.dsp.exec_cmd(ipc .. "settings-toggle"))
    hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(ipc .. "panel-toggle clipboard"))
    hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(ipc .. "session lock"))
    hl.bind("ALT + Tab", hl.dsp.exec_cmd(ipc .. "window-switcher"))

    -- Media keys
    hl.bind("XF86AudioRaiseVolume",   hl.dsp.exec_cmd(ipc .. "volume-up"))
    hl.bind("XF86AudioLowerVolume",   hl.dsp.exec_cmd(ipc .. "volume-down"))
    hl.bind("XF86AudioMute",          hl.dsp.exec_cmd(ipc .. "volume-mute"))
    hl.bind("XF86MonBrightnessUp",    hl.dsp.exec_cmd(ipc .. "brightness-up"))
    hl.bind("XF86MonBrightnessDown",  hl.dsp.exec_cmd(ipc .. "brightness-down"))

    -- Float Noctalia's settings window
    hl.window_rule({
        match = { class = "dev.noctalia.Noctalia" },
        float = true,
        size  = { 1080, 920 },
    })

    -- Blur Noctalia's own surfaces, disable Hyprland's layer anim for them
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
  '';
}

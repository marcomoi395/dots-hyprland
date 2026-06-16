-- Migrated from legacy execs.conf to Hyprland Lua config
-- Docs: https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
	hl.exec_cmd("fcitx5")
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
	hl.exec_cmd("hyprctl setcursor macOS 24")
	hl.exec_cmd("cliphist wipe")
	hl.exec_cmd("imwheel -b 45")
	-- hl.exec_cmd("bash -lc '/home/ym/.local/share/nvm/v22.22.2/bin/node $(command -v 9router)'")
end)

hl.permission("fcitx5-vmk-server", "keyboard", "allow")


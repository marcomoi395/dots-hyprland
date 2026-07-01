-- Migrated from legacy env.conf to Hyprland Lua config
-- Docs: https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("GTK_IM_MODULE", "fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("SDL_IM_MODULE", "fcitx")
hl.env("GLFW_IM_MODULE", "ibus")
hl.env("INPUT_METHOD", "fcitx")

hl.env("EDITOR", "nvim")

hl.env("XCURSOR_THEME", "macOS")
hl.env("XCURSOR_SIZE", "24")

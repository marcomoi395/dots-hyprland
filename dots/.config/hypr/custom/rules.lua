-- Migrated from legacy rules.conf to Hyprland Lua config
-- Docs: https://wiki.hypr.land/Configuring/Basics/Window-Rules/

hl.window_rule({
    name = "global-no-blur-off",
    match = { class = ".*" },
    no_blur = false,
})

hl.window_rule({
    name = "spotify-opacity",
    match = { class = "^spotify$" },
    opacity = "0.9 override 0.9 override",
})

hl.window_rule({
    name = "chrome-opacity",
    match = { class = "^google-chrome$" },
    opacity = "0.98 override 0.98 override",
})

hl.window_rule({
    name = "discord-opacity",
    match = { class = "^discord$" },
    opacity = "0.9 override 0.9 override",
})

hl.window_rule({
    name = "dolphin-opacity",
    match = { class = "^org\\.kde\\.dolphin$" },
    opacity = "0.9 override 0.9 override",
})

hl.window_rule({
    name = "telegram-no-initial-focus",
    match = { class = "^(org.telegram.desktop|telegram-desktop)$" },
    no_initial_focus = true,
})

hl.window_rule({
    name = "pot-float",
    match = { class = "^(pot)$" },
    float = true,
})

hl.window_rule({
    name = "pot-pin",
    match = { class = "^(pot)$" },
    pin = true,
})

hl.layer_rule({
    name = "quickshell-ignore-alpha",
    match = { namespace = "quickshell:.*" },
    ignore_alpha = 0.85,
})

hl.layer_rule({
    name = "quickshell-xray-off",
    match = { namespace = "quickshell:.*" },
    xray = false,
})

hl.layer_rule({
    name = "quickshell-blur-on",
    match = { namespace = "quickshell:.*" },
    blur = true,
})


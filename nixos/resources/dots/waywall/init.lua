-- ==== WAYWALL GENERIC CONFIG (Azusa Nakano fork) — corrected for stary ====
local main = require("main")
local remaps = require("remaps")

local cfg = {
    debug_text = false,

    -- ==== LOOKS ====
    -- NOT your monitor resolution. With window.fullscreen_width/height removed,
    -- waywall renders its overlays into a buffer the size of the waywall WINDOW in
    -- LOGICAL px (scene.c: glViewport(0,0,render_width,render_height)).
    -- niri: 1920x1200 @ scale 1.40 -> 1371x857 logical. Verify with `niri msg outputs`.
    -- Every x/y below is in THIS space, so if you change scale, redo them.
    resolution = { 1371, 857 },

    bg_col = "#000000",
    toggle_bg_picture = false,
    text_col = "#FFFFFF",
    pie_chart_1 = "#5E3A2B",
    pie_chart_2 = "#9E2A2B",
    pie_chart_3 = "#CDC4B6",

    ninbot_anchor = { position = "topright", x = 0, y = 0 },
    ninbot_opacity = 1,

    -- ==== ALTERNATIVE RESOLUTIONS ====
    -- tall is LOAD-BEARING: pie/percent mirrors use hardcoded y=15978 / y=16163.
    tall_res = { 384, 16384 },
    thin_res = { 384, 1080 },
    wide_res = { 1920, 300 },

    -- ==== MIRRORS ====
    e_count       = { enabled = true,  x = 803, y = 238, size = 5, colorkey = true, show_c = false },
    thin_pie      = { enabled = true,  x = 798, y = 384, size = 4, colorkey = true },
    tall_pie      = { enabled = true,  x = 798, y = 384, size = 4, colorkey = true },
    thin_percent  = { enabled = true,  x = 840, y = 625, size = 6 },
    tall_percent  = { enabled = true,  x = 840, y = 625, size = 6 },
    percentages_match_text = false,

    measuring_window = { x = 16, y = 202, size = 14 },
    stretched_measure = false,

    -- ==== MACROS ====
    thin = { key = "Ctrl-Shift-S", f3_safe = false, ingame_only = false },
    wide = { key = "Ctrl-Shift-W",     f3_safe = true,  ingame_only = false },
    tall = { key = "Ctrl-Shift-T",     f3_safe = false, ingame_only = false },

    launch_ninbot_key = "Ctrl-Shift-N",
    toggle_ninbot_key = "Ctrl-Shift-B",
    launch_paceman_key = "Shift-P",
    toggle_remaps_key  = "Insert",

    -- ==== KEYBOARD ====
    xkb_config = { enabled = false, layout = "mc", rules = nil, variant = "basic", options = "caps:none" },
    remaps_text_config = { text = "chat mode", x = 100, y = 100, size = 2, color = "#000000" },

    -- ==== MISC ====
    -- off: 12.8000006 is someone else's MC sensitivity value
    sens_change = { enabled = false, normal = 1.0, tall = 1.0, raw_input = false },
    enable_resize_animations = false,
}

return main(cfg, remaps)
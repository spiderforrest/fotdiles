local wezterm = require('wezterm')
return {
    -- {{{ fonts
    front_end = 'WebGpu', -- render on gpu with some new engine idk, it makes fonts look flat and hot

    font = wezterm.font_with_fallback { -- this does not remove default fallbacks. cool.
        'Space Mono', -- my main font
        'Hurmit Nerd Font Mono', -- prettiest more compatibility font
        'Noto Color Emoji', -- emoji font
        'Unifont', -- most complete fallback font: they have like 52k glyphts?? geebus
    },
    freetype_load_flags = 'NO_HINTING', -- no font hint
    harfbuzz_features = { 'calt=1', 'clig=1', 'liga=0' }, -- font features, see: https://docs.microsoft.com/en-us/typography/opentype/spec/
    font_size = 10.4,
    -- }}}

-- {{{ visuals
    enable_tab_bar = false, -- hides stupid modern tab gui go away baka
-- {{{ colorshemes
    -- oh man
    -- color_scheme = 'EverforestDark (Gogh)', -- still nightly and i dunnooo
    color_scheme = 'Django', -- too green maaayyybbbeee
        -- color_scheme = 'DjangoSmooth', --maybe too bright
-- }}} colorshemes
    cursor_thickness = '95%', -- why does 5% make this much difference? it makes the unfocused cursor thinner
-- }}} visuals

-- {{{ bindings
    -- i don't use like. any of the features and i'm mostly gonna get annoyed
    -- disable_default_key_bindings = true,
    -- disable_default_mouse_bindings = true,
    use_ime = false, -- fixes the INSANELY WEIRD issue of home row mod keys getting processed later than normal keys
    -- how does that happen even?? my guess is async race condition of processing keys but sheeesh
-- }}} bindings

-- {{{ behaviors
    window_close_confirmation = 'NeverPrompt', -- really?
    scrollback_lines = 5000,
-- }}} behaviors
}

-- vim:foldmethod=marker

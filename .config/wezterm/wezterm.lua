local wezterm = require('wezterm')
return {
    -- {{{ fonts
    front_end = 'WebGpu', -- render on gpu with some new engine idk, it makes fonts look flat and hot

    font = wezterm.font_with_fallback { -- this does not remove default fallbacks. cool.
        'Space Mono',
        'Hurmit Nerd Font Mono',
        'Noto Color Emoji',
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
    -- }}}
    cursor_thickness = '95%', -- why does 5% make this much difference? it makes the unfocused cursor thinner
}

-- vim:foldmethod=marker

return {
    -- manage self
    'folke/lazy.nvim',
    -- keymap
    { 'spiderforrest/vim-colemak', event = 'BufEnter', -- running it before everything else bc i'll start typing lol
        -- flag off if Lily isn't here :(
        enabled=function()
            if fn.system({"grep", "-c", "Lily58"}, fn.system('lsusb')) + 0 > 0 then -- dirty whatever
                return true
            end
            return false
        end
    }
}

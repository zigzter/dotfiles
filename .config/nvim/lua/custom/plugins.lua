return function(use)
    use({
        'prettier/vim-prettier',
        run = 'npm install',
        ft = {'javascript', 'typescript', 'css', 'scss', 'markdown',  'html'}
    })
    use({
        'LunarWatcher/auto-pairs'
    })
    use({
        'christoomey/vim-tmux-navigator'
    })
    use({
        'kaicataldo/material.vim'
    })
    use({
        'github/copilot.vim'
    })
    use({
        'pangloss/vim-javascript'
    })
    use({
        'sjl/vitality.vim'
    })
end


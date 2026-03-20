-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  { 'christoomey/vim-tmux-navigator' },
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup {
        -- Disable netrw (recommended by nvim-tree)
        disable_netrw = true,
        hijack_netrw = true,
        -- Update focused file in the tree
        update_focused_file = {
          enable = true,
          update_root = false,
        },
        -- Show git status icons
        git = {
          enable = true,
          ignore = false,
        },
        -- File system watchers
        filesystem_watchers = {
          enable = true,
        },
        -- View options
        view = {
          width = 40,
          side = 'right',
        },
        -- Renderer options
        renderer = {
          highlight_git = true,
          icons = {
            show = {
              git = true,
              folder = true,
              file = true,
              folder_arrow = true,
            },
          },
        },
      }

      -- Keybindings
      vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle [E]xplorer' })
      vim.keymap.set('n', '<leader>E', '<cmd>NvimTreeFindFile<CR>', { desc = 'Focus buffer in [E]xplorer' })
    end,
  },
  {
    'kdheepak/lazygit.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      vim.keymap.set('n', '<leader>gl', '<cmd>LazyGit<CR>', { desc = '[G]it [L]azygit' })
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      }
    end,
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('neogit').setup {}
      vim.keymap.set('n', '<leader>gn', '<cmd>Neogit<CR>', { desc = '[G]it [N]eogit' })
    end,
  },
  {
    'sindrets/diffview.nvim',
    config = function()
      require('diffview').setup {}
      vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<CR>', { desc = '[G]it [D]iffview' })
      vim.keymap.set('n', '<leader>gc', '<cmd>DiffviewClose<CR>', { desc = '[G]it diffview [C]lose' })
    end,
  },
  {
    'akinsho/flutter-tools.nvim',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim',
    },
    config = function()
      require('flutter-tools').setup {
        widget_guides = { enabled = true },
        closing_tags = { enabled = true },
        lsp = {
          color = { enabled = true },
        },
      }

      -- Load Telescope extension for flutter commands
      require('telescope').load_extension 'flutter'

      -- Keymaps under <leader>F prefix
      vim.keymap.set('n', '<leader>Fl', '<cmd>Telescope flutter commands<CR>', { desc = '[F]lutter commands [l]ist' })
      vim.keymap.set('n', '<leader>Fr', '<cmd>FlutterRun<CR>', { desc = '[F]lutter [r]un' })
      vim.keymap.set('n', '<leader>Fq', '<cmd>FlutterQuit<CR>', { desc = '[F]lutter [q]uit' })
      vim.keymap.set('n', '<leader>FR', '<cmd>FlutterRestart<CR>', { desc = '[F]lutter [R]estart' })
      vim.keymap.set('n', '<leader>Fd', '<cmd>FlutterDevices<CR>', { desc = '[F]lutter [d]evices' })
      vim.keymap.set('n', '<leader>Fo', '<cmd>FlutterOutlineToggle<CR>', { desc = '[F]lutter [o]utline toggle' })
    end,
  },
  { 'tpope/vim-dadbod' },
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod' },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' } },
    },
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = 'cd app && npx --yes yarn install',
    config = function()
      vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreview<CR>', { desc = '[M]arkdown [P]review' })
      vim.keymap.set('n', '<leader>ms', '<cmd>MarkdownPreviewStop<CR>', { desc = '[M]arkdown preview [S]top' })
      vim.keymap.set('n', '<leader>mt', '<cmd>MarkdownPreviewToggle<CR>', { desc = '[M]arkdown preview [T]oggle' })
    end,
  },
  {
    'brianhuster/live-preview.nvim',
    cmd = 'LivePreview',
    opts = {},
  },
  -- {
  --   'milanglacier/minuet-ai.nvim',
  --   dependencies = { 'nvim-lua/plenary.nvim' },
  --   config = function()
  --     require('minuet').setup {
  --       provider = 'claude',
  --       provider_options = {
  --         claude = {
  --           max_tokens = 256,
  --           model = 'claude-haiku-4-5-20251001',
  --           stream = true,
  --           api_key = 'ANTHROPIC_API_KEY',
  --         },
  --       },
  --       virtualtext = {
  --         auto_trigger_ft = { '*' },
  --         keymap = {
  --           accept = '<Tab>',
  --           accept_line = '<A-l>',
  --           prev = '<A-p>',
  --           next = '<A-n>',
  --           dismiss = '<A-e>',
  --         },
  --       },
  --     }
  --   end,
  -- },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ft = 'markdown',
    opts = {},
  },
  {
    'f-person/git-blame.nvim',
    event = 'VeryLazy',
    opts = {
      enabled = true,
      message_template = ' <author> • <date> • <summary>',
      date_format = '%Y-%m-%d',
    },
    config = function(_, opts)
      require('gitblame').setup(opts)
      vim.keymap.set('n', '<leader>gb', '<cmd>GitBlameToggle<CR>', { desc = '[G]it [B]lame toggle' })
    end,
  },
  {
    'coder/claudecode.nvim',
    dependencies = { 'folke/snacks.nvim' },
    keys = {
      { '<leader>a', nil, desc = '[A]I Claude Code' },
      { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = '[A]I Toggle [C]laude' },
      { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = '[A]I [F]ocus Claude' },
      { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = '[A]I [R]esume Claude' },
      { '<leader>aR', '<cmd>ClaudeCode --continue<cr>', desc = '[A]I Continue (Resume last)' },
      { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = '[A]I Select [M]odel' },
      { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = '[A]I Add [B]uffer' },
      { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = '[A]I [S]end to Claude' },
      { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = '[A]I Diff [A]ccept' },
      { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = '[A]I Diff [D]eny' },
    },
    opts = {
      terminal = {
        split_side = 'right',
        split_width_percentage = 0.40,
        provider = 'snacks',
        snacks_win_opts = {
          auto_insert = false,
          keys = {
            term_normal = false,
            nav_h = {
              '<C-h>',
              function()
                vim.cmd 'TmuxNavigateLeft'
              end,
              mode = 't',
              desc = 'Navigate left',
            },
            nav_j = {
              '<C-j>',
              function()
                vim.cmd 'TmuxNavigateDown'
              end,
              mode = 't',
              desc = 'Navigate down',
            },
            nav_k = {
              '<C-k>',
              function()
                vim.cmd 'TmuxNavigateUp'
              end,
              mode = 't',
              desc = 'Navigate up',
            },
            nav_l = {
              '<C-l>',
              function()
                vim.cmd 'TmuxNavigateRight'
              end,
              mode = 't',
              desc = 'Navigate right',
            },
            esc = { '<Esc>', '<C-\\><C-n>', mode = 't', desc = 'Exit terminal mode' },
          },
        },
      },
      diff_opts = {
        auto_close_on_accept = true,
        vertical_split = true,
      },
    },
  },
}

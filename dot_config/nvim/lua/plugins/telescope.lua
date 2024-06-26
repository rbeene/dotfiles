return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { "Telescope" },  -- Load when the `Telescope` command is used
    config = function()
      local initial_cwd = vim.loop.cwd()
      -- Setup Telescope with the specified commands
      require('telescope').setup {
        defaults = {
          -- Display path without leading './'
          path_display = function(_, path)
            return path:gsub("^%./", "")
          end,
        }
      }
    end,
    keys = {                -- Load on these key mappings
      {
        "<C-p>",
        function()
          require("telescope.builtin").find_files({
            cwd = vim.loop.cwd(),
            hidden = true,
            find_command = {
              "rg", "--files", "--hidden",
              "--glob=!.git/**",
              "--glob=!node_modules/**",
              "--glob=!tmp/**"
            }
          })
        end,
        { noremap = true, silent = true }
      },
      {
        "<leader>fg",
        function()
          require("telescope.builtin").live_grep({
            cwd = vim.loop.cwd(),  -- Set the cwd to the initial directory
            additional_args = function() return { "--hidden" } end,
            vimgrep_arguments = {
              "rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case",
              "--glob=!.git/**",
              "--glob=!node_modules/**",
              "--glob=!tmp/**"
            }
          })
        end,
        { noremap = true, silent = true }
      }
    }
  }
}


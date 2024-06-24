return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.6',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local builtin = require("telescope.builtin")

    -- Use `rg` to find files, including dotfiles and hidden files
    local find_command = {
      "rg", "--files", "--hidden",
      "--glob", "!**/.git/*",
      "--glob", "!**/node_modules/*",
      "--glob", "!**/tmp/*"
    }

    -- Use `rg` for live grep, including dotfiles and hidden files
    local vimgrep_arguments = {
      "rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case",
      "--hidden",
      "--glob", "!**/.git/*",
      "--glob", "!**/node_modules/*",
      "--glob", "!**/tmp/*"
    }

    -- Setup Telescope with the specified commands
    require('telescope').setup {
      defaults = {
        find_command = find_command,
        vimgrep_arguments = vimgrep_arguments,
        -- Display path without leading './'
        path_display = function(_, path)
          return path:gsub("^%./", "")
        end,
      }
    }

    -- Key mappings for find_files and live_grep
    vim.keymap.set("n", "<C-p>", function()
      builtin.find_files({
        find_command = find_command,
        hidden = true -- Ensure hidden files are included
      })
    end, {})

    vim.keymap.set("n", "<leader>fg", function()
      builtin.live_grep({
        vimgrep_arguments = vimgrep_arguments,
        additional_args = function() return { "--hidden" } end
      })
    end, {})
  end
}

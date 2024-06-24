return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.6',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    -- Function to check if a command exists
    local function is_executable(cmd)
      local handle = io.popen("command -v " .. cmd .. " > /dev/null 2>&1; echo $?")
      local result = handle:read("*a")
      handle:close()
      return tonumber(result) == 0
    end

    -- Determine which find command is available
    local find_command
    if is_executable("fd") then
      -- Use `fd` with flags to include hidden files and exclude .git and node_modules directories
      find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git", "--exclude", "node_modules", "--exclude", "tmp" }
    elseif is_executable("find") then
      -- Use `find` with flags to include hidden files and exclude .git and node_modules directories
      find_command = {
        "find", ".", "-type", "f",
        "(", "-name", ".*", "-or", "-name", "*", ")",
        "-not", "-path", "*/.git/*",
        "-not", "-path", "*/node_modules/*",
        "-not", "-path", "*/tmp/*"
      }
    else
      vim.notify("No suitable file find command available", vim.log.levels.ERROR)
    end

    -- Determine grep command
    local vimgrep_arguments
    if is_executable("rg") then
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
        "--glob", "!.git/*",
        "--glob", "!node_modules/*",
        "--glob", "!tmp/*"
      }
    elseif is_executable("grep") then
      vimgrep_arguments = {
        "grep",
        "--line-number",
        "--recursive",
        "--include", "*",
        "--exclude-dir", ".git",
        "--exclude-dir", "node_modules",
        "--exclude-dir", "tmp",
        "--hidden"
      }
    else
      vim.notify("No suitable grep command available", vim.log.levels.ERROR)
    end

    -- Custom function to remove leading './' from paths
    local function remove_leading_dot_slash(path)
      if path:sub(1, 2) == "./" then
        return path:sub(3)
      end
      return path
    end

    -- Setup Telescope with dynamic configuration
    require('telescope').setup {
      defaults = {
        find_command = find_command,
        vimgrep_arguments = vimgrep_arguments,
        path_display = function(opts, path)
          return remove_leading_dot_slash(path)
        end
      }
    }

    local builtin = require("telescope.builtin")

    -- Key mappings for find_files
    vim.keymap.set("n", "<C-p>", function()
      if find_command then
        builtin.find_files({
          find_command = find_command,
          hidden = true -- Ensure hidden files are included
        })
      else
        vim.notify("No suitable command found for find_files", vim.log.levels.ERROR)
      end
    end, {})

    -- Key mappings for live_grep
    vim.keymap.set("n", "<leader>fg", function()
      if vimgrep_arguments then
        builtin.live_grep({
          vimgrep_arguments = vimgrep_arguments,
          additional_args = function(opts)
            return { "--hidden" } -- Ensure hidden files are included
          end
        })
      else
        vim.notify("No suitable command found for live_grep", vim.log.levels.ERROR)
      end
    end, {})
  end
}

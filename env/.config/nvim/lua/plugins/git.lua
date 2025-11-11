-- Opens the remote Git repository URL for the current file and line number.
--
-- This function determines the Git repository's root, remote URL, and current branch
-- to construct a URL that points directly to the current line in your web browser.
-- It supports both HTTPS and SSH remote URLs and works on Linux, macOS, and Windows.
local function open_git_link()
  -- 1. Get the root directory of the Git repository.
  local git_root = vim.fn.trim(vim.fn.system 'git rev-parse --show-toplevel')
  if vim.v.shell_error ~= 0 then
    vim.notify('Not a git repository.', vim.log.levels.WARN)
    return
  end

  -- 2. Get the URL of the 'origin' remote.
  local remote_url = vim.fn.trim(vim.fn.system 'git config --get remote.origin.url')
  if vim.v.shell_error ~= 0 then
    vim.notify("Could not get remote 'origin' URL.", vim.log.levels.WARN)
    return
  end

  -- 3. Get context: current file path, branch, and line number.
  local file_path = vim.fn.expand '%:p'
  if file_path == '' then
    vim.notify('Cannot get link for an empty buffer.', vim.log.levels.WARN)
    return
  end

  local relative_path = file_path:sub(#git_root + 2)
  local branch = vim.fn.trim(vim.fn.system 'git rev-parse --abbrev-ref HEAD')
  local line_num = vim.fn.line '.'

  -- 4. Convert SSH or HTTPS git URLs into a browseable web URL.
  -- e.g., git@github.com:user/repo.git -> https://github.com/user/repo
  -- e.g., https://github.com/user/repo.git -> https://github.com/user/repo
  local web_url = remote_url:gsub('^git@(.-):', 'https://%1/'):gsub('%.git$', '')

  -- 5. Construct the final URL. This format is compatible with GitHub, GitLab, Gitea,
  -- and other common Git hosting platforms.
  local final_url = string.format('%s/blob/%s/%s#L%s', web_url, branch, relative_path, line_num)

  -- 6. Use the appropriate system command to open the URL.
  local open_cmd
  if vim.fn.has 'macunix' then
    open_cmd = 'open'
  elseif vim.fn.has 'win32' then
    open_cmd = 'start'
  else
    open_cmd = 'xdg-open'
  end

  vim.notify('Opening: ' .. final_url)
  -- Execute the command asynchronously to avoid blocking Neovim.
  vim.fn.jobstart(open_cmd .. " '" .. final_url .. "'", { detach = true })
end

-- Create a user command so you can run `:GitLink` in Neovim.
vim.api.nvim_create_user_command('GitLink', open_git_link, {
  desc = 'Open the remote Git repository link for the current line',
})

return {
  {
    'lewis6991/gitsigns.nvim',
    opts = {},
    config = function()
      local gitsigns = require 'gitsigns'
      gitsigns.setup {
        signs = {
          add = { text = '┃' },
          change = { text = '┃' },
          delete = { text = '╸' },
          topdelete = { text = '‾' },
          changedelete = { text = '┋' },
          untracked = { text = '┇' },
        },
        current_line_blame = true,
        on_attach = function(bufnr)
          local function map(mode, keys, func, desc)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'Git: ' .. desc })
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then
              vim.cmd.normal { ']c', bang = true }
            else
              gitsigns.nav_hunk 'next'
            end
          end, 'Go to next change')

          map('n', '[c', function()
            if vim.wo.diff then
              vim.cmd.normal { '[c', bang = true }
            else
              gitsigns.nav_hunk 'prev'
            end
          end, 'Go to previous change')

          -- Actions
          map('n', '<leader>hs', gitsigns.stage_hunk, '[h]unk [s]tage')
          map('v', '<leader>hs', function()
            gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end, '[h]unk [s]tage')
          map('n', '<leader>hS', gitsigns.stage_buffer, '[h]unk [S]tage buffer')

          map('n', '<leader>hr', gitsigns.reset_hunk, '[h]unk [r]eset')
          map('v', '<leader>hr', function()
            gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end, '[h]unk [r]eset')
          map('n', '<leader>hR', gitsigns.reset_buffer, '[h]unk [R]eset buffer')

          map('n', '<leader>hu', gitsigns.stage_hunk, '[h]unk [u]ndo stage')

          map('n', '<leader>hp', gitsigns.preview_hunk, '[h]unk [p]review')

          map('n', '<leader>hd', gitsigns.diffthis, '[h]unk [d]iff')
          map('n', '<leader>hD', function()
            gitsigns.diffthis '~'
          end, '[h]unk [D]iff buffer')
          map('n', '<leader>td', gitsigns.preview_hunk_inline, '[t]oggle [d]eleted')
        end,
      }
    end,
  },
  {
    'sindrets/diffview.nvim',
  },
}

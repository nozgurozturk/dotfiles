-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
local YankGroup = augroup('HighlightYank', { clear = true })
autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = YankGroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})

local LspGroup = augroup('LspGroup', {})
autocmd('LspAttach', {
  group = LspGroup,
  callback = function(ev)
    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end
    ---@diagnostic disable-next-line need-check-nil
    if client.server_capabilities.completionProvider then
      vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
      -- vim.bo[bufnr].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
    end
    ---@diagnostic disable-next-line need-check-nil
    if client.server_capabilities.definitionProvider then
      vim.bo[bufnr].tagfunc = 'v:lua.vim.lsp.tagfunc'
    end

    -- -- nightly has inbuilt completions, this can replace all completion plugins
    -- if client:supports_method("textDocument/completion", bufnr) then
    --   -- Enable auto-completion
    --   vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    -- end

    --- Disable semantic tokens
    ---@diagnostic disable-next-line need-check-nil
    client.server_capabilities.semanticTokensProvider = nil
  end,
})

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

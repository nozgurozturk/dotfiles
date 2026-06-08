---@brief
---
--- https://github.com/dotnet/roslyn
--
-- To install the server, compile from source or download as nuget package.
-- Go to `https://dev.azure.com/azure-public/vside/_artifacts/feed/vs-impl/NuGet/Microsoft.CodeAnalysis.LanguageServer.<platform>/overview`
-- replace `<platform>` with one of the following `linux-x64`, `osx-x64`, `win-x64`, `neutral`.
-- Download and extract it (nuget's are zip files).
-- - if you chose `neutral` nuget version, run via `dotnet <my_folder>/Microsoft.CodeAnalysis.LanguageServer.dll`
-- - for all other platforms put the extracted folder to neovim's PATH (`vim.env.PATH`)

--------------------------------------------------------------------------------
-- NEOVIM UNITY GLOBALS
--------------------------------------------------------------------------------

-- these globals are set by Neovim Unity plugin: com.walcht.ide.neovim upon the
-- instantiation of a Neovim server instance. These are set to themselves
-- because they are expected to be set via "nvim --cmd '<var> = <value>'" and
-- we want to keep LuaLS happy.

---@type string? this is only set in case of Unity projects
_G.nvim_unity_curr_unity_project_root_dir = nil

---@type string? an optional user-supplied project root. If this is set, then
---any opened C# files will always use this as their LS root dir (regardless
---of whether it actually is).
_G.nvim_unity_user_supplied_project_root_dir = _G.nvim_unity_user_supplied_project_root_dir

---@type boolean if true, textDocument/diagnostic requests completion times for
---initially opened buffers are logged and notified.
_G.nvim_unity_benchmark_roslyn_ls = _G.nvim_unity_benchmark_roslyn_ls or false

---@type "openFiles" | "fullSolution" | "none"
_G.nvim_unity_analyzer_diagnostic_scope = _G.nvim_unity_analyzer_diagnostic_scope or 'openFiles'

---@type "openFiles" | "fullSolution" | "none"
_G.nvim_unity_compiler_diagnostic_scope = _G.nvim_unity_compiler_diagnostic_scope or 'openFiles'

--------------------------------------------------------------------------------
-- ROSLYN LS BENCHMARKING
--------------------------------------------------------------------------------

---@type integer solution/project initialization start time in ms
local start_time

local function log_benchmarking_settings()
  local benchmark_settings = {
    ['os'] = vim.uv.os_uname().sysname,
    ['dotnet_analyzer_diagnostics_scope'] = _G.nvim_unity_analyzer_diagnostic_scope,
    ['dotnet_compiler_diagnostics_scope'] = _G.nvim_unity_compiler_diagnostic_scope,
  }
  local indent = vim.bo.expandtab and (' '):rep(vim.o.shiftwidth) or '\t'
  local stringified = vim.json.encode(benchmark_settings, { indent = indent })
  local msg = '[benchmark] started textDocument/diagnostic with settings: ' .. stringified
  vim.notify(msg, vim.log.levels.INFO)
  vim.lsp.log.error(msg)
end

local fs = vim.fs

local roslny_bin =
  vim.fn.expand '$HOME/.nuget/packages/microsoft.codeanalysis.languageserver.osx-arm64/5.4.0-2.26179.14/content/LanguageServer/osx-arm64/Microsoft.CodeAnalysis.LanguageServer.dll'

local sln_target = nil

local group = vim.api.nvim_create_augroup('lspconfig.roslyn_ls', { clear = true })

---@param client vim.lsp.Client
---@param target string
local function on_init_sln(client, target)
  vim.notify('Initializing: solution' .. target, vim.log.levels.INFO)
  ---@diagnostic disable-next-line: param-type-mismatch
  client:notify('solution/open', {
    solution = vim.uri_from_fname(target),
  })
end

---@param client vim.lsp.Client
---@param project_files string[]
local function on_init_project(client, project_files)
  vim.notify('Initializing: projects', vim.log.levels.INFO)
  ---@diagnostic disable-next-line: param-type-mismatch
  client:notify('project/open', {
    projects = vim.tbl_map(function(file)
      return vim.uri_from_fname(file)
    end, project_files),
  })
end

---@param bufnr integer
---@param on_dir fun(root_dir?:string)
local function project_root_dir_discovery(bufnr, on_dir)
  if _G.nvim_unity_user_supplied_project_root_dir then
    vim.notify('[C# LS] using user-supplied Unity project root dir: ' .. _G.nvim_unity_user_supplied_project_root_dir, vim.log.levels.INFO)
    on_dir(_G.nvim_unity_user_supplied_project_root_dir)
    return
  end

  local bufname = vim.api.nvim_buf_get_name(bufnr)
  local root_dir = nil
  for dir in vim.fs.parents(bufname) do
    if vim.fn.isdirectory(vim.fs.joinpath(dir, '/Assets')) == 1 then
      root_dir = dir
      break
    end
  end

  if root_dir then
    if _G.nvim_unity_curr_unity_project_root_dir then
      if _G.nvim_unity_curr_unity_project_root_dir == root_dir then
        on_dir(root_dir)
      else
        vim.notify(
          string.format(
            '[C# LSP] you have opened a C# file that belong to different Unity '
              .. 'project (%s) than the one currently in use (%s). LS support '
              .. 'for this buffer is disabled.',
            root_dir,
            _G.nvim_unity_curr_unity_project_root_dir
          ),
          vim.log.levels.WARN
        )
      end
    else
      _G.nvim_unity_curr_unity_project_root_dir = root_dir
      on_dir(root_dir)
    end
    return
  end

  root_dir = vim.fs.root(bufnr, function(fname, _)
    return fname:match '%.sln[x]?$' ~= nil
  end)

  if not root_dir then
    root_dir = vim.fs.root(bufnr, function(fname, _)
      return fname:match '%.csproj$' ~= nil
    end)
  end

  if root_dir then
    on_dir(root_dir)
    return
  end

  on_dir(bufname)
  vim.notify('[C# LSP] failed to find root directory - LS is running in single-file mode.', vim.log.levels.WARN)
end

---@param client vim.lsp.Client
local function refresh_diagnostics(client)
  for _, buf in ipairs(vim.lsp.get_buffers_by_client_id(client.id)) do
    if vim.api.nvim_buf_is_loaded(buf) then
      client:request(vim.lsp.protocol.Methods.textDocument_diagnostic, { textDocument = vim.lsp.util.make_text_document_params(buf) }, nil, buf)
    end
  end
end

---@param client vim.lsp.Client
---@param action table
local function apply_action(client, action)
  if action.edit then
    vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
  end
  if action.command then
    client:exec_cmd(action.command)
  end
end

---@param client vim.lsp.Client
---@param command table
---@param bufnr integer
local function handle_fix_all_action(client, command, bufnr)
  local arg = command.arguments and command.arguments[1]
  if type(arg) ~= 'table' then
    vim.notify('roslyn_ls: invalid fixAllCodeAction arguments', vim.log.levels.ERROR)
    return
  end

  local flavors = arg.FixAllFlavors
  if type(flavors) ~= 'table' or vim.tbl_isempty(flavors) then
    vim.notify('roslyn_ls: fixAllCodeAction has no FixAllFlavors', vim.log.levels.WARN)
    return
  end

  vim.ui.select(flavors, {
    prompt = 'Fix All Scope:',
  }, function(chosen_scope)
    if not chosen_scope then
      return
    end

    client:request('codeAction/resolveFixAll', {
      title = command.title,
      data = arg,
      scope = chosen_scope,
    }, function(err, resolved)
      if err then
        vim.notify('roslyn_ls: fixAllCodeAction resolve error: ' .. (err.message or tostring(err)), vim.log.levels.ERROR)
        return
      end
      if resolved then
        apply_action(client, resolved)
      end
    end, bufnr)
  end)
end

---@type table<string, function>
local roslyn_handlers = {
  ['workspace/projectInitializationComplete'] = function(_, _, ctx)
    vim.notify('Roslyn project initialization complete', vim.log.levels.INFO)

    local buffers = vim.lsp.get_buffers_by_client_id(ctx.client_id)
    local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
    local method = vim.lsp.protocol.Methods.textDocument_diagnostic

    if _G.nvim_unity_benchmark_roslyn_ls then
      local msg = string.format('[benchmark] textDocument/diagnostics request completion time for %i buffers', #buffers)
      vim.notify(msg, vim.log.levels.INFO)
      vim.lsp.log.error(msg)
    end

    for _, buf in ipairs(buffers) do
      local handler = nil

      if _G.nvim_unity_benchmark_roslyn_ls then
        handler = function(_err, _res, _ctx)
          (client.handlers[method] or vim.lsp.handlers[method])(_err, _res, _ctx)
          local secs, ms = vim.uv.gettimeofday()
          local diff = (secs + ms * 0.001 * 0.001) - start_time
          local bmsg = string.format('[benchmark] textDocument/diagnostics request for bufnr %i done in: %.3fs', _ctx.bufnr, diff)
          vim.notify(bmsg, vim.log.levels.INFO)
          vim.lsp.log.error(bmsg)
        end
      end

      local success = client:request(method, {
        textDocument = vim.lsp.util.make_text_document_params(buf),
      }, handler, buf)

      if not success then
        vim.notify(
          string.format('failed to send request to Roslyn LS for textDocument_diagnostic for buf: %s', vim.api.nvim_buf_get_name(buf)),
          vim.log.levels.ERROR
        )
      end
    end
  end,

  ['workspace/_roslyn_projectNeedsRestore'] = function(_, result, ctx)
    local client = assert(vim.lsp.get_client_by_id(ctx.client_id))

    ---@diagnostic disable-next-line: param-type-mismatch
    client:request('workspace/_roslyn_restore', result, function(err, response)
      if err then
        vim.notify(err.message, vim.log.levels.ERROR)
        vim.lsp.log.error(err.message)
      end
      local no_errors = true
      if response then
        for _, v in ipairs(response) do
          if string.find(v.message, 'error%s*MSB%d%d%d%d') then
            vim.lsp.log.warn(v.message)
            vim.notify(v.message, vim.log.levels.WARN)
            no_errors = false
          end
        end
      end
      if no_errors then
        vim.notify('dotnet restore completed successfully', vim.log.levels.INFO)
      else
        vim.notify('dotnet restore completed with errors - see LSP log', vim.log.levels.WARN)
      end
    end)

    return vim.NIL
  end,

  ['workspace/_roslyn_projectHasUnresolvedDependencies'] = function()
    if sln_target ~= nil then
      vim.notify(string.format('Detected missing dependencies. Run `dotnet restore %s` command.', sln_target), vim.log.levels.ERROR)
      return vim.NIL
    end
    vim.notify('Detected missing dependencies. Run `dotnet restore` command.', vim.log.levels.ERROR)
  end,

  ['razor/provideDynamicFileInfo'] = function(_, _, _)
    vim.notify('Razor is not supported.\nPlease use https://github.com/tris203/rzls.nvim', vim.log.levels.WARN)
  end,
}

local roslyn_ls_specific_settings = {
  ['csharp|background_analysis'] = {
    -- Note: "fullSolution" may cause significant performance degradation.
    -- See: https://github.com/dotnet/vscode-csharp/issues/8145#issuecomment-2784568100
    ---@type "openFiles" | "fullSolution" | "none"
    dotnet_analyzer_diagnostics_scope = _G.nvim_unity_analyzer_diagnostic_scope,
    ---@type "openFiles" | "fullSolution" | "none"
    dotnet_compiler_diagnostics_scope = _G.nvim_unity_compiler_diagnostic_scope,
  },
  ['csharp|inlay_hints'] = {
    csharp_enable_inlay_hints_for_implicit_object_creation = true,
    csharp_enable_inlay_hints_for_implicit_variable_types = true,
    csharp_enable_inlay_hints_for_lambda_parameter_types = true,
    csharp_enable_inlay_hints_for_types = true,
    csharp_enable_inlay_hints_for_collection_expressions = true,
    dotnet_enable_inlay_hints_for_indexer_parameters = true,
    dotnet_enable_inlay_hints_for_literal_parameters = true,
    dotnet_enable_inlay_hints_for_object_creation_parameters = true,
    dotnet_enable_inlay_hints_for_other_parameters = true,
    dotnet_enable_inlay_hints_for_parameters = true,
    dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
    dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
    dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
  },
  ['csharp|symbol_search'] = {
    dotnet_search_reference_assemblies = true,
  },
  ['csharp|completion'] = {
    dotnet_show_name_completion_suggestions = true,
    dotnet_provide_regex_completions = true,
    dotnet_show_completion_items_from_unimported_namespaces = false,
    dotnet_trigger_completion_in_argument_lists = true,
  },
  ['csharp|code_lens'] = {
    dotnet_enable_references_code_lens = true,
    dotnet_enable_tests_code_lens = true,
  },
  ['csharp|projects'] = {
    dotnet_binary_log_path = nil,
    dotnet_enable_automatic_restore = true,
    dotnet_enable_file_based_programs = true,
    dotnet_enable_file_based_programs_when_ambiguous = true,
  },
  ['csharp|navigation'] = {
    dotnet_navigate_to_decompiled_sources = true,
    dotnet_navigate_to_source_link_and_embedded_sources = true,
  },
  ['csharp|highlighting'] = {
    dotnet_highlight_related_json_components = true,
    dotnet_highlight_related_regex_components = true,
  },
}

local lsp_log_lvl_to_roslyn_log_lvl = {
  [vim.log.levels.OFF] = 'None',
  [vim.log.levels.TRACE] = 'Trace',
  [vim.log.levels.DEBUG] = 'Debug',
  [vim.log.levels.INFO] = 'Information',
  [vim.log.levels.WARN] = 'Warning',
  [vim.log.levels.ERROR] = 'Error',
}

---@type lsp.ClientCapabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- HACK: Doesn't show any diagnostics if we do not set this to true
capabilities.textDocument.diagnostic.dynamicRegistration = true

---@type vim.lsp.Config
return {
  name = 'roslyn_ls',
  offset_encoding = 'utf-8',
  cmd = {
    'dotnet',
    roslny_bin,
    '--logLevel=' .. lsp_log_lvl_to_roslyn_log_lvl[vim.lsp.log.get_level()],
    '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.log.get_filename()),
    '--stdio',
  },

  cmd_env = {
    -- Fixes LSP navigation in decompiled files for systems with symlinked TMPDIR (macOS)
    TMPDIR = vim.env.TMPDIR and vim.env.TMPDIR ~= '' and vim.fn.resolve(vim.env.TMPDIR) or nil,
  },

  filetypes = { 'cs' },
  handlers = roslyn_handlers,

  commands = {
    ['roslyn.client.completionComplexEdit'] = function(command, ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      local args = command.arguments or {}
      local uri, edit = args[1], args[2]

      ---@diagnostic disable: undefined-field
      if uri and edit and edit.newText and edit.range then
        local workspace_edit = {
          changes = {
            [uri.uri] = {
              {
                range = edit.range,
                newText = edit.newText,
              },
            },
          },
        }
        vim.lsp.util.apply_workspace_edit(workspace_edit, client.offset_encoding)
      ---@diagnostic enable: undefined-field
      else
        vim.notify('roslyn_ls: completionComplexEdit args not understood: ' .. vim.inspect(args), vim.log.levels.WARN)
      end
    end,

    ['roslyn.client.nestedCodeAction'] = function(command, ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      local arg = command.arguments and command.arguments[1]

      if type(arg) ~= 'table' then
        vim.notify('roslyn_ls: invalid nestedCodeAction arguments', vim.log.levels.ERROR)
        return
      end

      local function handle(action)
        if not action then
          return
        end

        if action.data and not action.edit and not action.command then
          client:request('codeAction/resolve', action, function(err, resolved)
            if err then
              vim.notify(err.message or tostring(err), vim.log.levels.ERROR)
              return
            end
            if resolved then
              handle(resolved)
            end
          end, ctx.bufnr)
          return
        end

        local nested = vim.islist(action) and action or action.NestedCodeActions
        if type(nested) ~= 'table' or vim.tbl_isempty(nested) then
          apply_action(client, action)
          return
        end

        if #nested == 1 then
          handle(nested[1])
          return
        end

        vim.ui.select(nested, {
          prompt = action.title or 'Select code action',
          format_item = function(item)
            return item.title or (item.command and item.command.title) or 'Unnamed action'
          end,
        }, function(choice)
          if choice then
            handle(choice)
          end
        end)
      end

      handle(arg)
    end,

    ['roslyn.client.fixAllCodeAction'] = function(command, ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      handle_fix_all_action(client, command, ctx.bufnr)
    end,
  },

  root_dir = project_root_dir_discovery,

  on_init = {
    function(client)
      local root_dir = client.config.root_dir

      if _G.nvim_unity_benchmark_roslyn_ls then
        local seconds, microsecond = vim.uv.gettimeofday()
        start_time = seconds + microsecond * 0.001 * 0.001
        log_benchmarking_settings()
      end

      for entry, type in fs.dir(root_dir) do
        if type == 'file' and (vim.endswith(entry, '.sln') or vim.endswith(entry, '.slnx')) then
          on_init_sln(client, fs.joinpath(root_dir, entry))
          sln_target = entry
          return
        end
      end

      local project_found = false
      for entry, type in fs.dir(root_dir) do
        if type == 'file' and vim.endswith(entry, '.csproj') then
          on_init_project(client, { fs.joinpath(root_dir, entry) })
          project_found = true
        end
      end

      if not project_found then
        vim.notify('[C# LSP] no solution/.csproj files were found', vim.log.levels.ERROR)
      end
    end,
  },

  on_attach = function(client, bufnr)
    if vim.api.nvim_get_autocmds({ buffer = bufnr, group = group })[1] then
      return
    end

    vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave' }, {
      group = group,
      buffer = bufnr,
      callback = function()
        refresh_diagnostics(client)
      end,
      desc = 'roslyn_ls: refresh diagnostics',
    })
  end,

  capabilities = capabilities,
  settings = roslyn_ls_specific_settings,
  detached = false,
}

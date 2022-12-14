local status, lsp = pcall(require, "lspconfig")
if (not status) then
  return
end

local function format(opts)

  if vim.lsp.buf.format then
    return vim.lsp.buf.format(opts)
  end

  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  local clients = vim.lsp.buf_get_clients(bufnr)
  if opts.filter then
    clients = opts.filter(clients)
  elseif opts.id then
    clients = vim.tbl_filter(function(client)
      return client.id == opts.id
    end, clients)
  elseif opts.name then
    clients = vim.tbl_filter(function(client)
      return client.name == opts.name
    end, clients)
  end
  clients = vim.tbl_filter(function(client)
    return client.supports_method "textDocument/formatting"
  end, clients)
  if #clients == 0 then
    vim.notify_once "[LSP] Format request failed, no matching language servers."
  end
  local timeout_ms = opts.timeout_ms or 1000
  for _, client in pairs(clients) do
    local params = vim.lsp.util.make_formatting_params(opts.formatting_options)
    local result, err = client.request_sync("textDocument/formatting", params, timeout_ms, bufnr)
    if result and result.result then
      vim.lsp.util.apply_text_edits(result.result, bufnr, client.offset_encoding)
    elseif err then
      vim.notify(string.format("[LSP][%s] %s", client.name, err), vim.log.levels.WARN)
    end
  end
end

local protocol = require("vim.lsp.protocol")

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap = true, silent = true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  -- buf_set_keymap('n', 'gD', ':lua vim.lsp.buf.declaration()<CR>', opts)
  -- buf_set_keymap('n', 'gd', ':lua vim.lsp.buf.definition()<CR>', opts)
  -- buf_set_keymap('n', 'gi', ':lua vim.lsp.buf.implementation()<CR>', opts)
  -- buf_set_keymap('n', 'K', ':lua vim.lsp.buf.hover()<CR>', opts)

  -- formatting
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function() format({ name = 'null-ls', bufnr = bufnr }) end
    })
  end
end

protocol.CompletionItemKind = {
  '???', -- Text
  '???', -- Method
  '???', -- Function
  '???', -- Constructor
  '???', -- Field
  '???', -- Variable
  '???', -- Class
  '???', -- Interface
  '???', -- Module
  '???', -- Property
  '???', -- Unit
  '???', -- Value
  '???', -- Enum
  '???', -- Keyword
  '???', -- Snippet
  '???', -- Color
  '???', -- File
  '???', -- Reference
  '???', -- Folder
  '???', -- EnumMember
  '???', -- Constant
  '???', -- Struct
  '???', -- Event
  '???', -- Operator
  '???', -- TypeParameter
}

local capabilities = require('cmp_nvim_lsp').default_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

lsp.tsserver.setup({
  on_attach = on_attach,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact" },
  cmd = { "typescript-language-server", "--stdio" },
  capabilities = capabilities
})

lsp.sumneko_lua.setup({
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false
      },
    },
  },
})

lsp.tailwindcss.setup {}
lsp.prismals.setup({})

-- lsp.spectral.setup({
--   cmd = { "spectral", "lint" },
--   filetypes = {"json", "yaml", "yml"},
--   settings = {
--     enable = true,
--     run = "onType",
--     validateLanguages = { "yaml", "json", "yml" }
--   }
-- })

lsp.jsonls.setup({})
lsp.yamlls.setup({
  settings = {
    yaml = {
      schemas = {
        ["/Users/jack/.config/nbin/schemas/openapi/v3.0/schema.yaml"] = "/*.api.yaml"
      }
    }
  }
})

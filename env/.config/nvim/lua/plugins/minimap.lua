return {
  'nvim-mini/mini.map',
  config = function()
    local minimap = require 'mini.map'
    minimap.setup {
      integrations = {
        minimap.gen_integration.diff(),
        minimap.gen_integration.diagnostic(),
        minimap.gen_integration.builtin_search(),
        minimap.gen_integration.gitsigns(),
      },
      symbols = {
        minimap.gen_encode_symbols.dot(),
      },
    }
  end,
}

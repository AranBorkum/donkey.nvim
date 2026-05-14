local Config = {}

Config.options = {}

function Config.setup(opts)
    Config.options = vim.tbl_deep_extend("force", Config.options, opts or {})
    require("donkey.commands").setup()
end

return Config

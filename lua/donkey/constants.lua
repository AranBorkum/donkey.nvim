local Constants = {}

local API_PATH = "https://app.asana.com/api/1.0/"

Constants.TASK_API_PATH = API_PATH .. "tasks/"
Constants.PROJECT_API_PATH = API_PATH .. "projects/"
Constants.SECTION_API_PATH = API_PATH .. "sections/"
Constants.AUTH_HEADER = {
    Authorization = "Bearer " .. vim.env.ASANA_ACCESS_TOKEN,
}

return Constants

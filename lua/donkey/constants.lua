local API_PATH = "https://app.asana.com/api/1.0/"

return {
    APP_PATH = "https://app.asana.com/0/0/",
    TASK_API_PATH = API_PATH .. "tasks/",
    PROJECT_API_PATH = API_PATH .. "projects/",
    SECTION_API_PATH = API_PATH .. "sections/",
    REQUEST_HEADER = {
        Authorization = "Bearer " .. vim.env.ASANA_ACCESS_TOKEN,
        content_type = "application/json",
    },
}

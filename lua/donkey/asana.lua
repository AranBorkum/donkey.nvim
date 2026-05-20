local curl = require("plenary.curl")
local constants = require("donkey.constants")

local Asana = {}

---Make an authenticated GET request to an asana API
---@param url string API url for a given endpoint
---@return table The curl response object
local function make_get_request(url)
    return curl.get(url, { headers = constants.REQUEST_HEADER })
end

---Make an authenticated POST request to an asana API
---@param url string API url for a given endpoint
---@param data table API request payload
---@return table The curl response object
local function make_post_request(url, body)
    return curl.post(url, {
        body = vim.json.encode(body),
        headers = constants.REQUEST_HEADER,
    })
end

---Get an Asana task by ID
---@param task_id string|nil The Asana task ID
---@return table The curl response object
function Asana.get_task(task_id)
    local response = make_get_request(constants.TASK_API_PATH .. task_id)

    if response.status ~= 200 then vim.notify("Could not get task from Asana") end

    local data = vim.json.decode(response.body).data

    return data
end

---Get an Asana project's sections by ID
---@param project_id string The Asana project ID
---@return table The curl response object
function Asana.get_project_sections(project_id)
    local response =
        make_get_request(constants.PROJECT_API_PATH .. project_id .. "/sections")

    if response.status ~= 200 then
        vim.notify("Could not get project from Asana", vim.log.levels.ERROR)
    end

    return response
end

---Get project IDs for a given task by ID
---@param task_id string|nil The Asana task ID
---@return table The project IDs for the task
function Asana.get_project_ids_for_task(task_id)
    local task = Asana.get_task(task_id)
    local projects = {}

    for _, membership in ipairs(task.memberships) do
        table.insert(projects, membership.project.name)
        projects[membership.project.name] = membership
        print(membership.project.name)
    end

    return projects
end

---Move a task to a section by their IDs
---@param section_id string The Asana section ID
---@param task_id string The Asana task ID
function Asana.move_task_to_section(section_id, task_id)
    local body = { data = { task = task_id } }
    local response =
        make_post_request(constants.SECTION_API_PATH .. section_id .. "/addTask", body)

    if response.status ~= 200 then
        vim.notify("Could not move ticket to new section", vim.log.levels.ERROR)
    end
end

return Asana

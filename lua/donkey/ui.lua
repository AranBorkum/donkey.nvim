local asana = require("donkey.asana")

local UI = {}

---Show a dropdown menu to select a section from a project
---@param project_id string The Asana project ID
---@param callback function Callback function that receives the selected section
---@param current_section_gid string|nil Optional current section GID to mark in the picker
function UI.select_section(project_id, callback, current_section_gid)
    local response = asana.get_project_sections(project_id)

    if response.status ~= 200 then
        vim.notify("Failed to fetch project sections", vim.log.levels.ERROR)
        return
    end

    local data = vim.json.decode(response.body).data
    local sections = {}
    local section_map = {}

    -- Build the sections list for the picker
    for _, section in ipairs(data) do
        local display_name = section.name
        if current_section_gid and section.gid == current_section_gid then
            display_name = "→ " .. section.name .. " (current)"
        end
        table.insert(sections, display_name)
        section_map[display_name] = section
    end

    -- Show the selection UI
    vim.ui.select(sections, {
        prompt = "Select a section:",
        format_item = function(item) return item end,
    }, function(choice)
        if choice then callback(section_map[choice]) end
    end)
end

---Show a dropdown menu to select a project for a task
---@param task_id string The Asana task ID
---@param callback function Callback function that receives the selected membership
function UI.select_project_for_task(task_id, callback)
    local projects = asana.get_project_ids_for_task(task_id)

    vim.ui.select(projects, {
        prompt = "Select a project:",
        format_item = function(item) return item end,
    }, function(choice)
        if choice then callback(projects[choice]) end
    end)
end

return UI

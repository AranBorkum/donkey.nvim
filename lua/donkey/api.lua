local asana = require("donkey.asana")
local constants = require("donkey.constants")
local ui = require("donkey.ui")
local utils = require("donkey.utils")

local Api = {}

---Move a ticket to a given section on a project
---@param task_id string|nil The task ID if known or will retrieve from branch
function Api.update_ticket_section(task_id)
    if task_id == "" then
        task_id = utils.get_task_id_from_branch()
        if not task_id then
            vim.notify(
                "No task ID provided and could not extract from branch name",
                vim.log.levels.ERROR
            )
            return
        end
    end

    local projects = asana.get_project_ids_for_task(task_id)

    -- Auto-select if there's only one project
    if #projects == 1 then
        local membership = projects[projects[1]]
        local current_section_gid = membership.section and membership.section.gid or nil

        ui.select_section(membership.project.gid, function(section)
            if not section then
                vim.notify("No section selected", vim.log.levels.WARN)
                return
            end

            asana.move_task_to_section(section.gid, task_id)

            vim.notify(
                "Moving task "
                    .. task_id
                    .. " to section "
                    .. section.name
                    .. " - "
                    .. section.gid
            )
        end, current_section_gid)
        return
    end

    ui.select_project_for_task(task_id, function(membership)
        if not membership then
            vim.notify("No project selected", vim.log.levels.WARN)
            return
        end

        local current_section_gid = membership.section and membership.section.gid or nil

        ui.select_section(membership.project.gid, function(section)
            if not section then
                vim.notify("No section selected", vim.log.levels.WARN)
                return
            end

            asana.move_task_to_section(section.gid, task_id)

            vim.notify(
                "Moving task "
                    .. task_id
                    .. " to section "
                    .. section.name
                    .. " - "
                    .. section.gid
            )
        end, current_section_gid)
    end)
end

---Open Asana ticket in default browser
---@param task_id string|nil The task ID if known or will retrieve from branch
function Api.open_ticket_in_browser(task_id)
    if task_id == "" then
        task_id = utils.get_task_id_from_branch()
        if not task_id then
            vim.notify(
                "No task ID provided and could not extract from branch name",
                vim.log.levels.ERROR
            )
            return
        end
    end

    local url = constants.APP_PATH .. task_id
    local sysname = vim.loop.os_uname().sysname

    if sysname == "Darwin" then
        -- macOS
        vim.fn.jobstart({ "open", url }, { detach = true })
    elseif sysname == "Windows_NT" then
        -- Windows
        vim.fn.jobstart({ "cmd.exe", "/c", "start", url }, { detach = true })
    else
        -- Linux and others
        vim.fn.jobstart({ "xdg-open", url }, { detach = true })
    end
end

return Api

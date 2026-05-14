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

return Api

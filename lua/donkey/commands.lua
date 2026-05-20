local api = require("donkey.api")
local ui = require("donkey.ui")

local Commands = {}

function Commands.setup()
    -- Command to select a section from a project
    vim.api.nvim_create_user_command("AsanaSelectSection", function(opts)
        local project_id = opts.args
        if project_id == "" then
            vim.notify("Please provide a project ID", vim.log.levels.ERROR)
            return
        end

        ui.select_section(project_id, function(section)
            vim.notify("Selected: " .. section.name .. " (ID: " .. section.gid .. ")")
            -- You can add your logic here for what to do with the selected section
        end)
    end, {
        nargs = 1,
        desc = "Select a section from an Asana project",
    })

    vim.api.nvim_create_user_command("AsanaSelectProject", function(opts)
        local task_id = opts.args
        ui.select_project_for_task(task_id, function(membership)
            vim.notify(
                "Selected: "
                    .. membership.project.name
                    .. " (ID: "
                    .. membership.project.gid
                    .. ")"
            )
            -- You can add your logic here for what to do with the selected membership
        end)
    end, {
        nargs = 1,
        desc = "Select a project for an Asana task",
    })

    vim.api.nvim_create_user_command(
        "AsanaUpdateTicket",
        function(opts) api.update_ticket_section(opts.args) end,
        {
            nargs = "?",
            desc = "Update an Asana task by selecting project and section",
        }
    )

    vim.api.nvim_create_user_command(
        "AsanaOpenTicket",
        function(opts) api.open_ticket_in_browser(opts.args) end,
        {
            nargs = "?",
            desc = "Open asana ticket in the default browser",
        }
    )
end

return Commands

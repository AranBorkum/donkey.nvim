local Utils = {}

---Extract task ID from a git branch name formatted as feature/task-id/description
---@return string|nil The task ID or nil if not found
function Utils.get_task_id_from_branch()
    local handle = io.popen("git rev-parse --abbrev-ref HEAD 2>/dev/null")
    if not handle then return nil end

    local branch = handle:read("*a")
    handle:close()

    if branch == "" then return nil end

    local branch_name = branch:gsub("%s+", "") -- trim whitespace

    if not branch_name then return nil end

    -- Split by '/' and get the second segment (task-id)
    local segments = {}
    for segment in branch_name:gmatch("[^/]+") do
        table.insert(segments, segment)
    end

    -- Return the second segment if it exists (e.g., "task-id" from "feature/task-id/description")
    if #segments >= 2 then return segments[2] end

    return nil
end

return Utils

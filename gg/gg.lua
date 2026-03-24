local args = {...}

local path, repo = args[1]:match("([^@]+)@(.+)")
local branch = "main"
if repo:find(":") then
    repo, branch = repo:match("([^:]+):(.+)")
end
local tree_url = "https://api.github.com/repos/" .. repo .. "/git/trees/" .. branch .. "?recursive=1"
local raw_url = "https://raw.githubusercontent.com/" .. repo .. "/refs/heads/" .. branch .. "/"
local output_path = args[2]

local tree_res = http.get(tree_url)
local tree_json = tree_res.readAll()
tree_res.close()
local tree = textutils.unserialiseJSON(tree_json)

function get(src, dest)
    fs.makeDir(fs.getDir(dest))
    shell.run("wget", raw_url .. src, dest)
end

for i, entry in ipairs(tree) do
    if entry.path == path then
        if entry.type == "blob" then
            get(entry.path, output_path)
            return
        else
            break
        end
    end
end

for i, entry in ipairs(tree) do
    if entry.path:sub(1, #path + 1) == path .. "/" then
        local output_sub_path = entry.path:sub(#path + 2)
        get(entry.path, output_path .. "/" .. output_sub_path)
    end
end
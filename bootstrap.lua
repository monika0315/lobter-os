local repo = "monika0315/lobter-os"
local branch = "dev"
local tree_url = "https://api.github.com/repos/" .. repo .. "/git/trees/" .. branch .. "?recursive=1"
local raw_url = "https://raw.githubusercontent.com/" .. repo .. "/refs/heads/" .. branch .. "/"

local tree_res = http.get(tree_url)
local tree_json = tree_res.readAll()
tree_res.close()

local index = textutils.unserializeJSON(tree_json)
for i, entry in ipairs(index.tree) do
    if entry.type == "blob" then
        local path = entry.path
        print("Downloading " .. path)
        fs.makeDir(fs.getDir(path))
        shell.run("wget", raw_base .. path, path)
    end
end
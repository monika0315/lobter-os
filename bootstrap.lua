local repo = "monika0315/lobter-os"
local branch = "dev"
local install_root = "/lobter"
local tree_url = "https://api.github.com/repos/" .. repo .. "/git/trees/" .. branch .. "?recursive=1"
local raw_url = "https://raw.githubusercontent.com/" .. repo .. "/refs/heads/" .. branch .. "/"

fs.makeDir(install_root)
shell.setDir(install_root)
for _, file in ipairs(fs.list(".")) do
    fs.delete(file)
end

local tree_res = http.get(tree_url)
local tree_json = tree_res.readAll()
tree_res.close()

local index = textutils.unserializeJSON(tree_json)
for i, entry in ipairs(index.tree) do
    if entry.type == "blob" then
        local path = entry.path
        fs.makeDir(fs.getDir(path))
        shell.run("wget", raw_url .. path, path)
    end
end
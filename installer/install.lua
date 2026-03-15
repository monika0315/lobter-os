function read_json(source)
    local content = source.readAll()
    source.close()
    return textutils.unserialiseJSON(content)
end

local config = read_json(fs.open("/disk/config.json", "r"))
local repo = config.repo
local branch = config.branch
local install_path = config.install_path
local tree_url = "https://api.github.com/repos/" .. repo .. "/git/trees/" .. branch .. "?recursive=1"
local raw_url = "https://raw.githubusercontent.com/" .. repo .. "/refs/heads/" .. branch .. "/"
local index = read_json(http.get(tree_url))

fs.makeDir(install_path)
shell.setDir(install_path)
for _, file in ipairs(fs.list(install_path)) do
    fs.delete(fs.combine(install_path, file))
end

for i, entry in ipairs(index.tree) do
    if entry.type == "blob" then
        local path = entry.path
        shell.run("wget", raw_url .. path, path)
    end
end

fs.copy("/disk/startup.lua", "/startup")
function read_string(source)
    local content = source.readAll()
    source.close()
    return content
end

local file = read_string(fs.open("/disk/bootstrap.json", "r"))
local config = textutils.unserialiseJSON(file)
local repo = config.repo
local branch = config.branch
local install_path = config.install_path

fs.makeDir(install_path)
shell.setDir(install_path)
for _, file in ipairs(fs.list(install_path)) do
    fs.delete(fs.combine(install_path, file))
end

local tree_url = "https://api.github.com/repos/" .. repo .. "/git/trees/" .. branch .. "?recursive=1"
local raw_url = "https://raw.githubusercontent.com/" .. repo .. "/refs/heads/" .. branch .. "/"

local tree_json = read_string(http.get(tree_url))
local index = textutils.unserializeJSON(tree_json)

for i, entry in ipairs(index.tree) do
    if entry.type == "blob" then
        local path = entry.path
        fs.makeDir(fs.getDir(path))
        shell.run("wget", raw_url .. path, path)
    end
end
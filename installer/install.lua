function read_json(source)
    local content = source.readAll()
    source.close()
    return textutils.unserialiseJSON(content)
end

local installer_root = "/disk"
local config = read_json(fs.open(installer_root .. "/config.json", "r"))
local repo = config.repo
local branch = config.branch
local install_path = config.install_path
local tree_url = "https://api.github.com/repos/" .. repo .. "/git/trees/" .. branch .. "?recursive=1"
local raw_url = "https://raw.githubusercontent.com/" .. repo .. "/refs/heads/" .. branch .. "/"
local index = read_json(http.get(tree_url))

function install_os()
    if fs.exists(install_path) then
        fs.delete(install_path)
    end

    fs.makeDir(install_path)
    shell.setDir(install_path)

    for i, entry in ipairs(index.tree) do
        if entry.type == "blob" then
            local path = entry.path
            shell.run("wget", raw_url .. path, path)
        end
    end
end

function install_bootloader()
    fs.copy(installer_root .. "/bootloader.lua", "/startup.lua")

    settings.set("boot.path", install_path)
    settings.define("boot.path", {
        description = "The path containing the default OS.",
        default = nil,
        type = "string"
    })

    settings.save()
end

install_os()
install_bootloader()
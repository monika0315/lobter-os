table.insert(_ENV.package.loaders, function(name)
    if not name:match("^lobter%.") then
        return nil
    end

    local path = fs.combine(_G.boot.path, "modules/" .. name:sub(8):gsub("%.", "/") .. ".lua")

    if not fs.exists(path) then
        return nil
    end

    return function()
        return dofile(path)
    end
end)

local sys = require("lobter.sys")
shell.run("clear")
print(sys.name .. " (" .. sys.version .. ")")
os.run(_ENV, "/rom/programs/shell")
os.reboot()
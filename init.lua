settings.load()
local sys_root = settings.get("sys.root")
package.path = package.path .. ";" .. sys_root .. "/modules/?.lua"

local sys = require("sys")
shell.run("clear")
print(sys.name .. " (" .. sys.version .. ")")
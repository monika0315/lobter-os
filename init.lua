return function(boot_config)
    local sys = require("/lobter.sys")
    shell.run("clear")
    print(sys.name .. " (" .. sys.version .. ")")
end
local repo = "monika0315/lobter-os"
local branch = "dev"
local file_index = "https://api.github.com/repos/" .. repo .. "/git/trees/" .. branch .. "?recursive=1"

local h = http.get(file_index)
local json = h.readAll()
h.close()

local data = textutils.unserializeJSON(json)

for i, file in ipairs(data.tree) do
    print("" .. i .. ": " .. file.path)
end
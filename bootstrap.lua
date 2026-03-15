local repo = "monika0315/lobter-os"
local branch = "dev"
local file_index = "https://api.github.com/repos/" .. repo .. "/git/trees/" .. branch .. "?recursive=1"

local h = http.get(url)
local json = h.readAll()
h.close()

print(json)
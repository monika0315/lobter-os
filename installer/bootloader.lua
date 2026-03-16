settings.load()
local boot_path = settings.get("boot.path")
require(boot_path) {
    path = boot_path
}
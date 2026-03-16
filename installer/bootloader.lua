settings.load()
_G.boot = {
    path = settings.get("boot.path")
}
require(boot.path)
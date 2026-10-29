hl.config({ animations = { enabled = true } })

hl.curve("smooth", { type = "bezier", points = { { 0.23, 1 },    { 0.32, 1 } } })
hl.curve("snappy", { type = "bezier", points = { { 0.15, 0 },    { 0.1, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 },       { 1, 1 } } })
hl.curve("bouncy", { type = "spring", mass = 1, stiffness = 238, damping = 24 })

local function anim(leaf, speed, curve, style)
    local spec = { leaf = leaf, enabled = true, speed = speed, style = style }
    if curve == "bouncy" then spec.spring = curve else spec.bezier = curve end
    hl.animation(spec)
end

anim("windows",     4.8, "bouncy")
anim("windowsIn",   4.1, "bouncy", "popin 85%")
anim("windowsOut",  1.5, "linear", "popin 85%")
anim("border",      5.4, "smooth")
anim("fade",        3,   "snappy")
anim("layers",      3.8, "smooth")
anim("layersIn",    4,   "smooth", "fade")
anim("layersOut",   1.5, "linear", "fade")
anim("workspaces",  4,   "smooth", "slide")
anim("specialWorkspace", 4, "smooth", "slidevert")

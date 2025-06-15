SampleJimbos = {}

assert(SMODS.load_file("globals.lua"))()

-- Jokers
local joker_src = NFS.getDirectoryItems(SMODS.current_mod.path .. "jokers")
for _, file in ipairs(joker_src) do
    assert(SMODS.load_file("jokers/" .. file))()
end
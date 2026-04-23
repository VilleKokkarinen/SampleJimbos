SampleJimbos = {}

assert(SMODS.load_file("globals.lua"))()

-- Jokers
local joker_src = NFS.getDirectoryItems(SMODS.current_mod.path .. "jokers")
for _, file in ipairs(joker_src) do
    if string.find(file, "%.lua$") then
		assert(SMODS.load_file("jokers/" .. file))()
	end
end

-- Decks
local joker_src = NFS.getDirectoryItems(SMODS.current_mod.path .. "decks")
for _, file in ipairs(joker_src) do
    if string.find(file, "%.lua$") then
		assert(SMODS.load_file("decks/" .. file))()
	end
end

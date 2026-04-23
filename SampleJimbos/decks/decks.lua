SMODS.Atlas({
	key = "money_deck",
	path = "j_money_deck.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "jimbo_deck",
	path = "j_jimbo_deck.png",
	px = 71,
	py = 95,
})

SMODS.Back({
	key = "money_deck",
	config = {
		consumables = { "c_hermit", "c_temperance" }, -- Add to starting consumables in a run
		dollars=1000 -- Add to starting money in a run
	},
	atlas = "money_deck"
})

SMODS.Back({
	key = "jimbo_deck",
	atlas = "jimbo_deck",
	apply = function(self)
		G.E_MANAGER:add_event(Event({
			func = function()
				local _joker = add_joker("j_sj_sample_wee", nil, k ~= 1) -- Add a sample wee to our jokers
				_joker:set_eternal(true) -- Make it eternal
				_joker.pinned = true -- Pin it to the left
				add_joker("j_sj_sample_baroness",'polychrome', k~= 1) -- Add a polychrome baroness to our jokers
			return true
			end
		}))
	end,
})

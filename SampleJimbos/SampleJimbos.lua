--- STEAMODDED HEADER
--- MOD_NAME: SampleJimbos
--- MOD_ID: SampleJimbos
--- MOD_AUTHOR: [Rare_K]
--- MOD_DESCRIPTION: The SampleJimbos mod
--- MOD_VERSION: 1.0.0
--- MOD_SITE: https://github.com/VilleKokkarinen/SampleJimbos

-- you can have shared helper functions
function shakecard(self) --visually shake a card
    G.E_MANAGER:add_event(Event({
        func = function()
            self:juice_up(0.5, 0.5)
            return true
        end
    }))
end

function return_JokerValues() -- not used, just here to demonstrate how you could return values from a joker
    if context.joker_main and context.cardarea == G.jokers then
        return {
            chips = self.ability.extra.chips,       -- these are the 3 possible scoring effects any joker can return.
            mult = self.ability.extra.mult,         -- adds mult (+)
            x_mult = self.ability.extra.x_mult,     -- multiplies existing mult (*)
            card = self,                            -- under which card to show the message
            colour = G.C.CHIPS,                     -- colour of the message, Balatro has some predefined colours, (Balatro/globals.lua)
            message = localize('k_upgrade_ex'),     -- this is the message that will be shown under the card when it triggers.
            extra = { focus = self, message = localize('k_upgrade_ex') }, -- another way to show messages, not sure what's the difference.
        }
    end
end

local msg_dictionary={
    -- do note that when using messages such as: 
    -- message = localize{type='variable',key='a_xmult',vars={current_xmult}},
    -- that the key 'a_xmult' will use provided values from vars={} in that order to replace #1#, #2# etc... in the localization file.

    a_chips="+#1#",
    a_chips_minus="-#1#",
    a_hands="+#1# Hands",
    a_handsize="+#1# Hand Size",
    a_handsize_minus="-#1# Hand Size",
    a_mult="+#1# Mult",
    a_mult_minus="-#1# Mult",
    a_remaining="#1# Remaining",
    a_sold_tally="#1#/#2# Sold",
    a_xmult="X#1# Mult",
    a_xmult_minus="-X#1# Mult",
}    

local mod_name = 'SampleJimbos' -- Put your mod name here!

local jokers = {
    sample_wee = {                                           --slug used by the joker.
        name = "sample_wee",                                 --name used by the joker.
        text = {                                             --description text. each line is a new line, try to keep to 5 lines.            
            "This Joker gains",
            "{C:chips}+#2#{} Chips when each",
            "played {C:attention}2{} is scored",
            "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)",
		},
		config = { extra = { chips = 8, chip_mod = 2 } },    --variables used for abilities and effects.
		pos = { x = 0, y = 0 },                              --pos in spritesheet 0,0 for single sprites or the first sprite in the spritesheet.
        rarity = 1,                                          --rarity 1=common, 2=uncommen, 3=rare, 4=legendary
        cost = 1,                                            --cost to buy the joker in shops.
        blueprint_compat=true,                               --does joker work with blueprint.
        eternal_compat=true,                                 --can joker be eternal.
        unlocked = true,                                     --is joker unlocked by default.
        discovered = true,                                   --is joker discovered by default.    
        effect=nil,                                          --you can specify an effect here eg. 'Mult'
        soul_pos=nil,                                        --pos of a soul sprite.

        calculate = function(self,context)                   --define calculate functions here
            if self.debuff then return nil end               --if joker is debuffed return nil
            if context.individual and context.cardarea == G.play then -- if we are in card scoring phase, and we are on individual cards
                if not context.blueprint then -- blueprint/brainstorm don't get to add chips to themselves
                    if context.other_card:get_id() == 2 then -- played card is a 2 by rank
                        self.ability.extra.chips = self.ability.extra.chips + self.ability.extra.chip_mod -- add configurable amount of chips to joker
                        
                        return { -- shows a message under the specified card (self) when it triggers, k_upgrade_ex is a key in the localization files of Balatro
                            extra = {focus = self, message = localize('k_upgrade_ex')},
                            card = self,
                            colour = G.C.CHIPS
                        }
                    end
                end
            end
            if context.joker_main and context.cardarea == G.jokers then
                return { -- returns total chips from joker to be used in scoring, no need to show message in joker_main phase, game does it for us.
                    chips = self.ability.extra.chips, 
                    colour = G.C.CHIPS
                }
            end
        end,

        loc_def = function(self)                              --defines variables to use in the UI. you can use #1# for example to show the chips variable
            return {self.ability.extra.chips, self.ability.extra.chip_mod}
        end
	},
    sample_obelisk = {
        name = "sample_obelisk",
        text = {
            "This Joker gives {X:mult,C:white} X#1# {} Mult",
            "for each time you've played this {C:attention}hand",
        },
        config = { extra = { x_mult = 0.1 } },
        pos = { x = 0, y = 0 },
        rarity = 3,
        cost = 6,
        blueprint_compat = true,
        eternal_compat = true,
        unlocked = true,
        discovered = true,
        effect = nil,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if self.debuff then return nil end
            if context.joker_main and context.cardarea == G.jokers and context.scoring_name then
                local current_hand_times = (G.GAME.hands[context.scoring_name].played or 0) -- how many times has the player played the current type of hand. (pair, two pair. etc..)
                local current_xmult = 1 + (current_hand_times * self.ability.extra.x_mult)
                
                return {
                    message = localize{type='variable',key='a_xmult',vars={current_xmult}},
                    colour = G.C.RED,
                    x_mult = current_xmult
                }

                -- you could also apply it to the joker, to do it like the sample wee, but then you'd have to reset the card and text every time the previewed hand changes.
            end
        end,

        loc_def = function(self)
            return { self.ability.extra.x_mult }
        end
    },
    sample_specifichand = {
        name = "sample_specifichand",
        text = {          
            "If the hand played is #1#,",
            "Gives {X:mult,C:white} X#2# {} Mult"
		},
		config = { extra = { poker_hand = "Five of a Kind", x_mult = 5 } },
		pos={ x = 0, y = 0 },
        rarity = 3,
        cost = 10,
        blueprint_compat=true,
        eternal_compat=true,
        unlocked = true,
        discovered = true,
        effect=nil,
        soul_pos=nil,

        calculate = function(self,context)
            if self.debuff then return nil end
            if context.joker_main and context.cardarea == G.jokers then
                if context.scoring_name == self.ability.extra.poker_hand then
                    return {
                        message = localize{type='variable',key='a_xmult',vars={self.ability.x_mult}},
                        colour = G.C.RED,
                        x_mult = self.ability.x_mult
                    }
                end
            end
        end,

        loc_def=function(self)
            return {self.ability.extra.poker_hand, self.ability.extra.x_mult}
        end        
	},    
    sample_money = {
        name = "sample_money",
        text = {
            "Earn (Ante x 2) {C:money}${} at",
            "end of round, also here's some text effects:",
            "{C:money} money{}, {C:chips} chips{}, {C:mult} mult{}, {C:red} red{}, {C:blue} blue{}, {C:green} green{}",
            "{C:attention} attention{}, {C:purple} purple{}, {C:inactive} inactive{}",
            "{C:spades} spades{}, {C:hearts} hearts{}, {C:clubs} clubs{}, {C:diamonds} diamonds{}",
            "{C:tarot} tarot{}, {C:planet} planet{}, {C:spectral} spectral{}",
            "{C:edition} edition{}, {C:dark_edition} dark edition{}, {C:legendary} legendary{}, {C:enhanced} enhanced{}",
        },
        config={ },
        pos = { x = 0, y = 0 },
        rarity = 1,
        cost = 4,
        blueprint_compat = true,
        eternal_compat = true,
        unlocked = true,
        discovered = true,
        effect = nil,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if self.debuff then return nil end
            if context.end_of_round and not (context.individual or context.repetition) then --and not (context.individual or context.repetition) => make sure doesn't activate on every card like gold cards.
                ease_dollars(G.GAME.round_resets.blind_ante*2) -- ease_dollars adds or removes provided amount of money. (-5 would remove 5 for example)
            end
        end,
        loc_def = function(self)
            return { }
        end
    },   
    sample_roomba = {
        name = "sample_roomba",
        text = {
            "Attempts to remove edition",
            "from another Joker",
            "at the end of each round",
            "{C:inactive}(Foil, Holo, Polychrome)"
        },
        config={ },
        pos = { x = 0, y = 0 },
        rarity = 2,
        cost = 4,
        blueprint_compat = true,
        eternal_compat = false,
        unlocked = true,
        discovered = true,
        effect = nil,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if self.debuff then return nil end
            if context.end_of_round and not (context.individual or context.repetition) then
                local cleanable_jokers = {}

                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] ~= self then -- if joker is not itself 
                        cleanable_jokers[#cleanable_jokers+1] = G.jokers.cards[i] -- add all other jokers into a array
                    end
                end

                local joker_to_clean = #cleanable_jokers > 0 and pseudorandom_element(cleanable_jokers, pseudoseed('clean')) or nil -- pick a random valid joker, or null if no valid jokers

                if joker_to_clean then -- if we have a valid joker we can bump into
                    shakecard(joker_to_clean) -- simulate bumping into a card
                    if(joker_to_clean.edition) then --if joker has an edition
                        if not joker_to_clean.edition.negative then --if joker is not negative
                            joker_to_clean:set_edition(nil) -- clean the joker from it's edition
                        end
                    end
                end
            end
        end,

        loc_def = function(self)
            return { }
        end
    },
    sample_drunk_juggler = {
        name = "sample_drunk_juggler",
        text = {
            "{C:red}+#1#{} discard,",
            "also here's some {X:legendary,C:white}text effects{}:",
            "{s:0.5} scaled down by 0.5",
            "{C:attention,T:tag_double}#2#"
        },
        config = { d_size = 1 }, -- d_size  = discard size, h_size = hand size. (HOWEVER, you can't have both on 1 joker!)
        pos = { x = 0, y = 0 },
        rarity = 2,
        cost = 4,
        blueprint_compat = true,
        eternal_compat = false,
        unlocked = true,
        discovered = true,
        effect = nil,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            return nil
        end,

        loc_def = function(self)
            return { self.ability.d_size, localize{type = 'name_text', key = 'tag_double', set = 'Tag'} }
        end
    },
    sample_hackerman = {
        name = "sample_hackerman",
        text = {
            "Retrigger",
            "each played",
            "{C:attention}6{}, {C:attention}7{}, {C:attention}8{}, or {C:attention}9{}",
        },
        config = { repetitions = 1 },
        pos = { x = 0, y = 0 },
        rarity = 2,
        cost = 4,
        blueprint_compat = true,
        eternal_compat = false,
        unlocked = true,
        discovered = true,
        effect = nil,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if self.debuff then return nil end
            if context.cardarea == G.play and context.repetition and (
                context.other_card:get_id() == 6 or 
                context.other_card:get_id() == 7 or 
                context.other_card:get_id() == 8 or 
                context.other_card:get_id() == 9) then
                return {
                    message = localize('k_again_ex'),
                    repetitions = self.ability.repetitions,
                    card = self
                }
            end
        end,

        loc_def = function(self)
            return { }
        end
    },
    sample_baroness = {
        name = "sample_baroness",
        text = {
            "Each {C:attention}Queen{}",
            "held in hand",
            "gives {X:mult,C:white} X#1# {} Mult",
        },
        config = { extra = { x_mult = 1.5 } },
        pos = { x = 0, y = 0 },
        rarity = 3,
        cost = 8,
        blueprint_compat = true,
        eternal_compat = false,
        unlocked = true,
        discovered = true,
        effect = nil,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if self.debuff then return nil end
            if not context.end_of_round then
                if context.cardarea == G.hand and context.individual and context.other_card:get_id() == 12 then
                    if context.other_card.debuff then
                        return {
                            message = localize('k_debuffed'),
                            colour = G.C.RED,
                            card = self,
                        }
                    else
                        return {
                            x_mult = self.ability.extra.x_mult,
                            card = self
                        }
                    end
                end
            end
        end,

        loc_def = function(self)
            return { self.ability.extra.x_mult }
        end
    },
    sample_rarebaseballcard = {
        name = "sample_rarebaseballcard",
        text = {
            "{X:mult,C:white}Rare{} Jokers",
            "each give {X:mult,C:white} X#1# {} Mult",
        },
        config = { extra = { x_mult = 2 } },
        pos = { x = 0, y = 0 },
        rarity = 2,
        cost = 8,
        blueprint_compat = true,
        eternal_compat = false,
        unlocked = true,
        discovered = true,
        effect = nil,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if self.debuff then return nil end
            if not (context.individual or context.repetition) and context.other_joker and context.other_joker.config.center.rarity == 3 and self ~= context.other_joker then
                shakecard(context.other_joker)
                return {
                    message = localize{type='variable',key='a_xmult',vars={self.ability.extra.x_mult}},
                    colour = G.C.RED,
                    x_mult = self.ability.extra.x_mult
                }
            end
        end,

        loc_def = function(self)
            return { self.ability.extra.x_mult }
        end
    },
    sample_multieffect = {
        name = "sample_multieffect",
        text = {
            "Each played {C:attention}10{}",
            "gives {C:chips}+#1#{} Chips and",
            "{C:mult}+#2#{} Mult when scored",
        },
        config = { extra = { chips = 10, mult = 10, x_mult = 2 } },
        pos = { x = 0, y = 0 },
        rarity = 2,
        cost = 4,
        blueprint_compat = true,
        eternal_compat = false,
        unlocked = true,
        discovered = true,
        effect = nil,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if self.debuff then return nil end
            if context.individual and context.cardarea == G.play and context.other_card:get_id() == 10 then
                return {
                    chips = self.ability.extra.chips,
                    mult = self.ability.extra.mult,
                    x_mult = self.ability.extra.x_mult,
                    card = self
                }
            end
        end,

        loc_def = function(self)
            return { self.ability.extra.chips, self.ability.extra.mult }
        end
    }
}

function SMODS.INIT.SampleJimbos()
    --localization for the info queue key
    G.localization.descriptions.Other["your_key"] = {
        name = "Example",
        text = {
            "TEXT L1",
            "TEXT L2",
            "TEXT L3"
        }
    }
    init_localization()

    --Create and register jokers
    for k, v in pairs(jokers) do --for every joker in 'jokers'
        local joker = SMODS.Joker:new(v.name, k, v.config, v.pos, { name = v.name, text = v.text }, v.rarity, v.cost,
        v.unlocked, v.discovered, v.blueprint_compat, v.eternal_compat, v.effect, v.atlas, v.soul_pos)
        joker:register()

        if not v.atlas then --if atlas=nil then use single sprites. In this case you have to save your sprite as slug.png (for example j_sample_wee.png)
            SMODS.Sprite:new("j_" .. k, SMODS.findModByID(mod_name).path, "j_" .. k .. ".png", 71, 95, "asset_atli")
                :register()
        end

        SMODS.Jokers[joker.slug].calculate = v.calculate
        SMODS.Jokers[joker.slug].loc_def = v.loc_def

        --if tooltip is present, add jokers tooltip
        if (v.tooltip ~= nil) then
            SMODS.Jokers[joker.slug].tooltip = v.tooltip
        end
    end
    --Create sprite atlas
    SMODS.Sprite:new("youratlasname", SMODS.findModByID(mod_name).path, "example.png", 71, 95, "asset_atli")
        :register()
end
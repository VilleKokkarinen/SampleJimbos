# Welcome to SampleJimbos!
This works as a base to start modding Balatro!

Includes some sample jokers and how to make them trigger correctly!

## How to make a new install of Balatro where you can install mods onto?
```
	- Make a "Balatro" folder in the same folder where this readme is
	- Copy the game files from steam into that balatro folder (Balatro.exe, love.dll, etc.)
	- Put version.dll from lovely (steamodded requirement) into this "Balatro" folder
	- Insert smods-main folder (steamodded) into %appdata%/Balatro/Mods (you need to make that folder)
	- Now when you run this Balatro.Exe, it should run with Mods
```

## To make it easier to build you can:
```
	- Pick a name! Use this name as the name of your folder structure to make everything easier!
	- Put the name of your mod into build.bat into the "name" field, and into 'local mod_name' in the base .lua file
	- build.bat copies / refreshes the mod in %appdata%/Mods folder.
```


## How to make Jimbo Art?
```
	- Check out for example Balatro_Textures\1x\Jokers.png
	- Make pixelart in the 1x size first, then just scale up to 2x and save into both folders, samples provided!
	- I wouldn't recommend making the 2x first and then downscaling as pixel art might not downscale nicely.
	- Example.png's are needed in both folders, they are your default sprite "Atlas"
```



## Did you know that you can just extract all the files from Balatro.exe with for example 7-Zip?
```
	- Give it a go!, it'll probably help!
```



## How to add base game jokers, or cash at the beginning of a run? ->
```
	- Open the .exe as an archive with 7-zip
	- Open up 'back.lua'
	- Ctrl+f to: Back:apply_to_run()
	- Paste this as the first thing in that function:
```
```
	if self.effect.config.jokers then
		delay(0.4)
		G.E_MANAGER:add_event(Event({
			func = function()
				for k, v in ipairs(self.effect.config.jokers) do
					local card = create_card('Joker', G.jokers, nil, nil, nil, nil, v, 'deck')
					card:add_to_deck()
					G.jokers:emplace(card)
				end
			return true
			end
		}))
    end	
```
```
	-> Now you can add base game jokers to any deck in the beginning of the game!
	-> NOTE! only base game jokers, if you figure out a way to insert modded jokers, let me know, or make a pull request!
	
	- Open up 'game.lua'
	- Ctrl+f to: "Plasma Deck", or any other deck, and find the one's config you want to edit.
		
	- To get blueprint + brainstorm + 10k cash at the beginning for example:
	
	b_plasma=           {name = "Plasma Deck",      stake = 1, unlocked = false,order = 14, pos = {x=4,y=2}, set = "Back", config = {ante_scaling = 2, dollars=10000, jokers = {'j_blueprint','j_brainstorm'}}, unlock_condition = {type = 'win_stake', stake=5}},
```

### Other Notes:
- if you want to edit joker stats / logic after starting a game you might have to kill your current save.jkr file in %appdata%/Balatro/[number of profile]

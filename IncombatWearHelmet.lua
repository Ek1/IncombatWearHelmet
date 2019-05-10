local IncombatWearHelmet = {
	Title = "Incombat wear helmet",
	Author = "Ek1",
	Description = "Shows helmet when entering combat and hides it when exiting combat",
	Version = "190510",
	License = "CC BY-SA: Creative Commons Attribution-ShareAlike 4.0 International License",
	www = "https://github.com/Ek1/IncombatWearHelmet"
}
	
-- Funktion that changes the helmet visibility according to the combat state
function IWH_combatState(_, Incombat)

	-- We need the present hat for all 2^2 state evalutions
	local activeHat = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_HAT)

	if Incombat then
		if activeHat ~= 0 then
		-- Character is in combat and hiding helmet (activeHat=0) thus lets unhide it
			UseCollectible(5002)
		end
	else
		if activeHat ~= 5002 then
		-- Character is not in combat and showing helmet (activeHat=5002) thus lets hide it
            UseCollectible(5002)
		end
	end
end

-- Lets fire up the add-on by registering for events
function IncombatWearHelmet.Initialize()
	EVENT_MANAGER:RegisterForEvent(IncombatWearHelmet.Title, EVENT_PLAYER_COMBAT_STATE, IWH_combatState)
	d( IncombatWearHelmet.Title .. ": initalization done")
end


-- Variable to keep count how many loads have been done before it was this ones turn.
local loadOrder = 0
function IncombatWearHelmet.OnAddOnLoaded(event, addonName)
  if addonName == IncombatWearHelmet.Title then
--	Seems it is our time so lets stop listening load trigger and initialize the add-on
	d( IncombatWearHelmet.Title .. ": load order " ..  loadOrder .. ", starting initalization")
	EVENT_MANAGER:UnregisterForEvent(IncombatWearHelmet.Title, EVENT_ADD_ON_LOADED)
	IncombatWearHelmet.Initialize()
  end
  loadOrder = loadOrder+1
end

-- Registering the addon's initializing event when add-on's are loaded 
EVENT_MANAGER:RegisterForEvent(IncombatWearHelmet.Title, EVENT_ADD_ON_LOADED, IncombatWearHelmet.OnAddOnLoaded)
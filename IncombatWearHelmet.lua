local IncombatWearHelmet = {
	Title = "Incombat wear helmet",	-- Not codereview friendly but enduser friendly version of the add-on's name
	Author = "Ek1",
	Description = "Shows helmet when entering combat and hides it when exiting combat",
	Version = "33.210106",
	License = "CC BY-SA: Creative Commons Attribution-ShareAlike 4.0 International License",
	www = "https://github.com/Ek1/IncombatWearHelmet"
}
local ADDON = "IncombatWearHelmet"	-- Variable used to refer to this add-on. Codereview friendly.

-- hatswap with 
-- GetCollectibleCooldownAndDuration(number collectibleId)

-- Funktion that changes the helmet visibility according to the combat state
function IncombatWearHelmet.combatState (inCombat)
	-- Prepearing hat for all 2^2 state evalutions
	local activeHat = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_HAT)
	local cooldownRemaining = 0
	local cooldownDuration = 0

	if inCombat then
		if activeHat ~= 0 then
		-- Character is in combat and hiding helmet (activeHat=0) thus lets unhide it
			UseCollectible(5002)
--			cooldownRemaining, cooldownDuration = GetCollectibleCooldownAndDuration(5002)
--			zo_callLater(function() IWH_combatState (IsUnitInCombat("player") ) end, cooldownRemaining )
		end
	else
		if activeHat ~= 5002 then
		-- Character is not in combat and showing helmet (activeHat=5002) thus lets hide it
			UseCollectible(5002)
--			cooldownRemaining, cooldownDuration = GetCollectibleCooldownAndDuration(5002)
--			zo_callLater(function() IncombatWearHelmet.combatState (IsUnitInCombat("player") ) end, cooldownRemaining )
		end
	end
end

-- 100033	EVENT_PLAYER_COMBAT_STATE (number eventCode, boolean inCombat)
function IncombatWearHelmet.EVENT_PLAYER_COMBAT_STATE (_, inCombat)
	IncombatWearHelmet.combatState(inCombat)
end

function IncombatWearHelmet.EVENT_ZONE_CHANGED (_, _)
	IncombatWearHelmet.combatState(	IsUnitInCombat("player")	)
end

-- Lets fire up the add-on by registering for events
function IncombatWearHelmet.Initialize()
	EVENT_MANAGER:RegisterForEvent(ADDON, EVENT_PLAYER_COMBAT_STATE, IncombatWearHelmet.EVENT_PLAYER_COMBAT_STATE)	-- listening when entering/exiting combat
	EVENT_MANAGER:RegisterForEvent(ADDON, EVENT_ZONE_CHANGED, IncombatWearHelmet.EVENT_ZONE_CHANGED)	-- listening when zone changes
	--d( IncombatWearHelmet.Title .. ": initalization done")
end

-- Listener to know when its our turn.
function IncombatWearHelmet.OnAddOnLoaded(_, addonName)
  if addonName == ADDON then	-- Its our time so lets stop listening load trigger and initialize the add-on
		EVENT_MANAGER:UnregisterForEvent(ADDON, EVENT_ADD_ON_LOADED)
		IncombatWearHelmet.Initialize()
	end
end

-- Registering the addon's initializing event when add-on's are loaded 
EVENT_MANAGER:RegisterForEvent(ADDON, EVENT_ADD_ON_LOADED, IncombatWearHelmet.OnAddOnLoaded)
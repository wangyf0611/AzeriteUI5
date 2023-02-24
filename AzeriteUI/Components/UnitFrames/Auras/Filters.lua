--[[

	The MIT License (MIT)

	Copyright (c) 2023 Lars Norberg

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.

--]]
local Addon, ns = ...
ns.AuraFilters = ns.AuraFilters or {}

ns.AuraFilters.PlayerAuraFilter = function(button, unit, data)

	--button.unitIsCaster = unit and caster and UnitIsUnit(unit, caster)
	button.spell = data.name
	button.timeLeft = data.expiration and (data.expiration - GetTime())
	button.expiration = data.expiration
	button.duration = data.duration
	button.noDuration = (not data.duration or data.duration == 0)
	button.isPlayer = data.isPlayerAura

	if (data.isBossDebuff) then
		return true
	end

	if (UnitAffectingCombat("player")) then
		return (not button.noDuration and data.duration < 301) or (button.timeLeft and button.timeLeft > 0 and button.timeLeft < 31) or (data.count > 1)
	else
		return (not button.noDuration) or (button.timeLeft and button.timeLeft > 0 and button.timeLeft < 31) or (data.count > 1)
	end

end

ns.AuraFilters.TargetAuraFilter = function(button, unit, data)

	button.spell = data.name
	button.timeLeft = data.expiration and (data.expiration - GetTime())
	button.expiration = data.expiration
	button.duration = data.duration
	button.noDuration = (not data.duration or data.duration == 0)
	button.isPlayer = data.isPlayerAura

	if (data.isBossDebuff) then
		return true
	end

	if (UnitAffectingCombat("player")) then
		return (not button.noDuration and duration < 301) or (count > 1)
	else
		return (not button.noDuration) or (count > 1)
	end
end

ns.AuraFilters.NameplateAuraFilter = function(button, unit, data)

	button.spell = data.name
	button.timeLeft = data.expiration and (data.expiration - GetTime())
	button.expiration = data.expiration
	button.duration = data.duration
	button.noDuration = (not data.duration or data.duration == 0)
	button.isPlayer = data.isPlayerAura

	if (data.isBossDebuff) then
		return true
	elseif (data.isStealable) then
		return true
	elseif (data.nameplateShowAll) then
		return true
	elseif (data.nameplateShowSelf and button.isPlayer) then
		if (button.isHarmful) then
			return (not button.noDuration and data.duration < 61) or (data.count > 1)
		else
			return (not button.noDuration and data.duration < 31) or (data.count > 1)
		end
	end
end

if (ns.IsRetail) then return end

ns.AuraFilters.PlayerAuraFilter = function(element, unit, button, name, texture,
	count, debuffType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID,
	canApply, isBossDebuff, casterIsPlayer, nameplateShowAll,timeMod, effect1, effect2, effect3)

	--button.unitIsCaster = unit and caster and UnitIsUnit(unit, caster)
	button.spell = name
	button.timeLeft = expiration and (expiration - GetTime())
	button.expiration = expiration
	button.duration = duration
	button.noDuration = (not duration or duration == 0)
	button.isPlayer = caster == "player" or caster == "vehicle"

	if (isBossDebuff) then
		return true
	end

	if (UnitAffectingCombat("player")) then
		return (not button.noDuration and duration < 301) or (button.timeLeft and button.timeLeft > 0 and button.timeLeft < 31) or (count > 1)
	else
		return (not button.noDuration) or (button.timeLeft and button.timeLeft > 0 and button.timeLeft < 31) or (count > 1)
	end

end

ns.AuraFilters.TargetAuraFilter = function(element, unit, button, name, texture,
	count, debuffType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID,
	canApply, isBossDebuff, casterIsPlayer, nameplateShowAll,timeMod, effect1, effect2, effect3)

	--button.unitIsCaster = unit and caster and UnitIsUnit(unit, caster)
	button.spell = name
	button.timeLeft = expiration and (expiration - GetTime())
	button.expiration = expiration
	button.duration = duration
	button.noDuration = (not duration or duration == 0)
	button.isPlayer = caster == "player" or caster == "vehicle"

	if (isBossDebuff) then
		return true
	end

	if (UnitAffectingCombat("player")) then
		return (not button.noDuration) or (count > 1)
	else
		return (not button.noDuration and duration < 301) or (count > 1)
	end
end

ns.AuraFilters.NameplateAuraFilter = function(element, unit, button, name, texture,
	count, debuffType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID,
	canApply, isBossDebuff, casterIsPlayer, nameplateShowAll, timeMod, effect1, effect2, effect3)

	button.spell = name
	button.timeLeft = expiration and (expiration - GetTime())
	button.expiration = expiration
	button.duration = duration
	button.noDuration = (not duration or duration == 0)
	button.isPlayer = caster == "player" or caster == "vehicle"

	if (isBossDebuff) then
		return true
	elseif (isStealable) then
		return true
	elseif (button.noDuration) then
		return
	elseif (caster == "player" or caster == "pet" or caster == "vehicle") then
		if (button.isDebuff) then
			return (duration < 301) -- Faerie Fire is 5 mins
		else
			return (duration < 31) -- show short buffs, like HoTs
		end
	end
end


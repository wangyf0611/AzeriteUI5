--[[

	The MIT License (MIT)

	Copyright (c) 2022 Lars Norberg

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
local Tutorials = ns:NewModule("Tutorials", "LibMoreEvents-1.0", "AceTimer-3.0", "AceHook-3.0")

Tutorials.DisableHelpTip = function(self)
	local AcknowledgeTips = function()
		local pool = HelpTip.framePool
		if (not pool or not pool.EnumerateActive) then return end
		for frame in pool:EnumerateActive() do
			if (frame.Acknowledge) then
				frame:Acknowledge()
			end
		end
	end
	self:SecureHook(HelpTip, "Show", AcknowledgeTips)
	self:ScheduleRepeatingTimer(AcknowledgeTips, 1)
end

Tutorials.DisableNPE = function(self, event, ...)
	local NPE = NewPlayerExperience
	if (NPE) then
		if (NPE.GetIsActive and NPE:GetIsActive()) then
			if (NPE.Shutdown) then
				NPE:Shutdown()
			end
		end
	end
end

Tutorials.DisableTutorials = function(self)
	SetCVar("showTutorials", "0")
end

Tutorials.OnEvent = function(self, event, ...)
	if (event == "SETTINGS_LOADED") then
		if (InCombatLockdown()) then
			return self:RegisterEvent("PLAYER_REGEN_ENABLED", "OnEvent")
		end

	elseif (event == "PLAYER_REGEN_ENABLED") then
		if (InCombatLockdown()) then return end
		self:UnregisterEvent("PLAYER_REGEN_ENABLED", "OnEvent")

	elseif (event == "ADDON_LOADED") then
		local addon = ...
		if (addon == "Blizzard_NewPlayerExperience" or addon == "Blizzard_BoostTutorial") then
			self:DisableNPE()
		end
		return
	end

	self:DisableHelpTip()
	self:DisableTutorials()

	if (IsAddOnLoaded("Blizzard_NewPlayerExperience") and IsAddOnLoaded("Blizzard_BoostTutorial")) then
		self:DisableNPE()
	else
		self:DisableNPE()
		self:RegisterEvent("ADDON_LOADED", "OnEvent")
	end
end

Tutorials.OnInitialize = function(self)
	self:RegisterEvent("SETTINGS_LOADED", "OnEvent")
end